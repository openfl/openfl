

let fs = require('fs');
let globby = require('globby');
let path = require('path');


let argv = process.argv;

/*
Run this after the "npm run build-lib" script. This script does the following:

- Goes through each of the commonjs modules under lib/_gen/ and generates es2015 versions 
of them and plaaces them under a different directory. See startCreateEsmModules()

- Goes through each of the commonjs modules under lib/openfl/ that re-export a single module and 
generates the equivalent es2015 module. See startCreateDefaultReExportEsms()

- Takes all the commonjs barrel index.js files under lib/openfl and generates es2015 versions of 
them. Also generates the index.d.ts declaration files for typescript. See startCreateBarrelModules()


We then need to make sure we add the following:

"module": "lib_esm/openfl/index.js"

to the openfl package.json. This way whenever the following import is encountered

import { Sprite, Stage } from "openfl";

webpack will rely on index.js to import the listed classes. We also need to add the 
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
var previousContentsMap = new Map();
var writtenContentsMap = new Map();
var originalContentsMap = new Map();

var c = 0;


console.log('generate-es2015 running...');
/*

*/

if (argv.length == 3) {
  if (argv[2] == 'export') {
    // First create the directory we will export our es2015 modules to
    mkDirByPathSync('../lib_esm/');

    //startCreateDefaultReExportEsms().then(() => {
        
      startCreateBarrelModules().then(() => {
        
        complete();
        
      });
    //});
  }
  if (argv[2] == 'gen') {
    
    // First create the directory we will export our es2015 modules to
    mkDirByPathSync('../lib_esm/_gen');


    startCreateEsmModules().then(() => {
  
      startModifyEsmModules().then(() => {
        complete();
        
      });
      
    });
  }
}


function complete() {
  
  writtenContentsMap.forEach((value, filePath) => {
    
    let content = value.content;
    let override = value.override;
    
    try {
      
      let created = false;
      if (!fs.existsSync(filePath) || createdMap.has(filePath)) {
        created = true;
      } else {
        if (!originalContentsMap.has(filePath))
          originalContentsMap.set(filePath, fs.readFileSync(filePath, 'utf8'));
      }
      
      if (originalContentsMap.has(filePath) && originalContentsMap.get(filePath) != content && override) {
        /*
        if (c++ < 1) {
          
          let originalContent = originalContentsMap.get(filePath);
          
          console.log('\n\n-original-');
          //console.log(originalContent.substr(originalContent.length - 500));
          console.log(originalContent.substr(0, 1000));
          console.log('\n\n-new-');
          //console.log(content.substr(content.length - 500));
          console.log(content.substr(0, 1000));
          console.log('\n\n');
          console.log('filePath', filePath);
          console.log(originalContentsMap.get(filePath).length, content.length);
        }
        */
       
        fs.writeFileSync(filePath, content, 'utf8');
        modifiedMap.set(filePath, true);
        
      } else if (created) {
        
        fs.writeFileSync(filePath, content, 'utf8');
        createdMap.set(filePath, true);
        
      } else {
        
        unchangedMap.set(filePath, true);
      }
      
    } catch (error) {
      unableToWriteMap.set(filePath, true);
      console.error('Could not write to file:', filePath);
      return false;
    }
  });
  
        
  
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

function moveImportsToTop(content, importLines) {
      
  for (let importLine of importLines) {
    content = content.replace(importLine, '');
  }
  
  let importLineStr = importLines.reduce((prev, value) => {
    return prev + "\n" + value;
  }, '');
  content = content.replace('// Imports', '// Imports\n' + importLineStr);
  
  return content; 
}

function appendImport(content, importStatement) {
  
  content = content.replace('// Constructor', importStatement + '\n\n// Constructor');
  
  return content;
}


function importAndCallInit(content, lookFor, className) {
  let rep = `
init${lookFor}();
var ${className} = function(`;
  
  content = content.replace(new RegExp(`var ${className} = function\\(`), rep);
    
  r = `import { default as ${lookFor}, init as init${lookFor} } from `;
  content = content.replace(new RegExp(`import { default as ${lookFor} } from `), r);
  
  return content;
}

function exportInit(content, className) {
  let rep = `
var ${className};
export function init() {

if (${className})
  return;
  
${className} = function(`;

  content = content.replace(new RegExp(`var ${className} = function\\(`), rep);
  
  // We need to use "export { Sprite as default }"" as opposed to "export default Sprite" in order to 
  // take advantage of live bindings. This way our module init functions can initialize our classes 
  // when other modules call the init function.
  content = content.replace(`export default ${className};`, `}\ninit();\nexport { ${className} as default };`);
  
  return content;
}


function createEsmModule(filePath) {
  
  let content = readFileSync(filePath);
  if (content === false)
    return;
  
    
  var result = content;
  
  
  
  // We must remove these lines at the top as they are only needed in commonjs modules
  result = result.replace('$global.Object.defineProperty(exports, "__esModule", {value: true});', '');
  result = result.replace('Object.defineProperty(exports, "__esModule", {value: true});', '');
  
  // TODO: Remove this line ONLY if $global is not used anywhere else in the module
  //result = result.replace('var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this', '');
  
  let esmFilePath = filePath.replace('lib/', 'lib_esm/');
  // ../lib/_gen/openfl/display/Sprite.js
  // to
  // ../lib_esm/_gen/openfl/display/Sprite.js
  
  
  mkDirByPathSync(path.dirname(esmFilePath));
  
  
  return writeFileSync(esmFilePath, result);
}



function startModifyEsmModules() {
  
  // Now we need to go through the esm.js modules that were generated 
  // and replace the required file paths with the .esm.js versions
  return globby(['../lib_esm/_gen/**/*.js']).then((paths) => {
    
    for (let path of paths) {
      
      if (modifyEsmModule(path)) {
      }
    }
  });
}

function modifyEsmModule(filePath) {
  
  let content = readFileSync(filePath);
  if (content === false)
    return;
  
  
  var result = content;
  
  // Replace
  // var $hxClasses = require("./../../hxClasses_stub").default;
  // with
  // import { default as $hxClasses } from "./../../hxClasses_stub";
  result = result.replace(/^var (.+?) = require\(['"](.+?)['"]\)\.default;/gm, 'import { default as $1 } from "$2";');
  
  // Replace
  // function openfl_display_DisplayObject() {return require("./../../openfl/display/DisplayObject");}
  // with
  // import { default as openfl_display_DisplayObject } from "./../../openfl/display/DisplayObject";
  result = result.replace(/^function (.+?)\(\) {return require\(['"]\.\/(.+?)['"]\);}/gm, 'import { default as $1 } from "./$2";');
  
  
  
  
  result = result.replace(/exports\.default =/g, 'export default');
  // Replace 
  // exports.default = Sprite
  // with
  // export { Sprite as default };
  
  
  
  if (filePath.indexOf('openfl/display/DisplayObject.') > -1) {
    result = exportInit(result, 'DisplayObject');
    
    // To deal with circular dependencies
    result = moveImportsToTop(result, [
      'import { default as haxe_ds_StringMap } from "./../../haxe/ds/StringMap";', 
      'import { default as lime_utils_ObjectPool } from "./../../lime/utils/ObjectPool";'
    ]);
    
  }
  
  
  if (filePath.indexOf('openfl/display/Bitmap.js') > -1) {
    result = importAndCallInit(result, 'openfl_display_DisplayObject', 'Bitmap');
  }

  if (filePath.indexOf('openfl/display/BitmapData.js') > -1) {
    
    result = exportInit(result, 'BitmapData');
      
    result = moveImportsToTop(result, [
'import { default as openfl_geom_Rectangle } from "./../../openfl/geom/Rectangle";',
'import { default as lime_graphics_Image } from "./../../lime/graphics/Image";',
'import { default as lime_math_Vector2 } from "./../../lime/math/Vector2";'
    ]);
  }
  
  if (filePath.indexOf('openfl/_internal/renderer/opengl/GLMaskShader.js') > -1) {
    
    result = importAndCallInit(result, 'openfl_display_BitmapData', 'GLMaskShader');
  }
  
  
  //
  // howler
  //
  result = result.replace('function lime_media_howlerjs_Howl() {return require("howler");}', 'import { Howl } from "howler";');
  // Replace
  // function lime_media_howlerjs_Howl() {return require("howler");}
  // with
  // import { Howl } from "howler";
  
  result = result.replace(/new \(lime_media_howlerjs_Howl\(\)\.Howl\)/g, 'new Howl');
  // Replace
  // new (lime_media_howlerjs_Howl().Howl)
  // with
  // new Howl
  
  
  //
  // filesaver
  //
  if (result.indexOf('require (\'file-saverjs\')') > -1)
    result = appendImport(result, 'import fileSaverJs from "file-saverjs";');
  result = result.replace(/require \('file-saverjs'\)/g, 'fileSaverJs');
  
  
  //
  // pako
  //
  if (result.indexOf('require ("pako").deflateRaw') > -1) 
    result = appendImport(result, 'import { deflateRaw, inflateRaw } from "pako";');
  if (result.indexOf('require ("pako").inflate') > -1) 
    result = appendImport(result, 'import { deflate, inflate } from "pako";');
    
  result = result.replace(/require \("pako"\)\./g, '');
  // Replace
  // var data = require ("pako").inflate(bytes.getData());
  // with
  // var data = inflate(bytes.getData());
  
  
  
  result = result.replace("var js_Boot = require('./js/Boot');", 'import { default as js_Boot } from "./js/Boot";');
  
  result = result.replace("var HxOverrides = require('./HxOverrides');", 'import { default as HxOverrides } from "./HxOverrides";');
  
  result = result.replace(/HxOverrides\.default/g, 'HxOverrides');
  
  // Replace
  // (openfl_display_DisplayObject().default).call(this);
  // with
  // openfl_display_DisplayObject.call(this);
  
  // I had to add the [^(] character negation (instead of .) to deal with this case:
  // (symbol1,(openfl__$internal_symbols_BitmapSymbol().default))
  // Had I instead used the dot metacharacter, it would have transformed it into this:
  // symbol1,(openfl__$internal_symbols_BitmapSymbol)
  // as opposed to the correct form:
  // (symbol1,openfl__$internal_symbols_BitmapSymbol)
  result = result.replace(/\(([^(]+?)\(\)\.default\)/gm, '$1');
  
 
  let esmFilePath = filePath;
  
  return writeFileSync(esmFilePath, result);
}


// Here we create the es2015 version of the commonjs modules that contain:
// module.exports = require("./../../_gen/openfl/display/Sprite").default;

// The generated es2015 module will contain:
// export { default } from "./../../_gen/openfl/display/Sprite");
function startCreateDefaultReExportEsms() {
  
  return globby(['../lib/openfl/**/*.js']).then((paths) => {
    
    for (let path of paths) {
    
      
      // Skip the barrel index.js and index.esm.js files
      if (path.match(/index(\.js|\.d\.ts)$/) != null) {
        continue;
      }
      
      if (createDefaultReExportEsm(path)) {
      }
    }
      
  });
  
}



function createDefaultReExportEsm(filePath) {
  
  
  let content = readFileSync(filePath);
  if (content === false)
    return;
  
  var result = content;
  
  result = result.replace(/^\s*module\.exports\s*=\s*require\(['"](.+?)['"]\);/gm, 'export { default } from "$1";');
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
  
  
  result = result.replace(/^\s*var (.*?) = require \(['"](.*?)['"]\)\.default;/gm, 'import { default as $1 } from "$2";');
  // Replace
  // var Lib = require ("./../../_gen/openfl/Lib").default;
  // with
  // import { default as Lib } from "./../../_gen/openfl/Lib.esm";
  
  
  result = result.replace('module.exports._internal = internal;', 'export { internal as _internal };');
  // Replace (in lib_esm/openfl/utils/AssetLibrary.js)
  // module.exports._internal = internal;
  // with
  // export { internal as _internal };

  
  
  let esmFilePath = filePath.replace('lib/', 'lib_esm/');
  mkDirByPathSync(path.dirname(esmFilePath));
  // ../lib/openfl/display/Sprite.js
  // to
  // ../lib_esm/openfl/display/Sprite.js
  
  return writeFileSync(esmFilePath, result, false);
}

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
  
  
  let content = readFileSync(filePath);
  if (content === false)
    return;
  
	var result = content;
  
  
	// Handle comment lines
	result = result.replace(/^\s*\/\/(.+?): require\(["'](.+?)["']\)\.default.*/gm, '// export { default as $1 } from "$2";');
	// Replaces: 
	// "// Application: require("./Application").default,"
	// with
	// "// export { default as Application } from "./Application.esm";"
	
	
	result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\)\.default.*/gm, 'export { default as $1 } from "$2";');
	//result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\)\.default.*/gm, 'export { default as $1 } from "$2";');
	// Replaces: 
	// "Bitmap: require("./Bitmap").default,"
	// with
	// "export { default as Bitmap } from "./Bitmap.esm";"
	 
  
  
  
	
	// Deal with the barrel index modules that are re-rexported
  // Note: Must call this AFTER the previous replace() call
  result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\).*/gm, (match, p1, p2) => {
		
		try {
			
			let fullPath = path.resolve(path.dirname(filePath), p2 + '.js');
			
			if (fs.statSync(fullPath).isFile()) {
				
        return 'export { default as ' + p1 + ' } from "' + p2 + '";';
			}
		} catch (error) {
			
		}
		
    return 'export * from "' + p2 + '";';
	});
	// Replaces: 
	// textures: require("./textures"),
	// with
	// export * from "./textures";
	
	
	
	// Remove the "module.exports = {" lines
	result = result.replace('module.exports = {', '');
	
	// And remove the end "}"
  result = result.replace(/}\s*$/gm, '');
  
  
  // Add additiona exports not present in the original index barrel module
  if (filePath.indexOf('openfl/utils/index.js') > -1)
    result += 'export { default as AssetLibrary } from "./AssetLibrary";';
  
  
  // We save the file as index.js and place it in the lib_esm/ directory
  //var esmFilePath = filePath.replace(/\.js$/, '.esm.js');
  let esmFilePath = filePath.replace('lib/', 'lib_esm/');
  mkDirByPathSync(path.dirname(esmFilePath));
  // ../lib/openfl/display/index.js
  // to
  // ../lib_esm/openfl/display/index.js
  
  writeFileSync(esmFilePath, result);
  
  
  var dTSFilePath = filePath.replace(/\.js$/, '.d.ts');
  writeFileSync(dTSFilePath, result, true);
  
  return true;
  
}

function isFile(filename) {
  
  filename = path.resolve(filename);
  
  if (writtenContentsMap.has(filename)) {
    return true;
  }
  
  if (originalContentsMap.has(filename)) {
    return true;
  }
  
  try {
    fs.statSync(filename).isFile();
  } catch (error) {
    return false;
  }
  
  return true;
}

function readFileSync(filename) {
  
  filename = path.resolve(filename);
  
  if (writtenContentsMap.has(filename)) {
    return writtenContentsMap.get(filename).content;
  }
  if (originalContentsMap.has(filename)) {
    return originalContentsMap.get(filename);
  }
  
  try {
    content = fs.readFileSync(filename, 'utf8');
    originalContentsMap.set(filename, content);
  } catch (error) {
    console.error('Could not read file:', filename);
    return false;
  }
  
  return content;
}



function writeFileSync(filename, content, override) {
    
  if (override == null)
    override = true;
    
  filename = path.resolve(filename);
  
  
  // Need to write to the file system so that globby() can pick up the file
  if (!fs.existsSync(filename)) {
    createdMap.set(filename, true);
    try {
      fs.writeFileSync(filename, content, 'utf8');
    } catch (error) {
      
    }
    
  }
  
  writtenContentsMap.set(filename, {content: content, override: override});
}


function mkDirByPathSync(targetDir, {isRelativeToScript = false} = {}) {
  const sep = path.posix.sep;
  const initDir = path.isAbsolute(targetDir) ? sep : '';
  const baseDir = isRelativeToScript ? __dirname : '.';

  targetDir.split(sep).reduce((parentDir, childDir) => {
    const curDir = path.resolve(baseDir, parentDir, childDir);
    try {
      fs.mkdirSync(curDir);
      //console.log(`Directory ${curDir} created!`);
    } catch (err) {
      if (err.code !== 'EEXIST') {
        throw err;
      }

      //console.log(`Directory ${curDir} already exists!`);
    }

    return curDir;
  }, initDir);
}

