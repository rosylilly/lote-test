module Lote
end

%w(
  version
  application
  request
  response
  util
).each do |mod|
  require "lote/#{mod}"
end
