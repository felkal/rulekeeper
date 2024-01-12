# RuleKeeper

An open-source, prototype implementation of RuleKeeper, a GDPR-compliant consent management system designed for full-stack web development frameworks.
We use MERN (MongoDB, Express.js, React.js, and Node.js) as our demonstration target.

RuleKeeper operates in two phases: an offline phase and a runtime phase.
The offline phase takes place at development time and includes a code analysis tool.
The runtime phase is composed of a middleware and a manager service.
RuleKeeper also includes a parser to translate the GDPR manifest specified using our DSL to a JSON format.

In this repository you will find:

* The static analysis engine in **Static Analysis Engine/** (including the Webus graph in **Webus Graph/**);
* The middleware code in **RuleKeeperMiddleware/**;
* The manager code in **RuleKeeperManager/**;
* The parser code in **Parser/**;
* The material used for the usability tests in **UsabilityTests/**;
* The use case applications in **UseCases/**.

# Quick setup

run `bash quick_setup.sh``

# Setup

1. go into every subdir and run `npm install`

## RuleKeeperManager

1. create manager server cert with `openssl req -x509 -newkey rsa:4096 -keyout RuleKeeperManager/utils/server.key -out RuleKeeperManager/utils/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"`
2. Get OPA binary: https://github.com/open-policy-agent/opa/releases
3. Copy OPA binary `~/.local/bin/opa` and execute `chmod +x ~/.local/bin/opa`
4. create all paths declared in .env
5. Set initial version in `RuleKeeperManager/config/versions.json` to 1: `{"access_control.wasm": 1, "rulekeeper.wasm": 1}`

## RuleKeeperMiddleware

1. create middleware server cert with `openssl req -x509 -newkey rsa:4096 -keyout RuleKeeperMiddleware/config/key.pem -out RuleKeeperMiddleware/config/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"`
2. Create folder `RuleKeeperMiddleware/pep/policies`
3. Create folder `RuleKeeperMiddleware/results`
4. Create file `RuleKeeperMiddleware/results/benchmark.csv`
