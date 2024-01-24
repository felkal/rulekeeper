const assert = require('assert');
const fs = require('fs');
const utf8 = require('utf8');
const { loadPolicy } = require('@open-policy-agent/opa-wasm');

let rulekeeperPolicy;
let accessControlPolicy;

const notAllowedResult = [{ result: false }];

before(async () => {
  const rulekeeperWasm = fs.readFileSync('wasm/rulekeeper.wasm');
  const accessControlWasm = fs.readFileSync('wasm/access_control.wasm');

  const policyDataContent = fs.readFileSync('../data/data.json');
  const encodedFileContent = utf8.encode(policyDataContent.toString());
  const policyData = JSON.parse(encodedFileContent);

  rulekeeperPolicy = await loadPolicy(rulekeeperWasm);
  rulekeeperPolicy.setData(policyData);

  accessControlPolicy = await loadPolicy(accessControlWasm);
  accessControlPolicy.setData(policyData);
});

describe('General Access Control Tests.', () => {
  it('Principal with authorization can perform the operation.', () => {
    assert(accessControlPolicy.evaluate({ principal: 'principalA', operation: 'GET /EndpointA' }));
    assert(accessControlPolicy.evaluate({ principal: 'principalB', operation: 'POST /EndpointB:variable' }));
  });

  it('Operations with * permissions can be executed by any principal or with no principal.', () => {
    assert(accessControlPolicy.evaluate({ operation: 'GET /All' }));
    assert(accessControlPolicy.evaluate({ principal: 'principalA', operation: 'GET /All' }));
  });

  it('Principal with no authorization cannot perform the operation.', () => {
    assert.deepStrictEqual(accessControlPolicy.evaluate({ principal: 'principalB', operation: 'GET /EndpointA' }), notAllowedResult);
    assert.deepStrictEqual(accessControlPolicy.evaluate({ principal: 'principalB', operation: 'DELETE /EndpointC' }), notAllowedResult);
    assert.deepStrictEqual(accessControlPolicy.evaluate({ principal: 'principalA', operation: 'POST /EndpointB:variable' }), notAllowedResult);
    assert.deepStrictEqual(accessControlPolicy.evaluate({ principal: 'principalA', operation: 'operationD' }), notAllowedResult);
  });

  it('Operations that require authorization cannot be executed without a principal.', () => {
    assert.deepStrictEqual(accessControlPolicy.evaluate({ operation: 'POST /EndpointB:variable' }), notAllowedResult);
  });

  it('Operations that are not mapped in the policy cannot be executed.', () => {
    assert.deepStrictEqual(accessControlPolicy.evaluate({ principal: 'principalA', operation: 'operationN' }), notAllowedResult);
  });
});

describe('General Personal Data Tests.', () => {
  it('Operation is allowed if data is not personal.', () => {
    assert(rulekeeperPolicy.evaluate({ data: ['datatypeC'], table: 'Table A' }));
  });

  it('Operation is not allowed if data is personal and principal is missing', () => {
    assert.deepStrictEqual(accessControlPolicy.evaluate({ data: ['datatypeA'], table: 'Table A' }), notAllowedResult);
    assert.deepStrictEqual(accessControlPolicy.evaluate({ data: ['datatypeA'], table: 'Table A', operation: 'GET /EndpointA' }), notAllowedResult);
  });

  it('Operation is not allowed if data is personal and the operation is missing', () => {
    assert.deepStrictEqual(accessControlPolicy.evaluate({ data: ['datatypeA'], table: 'Table A', operation: 'GET /EndpointA' }), notAllowedResult);
  });
});

describe('General Purpose Limitation Tests.', () => {
  it('Operation cannot process one datatype that does not include the purpose of the operation.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalA', operation: 'GET /EndpointA', data: ['datatypeB'], table: 'Table A',
    }), notAllowedResult);
  });

  it('Operation cannot process two datatypes that do not include the purpose of the operation.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalA', operation: 'GET /EndpointA', data: ['datatypeB', 'datatypeC'], table: 'Table A',
    }), notAllowedResult);
  });
});

describe('General Data Minimization Tests.', () => {
  it('Operation does not process more than the minimal data with one data type that is not minimal.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalA', operation: 'GET /EndpointA', data: ['datatypeB'], table: 'Table A',
    }), notAllowedResult);
  });

  it('Operation does not process more than the minimal data with one data type that is not minimal and one that is.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalA', operation: 'GET /EndpointA', data: ['datatypeA', 'datatypeB'], table: 'Table A',
    }), notAllowedResult);
  });

  it('Operation does not process more than the minimal data with one data type that is not minimal and two that are.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalA', operation: 'GET /EndpointA', data: ['datatypeA', 'datatypeB', 'datatypeD'], table: 'Table A',
    }), notAllowedResult);
  });
});

describe('General Lawfulness of Processing Tests - Principal is Data Subject.', () => {
  it('Operation is not allowed if principal did not consent to the purpose of the operation.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalDS', operation: 'POST /EndpointB:variable', data: ['datatypeB'], table: 'Table A',
    }), notAllowedResult);
  });
  it('Operation is allowed if principal consent to the purpose of the operation.', () => {
    assert(rulekeeperPolicy.evaluate({
      principal: 'principalDS', operation: 'GET /EndpointA', data: ['datatypeA'], table: 'Table A',
    }));
  });

  it('Operation is allowed if operation does not need consent of the principal/subject.', () => {
    assert(rulekeeperPolicy.evaluate({
      principal: 'principalDS', operation: 'DELETE /EndpointC', data: ['datatypeA'], table: 'Table A',
    }));
  });
});

describe('General Lawfulness of Processing Tests - Principal is Data Controller.', () => {
  it('Operation is not allowed if subject did not consent to the purpose of the operation.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalC', operation: 'POST /EndpointB:variable', data: ['datatypeB'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectA'] },
    }), notAllowedResult);
  });

  it('Operation is not allowed if one of the subjects did not consent to the purpose of the operation.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalC', operation: 'POST /EndpointB:variable', data: ['datatypeB'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectA', 'data_subjectB'] },
    }), notAllowedResult);
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalC', operation: 'GET /EndpointA', data: ['datatypeA'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectA', 'data_subjectB'] },
    }), notAllowedResult);
  });

  it('Operation is not allowed if both subjects did not consent to the purpose of the operation.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalC', operation: 'GET /EndpointA', data: ['datatypeA'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectB', 'data_subjectC'] },
    }), notAllowedResult);
  });

  it('Operation is allowed if subject consented to the purpose of the operation.', () => {
    assert(rulekeeperPolicy.evaluate({
      principal: 'principalC', operation: 'GET /EndpointA', data: ['datatypeA'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectA'] },
    }));
  });
});

describe('General Lawfulness of Processing Tests - Principal has no GDPR role.', () => {
  it('Operation is not allowed if principal is a third party.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalTP', operation: 'GET /EndpointA', data: ['datatypeA'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectA'] },
    }), notAllowedResult);
  });

  it('Operation is not allowed if principal is a null.', () => {
    assert.deepStrictEqual(rulekeeperPolicy.evaluate({
      principal: 'principalX', operation: 'GET /EndpointA', data: ['datatypeA'], table: 'Table A', subjects: { key: 'entity', list: ['data_subjectA'] },
    }), notAllowedResult);
  });
});
