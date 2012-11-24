module Lote
  %w(
    version
    application
    request
    response
  ).each do |mod|
    require "lote/#{mod}"
  end
end
