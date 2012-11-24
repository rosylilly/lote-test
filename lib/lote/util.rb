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
    end
  end
end
