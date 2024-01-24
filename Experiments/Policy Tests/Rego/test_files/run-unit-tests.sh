#! /bin/bash

printf "Unit Tests.\n"

printf "[Access Control]\n"
opa test ../tests/access-control-test.rego ../rego/policies/access_control.rego ../rego/utils/* ../data/sample-data.json -v

printf "\n[Personal Data]\n"
opa test ../tests/personal-data-test.rego ../rego/utils/* ../data/sample-data.json -v

printf "\n[Purpose Limitation]\n"
opa test ../tests/purpose-limitation-test.rego ../rego/rules/purpose-limitation.rego ../rego/utils/* ../data/sample-data.json -v

printf "\n[Data Minimization]\n"
opa test ../tests/data-minimization-test.rego ../rego/rules/data-minimization.rego ../rego/utils/* ../data/sample-data.json -v

printf "\n[Lawfulness of Processing]\n"
opa test ../tests/lawfulness-of-processing-test.rego ../rego/rules/lawfulness-of-processing.rego ../rego/utils/* ../data/sample-data.json -v
