package rulekeeper

# Test that principal can execute an allowed operation.
test_access_control_allowed {
	allow with input as {"principal": "principalA", "operation": "GET /EndpointA"}
	allow with input as {"principal": "principalA", "operation": "DELETE /EndpointC"}
}


# Test that a request with no principal can execute an allowed operation.
test_access_control_no_principal_allowed {
	allow with input as {"operation": "GET /All"}
	allow with input as {"principal": "principalA", "operation": "GET /All"}
}

# Test that another principal can execute an allowed operation.
test_access_control_second_user_allowed {
	allow with input as {"principal": "principalB", "operation": "POST /EndpointB:variable"}
}

# Test that a principal cannot execute a disallowed operation.
test_access_control_disallowed {
	not allow with input as {"principal": "principalB", "operation": "GET /EndpointA"}
	not allow with input as {"principal": "principalB", "operation": "DELETE /EndpointC"}
	not allow with input as {"principal": "principalA", "operation": "POST /EndpointB:variable"}
	not allow with input as {"principal": "principalA", "operation": "operationD"}
}

# Test with invalid input.
test_access_control_invalid_input {
	not allow with input as {"operation": "POST /EndpointB:variable"}
	not allow with input as {"principal": "principalA", "operation": "GET /EndpointN"}
}
