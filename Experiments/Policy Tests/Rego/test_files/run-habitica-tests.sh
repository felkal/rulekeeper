#! /bin/bash

printf "Habitica Tests.\n"

printf "[Experiments Data]\n"
opa test ../tests/habitica-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/database/habitica/* ../data/manifests/manifest_habitica.json -v

printf "[Sample Data]\n"
opa test ../tests/habitica-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/test-data-habitica.json -v