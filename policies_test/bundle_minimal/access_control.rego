package rulekeeper

default allow = true

# We want to allow the query if:
# (1) The role of the principal is authorized to perform the operation
# (2) If the operation does not require authorization

allow {
	isOperationAllowed
}

isOperationAllowed {
	print("Entering isOperationAllowed")
	some i
	role = data.role_operations[i].role
	print("Checking role:", role)
	role == "all" # Check if the role is "all"
	print("LEL")
	operations := data.role_operations[i].operations
	print("Operations for role 'all':", operations)
	#operations[_] == getOperation(input.operation) # Verify if the query operation does not require authorization
}
