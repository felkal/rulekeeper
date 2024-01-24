package rulekeeper

# Experiment 1: As a user, get articles.
test_access_articles {
	allow with input as {
	"operation": "GET /api/articles",
	"data": ["id", "name", "image", "brand", "price", "category", "countInStock", "description", "rating", "numReviews", "reviews.name", "reviews.rating", "reviews.comment"],
    "table": "products" }
}

# Experiment 2: As a user, order a product.
test_user_get_profile {
	allow with input as {
	"operation": "POST /api/orders",
	"principal": "user3@amazona.com",
	"data": ["user", "orderItems.name", "orderItems.qty", "orderItems.image", "orderItems.price", "orderItems.product", "shipping.address", "shipping.city", "shipping.postalCode", "shipping.country", "payment.paymentMethod", "itemsPrice", "taxPrice", "shippingPrice", "totalPrice", "isPaid", "paidAt", "isDelivered", "deliveredAt"],
    "table": "orders" }
}

# Experiment 3: As a user, comment an article.
test_user_see_orders {
	allow with input as {
	"operation": "GET /api/orders/mine",
	"principal": "user2@amazona.com",
	"data": ["user", "orderItems.name", "orderItems.qty", "orderItems.image", "orderItems.price", "orderItems.product", "shipping.address", "shipping.city", "shipping.postalCode", "shipping.country", "payment.paymentMethod", "itemsPrice", "taxPrice", "shippingPrice", "totalPrice", "isPaid", "paidAt", "isDelivered", "deliveredAt"],
    "table": "orders" }
}