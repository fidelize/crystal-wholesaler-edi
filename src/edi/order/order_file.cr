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
        return false if File.exists?(file_path)
        File.write(file_path, file_content)
        true
      end

      def file_path
        "files/#{file_name}"
      end

      private def file_name
        [
          "PEDIDO",
          id.to_s.rjust(10, '0'),
          wholesaler_code.to_s.rjust(14, '0'),
          project_code.to_s
        ].join('_') + ".PED." + SecureRandom.uuid
      end

      private def file_content
        [
          register_1,
          register_2,
          register_9
        ].join("\n")
      end

      private def register_1
        [
          "1",
          pos_code.to_s,
          email.to_s,
          wholesaler_code.to_s,
          term.to_s,
          condition_code.to_s,
          order_client.to_s,
          id.to_s,
          markup.to_s
        ].join(";")
      end

      private def register_2
        registers = [] of String

        itens.each do |item|
          registers << [
            "2",
            item.ean,
            item.amount.to_s,
            item.discount.to_s,
            item.net_price.to_s,
            term.to_s,
          ].join(";")
        end

        registers.join("\n")
      end

      private def register_9
        [
          "9",
          itens.size.to_s
        ].join(";")
      end
    end
  end
end
