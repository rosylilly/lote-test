require 'rack/response'

module Lote
  module Response
    refine ::Rack::Response do
      def body=(value)
        @body = value.kind_of?(String) ? [ value.to_s ] : value
      end

      def finish
        status, headers, result = super
        result = body if result == self
        [ status, headers, result ]
      end
    end
  end
end
