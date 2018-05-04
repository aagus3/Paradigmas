LOCATIONS = {
    1 => {id: 1, name: 'Location 1'},
    2 => {id: 2, name: 'Location 2'}
}

CONSUMERS = {
    'consumer@consumer.com' => {id: 3, email: 'consumer1@consumer.com',
                                location: 1, balance: 0}
}

PROVIDERS = {
    'provider@provider.com' => {id: 4, email: 'provider1@provider.com',
                                location: 2, store_name: 'Provider 1',
                                balance: 0}
}

ITEMS = {
    5 => {
      id: 5,
      name: 'Item 1',
      provider: 4,
      price: 50.0
    }
}

ORDERS = {
    6 => {
      id: 6,
      consumer: 3,
      provider: 4,
      items: {
          5 => 3
      },
      status: 'delivered',
      total: 150.0
    }
}

MAX_ID = 6