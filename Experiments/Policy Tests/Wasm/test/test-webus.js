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

  const policyDataContent = fs.readFileSync('../data/test-data-webus.json');
  const encodedFileContent = utf8.encode(policyDataContent.toString());
  const policyData = JSON.parse(encodedFileContent);

  rulekeeperPolicy = await loadPolicy(rulekeeperWasm);
  rulekeeperPolicy.setData(policyData);

  accessControlPolicy = await loadPolicy(accessControlWasm);
  accessControlPolicy.setData(policyData);
});

describe('Webus Access Control Tests.', () => {
  it('All principals can perform operations.', () => {
    assert(accessControlPolicy.evaluate({ operation: 'GET /tickets/schedules' }));
    assert(accessControlPolicy.evaluate({ operation: 'GET /tickets/buy_ticket' }));
    assert(accessControlPolicy.evaluate({ operation: 'GET /tickets/purchase_history' }));
    assert(accessControlPolicy.evaluate({ operation: 'GET /newsletter/subscribe' }));
  });

  it('Operations that are not mapped in the policy cannot be executed.', () => {
    assert.deepStrictEqual(accessControlPolicy.evaluate({ principal: 'principalA', operation: 'operationN' }), notAllowedResult);
  });
});

describe('Webus Personal Data Tests.', () => {
  it('Any operation is allowed if data is not personal.', () => {
    assert(rulekeeperPolicy.evaluate({ data: ['destination', 'date'], table: 'schedules' }));
  });

  it('Operation is not allowed if operation contains data that is personal and the principal is not set.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({ operation: 'GET /tickets/schedules', data: ['travelers', ' date'], table: 'schedules' }), notAllowedResult);
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({ data: ['travelers', 'date'], table: 'schedules' }), notAllowedResult);
  });

  it('Operation is not allowed if operation contains data that is personal and the operation supposedly does not process personal data.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'some-user', operation: 'GET /tickets/schedules', data: ['travelers', 'date'], table: 'schedules',
    }), notAllowedResult);
  });
});

describe('Webus Purpose Limitation Tests.', () => {
  it('Operation "See Schedules" cannot process personal data (ticket buyer name).', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'some-user', operation: 'GET /tickets/schedules', data: ['name'], table: 'tickets',
    }), notAllowedResult);
  });

  it('Operation "Newsletter" cannot process personal data collected for "Ticket Management" purposes.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'some-user', operation: 'POST /newsletter/subscribe', data: ['name', 'e_mail'], table: 'tickets',
    }), notAllowedResult);
  });
});

describe('Webus Data Minimization Tests.', () => {
  it('Operation "Newsletter" cannot process personal data not associated with the purpose "Marketing" (ticket data).', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'some-user', operation: 'POST /newsletter/subscribe', data: ['e_mail', 'destination'], table: 'tickets',
    }), notAllowedResult);
  });
});

describe('Webus Lawfulness of Processing Tests - Principal is Data Subject.', () => {
  it('Subscribe to newsletter is not allowed if user did not consent to the "Marketing" purpose.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'some-user-no-marketing', operation: 'POST /newsletter/subscribe', data: ['e_mail'], table: 'newsletters',
    }), notAllowedResult);
  });
  it('Operation is allowed if principal consent to the purpose of the operation.', () => {
    assert(rulekeeperPolicy.evaluate({
      principal: 'some-user', operation: 'POST /newsletter/subscribe', data: ['e_mail'], table: 'newsletters',
    }));
  });

  it('Operation is allowed if operation does not need consent of the principal/subject.', () => {
    assert(rulekeeperPolicy.evaluate({ principal: 'some-user', operation: 'GET /tickets/schedules', data: ['destination'], table: 'schedules' }));
  });
});
