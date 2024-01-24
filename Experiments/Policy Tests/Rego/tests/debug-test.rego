package rulekeeper

# Test that operation can process one datatype that includes the purpose of the operation
test_custom {
	allowPurposeLimitation with input as {
	"operation": "GET /user",
	"principal": "bob",
	"data": ["auth.local.username", "auth.local.lowerCaseUsername", "auth.local.email"]}
}
