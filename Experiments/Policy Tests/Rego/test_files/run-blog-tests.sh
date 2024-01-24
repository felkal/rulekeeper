#! /bin/bash

opa test ../tests/blog-test.rego ../rego/policies/rulekeeper.rego ../rego/rules/* ../rego/utils/* ../data/database/blog/* ../data/manifests/manifest_blog.json -v