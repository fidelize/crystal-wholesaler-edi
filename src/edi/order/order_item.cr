module Edi
  module Model
    class OrderItem
      property ean : String
      property amount : Int64
      property monitored : Bool
      property discount : Float64
      property net_price : Float64

      def initialize(@ean, @amount, @monitored, @discount, @net_price)
      end
    end
  end
end
