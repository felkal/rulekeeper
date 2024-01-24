const shell = require('shelljs');
const fs = require('fs');
const path = require('path');

const REGO_DIR = '../policies/rego/policies';
const WASM_DIR = 'wasm';
const REGO_UTILS_DIR = '../policies/rego/utils';
const REGO_RULES_DIR = '../policies/rego/rules';

module.exports = {
  buildWasmPolicies() {
    if (!shell.which('opa')) {
      console.log('Sorry, this operation requires the opa binary.');
      shell.exit(1);
      return;
    }

    /* 1. Get all Rego policies stored in REGO_DIR directory. */
    const policyFiles = fs.readdirSync(REGO_DIR);
    if (!policyFiles) {
      console.log.error('Unable to open Rego directory.');
      return;
    }

    policyFiles.forEach((regoFilename) => {
    /* 2. Check if it is already built. (optimization step) */
      if (fs.existsSync(`${WASM_DIR}/${path.basename(regoFilename, path.extname(regoFilename))}.wasm`)) return;
      console.log(`Build .wasm policy for file ${regoFilename}.`);

      /* 3. Generate the bundle (.tar.gz with .rego + .wasm + data). */
      const bundleFilename = generateBundle(regoFilename);
      if (!bundleFilename) return;
      console.log(`   1. Bundle ${bundleFilename}.`);

      /* 3. Extract .wasm */
      const wasmFile = extractWasmFile(regoFilename, bundleFilename);
      if (!wasmFile) return;
      console.log(`   2. Extract ${wasmFile}.`);
    });
  },
};

function generateBundle(regoFile) {
  const filename = `${REGO_DIR}/${regoFile}`;
  const bundleFilename = `${WASM_DIR}/${path.basename(regoFile, path.extname(regoFile))}.tar.gz`;
  console.log(__dirname)
  shell.exec(`opa build -o=2 -t wasm -e 'rulekeeper/allow' ${filename} ${REGO_RULES_DIR} ${REGO_UTILS_DIR} -o ${bundleFilename}`);

  if (!fs.existsSync(bundleFilename)) {
    console.log(`Unable to generate bundle ${bundleFilename}`);
    return null;
  }
  return bundleFilename;
}

function extractWasmFile(file, bundle) {
  if (!fs.existsSync(bundle)) {
    console.log(`Unable to open generated bundle ${bundle}`);
    return null;
  }
  /* Extract the policy from the bundle */
  shell.exec(`tar -C ${WASM_DIR} -xzf ${bundle} /policy.wasm`, { silent: true });
  const filename = `${WASM_DIR}/policy.wasm`;
  if (!shell.find(filename)) {
    console.log(`Unable to generate .wasm file from ${file}`);
    return null;
  }
  /* Change the name */
  const newFilename = `${WASM_DIR}/${path.basename(file, path.extname(file))}.wasm`;
  fs.renameSync(filename, newFilename);
  /* Remove bundle from file system. */
  fs.unlinkSync(bundle);
  return filename;
}
