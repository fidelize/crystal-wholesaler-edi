require "kemal"
require "./edi/*"

get "/api/v1/orders" do
  "GET Hello World!"
end

post "/api/v1/orders" do
  "POST Hello World!"
end

Kemal.run
