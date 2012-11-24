require 'lote/request'
require 'lote/response'

module Lote
  class Application
    using Response
    using Request

    class << self
      def call(env)
        @instance ||= self.new
        return @instance.call(env)
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
