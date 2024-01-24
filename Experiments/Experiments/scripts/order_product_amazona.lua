mongo = require 'mongo'
counter = 0

client = mongo.Client('...')
orders = client:getCollection('amazona', 'orders')

request = function()
   wrk.method = "POST"
   wrk.body = '{ "isPaid": "false", "isDelivered": "false", "user": "User 1", "shipping": { "address": "Street 1", "city": "City 1", "postalCode": "Postal Code 1", "country": "Country 1" }, "payment": { "paymentMethod": "paypal" }, "itemsPrice": "420", "taxPrice": "63", "shippingPrice": "0", "totalPrice": "483", "orderItems": [ { "product": "6233763378c5901c58b8630e", "name": "Slim Shirt 150", "image": "/images/d1.jpg", "price": "60", "qty": "1" }, { "product": "6233763378c5901c58b8630f", "name": "Slim Shirt 150", "image": "/images/d1.jpg", "price": "60", "qty": "1" } ] }'
   wrk.headers["Content-Type"] = "application/json"
   path = "/api/orders"
   counter = counter + 1
   if (counter == 25) then
      orders:remove('{"user": "User 3"}')
      counter = 0
   end
   return wrk.format(nil, path)
end
