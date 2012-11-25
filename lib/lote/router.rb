require 'lote/route'

module Lote
  class Router
    HTTP_METHODS = %i(
      get post put delete
      head options trace connect
      patch link unlink
    ).freeze

    def initialize(&block)
      @routes = Hash[ HTTP_METHODS.map {|method| [ method, [] ] } ]
      define!(&block) if block_given?
    end

    def define!(&block)
      instance_eval(&block) if block_given?
    end

    def set(method, path, action, regexp = {})
      @routes[method] << Route.new(path, action, regexp)
    end

    HTTP_METHODS.each do |method|
      define_method(method) {|*args| set(method, *args) }
    end

    def routing(method, path)
      routes = @routes[method]

      routes.inject(false) do |matched, route|
        matched || route.route!(path)
      end
    end
  end
end
