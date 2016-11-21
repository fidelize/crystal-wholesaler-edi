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

        order_file = Edi::Model::OrderFile.new
        order_file.id = @env.params.json["id"].as(String).to_i64
        order_file.wholesaler = @env.params.json["wholesaler"].as(String)
        order_file.industry = @env.params.json["industry"].as(String)
        order_file.layout = @env.params.json["layout"].as(String)

        order_file.project_code = @env.params.json["order"].as(Hash)["project_code"].as(String)
        order_file.pos_code = @env.params.json["order"].as(Hash)["pos_code"].as(String)
        order_file.email = @env.params.json["order"].as(Hash)["email"].as(String)
        order_file.wholesaler_code = @env.params.json["order"].as(Hash)["wholesaler_code"].as(String)
        order_file.term = @env.params.json["order"].as(Hash)["term"].as(String)
        order_file.condition_code = @env.params.json["order"].as(Hash)["condition_code"].as(String)
        order_file.order_client = @env.params.json["order"].as(Hash)["order_client"].as(String)
        order_file.markup = @env.params.json["order"].as(Hash)["markup"].as(String)

        @env.params.json["order"].as(Hash)["itens"].as(Hash).each do |key, item|
          order_file.add_item Edi::Model::OrderItem.new(
            item.as(Hash)["ean"].as(String),
            item.as(Hash)["amount"].as(Int64),
            item.as(Hash)["monitored"].as(Bool),
            item.as(Hash)["discount"].as(Float64),
            item.as(Hash)["net_price"].as(Float64)
          )
        end

        if order_file.save
          @env.response.status_code = 201
          return {
            name: order_file.file_path,
            order: @env.params.json["order"].as(Hash)
          }.to_json
        end

        @env.response.status_code = 409
        { status: 409 }.to_json
      end
    end
  end
end
