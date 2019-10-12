require 'datax/plugin/helper'
module Datax
  module Plugin
    class Mysqlreader
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "mysqlreader",
        parameter: {
          username: "",
          password: "",
          column: ["*"], # ["id", "name"]
          splitPk: "", #"db_id"
          where: "", #"id > 2"
          connection: [
            {
              querySql: [],#当用户配置querySql时，MysqlReader直接忽略table、column、where条件的配置，querySql优先级大于table、column、where选项。
              table: [],
              jdbcUrl: [] #["jdbc:mysql://bad_ip:3306/database"]
            }
          ]
        }
      }.as_json.freeze

      def self.special_handle(ret, options)
        unless options['querySql'].nil?
          ret['parameter'] = ret['parameter'].delete_if{|k,v| ['column', 'where'].include?(k)}
          ret['parameter']['connection'] = ret['parameter']['connection'].map do |config|
            config.delete_if{|k,v| ['table'].include?(k)}
          end
        else
          ret['parameter']['connection'] = ret['parameter']['connection'].map do |config|
            config.delete_if{|k,v| ['querySql'].include?(k)}
          end
        end
        ret
      end

    end
  end
end
