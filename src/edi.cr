require "kemal"
require "./edi/controller/orders_controller.cr"

post "/api/v1/orders" do |env|
  controller = Edi::Controller::OrdersController.new(env)
  controller.create
end

Kemal.run
