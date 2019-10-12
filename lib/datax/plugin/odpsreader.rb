require 'datax/plugin/helper'
module Datax
  module Plugin
    class Odpsreader
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "odpsreader",
        parameter: {
            accessId: "",
            accessKey: "",
            project: "",
            table: "",
            partition: [], #["pt=1,ds=hangzhou"]如果表为分区表，则必填。如果表为非分区表，则不能填写
            column: ["*"], #["customer_id", "nickname"]["*"]
            packageAuthorizedProject: "",
            splitMode: "record",#"splitMode":"partition"
            odpsServer: "http://service.odps.aliyun.com/api",
            tunnelServer: "http://dt.odps.aliyun.com",
            accountProvider: "aliyun", #taobao
            isCompress: "false"
        }
      }.as_json.freeze
    end
  end
end
