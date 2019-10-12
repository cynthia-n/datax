require 'datax/helpers/job_command'
module Datax
  class Job
    include Datax::Helpers::JobCommand
    DEFAULT_OPTION = {
      # xms: '1g',
      # xmx: '1g',
      ext_jvm_config: '',
      jobid: '-1',
      mode: 'standalone',
      params: {},
      overwritten: false,
      job_file_path: nil,
      job_config: nil,
    }.as_json.freeze
    REQUIRED_PARAMS = ['job_file_path']
    def initialize(options = {})
      options = options.as_json
      REQUIRED_PARAMS.map do |k|
        raise "options #{k.to_s} must exist" if options[k].nil?
      end
      @log_file_name = options['log_file_name'] || Time.now().to_i.to_s
      @options = DEFAULT_OPTION.dup
      @options.merge!(options.select{|k,v| !(v.nil?)})
    end

    def options
      @options
    end

    def log_file_name
      @log_file_name
    end

    def run_log_path
      File.join(Datax.log_path,"log", "#{log_file_name}.log")
    end

    # def pref_log_path
    #   File.join(Datax.log_path,"log", "#{command[:log_file_path]}.log")
    # end

  end
end
