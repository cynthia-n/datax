require 'datax/plugin/helper'
module Datax
  module Plugin
    class Txtfilewriter
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "txtfilewriter",
        parameter: {
          path: "",
          fileName: '', #写入的文件名，该文件名会添加随机的后缀作为每个线程写入实际文件名
          writeMode: 'truncate',#"truncate|append|nonConflict"
          fieldDelimiter: ',',
          compress: '', #支持压缩类型zip、lzo、lzop、tgz、bzip
          encoding: 'UTF-8',
          nullFormat: '\N',
          dateFormat: 'yyyy-MM-dd', #日期类型的数据序列化到object中时的格式，例如 "dateFormat": "yyyy-MM-dd"。
          fileFormat: 'csv',#"csv|text"
          header: []#['id', 'name', 'age']
        }
      }.as_json.freeze

      def self.special_handle(ret, options)
        options.delete('compress') if options['compress'].nil? || options['compress'].strip == ''
        ret
      end

    end
  end
end
