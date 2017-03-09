require "../spec_helper"
require "../helper_methods"

def check_sql
  yield Crecto::Adapters::Postgres.sqls
end

module Crecto
  module Adapters
    module Postgres

      @@SQLS = [] of String

      def self.sqls
        @@SQLS
      end

      def self.clear_sql
        @@SQLS.clear
      end

      def self.execute(query_string, params)
        @@SQLS << query_string
        previous_def(query_string, params)
      end

      def self.execute(query_string, params, tx : DB::Transaction?)
        @@SQLS << query_string if !tx.nil?
        previous_def(query_string, params, tx)
      end

      def self.exec_execute(query_string, params, tx : DB::Transaction?)
        @@SQLS << query_string if !tx.nil?
        previous_def(query_string, params, tx)
      end

      def self.exec_execute(query_string, tx : DB::Transaction?)
        @@SQLS << query_string if !tx.nil?
        previous_def(query_string, tx)
      end

      def self.execute(query_string, tx : DB::Transaction?)
        @@SQLS << query_string if !tx.nil?
        previous_def(query_string, tx)
      end

      def self.execute(query_string)
        @@SQLS << query_string
        previous_def(query_string)
      end
    end
  end
end

describe "Crecto" do
  describe "Adapters" do
    describe "Postgres" do

      Spec.after_each do
        Crecto::Adapters::Postgres.clear_sql
      end

      it "should generate insert query" do
        user = User.new
        user.name = "chuck"
        changeset = Crecto::Repo.insert(user)
        check_sql do |sql|
          sql.first.should eq("INSERT INTO users (name, created_at, updated_at) VALUES ($1, $2, $3) RETURNING *")
        end
      end
    end
  end
end
