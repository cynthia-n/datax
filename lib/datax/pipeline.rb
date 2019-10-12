require 'datax/plugin/mysqlreader'
require 'datax/plugin/mysqlwriter'
require 'datax/plugin/odpsreader'
require 'datax/plugin/odpswriter'
require 'datax/plugin/postgresqlreader'
require 'datax/plugin/postgresqlwriter'
require 'datax/plugin/ossreader'
require 'datax/plugin/osswriter'
require 'datax/plugin/txtfilereader'
require 'datax/plugin/txtfilewriter'
module Datax
  class Pipeline
    DEFAULT_SPEED = {
      channel: 10,
      byte: 104857600
    }.freeze
    DEFAULT_ERROR_Limit = {}.freeze #{"record": 10, "percentage": 0.05}
    READER_PLUGIN = ["mysqlreader", "odpsreader", "postgresqlreader", "ossreader", "txtfilereader"]
    WRITER_PLUGIN = ["mysqlwriter", "odpswriter", "postgresqlwriter", "osswriter", "txtfilewriter"]
    REQUIRED_PARAMS = ['reader', 'writer']
    COMMON_JOB_FILE_PATH = File.join(Datax.root_path || "", 'datax/job_files/common.json')

    def initialize(options = {})
      options = options.as_json
      REQUIRED_PARAMS.map do |k|
        raise "options #{k.to_s} must exist" if options[k].nil?
      end
      raise "reader name only allows #{READER_PLUGIN.join(",")}" unless options.dig('reader_custom') == true || READER_PLUGIN.include?(options.dig('reader', 'name'))
      raise "writer name only allows #{WRITER_PLUGIN.join(",")}" unless options.dig('writer_custom') == true || WRITER_PLUGIN.include?(options.dig('writer', 'name'))
      @options = options
    end
    # options example:
    # {
    #   jobid: "1123",
    #   xms: '1g',
    #   xmx: '1g',
    #   ext_jvm_config: '',
    #   mode: 'standalone',
    #   params: {},
    #   log_file_name: "log_file_name",
    #   reader: {
    #     name: 'mysqlreader',
    #     table: "test",
    #     jdbc: "jdbc:mysql://bad_ip:3306/database",
    #     ....
    #   }
    #   writer: {
    #     name: 'mysqlwriter',
    #     table: "test",
    #     jdbc: "jdbc:mysql://bad_ip:3306/database",
    #     ....
    #   },
    #   speed: {
    #     "channel": 10,
    #     "byte": 104857600
    #   },
    #   error_limit: {"record": 10, "percentage": 0.05}
    #   reader_custom: true,
    #   writer_custom: fasle,
    # }

    def options
      @options
    end

    def execute
      configs = options.select do |k,v|
        ['jobid', 'ext_jvm_config', 'jobid', 'mode', 'log_file_name'].include?(k)
      end
      configs[:job_file_path] = COMMON_JOB_FILE_PATH
      configs[:params] = {
        reader_config: plugin_init(options.dig('reader', 'name'), options['reader'], options['reader_custom']),
        writer_config: plugin_init(options.dig('writer', 'name'), options['writer'], options['writer_custom']),
        speed_config: (options['speed'].size == 0 ? DEFAULT_SPEED : options['speed']).to_json.inspect,
        error_limit_config: (options['error_limit'].size == 0 ? DEFAULT_ERROR_Limit : options['error_limit']).to_json.inspect
      }
      Datax::Job.new(configs).run_command
    end

    private
    def plugin_init(plugin_name, config, custom)
      if custom == true
        config.to_json.inspect
      else
        eval("Datax::Plugin::#{plugin_name.capitalize}").send(:generate_json, config).inspect
      end
    end

  end
end
