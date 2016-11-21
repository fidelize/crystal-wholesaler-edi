require "kemal"
require "json"
require "jwt"
require "./edi/order/order_file.cr"
require "./edi/order/order_item.cr"

def authenticated?(env)
  begin
    authorization_header = env.request.headers["Authorization"]
    token = authorization_header.split(' ').last
    payload, header = JWT.decode(token, "secret", "HS256")
    return true
  rescue
    return false
  end
end

before_all do |env|
  env.response.content_type = "application/json"
end

post "/api/v1/orders" do |env|
  # Authentication
  unless authenticated? env
    env.response.status_code = 401
    next { status: 401 }.to_json.to_json
  end

  order_file = Edi::Model::OrderFile.new
  order_file.id = env.params.json["id"].as(String).to_i64
  order_file.wholesaler = env.params.json["wholesaler"].as(String)
  order_file.industry = env.params.json["industry"].as(String)
  order_file.layout = env.params.json["layout"].as(String)

  order_file.project_code = env.params.json["order"].as(Hash)["project_code"].as(String)
  order_file.pos_code = env.params.json["order"].as(Hash)["pos_code"].as(String)
  order_file.email = env.params.json["order"].as(Hash)["email"].as(String)
  order_file.wholesaler_code = env.params.json["order"].as(Hash)["wholesaler_code"].as(String)
  order_file.term = env.params.json["order"].as(Hash)["term"].as(String)
  order_file.condition_code = env.params.json["order"].as(Hash)["condition_code"].as(String)
  order_file.order_client = env.params.json["order"].as(Hash)["order_client"].as(String)
  order_file.markup = env.params.json["order"].as(Hash)["markup"].as(String)

  env.params.json["order"].as(Hash)["itens"].as(Hash).each do |key, item|
    order_file.add_item Edi::Model::OrderItem.new(
      item.as(Hash)["ean"].as(String),
      item.as(Hash)["amount"].as(Int64),
      item.as(Hash)["monitored"].as(Bool),
      item.as(Hash)["discount"].as(Float64),
      item.as(Hash)["net_price"].as(Float64)
    )
  end

  env.response.status_code = 409
  response_body = { status: 409 }.to_json

  if order_file.save
    env.response.status_code = 201
    response_body = {
      name: order_file.file_path,
      order: env.params.json["order"].as(Hash)
    }.to_json
  end

  response_body
end

Kemal.run
