#!/bin/bash

# Function to install npm dependencies in a directory
install_dependencies_in_dir() {
  if [ -f "$1/package.json" ]; then
    echo "Installing npm dependencies in directory: $1"
    (cd "$1" && npm install)
  else
    echo "Skipping directory: $1 (no package.json found)"
  fi
}

# Iterate over every subdirectory and install npm dependencies
for dir in */; do
  dir="${dir%/}"  # Remove trailing slash
  install_dependencies_in_dir "$dir"
done

# Additional setup for RuleKeeperManager
echo "Setting up RuleKeeperManager..."

echo "Step 1: Create manager server cert"
openssl req -x509 -newkey rsa:4096 -keyout ./RuleKeeperManager/utils/server.key -out ./RuleKeeperManager/utils/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"

echo "Saving OPA to ~/.local/bin/opa"
echo "Step 2: Get OPA binary"
wget -O ~/.local/bin/opa https://github.com/open-policy-agent/opa/releases/latest/download/opa_linux_amd64
chmod +x ~/.local/bin/opa


echo "Step 3: Create paths declared in .env.example and create .env"
mkdir -p ./RuleKeeperManager/policies/rego/policies
mkdir -p ./RuleKeeperManager/policies/rego/rules
mkdir -p ./RuleKeeperManager/policies/rego/utils
mkdir -p ./RuleKeeperManager/policies/wasm
mkdir -p ./RuleKeeperManager/policies/data

echo "Step 4: Copy ./RuleKeeperManager/.env.example ./RuleKeeperManager/.env"
cp ./RuleKeeperManager/.env.example ./RuleKeeperManager/.env

echo "Step 5: Adjust paths in .env to be absolute"

rulekeeper_manager_dir=$(pwd)/RuleKeeperManager/policies
escaped_rulekeeper_manager_dir=$(echo "$rulekeeper_manager_dir" | sed 's/\//\\\//g')
sed -i "s/policies/$escaped_rulekeeper_manager_dir/" "./RuleKeeperManager/.env"


echo "Step 6: Set initial version in RuleKeeperManager/config/versions.json"
echo '{"access_control.wasm": 1, "rulekeeper.wasm": 1}' > RuleKeeperManager/config/versions.json

echo "Setting up RuleKeeperMiddleware..."

echo "Step 1: Create middleware server cert"
openssl req -x509 -newkey rsa:4096 -keyout RuleKeeperMiddleware/config/key.pem -out RuleKeeperMiddleware/config/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"

echo "Step 2: Create folder RuleKeeperMiddleware/pep/policies"
mkdir -p RuleKeeperMiddleware/pep/policies

echo "Step 3: Create folder RuleKeeperMiddleware/results"
mkdir -p RuleKeeperMiddleware/results

echo "Step 4: Create file RuleKeeperMiddleware/results/benchmark.csv"
touch RuleKeeperMiddleware/results/benchmark.csv

echo "Setup completed."
