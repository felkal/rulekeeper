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

# Setup

1. go into every subdir and run 'npm install'
2. create middleware server cert with 'openssl req -x509 -newkey rsa:4096 -keyout RuleKeeper\ Middleware/config/key.pem -out RuleKeeper\ Middleware/config/server.cert -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"'
3. Create folder "RuleKeeperMiddleware/pep/policies"
4. Create folder "RuleKeeperMiddleware/results"
5. Create file "RuleKeeperMiddleware/results/benchmark.csv"
6. Copy manifest from "UsabilityTests/<unzipped_folder>/webus/gdpr_manifest.txt" to