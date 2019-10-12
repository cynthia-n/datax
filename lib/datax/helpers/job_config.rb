module Datax
  module Helpers
    module JobConfig

      def self.create(file_path, config_json, overwritten)
        raise "The job config filename already exists" if File.exist?(file_path) && overwritten == false
        File.open(file_path,"w") do |file|
          file.puts config_json
        end
      end

    end
  end
end
