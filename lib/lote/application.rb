require 'logger'
require 'lote/request'
require 'lote/response'
require 'lote/util'
require 'lote/router'
require 'lote/controller'

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
        @instance ||= begin
          instance = self.new
          instance.define_routes!(&@routes_block) if @routes_block

          instance
        end

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

      def controllers
        Lote::Controller.controllers
      end

      def routes!(&block)
        @routes_block = block
      end
    end

    def initialize
      clear_routes!
      auto_require!
    end

    def auto_require!
      %i(controller_path model_path).each do |key|
        Dir[File.join(self.class.root, config[key], '**/*.rb')].each do |file|
          require file
        end
      end
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
      matched_route = @router.routing(
        @request.request_method.downcase.to_sym,
        @request.path_info
      )


      if matched_route
        controller = self.class.controllers[matched_route.controller]
        controller.new(matched_route, @request, @response).execute!
      else
        halt(404)
      end
    end

    def halt(code)
      @response.status = code
      @response.body = ''
    end

    def config
      self.class.config
    end

    def logger
      config.logger
    end
  end
end
