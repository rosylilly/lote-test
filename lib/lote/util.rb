module Lote
  module Util
    refine String do
      def html_safe
        dup.html_safe!
      end

      def html_safe?
        @html_safe
      end

      def html_safe!
        @html_safe = true
        self
      end

      def camelize
        self.gsub(/^[a-z]|_[a-z]/) do |char|
          char[-1].upcase
        end.gsub(/\/[a-z]/) do |char|
          "::#{char[-1].upcase}"
        end
      end

      def underscore
        self.gsub(/::[A-Z]/) do |char|
          "/#{char[-1].downcase}"
        end.gsub(/^[A-Z]/) do |char|
          char[-1].downcase
        end.gsub(/[A-Z]/) do |char|
          "_#{char[-1].downcase}"
        end
      end

      def url_split
        self.split('/').reject(&:empty?)
      end
    end

    refine Method do
      # FIXME このへん無茶苦茶なことしすぎ
      def call_with_safe_parameters(params)
        required_params = []
        keywords = []
        with_rest = false
        with_keyrest = false

        self.parameters.each do |type, name|
          case type
          when :req
            required_params << name
          when :key
            keywords << name
          when :rest
            with_rest = true
          when :keyrest
            with_keyrest = true
          end

          args = []
          required_params.each do |name|
            args << params[name] unless params[name].nil?
          end

          if with_rest
            args.concat(params.to_a.reject{|param| required_params.include?(param[0]) })
          end

          kargs = {}

          unless keywords.empty?
            keywords.each do |key|
              kargs[key] = params[key] unless params[key].nil?
            end
          end

          if with_keyrest
            kargs = params
          end

          if args.empty? && kargs.empty?
            call
          elsif args.any? && kargs.empty?
            call(*args)
          elsif args.empty? && kargs.any?
            call(**kargs)
          else
            call(*args, **kargs)
          end
        end
      end
    end
  end
end
