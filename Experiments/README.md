## RuleKeeper Tests


### Policy Tests
The folder *Policy Tests* contains policy correctness tests, and is divided into *Rego* tests and *Wasm* tests.

The Rego tests the correctness of the Rego tests and the Wasm tests if the wasm policies are being generated well and can be evaluated in a Node.js environment.

These tests are stored with the following structure:
```
Policy Tests
├── Rego
│   ├── tests - Contains the policy tests written in Rego
│   ├── test_files - Contains bash scripts that run the Rego tests
│   ├── rego - Contains the Rego policies (the ones in the Manager)
│   └── data - Contains data for the tests, namely the manifests and database data
├── Wasm
│   ├── wasm - Contains the wasm compiled policies
│   └── data - Contains .js tests that evaluate the wasm policies
```

### Experiments
The folder *Experiments* contains scripts that were used to perform the experiments in the paper.
Note that these experiments were meant to test performance, so they use wrk and may not be the best way to test simple requests.

These tests are stored with the following structure:


```
Experiments
├── experiments.py - Contains the requests of all tasks for all use cases (with authentication)
├── run_single_experiment.py - Script that runs one experiment
├── configs
│   └── shared_config.ini - Some configuration for the tests, namely application server url, nr of iterations, etc
├── scripts - Contains scripts that may be useful for some tasks
│   └── ...
└── utils
    └── ...

```

To run a single experiment:
```
python3 run_single_experiment.py <use_case> <task_id_number>

# For example, to run the H1 task:
python3 run_single_experiment.py habitica 1

```

### Databases

This folder contains a snapshot of the databases for all use cases.
