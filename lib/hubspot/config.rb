require 'logger'

module Hubspot
  class Config

    CONFIG_KEYS = [:hapikey, :base_url, :portal_id, :logger]
    DEFAULT_LOGGER = Logger.new('/dev/null')

    class << self

      CONFIG_KEYS.each do |key|
        define_method("#{key}=") do |value|
          Thread.current[:hubspot_ruby_config][key] = value
        end

        define_method(key) do
          Thread.current[:hubspot_ruby_config][key]
        end
      end

      def configure(config)
        reset!
        Thread.current[:hubspot_ruby_config].merge!(config.symbolize_keys)
        self
      end

      def reset!
        Thread.current[:hubspot_ruby_config] = {
            hapikey: nil,
            base_url: 'https://api.hubapi.com',
            portal_id: nil,
            logger: DEFAULT_LOGGER
        }
        true
      end

      def ensure!(*params)
        params.each do |p|
          raise Hubspot::ConfigurationError.new("'#{p}' not configured") unless send(p)
        end
      end
    end

    reset!
  end
end
