#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Check if mongoimport command is available
if command -v mongoimport &> /dev/null; then
    echo "mongoimport is installed."
else
    echo "mongoimport is not installed. Please install it before running this script."
    exit 1
fi

# Check if the Docker container "realworld-mongo" is up and running
if docker ps -q --filter "name=realworld-mongo" | grep -q .; then
    echo "Docker container 'realworld-mongo' is running."
else
    echo "Docker container 'realworld-mongo' is not running. Please start it before running this script."
    exit 1
fi

echo "All checks passed."

# MongoDB URL for "amazona" database (assuming default MongoDB port)
MONGODB_URL="mongodb://localhost:27017/amazona"

# Directory path for JSON files
JSON_FILES_DIR="Experiments/Databases/Domain Data/amazona"

# Import data for "orders" collection
mongoimport --uri "$MONGODB_URL" --collection orders --file "$JSON_FILES_DIR/orders.json" --jsonArray

# Import data for "products" collection
mongoimport --uri "$MONGODB_URL" --collection products --file "$JSON_FILES_DIR/products.json" --jsonArray

# Import data for "users" collection
mongoimport --uri "$MONGODB_URL" --collection users --file "$JSON_FILES_DIR/users.json" --jsonArray

# MongoDB URL for "blog" database (assuming default MongoDB port)
MONGODB_BLOG_URL="mongodb://localhost:27017/blog"

# Directory path for JSON files for "blog" database
JSON_BLOG_DIR="Experiments/Databases/Domain Data/blog"

# Import data for "articles" collection in "blog" database
mongoimport --uri "$MONGODB_BLOG_URL" --collection articles --file "$JSON_BLOG_DIR/articles.json" --jsonArray

# Import data for "users" collection in "blog" database
mongoimport --uri "$MONGODB_BLOG_URL" --collection users --file "$JSON_BLOG_DIR/users.json" --jsonArray

# MongoDB URL for "habitica" database (assuming default MongoDB port)
MONGODB_HABITICA_URL="mongodb://localhost:27017/habitica"

# Directory path for JSON files for "habitica" database
JSON_HABITICA_DIR="Experiments/Databases/Domain Data/habitica"

# Import data for "tasks" collection in "habitica" database
mongoimport --uri "$MONGODB_HABITICA_URL" --collection tasks --file "$JSON_HABITICA_DIR/tasks.json" --jsonArray

# Import data for "users" collection in "habitica" database
mongoimport --uri "$MONGODB_HABITICA_URL" --collection users --file "$JSON_HABITICA_DIR/users.json" --jsonArray

# MongoDB URL for "leb" database (assuming default MongoDB port)
MONGODB_LEB_URL="mongodb://localhost:27017/leb"

# Directory path for JSON files for "leb" database
JSON_LEB_DIR="Experiments/Databases/Domain Data/leb"

# Import data for "patients" collection in "leb" database
mongoimport --uri "$MONGODB_LEB_URL" --collection patients --file "$JSON_LEB_DIR/patients.json" --jsonArray

# Import data for "users" collection in "leb" database
mongoimport --uri "$MONGODB_LEB_URL" --collection users --file "$JSON_LEB_DIR/users.json" --jsonArray


# End of the script