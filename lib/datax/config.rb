module Datax
  DATAX_VERSION = 'DATAX-OPENSOURCE-3.0'.freeze
  CURRENT_GEM_PATH = Gem.path.find do |base|
    path = $LOAD_PATH.find do |path|
      break path if path[%r{\A#{base}/(?:bundler/)?gems/datax\-[^/-]+?}x]
    end
    break path if path
  end.freeze
  DEFAULTS = {
    log_path: File.join(ENV['PWD'], 'log/datax_log'),
    dump_path: File.join(ENV['PWD'], 'log/datax_dump'),
    original_datax_path: File.join(CURRENT_GEM_PATH || "", 'datax/datax_jar'),
    java_lib_path: File.join(CURRENT_GEM_PATH || "", 'datax/datax_jar/lib/*:.'),
    logback_conf_path: File.join(CURRENT_GEM_PATH || "", 'datax/datax_jar/conf/logback.xml')
  }.freeze
  CONFIGURABLE = [:log_path, :dump_path].freeze

  class << self
    def options
      @options ||= DEFAULTS.dup
    end
    attr_writer :options

    def configure
      yield self
    end

    def root_path
      CURRENT_GEM_PATH
    end
  end

  DEFAULTS.each do |k, _v|
    define_singleton_method k do
      options[k]
    end
  end

  CONFIGURABLE.each do |k|
    define_singleton_method "#{k}=" do |value|
      options.merge!(k => value) unless value.nil?
    end
  end
end
