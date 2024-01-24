#! /bin/bash

printf "[Debug test]\n"

opa test ../tests/debug-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/sample-data.json -v
