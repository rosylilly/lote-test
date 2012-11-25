require 'slim'

class HomeController
  include Lote::Controller

  def index(message: 'hello', title_size: 120)
    @message = message
    @title_size = title_size
  end

  def not_found
    halt 404
  end
end
