require 'datax/plugin/helper'
module Datax
  module Plugin
    class Odpswriter
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "odpswriter",
        parameter: {
          accessId: "",
          accessKey: "",
          project: "",
          table: "",
          partition: "", #"school=SiChuan-School,class=1"如果是分区表，该选项必填，如果非分区表，该选项不可填写
          column: ["*"], #["id","name"]
          truncate: true, #保证写入的幂等性，即当出现写入失败再次运行时，ODPSWriter将清理前述数据，并导入新数据，这样可以保证每次重跑之后的数据都保持一致。 truncate选项不是原子操作！
          odpsServer: "http://service.odps.aliyun.com/api",
          tunnelServer: "http://dt.odps.aliyun.com",
          accountType: "aliyun"
        }
      }.as_json.freeze
    end
  end
end
