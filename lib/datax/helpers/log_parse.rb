module Datax
  module Helpers
    module LogParse

      def self.get_error_info(log_file)
        begin
          file = File.open(log_file, "r")
          info = ""
          file.each_line do |line|
             if !(/com\.alibaba\.datax\.common\.exception.*Code\:.+/.match(line).nil?)
               info = line
               break
             end
          end
          file.close
          info&.strip&.gsub(/\n/, '')
        rescue Exception => e
          ""
        end
      end

      def self.get_success_info(log_file)
        begin
          file = File.open(log_file, "r")
          ret = {}
          file.each_line do |line|
             if !(/counter={writeSucceedRecords=.*}/.match(line).nil?)
               result = line&.match(/{.*}/)&.to_s&.gsub(/{|}| /, '')&.split(",")&.map do |c|
                 d=c.split("=")
                 [d[0].to_sym, d[1]]
               end&.to_h
               ret.merge!( result || {} )
             elsif !(/任务启动时刻/.match(line).nil?)
               ret[:startAt] = line&.split(": ")&.last&.gsub(/\n/, '')&.strip
             elsif !(/任务结束时刻/.match(line).nil?)
               ret[:endAt] = line&.split(": ")&.last&.gsub(/\n/, '')&.strip
             elsif !(/任务总计耗时/.match(line).nil?)
               ret[:totalTime] = line&.split(":")&.last&.gsub(/\n/, '')&.strip
             elsif !(/任务平均流量/.match(line).nil?)
               ret[:averageSpeed] = line&.split(":")&.last&.gsub(/\n/, '')&.strip
             elsif !(/记录写入速度/.match(line).nil?)
               ret[:writeSpeed] = line&.split(":")&.last&.gsub(/\n/, '')&.strip
             elsif !(/读出记录总数/.match(line).nil?)
               ret[:readRecords] = line&.split(":")&.last&.gsub(/\n/, '')&.strip
             elsif !(/读写失败总数/.match(line).nil?)
               ret[:totalErrorRecords] = line&.split(":")&.last&.gsub(/\n/, '')&.strip
             end
          end
          file.close
          ret.select!{|k,v| [:writeFailedRecords, :writeFailedBytes, :totalErrorRecords, :totalErrorBytes, :waitReaderTime, :waitWriterTime, :writeReceivedBytes, :totalReadBytes, :startAt, :endAt, :totalTime, :averageSpeed, :writeSpeed, :readRecords].include?(k)}
        rescue Exception => e
          {}
        end
      end

      # def self.get_pref_info(log_file_name)
      # end

    end
  end
end
