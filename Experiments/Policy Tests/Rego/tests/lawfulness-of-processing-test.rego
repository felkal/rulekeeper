package rulekeeper

## User is data subject

# Test that user does not need consent to the purpose of the operation
test_operation_does_not_need_consent {
	allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "DELETE /EndpointC"}
}

# Test that user consented to the purpose of the operation
test_user_consented_purpose {
	allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "GET /EndpointA"}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA"]}}
}

# Test that user consented to more purposes than the operation
test_user_consented_more_purpose {
	allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "GET /EndpointA"}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA", "purposeB"]}}
}

# Test that user did not consent to the purpose of the operation
test_user_not_consented_purpose {
	not allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "GET /EndpointA"}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeB"]}}
}

# Test that operation is invalid
test_user_invalid_operation {
	not allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "POST /EndpointB:variable"}
		 with data.consents as {"data_subjectA": { "purposes": []}}

	not allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "POST /EndpointB:variable"}
		 with data.consents as {"data_subjectA": { "purposes": null}}

	not allowLawfulnessOfProcessing with input as {"principal": "principalDS", "operation": "POST /EndpointB:variable"}
		 with data.consents as {}
}

## User is not data subject

# Test that user does not need consent to the purpose of the operation
test_operation_does_not_need_consent_not_datasubject {
	allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "DELETE /EndpointC", "subjects": {"key": "entity", "list": ["data_subjectA"]}}
    		 with data.consents as {"data_subjectA": { "purposes": ["purposeA"]}}
}

# Test that user consented to the purpose of the operation
test_users_consented_purpose_not_datasubject {
	allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA"]}}
}

# Test that user consented to more purposes than the operation
test_user_consented_more_purpose_not_datasubject {
	allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA", "purposeB"]}}
}

# Test that user did not consent to the purpose of the operation
test_user_not_consented_purpose_not_datasubject {
	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeB"]}}
}

# Test that both users gave consent to the purpose
test_users_consented_purpose {
	allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA"]},
		 						"data_subjectB": { "purposes": ["purposeA"]}}
}

# Test that both users gave consent to more purposes
test_users_consented_more_purposes {
	allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA", "purposeB"]},
		 						"data_subjectB": { "purposes": ["purposeA", "purposeB"]}}
}

# Test that only one user gave consent to the purpose
test_users_one_not_consented_purpose {
	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA", "purposeB"]},
		 						"data_subjectB": { "purposes": ["purposeB"]}}

	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeA", "purposeB"]},
		 						"data_subjectB": { "purposes": []}}
}

# Test that only one user gave consent to more purposes
test_users_one_not_consented_more_purposes {
    allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
         with data.consents as {"data_subjectA": { "purposes": ["purposeA"]},
		 						"data_subjectB": { "purposes": ["purposeA", "purposeB"]}}
}

# Test that both user did not give consent to purpose
test_users_both_not_consented_purpose {
	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeB"]},
		 						"data_subjectB": { "purposes": ["purposeC"]}}

	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectA": { "purposes": ["purposeB"]},
		 						"data_subjectB": { "purposes": ["purposeB"]}}
}

# Test that principal has no authorization
test_users_both_not_consented_purpose {
	not allowLawfulnessOfProcessing with input as {"principal": "principalTP", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
		 with data.consents as {"data_subjectTP": { "purposes": ["purposeB"]}}

    not allowLawfulnessOfProcessing with input as {"principal": "principalX", "operation": "GET /EndpointA", "subjects": {"key": "entity", "list": ["data_subjectA", "data_subjectB"]}}
    		 with data.consents as {"data_subjectX": { "purposes": ["purposeB"]}}

}

# Test that operation is invalid
test_user_invalid_operation_not_datasubject {
	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "POST /EndpointB:variable", "subjects": {"key": "entity"}}
	not allowLawfulnessOfProcessing with input as {"principal": "principalC", "operation": "POST /EndpointB:variable", "subjects": {}}
}
