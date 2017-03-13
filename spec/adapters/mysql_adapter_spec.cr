require "../spec_helper"
require "../helper_methods"

module Crecto
  module Adapters
    module Mysql
      def self.exec_execute(query_string, params, tx : DB::Transaction?)
        Crecto::Adapters.sqls << query_string if !tx.nil?
        previous_def(query_string, params, tx)
      end

      def self.exec_execute(query_string, params)
        Crecto::Adapters.sqls << query_string
        previous_def(query_string, params)
      end

      def self.exec_execute(query_string)
        Crecto::Adapters.sqls << query_string
        previous_def(query_string)
      end
    end
  end
end

if Crecto::Repo::ADAPTER == Crecto::Adapters::Mysql

  describe "Crecto::Adapters::Mysql" do
    Spec.after_each do
      Crecto::Adapters.clear_sql
    end

  end

end
