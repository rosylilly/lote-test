require 'rack/request'
require 'hashr'

module Lote
  module Request
    refine ::Rack::Request do
      def params
        @hashr_params ||= Hashr.new(super)
      end
    end
  end
end
