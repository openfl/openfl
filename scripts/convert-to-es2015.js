

let fs = require('fs');
let globby = require('globby');


/*
This script replaces all occurrences of:

exports.default =

with

export default

and remove the $global lines at the top of all the js files

under lib/_gen/ to make all the modules es2015 modules as opposed to commonjs modules. This then 
allows webpack to properly tree shake our code. Any unused modules can be excluded 
from the webpack generated js bundle.

*/

//console.log('Replacing exports.default = with export default...');

// Search for all the js files under lib/_gen/

startCreateDefaultReExportEsms();

function startCreateEsmModules() {
  globby(['../lib/_gen/openfl/**/*.js']).then((paths) => {

    let updated = 0;
    
    for (let path of paths) {
      
      if (path.match(/\.esm\.js$/) != null) {
        continue;
      }
      
      if (createEsmModule(path)) {
        updated++;
      }
    }
      
    console.log(__filename, 'Complete', updated, 'affected files');
  });
}



function createEsmModule(filePath) {
  
  let content;
  
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (error) {
    console.error('Could not read file:', filePath);
    return;
  }
  
  
  var result = content.replace(/exports\.default =/g, 'export default');
  // Replace 
  // exports.default =
  // with
  // export default 
  
  
  // We must remove these lines at the top of the generated js files or else when the
  // webpack generated bundle is run in the browser we will encounter an "exports is not defined" 
  // error. The variable "exports" is only availabe in commonjs modules.
  result = result.replace('var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this', '');
  result = result.replace('$global.Object.defineProperty(exports, "__esModule", {value: true});', '');
  result = result.replace('Object.defineProperty(exports, "__esModule", {value: true});', '');
  

  try {
    
    let esmFilePath = filePath.replace(/\.js$/, '.esm.js');
    //console.log('writing', esmFilePath);
    fs.writeFileSync(esmFilePath, result, 'utf8');
    
  } catch (error) {
    console.error('Could not write to file:', filePath);
    return;
  }
  return true;
  
}



function startCreateDefaultReExportEsms() {
  
  globby(['../lib/openfl/**/*.js']).then((paths) => {

    let updated = 0;
  
    
    for (let path of paths) {
    
      // Skip the barrel index.js and index.esm.js files
      if (path.match(/\.esm\.js$/) != null) {
        continue;
      }
      
      if (path.match(/index(\.js|\.esm\.js|\.d\.ts)$/) != null) {
        continue;
      }
      
      if (createDefaultReExportEsm(path)) {
        updated++;
      }
    }
      
    console.log(__filename, 'Complete', updated, 'files affected');
  });
  
}



function createDefaultReExportEsm(filePath) {
  
  let content;
  
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (error) {
    console.error('Could not read file:', filePath);
    return;
  }
  
  
  if (content.indexOf('module.exports.default') > -1) {
    //console.log(filePath);
  }
  //module.exports = require("./../../_gen/openfl/display/Graphics");
  // By replacing exports.default with export default we are converting the module 
  // to an es2015 module from commonjs
  var result = content;
  
  
  result = result.replace(/^\s*module\.exports\s*=\s*require\(['"](.+?)['"]\);/gm, 'export { default } from "$1.esm";');
  // Replace:
  // "module.exports = require("./../../_gen/openfl/display/Graphics");"
  // with
  // "export { default } from "./../../_gen/openfl/display/Graphics.esm";
  
  
  result = result.replace('Object.defineProperty (module.exports, "__esModule", { value: true });', '');
  // Remove these lines
  // Object.defineProperty (module.exports, "__esModule", { value: true });
  
  
  result = result.replace(/module\.exports\..+? = module\.exports\.default = {/gm, 'export default {');
  // Replace
  // module.exports.Endian = module.exports.default = {
  // with
  // export default {
    
  
  result = result.replace(/(module\.)?exports\.default =/g, 'export default');
  // Replace 
  // "exports.default ="   OR   "module.exports.default ="
  // with
  // export default 
  
  
  result = result.replace(/^\s*var (.*?) = require \(['"](.*?)['"]\)\.default;/gm, 'import { default as $1 } from "$2.esm";');
  // Replace
  // var Lib = require ("./../../_gen/openfl/Lib").default;
  // with
  // import { default as Lib } from "./../../_gen/openfl/Lib.esm";
  
  

  try {
    
    let esmFilePath = filePath.replace(/\.js$/, '.esm.js');
    
    //console.log(esmFilePath);
    fs.writeFileSync(esmFilePath, result, 'utf8');
    
    
  } catch (error) {
    console.error('Could not write to file:', filePath);
    return;
  }
  return true;
  
}