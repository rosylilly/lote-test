require 'lote/request'
require 'lote/response'
require 'lote/util'

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
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(@env)
      @response = Rack::Response.new

      @response.body = 'testing'

      return @response.finish
    end
  end
end
