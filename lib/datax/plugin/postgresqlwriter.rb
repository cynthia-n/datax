require 'datax/plugin/helper'
module Datax
  module Plugin
    class Postgresqlwriter
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "postgresqlwriter",
        parameter: {
          username: "",
          password: "",
          column: ["*"],
          preSql: [], #["delete from test"],
          postSql: [],
          batchSize: 1024,#设置过大可能会造成DataX运行进程OOM
          connection: [
            {
              jdbcUrl: "", #"jdbc:postgresql://127.0.0.1:3002/datax"
              table: []
            }
          ]
        }
      }.as_json.freeze
    end
  end
end
