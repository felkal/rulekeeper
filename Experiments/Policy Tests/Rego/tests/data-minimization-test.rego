package rulekeeper

# Test that operation does not process more than the minimal data with one data type
test_user_minimal_data_one_ok {
	allowDataMinimization(["Data Type A"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeA"], "table": "Table A"}
}

# Test that operation does not process more than the minimal data with one data type (subset)
test_user_minimal_data_subset_ok {
	allowDataMinimization(["Data Type A"]) with input as {"operation": "POST /EndpointB:variable", "data": ["datatypeA"], "table": "Table A"}
}

# Test that operation does not process more than the minimal data with several data types (all)
test_user_minimal_data_all_ok {
	allowDataMinimization(["Data Type A", "Data Type B"]) with input as {"operation": "POST /EndpointB:variable", "data": ["datatypeA", "datatypeB"], "table": "Table A"}
}

# Test that operation does not process more than the minimal data with no personal data
test_user_minimal_data_no_data_ok {
	allowDataMinimization([]) with input as {"operation": "DELETE /EndpointC", "data": ["datatypeC"], "table": "Table A"}
}

# Test that operation does not process more than the minimal data with one data type that is not minimal
test_user_minimal_data_one_nok {
	not allowDataMinimization(["Data Type B"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeB"], "table": "Table A"}
}

# Test that operation does not process more than the minimal data with one data type that is not minimal and one that is
test_user_minimal_data_one_nok {
	not allowDataMinimization(["Data Type A", "Data Type B"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeA", "datatypeB"], "table": "Table A"}
}

# Test that operation does not process more than the minimal data with one data type that is not minimal and two that are
test_user_minimal_data_subset_nok {
	not allowDataMinimization(["Data Type A", "Data Type B", "Data Type D"]) with input as {"operation": "POST /EndpointB:variable", "data": ["datatypeA", "datatypeB", "datatypeD"], "table": "Table A"}
}

