require "./order_item.cr"

module Edi
  module Model
    class OrderFile
      property id : Int64?
      property wholesaler : String?
      property industry : String?
      property layout : String?

      property project_code : String?
      property pos_code : String?
      property email : String?
      property wholesaler_code : String?
      property term : String?
      property condition_code : String?
      property order_client : String?
      property markup : String?

      property itens : Array(Edi::Model::OrderItem)

      def initialize
        @itens = [] of Edi::Model::OrderItem
      end

      def add_item(item : Edi::Model::OrderItem)
        @itens << item
      end

      def save
        false
      end

      def file_path
        "/file/path"
      end
    end
  end
end
