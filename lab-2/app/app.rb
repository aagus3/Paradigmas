require 'json'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/namespace'
require_relative './models/item'

# Main class of the application
class DeliveruApp < Sinatra::Application
  register Sinatra::Namespace

  enable :sessions unless test?

  configure :development do
    pid = begin
            File.read('./node.pid')
          rescue StandardError
            nil
          end

    if pid.nil?
      ## Start the node server to run React
      pid = Process.spawn('npm run dev')
      Process.detach(pid)
      File.write('./node.pid', pid.to_s)
    end
  end

  ## Function to clean up the json requests.
  before do
    begin
      if request.body.read(1)
        request.body.rewind
        @request_payload = JSON.parse(request.body.read, symbolize_names: true)
      end
    rescue JSON::ParserError
      request.body.rewind
      puts "The body #{request.body.read} was not JSON"
    end
  end

  register do
    def auth
      condition do
        halt 401 unless session.key?(:logged_id) || self.settings.test?
      end
    end
  end

  ## API functions
  namespace '/api' do

    post '/login' do
      e = @request_payload[:email]
      p = @request_payload[:password]
      h = {'username'=> e}
      users = Consumer.filter(h) + Provider.filter(h)
      us = users[0]

      if !us.nil?
        if us.password == p
          session[:logged_id] = us.id
          return {"id" => us.id, "isProvider" => us.isProvider}.to_json
        else
          halt 403, 'incorrect password'
        end
      else
        halt 401, 'non existing user'
      end
    end

    post '/logout' do
      session[:logged_id] = nil
      redirect '/'
    end

    post '/consumers' do
      e = @request_payload[:email]
      l = @request_payload[:location]
      p = @request_payload[:password]
      
      if e.nil? || l.nil?
        halt 400, 'no email/location'
      else
        h = {'username'=> e}
        cusers = Consumer.filter(h)
        pusers = Provider.filter(h)
        cus = cusers[0]
        pus = pusers[0]
        if !cus.nil? || !pus.nil?
          halt 409, 'existing user'
        else
          user = Consumer.new
          user.create(e, l, p)
          user.save
          return user.id.to_json
        end
      end

    end

    post '/providers' do
      e = @request_payload[:email]
      l = @request_payload[:location]
      p = @request_payload[:password]
      s_n = @request_payload[:store_name]
      m_d_d = @request_payload[:max_delivery_distance]

      h = {'username'=> e}
      cusers = Consumer.filter(h)
      pusers = Provider.filter(h)
      cus = cusers[0]
      pus = pusers[0]
      
      if !cus.nil? || !pus.nil?
        halt 409, 'existing provider'
      elsif e == nil || l == nil || s_n == nil
        halt 400, 'no email/location/store_name'
      end
      user = Provider.new
      user.create(e, l, p, s_n, m_d_d)
      user.save
      return user.id.to_json
    end
    
    post '/items' do
      n = @request_payload[:name]
      pri = @request_payload[:price]
      pro = @request_payload[:provider]


      if n == nil || pri == nil || pro == nil
        halt 400, 'no name/price/provider'
      end
      h = {"id" => pro.to_i}
      users = Provider.filter(h)
      us = users[0]
      if us == nil
        halt 404, 'non existing provider'
      end
      i_name = {"provider" => pro.to_i, "name" => n}
      eitem = Item.filter(i_name)
      ei = eitem[0]
      if ei != nil
        halt 409, 'duplicate item for provider'
      end
      
      item = Item.new
      item.create(n,pri,pro)
      item.save
      return item.id.to_json
   end
   
    post '/items/delete/:id' do
      id = params[:id].to_i
      h = {"id" => id}
      items = Item.filter(h)
      it = items[0]

      if it == nil
        halt 404, 'non existing item'
      elsif id == it.provider
        halt 403, 'item not belonging to logged in provider'
      else
        Item.delete(id)
        Item.save
      end
    end
    
    get '/providers' do
      loc = params[:location]
      h = {'location' => loc.to_i}
      locations = Locations.filter(h)

      if loc == nil
        providers = Provider.all
      else
        providers = Provider.filter(h)
      end
      if locations == nil
        halt 404, 'non existing location'
      end
      json_response = []
      providers.each do |pro|
        json_response << {'id': pro.id, 'email': pro.username,  'location': pro.location,
                          'store_name': pro.storeName, 'max_delivery_distance': pro.maxDist}
      end
      json_response.to_json
    end

    get '/consumers' do
      consumers = Consumer.all
      json_response = []
      consumers.each do |consumer|
        json_response << {'id' => consumer.id, 'username': consumer.username, 'location': consumer.location}
      end
      json json_response
    end
    
    post '/users/delete/:id' do
      id = params[:id].to_i
      users = Consumer.find(id)
      pusers = Provider.find(id)

      if !users.nil?
        Consumer.delete(id)
      end
      if !pusers.nil?
        Provider.delete(id)
      end
      if users.nil? || pusers.nil?
        halt 404, 'non existing user'
      end
    end
    
    get '/items' do
      pro = params[:provider]
      if pro == nil
        items = Item.all
      else
        i = {"provider" => pro.to_i}
        provider = Provider.index?(pro.to_i)
        if provider == false
          halt 404, 'non existing provider'
        else
         items = Item.filter(i)
        end
      end
      
      json_response = []
      items.each do |it|
        json_response << {'id' => it.id, 'name' => it.name,  'price' => it.price, 'provider' => pro.to_i}
      end
      json json_response
    end
    
    post '/orders' do
      p = @request_payload[:provider]
      i = @request_payload[:items]
      c = @request_payload[:consumer]
      
      if p == nil || i == nil || c == nil || i.length == 0
        halt 400, 'no consumer/item/provider'
      end

      provider = Provider.find(p)
      consumer = Consumer.find(c)
      items = []
      i.each do |item|
        it = Item.exists?({"id" => item[:id]})
        if it 
          items << it
        else
          halt 404, 'non existing item' 
        end
      end
      
      if provider == nil || consumer == nil
        halt 404, 'non existing consumer/provider'
      end

      order = Order.new
      order.create(p,i,c)
      order.save
      consumer.pay(order.total)
      Consumer.save
      provider.make_it_rain(order.total)
      Provider.save
      return order.id.to_json
    end
    
    get '/orders/detail/:id' do
      user_id = params[:id]
      json_response = []
      
      if user_id == nil
        halt 400, 'no id'
      end
      order = Order.find(user_id.to_i)
      if order == nil
        halt 404, 'non existing id'
      end
      
      o = order.to_hash

      o["items"].each do |item|
        it = Item.find(item[:id])
        json_response << {'id' => item[:id], 'name' => it.name, 
                          'price' => it.price, 'amount' => item[:amount]}
      end
      json json_response
    end

    get '/orders' do
      json_response = []
      user_id = params[:user_id]
      
      if user_id == nil
        halt 400, 'no user_id'
      else
        consumer = Consumer.index?(user_id.to_i)
        provider = Provider.index?(user_id.to_i)
        if consumer == false && provider == false
          halt 404, 'non existing consumer'
        else
          c = {"consumer" => user_id.to_i}
          d = {"provider" => user_id.to_i}
          orders = Order.filter(c) + Order.filter(d)
        end
        if orders[0] != nil
          consumer = Consumer.find(orders[0].consumer)
        else
          return json json_response
        end
      end
      
      orders.each do |order|
        provider = Provider.find(order.provider)
        json_response << {'id': order.id,   'provider': provider.id,  'provider_name': provider.storeName,
        'consumer': consumer.id, 'consumer_email': consumer.username, 'consumer_location': consumer.location, 'order_amount': order.total,
        'status': order.status}
      end
      json json_response
    end
    
    
    post '/deliver/:id' do
      id = params[:id].to_i
      h = {"id" => id}
      orders = Order.filter(h)
      o = orders[0]

      if o == nil
        halt 404, 'non existing order'
      else
        o.status = "delivered"
        Order.save
      end
    end
    
    post '/orders/delete/:id' do
      id = params[:id].to_i
      orders = Order.delete(id)
    end

    get '/users/:id' do
      id = params[:id].to_i
      users = Consumer.find(id)

      if id == nil
        halt 400, 'no user_id'
      end
      if users == nil
        users = Provider.find(id)
        if users == nil
          halt 404, 'non existing user'
        else
            return  {"username" => users.username, "location" => users.location, "balance" => users.balance, "store_name" => users.storeName, "max_delivery_distance" => users.maxDist}.to_json
        end
      else
        return {"username" => users.username, "location" => users.location, "balance" => users.balance}.to_json
      end
    end
    
    get '/locations' do
      locations = Locations.all
      json_response = []
      locations.each do |location|
        json_response << location.to_hash
      end
      json json_response
    end

    get '*' do
      halt 404
    end
  end

  # This goes last as it is a catch all to redirect to the React Router
  get '/*' do
    erb :index
  end
end
