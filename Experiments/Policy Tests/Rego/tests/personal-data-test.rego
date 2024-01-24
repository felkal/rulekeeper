package rulekeeper

# Test that input contains personal data.
test_contains_personal_data {
	count(getPersonalData) != 0 with input as {"data": ["datatypeA"], "table": "Table A"}
}

# Test that input contains personal data.
test_contains_several_personal_data {
	count(getPersonalData) != 0 with input as {"data": ["datatypeA", "datatypeB"], "table": "Table A"}
}

# Test that input does not contain personal data.
test_not_contains_personal_data {
	count(getPersonalData) == 0 with input as {"data": ["datatypeC"], "table": "Table A"}
}

# Test that input does contain personal data, mixed with non personal data.
test_mixed_personal_data {
	count(getPersonalData) != 0 with input as {"data": ["datatypeA", "datatypeC"], "table": "Table A"}
}

# Test with input without data.
test_invalid_personal_data {
	count(getPersonalData) == 0 with input as {}
	count(getPersonalData) == 0 with input as {"data": ["datatypeN"]}
	count(getPersonalData) == 0 with input as {"data": ["datatypeN"], "table": "Table A"}
}
