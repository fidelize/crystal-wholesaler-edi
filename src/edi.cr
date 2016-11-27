require "kemal"
require "option_parser"
require "./edi/controller/orders_controller.cr"
require "./edi/config.cr"

port = 3000
start = false
directory = "files/"
secret = "secret"

# Menu
parser = OptionParser.parse! do |parser|
  parser.banner = "Usage: edi [arguments]"
  parser.on("start", "Start the server") { start = true }
  parser.on("-p NUMBER", "--port=NUMBER", "Server port") { |number| port = number.to_i32 }
  parser.on("-d PATH", "--directory=PATH", "Directory for EDI files") { |path| directory = path.to_s }
  parser.on("-s KEY", "--secret=KEY", "JWT secret key") { |key| secret = key.to_s }
  parser.on("-h", "--help", "Show this help") { puts parser }
end

# APIs
post "/api/v1/orders" do |env|
  controller = Edi::Controller::OrdersController.new(env)
  controller.create
end

# Configuration
Edi::Config.directory = directory
Edi::Config.secret = secret

# Run
if start
  Kemal.run port
else
  puts parser
end
