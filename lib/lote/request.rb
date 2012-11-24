require 'rack/request'
require 'hashr'

module Lote
  module Request
    refine ::Rack::Request do
      def params
        @hashr_params ||= Hashr.new(@params)
      end
    end
  end
end
