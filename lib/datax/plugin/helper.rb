module Datax
  module Plugin
    module Helper
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def parse_options(ret, options)
          result = ret
          ret.each do |k, v|
            case v.class.to_s
            when 'Array'
              if v.first.is_a?(Hash) || v.first.is_a?(Array)
                result[k] = v.map{|a| parse_options(a, options)}
              else
                result[k] = (options[k].is_a?(Array) ? options[k] : [options[k]]) unless options[k].nil?
              end
            when 'Hash'
              result[k] = parse_options(v, options)
            else
              result[k] = options[k] || result[k]
            end
          end
          result
        end

        def generate_json(options)
          ret = parse_options(self::DEFAULT_CONFIG.dup, options)
          if self.respond_to?(:special_handle)
            ret = self.send(:special_handle, *[ret, options])
          end
          ret.to_json
        end
      end

    end
  end
end
