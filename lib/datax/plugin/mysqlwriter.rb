require 'datax/plugin/helper'
module Datax
  module Plugin
    class Mysqlwriter
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "mysqlwriter",
        parameter: {
          username: "",
          password: "",
          column: ["*"],
          session: ["set session sql_mode='ANSI'"],
          preSql: [], #["delete from test"],
          postSql: [],
          writeMode: "insert", #insert/replace/update
          batchSize: 1024,#设置过大可能会造成DataX运行进程OOM
          connection: [
            {
              jdbcUrl: "", #"jdbc:mysql://127.0.0.1:3306/datax?useUnicode=true&characterEncoding=gbk"
              table: []
            }
          ]
        }
      }.as_json.freeze
    end
  end
end
