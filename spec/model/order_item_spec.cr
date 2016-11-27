require "../spec_helper"
require "../../src/edi/model/order_item.cr"

describe Edi::Model::OrderItem do
  describe "#initialize" do
    it "correctly initialize all properties" do
      ean = "7894900700046"
      amount = 5.to_i64
      monitored = false
      discount = 10.0.to_f64
      net_price = 3.99.to_f64

      model = Edi::Model::OrderItem.new(ean, amount, monitored, discount, net_price)

      model.ean.should eq ean
      model.amount.should eq amount
      model.monitored.should eq monitored
      model.discount.should eq discount
      model.net_price.should eq net_price
    end
  end
end
