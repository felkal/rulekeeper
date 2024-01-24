package rulekeeper

# Experiment 1.1: As a patient, access own patient data.
test_patient_fetch_data {
	allow with input as {
	"operation": "GET /patients/:patientId",
	"principal": "charles",
	"data": ["personal_data.full_name","personal_data.birth_date","personal_data.gender","personal_data.ss_number","personal_data.photo","personal_data.address","contact_info.mobile","patient_id","_id._bsontype","_id.id","citizencard","authenticated","__v"],
    "table": "patients" }
}

# Experiment 1.2: As a patient, update own patient data.
test_patient_update_data {
	allow with input as {
	"operation": "POST /patients/:patientId",
	"principal": "charles",
	"data": ["personal_data.full_name"],
    "table": "patients" }
}

# Experiment 1.3: As a receptionist, access a patient's data.
test_recepcionist_patient_fetch_data {
	allow with input as {
	"operation": "GET /patients/:patientId",
	"principal": "alice",
	"data": ["personal_data.full_name"],
	"table": "patients",
	"subjects": {"list": ["12340001"] }
	}
}

# Experiment 1.4: As a receptionist, access several patient data.
test_recepcionist_patient_fetch_all_data {
	allow with input as {
	"operation": "GET /patients/available",
	"principal": "alice",
	"data": ["personal_data.full_name"],
	"table": "patients",
	"subjects": {"list": ["12340001"] }
	}
}

# Experiment 1.5: As a receptionist, update a patient's data.
test_recepcionist_patient_update_patient_data {
	allow with input as {
	"operation": "POST /patients/:patientId",
	"principal": "alice",
	"data": ["personal_data.full_name"],
	"table": "patients",
	"subjects": {"list": ["12340001"] }
	}
}

# 2.1 Authenticate does not require consent (no principal yet)
test_authenticates {
	allow with input as {
	"operation": "POST /authenticate",
	"data": ["entity","_id._bsontype","_id.id","username","password","role"],
	"table": "users" }
}

# Experiment 2.2: As a receptionist, cannot fetch data without consent.
test_recepcionist_patient_fetch_data_all_not_consented {
	not allow with input as {
	"operation": "GET /patients/:patientId",
	"principal": "alice",
	"data": ["personal_data.full_name"],
	"table": "patients",
	"subjects": {"list": ["12340499"] } #user 12340499 did not give consent
	}
}

# Experiment 2.3: As a receptionist, cannot fetch data if one does not give consent.
test_recepcionist_patient_fetch_data_one_not_consented {
	not allow with input as {
	"operation": "GET /patients/:patientId",
	"principal": "alice",
	"data": ["personal_data.full_name"],
	"table": "patients",
	"subjects": {"list": ["12340001", "12340499"] } #user 12340499 did not give consent
	}
}
