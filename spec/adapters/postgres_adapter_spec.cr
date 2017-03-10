require "../spec_helper"
require "../helper_methods"

module Crecto
  module Adapters
    module Postgres
      def self.execute(query_string, params, tx : DB::Transaction?)
        Crecto::Adapters.sqls << query_string if !tx.nil?
        previous_def(query_string, params, tx)
      end

      def self.execute(query_string, tx : DB::Transaction?)
        Crecto::Adapters.sqls << query_string if !tx.nil?
        previous_def(query_string, tx)
      end

      def self.exec_execute(query_string, params, tx : DB::Transaction?)
        Crecto::Adapters.sqls << query_string if !tx.nil?
        previous_def(query_string, params, tx)
      end

      def self.exec_execute(query_string, tx : DB::Transaction?)
        Crecto::Adapters.sqls << query_string if !tx.nil?
        previous_def(query_string, tx)
      end
    end
  end
end

describe "Crecto" do
  describe "Adapters" do
    describe "Postgres" do

      Spec.after_each do
        Crecto::Adapters.clear_sql
      end

      it "should generate insert query" do
        user = User.new
        user.name = "chuck"
        changeset = Crecto::Repo.insert(user)
        check_sql do |sql|
          sql.should eq(["INSERT INTO users (name, created_at, updated_at) VALUES ($1, $2, $3) RETURNING *"])
        end
      end
    end
  end
end
