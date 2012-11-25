require 'hashr'
require 'lote/util'

module Lote
  class Route
    using Lote::Util

    DEFAULT_REGEXP = {
      id: /\d+/
    }
    DEFAULT_REGEXP.default = /[a-zA-Z0-9._~\-!$&'()*+,;=]+/
    DEFAULT_REGEXP.freeze

    KEYWORD = /^\:([a-zA-Z_]+)$/.freeze

    def initialize(path, action, regexp = {})
      @controller, @action = action.split('#')
      @regexp = DEFAULT_REGEXP.merge(regexp)

      @paths = path.url_split
    end
    attr_reader *%i(controller action params)

    def route!(path)
      return false unless match?(path)

      @params.dup.merge(
        controller: @controller,
        action: @action
      )
    end

    def match?(path)
      @params = Hashr.new
      path = path.url_split

      [@paths, path].transpose.inject(true) do |result, paths|
        break result unless result

        if paths[0] =~ KEYWORD
          keyword_match_with_assign($1.to_s, paths[1])
        else
          paths[0] == paths[1]
        end
      end
    rescue IndexError
      return false
    end

    def keyword_match_with_assign(keyword, path)
      keyword = keyword.to_sym unless keyword === Symbol

      match = !!path.match(/^#{@regexp[keyword]}$/)

      if match
        @params[keyword] = path
      end

      return match
    end
    private :keyword_match_with_assign
  end
end
