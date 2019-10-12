require 'datax/helpers/log_parse'
require 'datax/helpers/job_config'
module Datax
  module Helpers
    module JobCommand
      # java -server -Xms1g -Xmx1g -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/Users/fanink/tools/datax/log -Dloglevel=info -Dfile.encoding=UTF-8 -Dlogback.statusListenerClass=ch.qos.logback.core.status.NopStatusListener -Djava.security.egd=file:///dev/urandom -Ddatax.home=/Users/fanink/tools/datax -Dlogback.configurationFile=/Users/fanink/tools/datax/conf/logback.xml -classpath /Users/fanink/tools/datax/lib/*:. -Ddatax.log_path=******** -Dlog.file.name=_datax_job_test_json com.alibaba.datax.core.Engine -mode standalone -jobid -1 -job /Users/fanink/tools/datax/job/test.json
      ENGINE_COMMAND = "java -server %s -Dloglevel=all %s -classpath %s %s %s com.alibaba.datax.core.Engine -mode %s -jobid %s -job %s"
      # DEFAULT_JVM_CONFIG = "-Xms%s -Xmx%s -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=%s"
      DEFAULT_PROPERTY_CONF = "-Dfile.encoding=UTF-8 -Dlogback.statusListenerClass=ch.qos.logback.core.status.NopStatusListener -Djava.security.egd=file:///dev/urandom -Ddatax.home=%s -Dlogback.configurationFile=%s"
      DEFAULT_LOG_CONFIG = "-Ddatax.log_path=%s -Dlog.file.name=%s"



      def run_command
        command=generate_job_command
        #puts command
        if system command
          ret = Datax::Helpers::LogParse.get_success_info(self.run_log_path)
          {status: true, data: ret}
        else
          ret = Datax::Helpers::LogParse.get_error_info(self.run_log_path)
          {status: false, msg: ret}
        end
      end

      private
      def generate_job_command
        option_parse_ret = option_parse
        ENGINE_COMMAND % [
          # option_parse_ret[:default_jvm],
          option_parse_ret[:ext_jvm_config],
          DEFAULT_PROPERTY_CONF % [
            Datax.original_datax_path,
            Datax.logback_conf_path
          ],
          Datax.java_lib_path,
          DEFAULT_LOG_CONFIG % [
            Datax.log_path,
            self.log_file_name
          ],
          option_parse_ret[:params],
          option_parse_ret[:mode],
          option_parse_ret[:jobid],
          option_parse_ret[:job]
        ]
      end

      def option_parse
        ret = {}
        unless options['job_config'].nil?
          Datax::Helpers::JobConfig.create(
            options['job_file_path'],
            options['job_config'],
            options['overwritten']
          )
        end
        ret[:job] = options['job_file_path']
        # ret[:default_jvm] = DEFAULT_JVM_CONFIG % [
        #   options['xms'],
        #   options['xmx'],
        #   Datax.dump_path
        # ]
        ret[:params] = params_parse(options['params'])
        [:mode, :jobid, :ext_jvm_config].each do |k|
          ret[k] = options[k.to_s]
        end
        ret
      end

      def params_parse(params)
        params.map do |k,v|
          "-D#{k}=#{v}"
        end.join(" ")
      end

    end
  end
end
