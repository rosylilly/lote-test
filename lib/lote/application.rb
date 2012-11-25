require 'lote/request'
require 'lote/response'
require 'lote/util'
require 'logger'
require 'lote/router'

module Lote
  class Application
    using Response
    using Request
    using Util

    DEFAULT_CONFIG = {
      controller_path: 'app/controller',
      model_path: 'app/model',
      view_path: 'app/view',
      template_path: '%{controller}/%{action}',
      logger: ::Logger.new(STDOUT)
    }.freeze

    class << self
      def call(env)
        @instance ||= self.new
        return @instance.call(env)
      end

      def initialize!(configru_path, &block)
        @root = File.expand_path('..', configru_path)
        @config = Hashr.new(DEFAULT_CONFIG)

        yield @config if block_given?
      end

      def config
        @config
      end

      def root
        @root
      end
    end

    def initialize
      clear_routes!
    end

    def define_routes!(&block)
      @router.define!(&block)
    end

    def clear_routes!
      @router = Router.new
    end

    def call(env)
      @env = env

      @request = Rack::Request.new(@env)
      logger.debug("#{@request.request_method} #{@request.path_info}")
      logger.debug("params: #{@request.params}")

      @response = Rack::Response.new

      dispatch!

      return @response.finish
    end

    def dispatch!
    end

    def config
      self.class.config
    end

    def logger
      config.logger
    end
  end
end
