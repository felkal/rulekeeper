#! /bin/bash

opa test ../tests/leb-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/database/leb/* ../data/manifests/manifest_leb.json -v

opa test ../tests/leb-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/test-data-leb.json -v
