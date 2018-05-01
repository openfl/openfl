

let fs = require('fs');
let globby = require('globby');
let path = require('path');

/*
This script goes through each of the commonjs modules under lib/_gen/ and 
generates es2015 versions of them. It will also go through each of the 
modules that re-export a single module and generate es2015 version of that.
*/


startCreateEsmModules();

startCreateDefaultReExportEsms();


function startCreateEsmModules() {
  globby(['../lib/_gen/**/*.js']).then((paths) => {

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
  
  result = result.replace('$global.Object.defineProperty(exports, "__esModule", {value: true});', '');
  result = result.replace('Object.defineProperty(exports, "__esModule", {value: true});', '');
  
  // TODO: Remove this line ONLY if $global is not used anywhere else in the module
  //result = result.replace('var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this', '');
  
  
  // Replace
  // require("./../../_gen/openfl/display/Sprite");
  // with
  // require("./../../_gen/openfl/display/Sprite.esm");
  // BUT ONY IF Sprite.esm.js exists, if not, leave as is
  result = result.replace(/require\(['"](.+?)['"]\)/gm, (match, p1) => {
    
    try {
      
      // Check if the esm.js file event exists
			let fullPath = path.resolve(path.dirname(filePath), p1 + '.esm.js');
			
			if (fs.statSync(fullPath).isFile()) {
        return 'require("' + p1 + '.esm")';
			}
		} catch (error) {
			
    }
    
    return 'require("' + p1 + '")';
  });
  
  
  try {
    
    let esmFilePath = filePath.replace(/\.js$/, '.esm.js');
    
    fs.writeFileSync(esmFilePath, result, 'utf8');
    
  } catch (error) {
    console.error('Could not write to file:', filePath);
    return;
  }
  return true;
  
}



// Here we look create the es2015 version of the commonjs modules that contain:
// module.exports = require("./../../_gen/openfl/display/Sprite").default;

// The generated es2015 module will contain:
// export { default } from "./../../_gen/openfl/display/Sprite.esm");
function startCreateDefaultReExportEsms() {
  
  globby(['../lib/openfl/**/*.js']).then((paths) => {

    let updated = 0;
    
    for (let path of paths) {
    
      // Ignore the esm.js files
      if (path.match(/\.esm\.js$/) != null) {
        continue;
      }
      
      // Skip the barrel index.js and index.esm.js files
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
  
  var result = content;
  
  
  result = result.replace(/^\s*module\.exports\s*=\s*require\(['"](.+?)['"]\);/gm, 'export { default } from "$1.esm";');
  // Replace:
  // "module.exports = require("./../../_gen/openfl/display/Graphics");"
  // with
  // "export { default } from "./../../_gen/openfl/display/Graphics.esm";
  
  
  result = result.replace(/Object\.defineProperty \(module.exports, "__esModule", { value: true }\)(,|;)?/, '');
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
    
    fs.writeFileSync(esmFilePath, result, 'utf8');
    
  } catch (error) {
    console.error('Could not write to file:', filePath);
    return;
  }
  return true;
  
}