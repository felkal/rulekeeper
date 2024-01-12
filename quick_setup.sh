#!/bin/bash

#!/bin/bash

echo "Installing npm for RuleKeeper..."

(cd ./Parser; npm install --silent)
(cd ./RuleKeeperManager; npm install --silent)
(cd ./RuleKeeperMiddleware; npm install --silent)
(cd ./StaticAnalysisEngine/parser; npm install --silent)

echo "Installing npm for webus..."

(cd ./UseCases/webus; npm install --silent)




# Additional setup for RuleKeeperManager
echo ""
echo "Setting up RuleKeeperManager..."
echo ""

echo "Step 1: Create manager server cert"
openssl req -x509 -newkey rsa:4096 -keyout ./RuleKeeperManager/utils/server.key -out ./RuleKeeperManager/utils/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname" 2>/dev/null

# Define the GitHub repository and file URL
github_repo="https://github.com/open-policy-agent/opa/releases/latest/download/opa_linux_amd64"
file_path=~/.local/bin/opa

# Check if the file exists locally
if [ -f "$file_path" ]; then
    echo "File already exists locally: $file_path"
else
    echo "Downloading OPA from github..."
    wget -O $file_path $github_repo 2>/dev/null
    echo "Finished"
fi



echo "Step 3: Create paths declared in .env.example and create .env"
mkdir -p ./RuleKeeperManager/policies/rego/policies 2>/dev/null
mkdir -p ./RuleKeeperManager/policies/rego/rules 2>/dev/null
mkdir -p ./RuleKeeperManager/policies/rego/utils 2>/dev/null
mkdir -p ./RuleKeeperManager/policies/wasm 2>/dev/null
mkdir -p ./RuleKeeperManager/policies/data 2>/dev/null

echo "Step 4: Copy ./RuleKeeperManager/.env.example ./RuleKeeperManager/.env"
cp ./RuleKeeperManager/.env.example ./RuleKeeperManager/.env 2>/dev/null

echo "Step 5: Adjust paths in .env to be absolute"

rulekeeper_manager_dir=$(pwd)/RuleKeeperManager/policies
escaped_rulekeeper_manager_dir=$(echo "$rulekeeper_manager_dir" | sed 's/\//\\\//g')
sed -i "s/policies/$escaped_rulekeeper_manager_dir/" "./RuleKeeperManager/.env" 2>/dev/null


echo "Step 6: Set initial version in RuleKeeperManager/config/versions.json"
echo '{"access_control.wasm": 1, "rulekeeper.wasm": 1}' > RuleKeeperManager/config/versions.json

echo ""
echo "Setting up RuleKeeperMiddleware..."
echo ""

echo "Step 1: Create middleware server cert"
openssl req -x509 -newkey rsa:4096 -keyout RuleKeeperMiddleware/config/key.pem -out RuleKeeperMiddleware/config/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname" 2>/dev/null

echo "Step 2: Create folder RuleKeeperMiddleware/pep/policies"
mkdir -p RuleKeeperMiddleware/pep/policies

echo "Step 3: Create folder RuleKeeperMiddleware/results"
mkdir -p RuleKeeperMiddleware/results

echo "Step 4: Create file RuleKeeperMiddleware/results/benchmark.csv"
touch RuleKeeperMiddleware/results/benchmark.csv

echo ""
echo "Setting up policy for webus..."
echo ""

echo "Step 1: Copy policy to RuleKeeperManager"
cp ./UseCases/webus/gdpr-manifest-parsed.json RuleKeeperManager/policies/data/privacy_policy.json

echo ""
echo "Setup completed."
echo ""