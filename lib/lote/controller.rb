require 'hashr'
require 'tilt'
require 'lote/util'

module Lote
  module Controller
    using Lote::Request
    using Lote::Response
    using Lote::Util

    def initialize(route, request, response)
      @route = route
      @request = request
      @response = response

      @rendered = false
    end
    attr_reader *%i(route request response)

    def execute!
      catch(:halt) do
        method(@route.action).call_with_safe_parameters(params)
        render unless @rendered
      end
    end

    private
      def params
        @request.params.merge(@route)
      end

      def halt(code, message: 'not found')
        @response.status = code
        @response.body = message
        @rendered = true
        throw :halt
      end

      def render(template = nil, code: 200)
        @response.body = Tilt.new(template_path(template)).render(
          self, { params: params }
        )
        @response.status = code
      end

      def template_path(template)
        Dir[
          File.join(
            Application.config.view_path,
            "#{template || default_template}.*"
          )
        ].first || halt(404, message: 'template not found')
      end

      def default_template
        Application.config.template_path % @route.to_hash
      end

    class << self
      def included(klass)
        register(klass)
      end

      def register(klass)
        @controllers ||= {}
        @controllers[klass.name.underscore.sub(/_controller/, '')] = klass
      end

      def controllers
        @controllers || {}
      end
    end
  end
end
