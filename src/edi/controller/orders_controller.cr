require "json"

require "./application_controller.cr"
require "../model/order_file.cr"
require "../model/order_item.cr"

module Edi
  module Controller
    class OrdersController < ApplicationController
      def create
        unless authenticated?
          @env.response.status_code = 401
          return { status: 401 }.to_json.to_json
        end

        order_file = new_order_file

        if order_file.save
          @env.response.status_code = 201
          return {
            name: order_file.file_path,
            order: json_param("order").as(Hash)
          }.to_json
        end

        @env.response.status_code = 409
        { status: 409 }.to_json
      end

      private def new_order_file
        order_file = Edi::Model::OrderFile.new
        order_file.id = json_param("id").to_s.to_i64
        order_file.wholesaler = json_param("wholesaler").to_s
        order_file.industry = json_param("industry").to_s
        order_file.layout = json_param("layout").to_s

        order_file.project_code = json_param("order").as(Hash)["project_code"].to_s
        order_file.pos_code = json_param("order").as(Hash)["pos_code"].to_s
        order_file.email = json_param("order").as(Hash)["email"].to_s
        order_file.wholesaler_code = json_param("order").as(Hash)["wholesaler_code"].to_s
        order_file.term = json_param("order").as(Hash)["term"].to_s
        order_file.condition_code = json_param("order").as(Hash)["condition_code"].to_s
        order_file.order_client = json_param("order").as(Hash)["order_client"].to_s
        order_file.markup = json_param("order").as(Hash)["markup"].to_s

        json_param("order").as(Hash)["itens"].as(Hash).each do |key, item|
          order_file.add_item new_order_item(item)
        end

        order_file
      end

      private def new_order_item(item)
        Edi::Model::OrderItem.new(
          item.as(Hash)["ean"].to_s,
          item.as(Hash)["amount"].as(Int64),
          item.as(Hash)["monitored"].as(Bool),
          item.as(Hash)["discount"].as(Float64),
          item.as(Hash)["net_price"].as(Float64)
        )
      end
    end
  end
end
