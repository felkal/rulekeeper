#! /bin/bash

opa test ../tests/amazona-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/database/amazona/* ../data/manifests/manifest_amazona.json -v