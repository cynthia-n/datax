require 'datax/plugin/helper'
module Datax
  module Plugin
    class Osswriter
      include Datax::Plugin::Helper
      DEFAULT_CONFIG = {
        name: "osswriter",
        parameter: {
          endpoint: 'http://oss.aliyuncs.com',
          accessId: '',
          accessKey: '',
          bucket: '',
          object: '', #描述：写入的文件名，OSS使用文件名模拟目录的实现。使用"object": "/cdo/datax"，写入的object以/cdo/datax开头，后缀随机添加字符串，/作为OSS模拟目录的分隔符。
          writeMode: 'truncate',#"truncate|append|nonConflict"
          fieldDelimiter: ',',
          encoding: 'UTF-8',
          nullFormat: '\N',
          dateFormat: 'yyyy-MM-dd', #日期类型的数据序列化到object中时的格式，例如 "dateFormat": "yyyy-MM-dd"。
          fileFormat: 'csv',#"csv|text"
          header: [],#['id', 'name', 'age']
          maxFileSize: "100000"
        }
      }.as_json.freeze
    end
  end
end
