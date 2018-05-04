require_relative 'model'

class Item < Model
  class_inherited_attributes :instances, :db_filename
  @instances = {}
  @db_filename = "Items.json"
  
  attr_reader :name, :price, :provider
  
  def initialize
    super
  end
  
  def create(name, price, provider)
    @name = name
    @price = price
    @provider = provider
  end
  
  def self.validate_hash(model_hash)
    super
    model_hash.key?('name')
    model_hash.key?('price')
    model_hash.key?('provider')
  end
end

class Order < Model
  class_inherited_attributes :instances, :db_filename
  @instances = {}
  @db_filename = "Orders.json"
  
  attr_reader :provider, :items, :consumer, :total
  attr_accessor :status
  
  def initialize
    super
  end
  
  def create(provider, items, consumer)
    @provider = provider
    @items = items
    @consumer = consumer
    @status = "payed"
    @total = self.calculate
  end
  
  def calculate
    @total = 0
    @items.each do |key|
      id = key[:id]
      i = Item.find(id)
      @total += (i.price * key[:amount])
    end
    @total
  end
  
  def self.validate_hash(model_hash)
    super
    model_hash.key?('provider')
    model_hash.key?('items')
    model_hash.key?('consumer')
    model_hash.key?('status')
    model_hash.key?('total')
  end
  
end
