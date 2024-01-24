const assert = require('assert');
const fs = require('fs');
const utf8 = require('utf8');
const { loadPolicy } = require('@open-policy-agent/opa-wasm');
const utils = require('./testUtils');

let rulekeeperPolicy;
let accessControlPolicy;

const notAllowedResult = [{ result: false }];

before(async () => {
  utils.buildWasmPolicies();
  const rulekeeperWasm = fs.readFileSync('wasm/rulekeeper.wasm');
  const accessControlWasm = fs.readFileSync('wasm/access_control.wasm');

  const policyDataContent = fs.readFileSync('../data/test-data-leb.json');
  const encodedFileContent = utf8.encode(policyDataContent.toString());
  const policyData = JSON.parse(encodedFileContent);

  rulekeeperPolicy = await loadPolicy(rulekeeperWasm);
  rulekeeperPolicy.setData(policyData);

  accessControlPolicy = await loadPolicy(accessControlWasm);
  accessControlPolicy.setData(policyData);
});

describe('LEB Test Operations Tests.', () => {
  it('All principals can authenticate.', () => {
    assert(rulekeeperPolicy.evaluate({ operation: 'POST /authenticate', data: ["entity","_id._bsontype","_id.id","username","password","role"], table: 'users' }));
  });

  it('Patient can fetch its data.', () => {
    assert(rulekeeperPolicy.evaluate({ principal: "charles", operation: 'GET /patients/:patientId', data: ["personal_data.full_name","personal_data.birth_date","personal_data.gender","personal_data.ss_number","personal_data.photo","personal_data.address","contact_info.mobile","patient_id","_id._bsontype","_id.id","citizencard","authenticated","__v"], table: 'patients' }));
  });

  it('Patient can update its data.', () => {
    assert(rulekeeperPolicy.evaluate({ principal: "charles", operation: 'POST /patients/:patientId', data: ["personal_data.full_name"], table: 'patients' }));
  });

  it('Receptionist can fetch data.', () => {
    assert(rulekeeperPolicy.evaluate({ principal: "alice", operation: 'GET /patients/:patientId', data: ["personal_data.full_name"], table: 'patients', subjects: { key: "entity", list: ["Charles"] } }));
  });

  it('Receptionist cannot fetch data without consent.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({ principal: "alice", operation: 'GET /patients/:patientId', data: ["personal_data.full_name"], table: 'patients', subjects: { key: "entity", list: ["bob"] } }), notAllowedResult);
  });
});
