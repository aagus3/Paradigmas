#\ -p 4000

require 'rack-proxy'
require 'sinatra'
require './app'
require_relative './models/user'
require_relative './models/item'

## Function to load all instances of model_class from the json file.
def load_model(model_class)
  begin
    file_content = File.read(model_class.db_filename)
    json_data = JSON.parse(file_content)
  rescue Errno::ENOENT
    # The file does not exists
    json_data = []
  end
  json_data.each do |data_hash|
    new_object = model_class.from_hash(data_hash)
    new_object.save
  end
end

warmup do
  # puts 'Loading objects from json files'
  load_model(Locations)
  load_model(Consumer)
  load_model(Provider)
  load_model(Item)
  load_model(Order)
end

# Setting up routes
ROUTES = {
  '/' => DeliveruApp
}

## For development environment use a proxy to the React App
configure :development do
  # Class to act as proxy for the react server, which will run in port 3000
  class AppProxy < Rack::Proxy
    def rewrite_env(env)
      env['HTTP_HOST'] = 'localhost:3000'
      env
    end
  end

  ROUTES['/static'] = AppProxy.new
end

# Run the application
run Rack::URLMap.new(ROUTES)
