require_relative 'model'

class Locations < Model
  class_inherited_attributes :instances, :db_filename
  @db_filename = "Locations.json"
  attr_reader :name

  def self.validate_hash(model_hash)
    super
    model_hash.key?('name')
  end
end

class User < Model
  @username
  @location
  @password
  @isProvider
  @balance
end

class Consumer < User
  class_inherited_attributes :instances, :db_filename
  @instances = {}
  @db_filename = "Consumers.json"
   attr_reader :username, :location, :password, :balance, :isProvider

  def initialize
    super
  end

  def create(username, location, password)
    @username = username
    @location = location
    @password = password
    @balance = 0
    @isProvider = false
  end
  
  def pay(cost)
    @balance -= cost
  end
  
  def self.validate_hash(model_hash)
    super
    model_hash.key?('username')
    model_hash.key?('location')
    model_hash.key?('password')
    model_hash.key?('balance')
    model_hash.key?('isProvider')
  end


end

class Provider < User
  class_inherited_attributes :instances, :db_filename
  @instances = {}
  @db_filename = "Providers.json"

 attr_reader :username, :location, :password, :storeName, 
              :maxDist, :balance, :isProvider

  def initialize
    super
  end
  
  def create(username, location, password, storeName, maxDist)
    @username = username
    @location = location
    @password = password
    @storeName = storeName
    @maxDist = maxDist
    @balance = 0
    @isProvider = true
  end
  
  def make_it_rain(cost)
    @balance += cost
  end
  
  def self.validate_hash(model_hash)
    super
    model_hash.key?('username')
    model_hash.key?('location')
    model_hash.key?('password')
    model_hash.key?('storeName')
    model_hash.key?('maxDist')
    model_hash.key?('balance')
    model_hash.key?('isProvider')
  end
  
end
