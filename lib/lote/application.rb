require 'lote/request'
require 'lote/response'
require 'lote/util'
require 'lote/router'

module Lote
  class Application
    using Response
    using Request
    using Util

    class << self
      def call(env)
        @instance ||= self.new
        return @instance.call(env)
      end

      def initialize!
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
      @response = Rack::Response.new

      dispatch!

      return @response.finish
    end

    def dispatch!
    end
  end
end
