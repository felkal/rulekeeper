package rulekeeper

# Test that operation can process one datatype that includes the purpose of the operation
test_collection_single_data_ok {
	allowPurposeLimitation(["Data Type A"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeA"], "table": "Table A"}
}

# Test that operation cannot process one datatype that does not include the purpose of the operation
test_collection_single_data_nok {
	not allowPurposeLimitation(["Data Type B"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeB"], "table": "Table A"}
}

# Test that operation can process two datatypes that include the purpose of the operation
test_collection_several_data_ok {
	allowPurposeLimitation(["Data Type A", "Data Type B"]) with input as {"operation": "POST /EndpointB:variable", "data": ["datatypeA", "datatypeB"], "table": "Table A"}
}

# Test that operation cannot process two datatypes that do not include the purpose of the operation
test_collection_several_data_nok {
	not allowPurposeLimitation(["Data Type B"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeB", "datatypeC"], "table": "Table A"}
}

# Test that operation cannot process two datatypes when one does not include the purpose of the operation
test_collection_several_single_data_nok {
	not allowPurposeLimitation(["Data Type A", "Data Type B"]) with input as {"operation": "GET /EndpointA", "data": ["datatypeA", "datatypeB"], "table": "Table A"}
}
