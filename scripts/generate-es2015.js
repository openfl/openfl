

let fs = require('fs');
let globby = require('globby');
let path = require('path');

/*
Run this after the "npm run build-lib" script. This script does the following:

- Goes through each of the commonjs modules under lib/_gen/ and generates es2015 versions 
of them with .esm.js file extension. See startCreateEsmModules()

- Goes through each of the commonjs modules under lib/openfl/ that re-export a single module and 
generates the equivalent es2015 module. See startCreateDefaultReExportEsms()

- Takes all the commonjs barrel index.js files under lib/openfl and generates es2015 versions of them
and saves them as index.esm.js. Also generates the index.d.ts declaration files for 
typescript. See startCreateBarrelModules()


We then need to make sure we add the following:

"module": "lib/openfl/index.esm.js"

to the openfl package.json. This way whenever the following import is encountered

import { Sprite, Stage } from "openfl";

webpack will rely on index.esm.js to import the listed classes. We also need to add the 
following:

"sideEffects": false

to package.json. This in combination with assigning a es2015 index module to the "module" field 
allows webpack 4 to exclude entire unused modules from the generated bundle, thus decreasing the 
file size.
*/


var createdMap = new Map();
var modifiedMap = new Map();
var unchangedMap = new Map();
var unableToWriteMap = new Map();


console.log('generate-es2015 running...');

startCreateEsmModules().then(() => {
  
  startModifyEsmModules().then(() => {
    
    startCreateDefaultReExportEsms().then(() => {
      
      startCreateBarrelModules().then(() => {
        
        complete();
        
      });
    });
  });
  
});


function complete() {
    
  var modifiedFiles = Array.from(modifiedMap.keys());
  var errorFiles = Array.from(unableToWriteMap.keys());
  
  console.log('complete!');
  console.log(modifiedFiles.length + ' files updated');
  console.log(Array.from(createdMap.keys()).length + ' files added');
  console.log(Array.from(unchangedMap.keys()).length + ' files unchanged');
  console.log(errorFiles.length +  ' files were unable to be saved');
  
  if (modifiedFiles.length > 0) {
    console.log("list of updated files:");
    for (let filePath of modifiedFiles) {
      console.log(filePath);
    }
  }
  
  if (errorFiles.length > 0) {
    console.log("list of files unable to be saved:");
    for (let filePath of errorFiles) {
      console.log(filePath);
    }
  }
}



function startCreateEsmModules() {
  
  return globby(['../lib/_gen/**/*.js']).then((paths) => {
    
    for (let path of paths) {
      
      if (path.match(/\.esm\.js$/) != null) {
        continue;
      }
      
      if (createEsmModule(path)) {
      }
    }
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
  
    
  let esmFilePath = filePath.replace(/\.js$/, '.esm.js');
    
  return writeIfModified(esmFilePath, result);
}



function startModifyEsmModules() {
  
  // Now we need to go through the esm.js modules that were generated 
  // and replace the required file paths with the .esm.js versions
  return globby(['../lib/_gen/**/*.esm.js']).then((paths) => {
    
    for (let path of paths) {
      
      if (modifyEsmModule(path)) {
      }
    }
  });
}

function modifyEsmModule(filePath) {
  
  let content;
  
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (error) {
    console.error('Could not read file:', filePath);
    return;
  }
  
  
  var result = content;
  
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
  
    
  //let esmFilePath = filePath.replace(/\.js$/, '.esm.js');
  let esmFilePath = filePath;
  
  return writeIfModified(esmFilePath, result);
}


// Here we look create the es2015 version of the commonjs modules that contain:
// module.exports = require("./../../_gen/openfl/display/Sprite").default;

// The generated es2015 module will contain:
// export { default } from "./../../_gen/openfl/display/Sprite.esm");
function startCreateDefaultReExportEsms() {
  
  return globby(['../lib/openfl/**/*.js']).then((paths) => {
    
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
      }
    }
      
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
  
    
  let esmFilePath = filePath.replace(/\.js$/, '.esm.js');
  
  return writeIfModified(esmFilePath, result);
}




/*
Take all the barrel index.js files under lib/openfl and generate es2015 versions of them
and save them as index.esm.js. We then need to make sure we add the key-value pair: 

"module": "lib/openfl/index.esm.js"

to the openfl package.json. This way when webpack is run, it will be able to tree shake our bundle, excluding 
modules that are not used in an openfl app. Also add

"sideEffects": false

to package.json to indicate to webpack 4 that it is safe to exclude entire unused modules from the bundle

*/

function startCreateBarrelModules() {
    
  // Look for all the index.js files under lib/openfl/ and create index.esm.js versions of them
  return globby(['../lib/openfl/**/index.js']).then((paths) => {
    
    for (let path of paths) {
      if (createEsmIndex(path)) {
      }
    }
    
  });
}

function createEsmIndex(filePath) {
  
  let content;
  
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (error) {
    console.error('Could not read file:', filePath);
    return;
  }
  
	var result = content;
  
  
	// Handle comment lines
	result = result.replace(/^\s*\/\/(.+?): require\(["'](.+?)["']\)\.default.*/gm, '// export { default as $1 } from "$2.esm";');
	// Replaces: 
	// "// Application: require("./Application").default,"
	// with
	// "export { default as Application } from "./Application.esm";"
	
	
	result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\)\.default.*/gm, 'export { default as $1 } from "$2.esm";');
	// Replaces: 
	// "Bitmap: require("./Bitmap").default,"
	// with
	// "export { default as Bitmap } from "./Bitmap.esm";"
	 
  
  
  
	
	// Deal with the barrel index modules that are re-rexported
	// Note: Must call this AFTER the previous replace() call
	//result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\).*/gm, 'export * from "$2/index.esm";');
	result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\).*/gm, (match, p1, p2) => {
		
		try {
			
			let fullPath = path.resolve(path.dirname(filePath), p2 + '.js');
			//fullPath = path.dirname(filePath) + '/' + p2 + '.js';
			
			if (fs.statSync(fullPath).isFile()) {
				return 'export * from "' + p2 + '.esm";';
			}
		} catch (error) {
			
		}
		
		return 'export * from "' + p2 + '/index.esm";';
	});
	// Replaces: 
	// textures: require("./textures"),
	// with
	// export * from "./textures/index.esm";
	
	
	
	// Remove the "module.exports = {" lines
	result = result.replace('module.exports = {', '');
	
	// And remove the end "}"
	result = result.replace(/}\s*$/gm, '');
  
  
  // We save the file as index.esm.js and place it in the same directory as the 
  // index.js that we read
  var esmFilePath = filePath.replace(/\.js$/, '.esm.js');
  writeIfModified(esmFilePath, result);
  
  
  result = result.replace(/\/index.esm/g, '');
  result = result.replace(/\.esm/g, '');
  
  var dTSFilePath = filePath.replace(/\.js$/, '.d.ts');
  writeIfModified(dTSFilePath, result);
  
  return true;
  
}



function writeIfModified(filePath, content) {
  
  try {
    
    if (!fs.existsSync(filePath)) {
      createdMap.set(filePath, true);
    } else {
      
      previousContents = fs.readFileSync(filePath, 'utf8');
    
      if (filePath.indexOf('openfl/display') > -1) {
        //console.log(filePath);
      }
      
      if (filePath.indexOf('Sprite.esm.js') > -1) {
        
        //console.log(filePath);
        //console.log(previousContents.substring(0, 100));
        //console.log(content.substring(0, 100));
        //console.log(previousContents);
      }
      if (content == previousContents) {
        unchangedMap.set(filePath, true);
        return false;
      } 
      
      if (!createdMap.has(filePath))
        modifiedMap.set(filePath, true);
    }
    
    fs.writeFileSync(filePath, content, 'utf8');
    
  } catch (error) {
    unableToWriteMap.set(filePath, true);
    console.error('Could not write to file:', filePath);
    return false;
  }
  
  return true;
}