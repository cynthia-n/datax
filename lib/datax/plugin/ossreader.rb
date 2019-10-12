require 'datax/plugin/helper'
module Datax
  module Plugin
    class Ossreader
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "ossreader",
        parameter: {
          endpoint: 'http://oss.aliyuncs.com',
          accessId: '',
          accessKey: '',
          bucket: '',
          object: [], #指定/*代表读取bucket下游所有的Object，指定/bazhen/*代表读取bazhen目录下游所有的Object。
          column: ["*"],
          fieldDelimiter: ',',
          compress: '', #支持压缩类型zip、gzip、bzip2
          encoding: 'UTF-8',
          nullFormat: '\N',
          skipHeader: false,
          csvReaderConfig: {}
        }
      }.as_json.freeze
      # csvReaderConfig:
      # boolean caseSensitive = true;
      # char textQualifier = 34;
      # boolean trimWhitespace = true;
      # boolean useTextQualifier = true;//是否使用csv转义字符
      # char delimiter = 44;//分隔符
      # char recordDelimiter = 0;
      # char comment = 35;
      # boolean useComments = false;
      # int escapeMode = 1;
      # boolean safetySwitch = true;//单列长度是否限制100000字符
      # boolean skipEmptyRecords = true;//是否跳过空行
      # boolean captureRawRecord = true;

      def self.special_handle(ret, options)
        options.delete('compress') if options['compress'].nil? || options['compress'].strip == ''
        options.delete('csvReaderConfig') if options['csvReaderConfig'].nil? || options['csvReaderConfig'].size == 0
        ret
      end

    end
  end
end
