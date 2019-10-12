require 'datax/plugin/helper'
module Datax
  module Plugin
    class Postgresqlreader
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "postgresqlreader",
        parameter: {
          username: "",
          password: "",
          column: ["*"],
          splitPk: "",
          where: "",
          fetchSize: 1024, #该值过大(>2048)可能造成DataX进程OOM。
          connection: [
            {
              querySql: [],
              table: [],
              jdbcUrl: [] #jdbc:postgresql://127.0.0.1:3002/datax
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
