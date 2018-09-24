/*
generate-es2015.js


Commands:
node generate-es2015 gen
- This will generate the es2015 modules and save them under lib-esm/_gen/

node generate-es2015 other
- This will generate the re-export modules as well as the index.js and index.d.ts barrel modules
- re-export module example: lib-esm/openfl/display/Sprite.js
- barrel modules examples: lib-esm/openfl/display/index.js and lib/openfl/display/index.d.ts

*/

const _fs = require('fs');
const _path = require('path');
const globby = require('globby');
const readline = require('readline');
let DelayFS = init();
let delayFS = new DelayFS(false);


// Settings
const inputLibDirname = 'lib';
const outputLibDirname = 'lib-esm';
const baseDir = '..';

let fullInputLibDirPath = _path.resolve(baseDir, inputLibDirname);
let fullOutputLibDirPath = _path.resolve(baseDir, outputLibDirname);

let inputGenPath = _path.resolve(baseDir, inputLibDirname, '_gen');
let outputGenPath = _path.resolve(baseDir, outputLibDirname, '_gen');

let inputLibOpenflPath = _path.resolve(baseDir, inputLibDirname, 'openfl');
let outputLibOpenflPath = _path.resolve(baseDir, outputLibDirname, 'openfl');


// Convert windows paths to posix paths
fullInputLibDirPath = normalizePath(fullInputLibDirPath);
fullOutputLibDirPath = normalizePath(fullOutputLibDirPath);
inputGenPath = normalizePath(inputGenPath);
outputGenPath = normalizePath(outputGenPath);
inputLibOpenflPath = normalizePath(inputLibOpenflPath);
outputLibOpenflPath = normalizePath(outputLibOpenflPath);


const debug = false;


let argv = process.argv;
if (argv.length == 3) {
  start(argv[2]);
} else {
  start(null);
}

async function start(option) {

  output('\n## convert-es2015.js...');

  if (option == 'gen') {
    // Generate the es2015 modules in the lib-esm/_gen/ directory
    await startCreateEsmModules();
    
    let totalFilesAddedOrModified = writeAllToFileSystem();
    if (totalFilesAddedOrModified == 0) {
      output('\nComplete! No files were created or modified', true);
      return;
    }
    output(`\nComplete! ${totalFilesAddedOrModified} files were created or modified`, true);

  } else if (option == 'gen-confirm') {
    // Same as "gen" but prompts user before saving to file system
    await startCreateEsmModules();
    
    let totalFilesAddedOrModified = writeAllToFileSystem(true);
    if (totalFilesAddedOrModified == 0) {
      output('\nComplete! No files were created or modified', true);
      return;
    }
    const r1 = readline.createInterface({ input: process.stdin, output: process.stdout });
    r1.question('\n\nBased on the above, do you want to write the changes to the file system? [y/n]', answer => {
      r1.close();
      if (answer == 'y') {
        writeAllToFileSystem();
        output(`\nComplete! ${totalFilesAddedOrModified} files were created or modified`, true);
      } else {
        output('\nComplete! No files were created or modified', true);
      }
    });
  }
  else if (option == 'non-gen') {

    await startCreateDefaultReExportEsms();
    await startCreateIndexModules();
    
    let totalFilesAddedOrModified = writeAllToFileSystem(true);

    if (totalFilesAddedOrModified == 0) {
      output('\nComplete! No files were created or modified', true);
      return;
    }
        
    const r1 = readline.createInterface({ input: process.stdin, output: process.stdout });
    r1.question('\n\nBased on the above, do you want to write the changes to the file system? [y/n]', answer => {
      r1.close();
      if (answer == 'y') {
        writeAllToFileSystem();
        output(`\nComplete! ${totalFilesAddedOrModified} files were created or modified`, true);
      } else {
        output('\nComplete! No files were created or modified', true);
      }

    });

  } else if (option == 'circular') {
    // Search for circular dependencies that may cause run-time errors
    await startFind();
    output('Complete!', true);
  }
  else {
    output('\nOption unrecognized or not specified. Nothing to be done. Exiting script.', true);
    return;
  }

}



function startFind() {
  
  output('Searching for runtime circular dependency related errors:');
  
  return globby([_path.resolve(`${outputGenPath}`, `**/*.js`)]).then((paths) => {
    
    // First we search for circular references...
    let result = new EsmModuleResult();
    
    for (let i = 0; i < paths.length; i++) {      
      let path = paths[i];
      
      result.level = 0;
      processModule(result, path);
    }
    
    // ... then we look for circular imports that would cause a runtime error
    result.circulars.forEach(circular => {
      analyzeCircular(circular);
    });
    
    
  });
}


function analyzeCircular(circularChain) {
  
  circularChain.map(module => {
    
    Array.from(module.directImports.values()).map(importedModuleInfo => {
      
      if (circularChain.some(module => importedModuleInfo.module)) {
        if (importedModuleInfo.inCircular) {
          
          
          if (module.content.search(new RegExp(`\\$extend\\(${RegExp.escape(importedModuleInfo.localName)}\\.prototype`)) > -1) {
            console.log('\nPossible runtime error:');
            console.log(module.fullFilePath, 'extends', importedModuleInfo.localName);
            console.log(circularChain.map(module => module.shortName).join(' -> ') + ' -> ' + circularChain[0].shortName);
          }
          
          let initCommentLine = module.content.search(/^\/\/ Init/m);
          
          if (initCommentLine > -1) {
            
            let lastPart = '';
            
            initCommentLine += '// Init'.length;
            
            let exportCommentLine = module.content.search(/^\/\/ Export/m);
            if (exportCommentLine > -1)
              lastPart = module.content.substring(initCommentLine, exportCommentLine);
            else
              lastPart = module.content.substring(initCommentLine);
              
            let localNameUsedIndex = lastPart.search(new RegExp(`^[^\t]*?${RegExp.escape(importedModuleInfo.localName)}`, 'm'));
            
            
            if (localNameUsedIndex > -1) {
              console.log('\nPossible runtime error:');
              console.log(module.fullFilePath, 'depends on', importedModuleInfo.localName);
              console.log(circularChain.map(module => module.shortName).join(' -> ') + ' -> ' + circularChain[0].shortName);
            }
          }
          
        }
      }
    });
    
    
    
  });
  
  
}




RegExp.escape = function(str) {
  if (!arguments.callee.sRE) {
      var specials = [
          '/', '.', '*', '+', '?', '|',
          '(', ')', '[', ']', '{', '}', '\\', '$'
      ];
      arguments.callee.sRE = new RegExp(
      '(\\' + specials.join('|\\') + ')', 'gim'
  );
  }
  return str.replace(arguments.callee.sRE, '\\$1');
}
            

function processModule(result, moduleFilePath) {
  
  let module = new EsmModule();
  
  if (typeof moduleFilePath == 'string')
    module = result.getOrCreateModule(moduleFilePath);
  else
    module = moduleFilePath;
    
  if (module.importsProcessed) {
    return;
  }
  if (module.isAbsolute)
    return;
  
  
  let dirname = _path.dirname(module.fullFilePath);
  let content = _fs.readFileSync(module.fullFilePath, 'utf8');
  let regex = /^import \{ default as (.+?)[, ].*?} from "(.+?)";/gm;
  module.content = content;
  
  // We look for lines like this:
  // import { default as openfl_display_DisplayObject } from "./../../openfl/display/DisplayObject";
  // And we want to extract these parts:
  // openfl_display_DisplayObject
  // ./../../openfl/display/DisplayObject
  
  while (matches = regex.exec(content)) {
    
    let importPath = matches[2];
    let importFullFilePath = _path.resolve(dirname, matches[2] + '.js');
    importFullFilePath = normalizePath(importFullFilePath);
    
    
    
    let importedModule;
    
    if (importPath[0] != '.' && importPath[0] != '/') {
      // absolute import path
      importedModule = result.getOrCreateModule(importPath);
      importedModule.isAbsolute = true;
    } else {
      importedModule = result.getOrCreateModule(importFullFilePath);
    }
    
    // Such as "openfl_display_DisplayObject"
    let localName = matches[1];
    
    module.addDirectImport(importedModule, localName); 
  }
  
  
  module.importsProcessed = true;
  
  result.chain.push(module);
  module.directImports.forEach((importedModuleInfo, key) => {
    
    if (result.chain.has(importedModuleInfo.module)) {
      result.foundCircular(result.chain, importedModuleInfo.module, module);
      
      // We must not go further or we get trapped in an endless loop
      return;
    }
    result.level++;
    processModule(result, importedModuleInfo.module);
    result.level--;
  });
  result.chain.pop();
  
}

class ImportChain {
  
  constructor() {
    this.chain = [];
  }
  
  setAsCircular(startModule, endModule) {
    
  }
  
  getModulesBetween(start, end) {
    
    let index = this.chain.indexOf(start);
    
    let modules = [];
    
    while (true) {
      
      modules.push(this.chain[index]);
      
      if (this.chain[index] == end) {
        break;
      }
      index++;
      
    }
    
    return modules;
  }
  has(module) {
    return this.chain.indexOf(module) > -1;
  }
  push(module) {
    this.chain.push(module);
  }
  pop() {
    this.chain.pop();
  }
}
class EsmModuleResult {
  
  constructor() {
    this.chain = new ImportChain();
    this.modules = new Map();
    
    this.circulars = [];
  }
  
  foundCircular(chain, startModule, endModule) {
    
    let modules = chain.getModulesBetween(startModule, endModule);
    
    modules.forEach(module => {
      
      let importedModuleInfos = Array.from(module.directImports.values()).filter(importedModuleInfo => modules.some(module2 => module2 == importedModuleInfo.module));
      
      importedModuleInfos.forEach(importedModuleInfo => {
        importedModuleInfo.inCircular = true;
      });
    });
    
    this.circulars.push(modules);
  }
  
  
  addModule(module) {
    this.modules.set(module.fullFilePath, module);
  }
  hasModule(fullFilePath) {
    return this.modules.has(fullFilePath);
    
  }
  
  moduleProcessed(module) {
    return module.processed;
  }
  
  
  getOrCreateModule(fullFilePath) {
    
    if (this.hasModule(fullFilePath)) {
      return this.modules.get(fullFilePath);
    }
    
    let module = new EsmModule();
    module.shortName = _path.basename(fullFilePath);
    module.fullFilePath = fullFilePath;
    this.addModule(module);
    
    return module;
    
  }
}

class EsmModule {
  
  constructor() {
    
    this.isAbsolute = false;
    
    this.directImports = new Map();
    this.indirectImports = new Map();
    
    this.isInCircularImportChain = false;
    this.fullFilePath = null;
    this.importsProcessed = false;
  }
  
  addDirectImport(module, localName) {
    
    let importedModuleInfo = {};
    importedModuleInfo.module = module;
    importedModuleInfo.localName = localName;
    importedModuleInfo.inCircular = false;
    
    this.directImports.set(module.fullFilePath, importedModuleInfo);
  }
}




function startCreateEsmModules() {
  
  return globby([_path.resolve(`${inputGenPath}`, `**/*.js`)]).then((paths) => {
    
    for (let path of paths) {
      
      if (path.match(/\.esm\.js$/) != null) {
        continue;
      }
      
      let content = delayFS.readFileSyncUTF8(path, 'cjs-module');

      let result = createEsmModule(content, path);
      
      
      let esmFilePath = path.replace(fullInputLibDirPath + '/', fullOutputLibDirPath + '/');
      // change: ".../openfl/lib/_gen/openfl/display/Sprite.js" to ".../openfl/lib-esm/_gen/openfl/display/Sprite.js"
      
      delayFS.mkDirByPathSync(_path.dirname(esmFilePath));
      delayFS.writeFileSyncUTF8(esmFilePath, result, 'esm-module');
    }
  });
}




// Here we create the es2015 version of the commonjs modules that contain:
// module.exports = require("./../../_gen/openfl/display/Sprite").default;

// The generated es2015 module will contain:
// export { default } from "./../../_gen/openfl/display/Sprite");
function startCreateDefaultReExportEsms() {

  return globby([_path.resolve(`${inputLibOpenflPath}`, `**/*.js`)]).then(paths => {

    for (let path of paths) {

      // Skip the barrel index.js and index.esm.js files
      if (path.match(/index(\.js|\.d\.ts)$/) != null) {
        continue;
      }
      

      let content = delayFS.readFileSyncUTF8(path);
      let esmFilePath = path.replace(fullInputLibDirPath + '/', fullOutputLibDirPath + '/');
      
      
      let result = createDefaultReExportEsm(content, path);
      delayFS.mkDirByPathSync(_path.dirname(esmFilePath));
      
      if (path.indexOf('AssetLibrary') > -1) {
        delayFS.writeFileSyncUTF8(esmFilePath, result, {tags: 'rexport', createOnly: true});
      } else {
        delayFS.writeFileSyncUTF8(esmFilePath, result, 'rexport');
      }
    }
  });
}


function startCreateIndexModules() {

  // Look for all the index.js files under lib/openfl/ and create index.esm.js versions of them
  return globby([_path.resolve(inputLibOpenflPath, '**/index.js')]).then((paths) => {
    
    for (let path of paths) {
      
      let content = delayFS.readFileSyncUTF8(path);
      let esmFilePath = path.replace(fullInputLibDirPath + '/', fullOutputLibDirPath + '/');

      let result = createIndexModules(content, path);
      
      delayFS.mkDirByPathSync(_path.dirname(esmFilePath));

      delayFS.writeFileSyncUTF8(esmFilePath, result, 'index');
      
      var dTSFilePath = path.replace(/\.js$/, '.d.ts');
      delayFS.writeFileSyncUTF8(dTSFilePath, result, 'index');

    }
  });
}



function createEsmModule(content, filePath) {
  
  var result = content;
  
  // We must remove these lines at the top as they are only needed in commonjs modules
  result = result.replace('$global.Object.defineProperty(exports, "__esModule", {value: true});', '');
  result = result.replace('Object.defineProperty(exports, "__esModule", {value: true});', '');
  
  // TODO: Remove this line ONLY if $global is not used anywhere else in the module
  //result = result.replace('var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this', '');
  
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
  
  
  
  //
  // Here we deal with circular dependency related bugs
  //
  if (filePath.indexOf('openfl/display/Bitmap.') > -1) {
    result = importAndCallInit(result, 'openfl_display_DisplayObject', 'Bitmap');
  }
  
  if (filePath.indexOf('Context3DMaskShader.') > -1) {
    result = importAndCallInit(result, 'openfl_display_BitmapData', 'Context3DMaskShader');
  }
  
  if (filePath.indexOf('openfl/display/DisplayObject.') > -1) {
    
    result = exportInit(result, 'DisplayObject');
    
    // Because the following imports are used in the module context of DisplayObject.js, that is, 
    // outside any function attached to the prototype of DisplayObject or static function. We must 
    // make sure these imports are processed before the import that leads to the circular dependency
    result = moveImportsToTop(result, [
      'import { default as haxe_ds_StringMap } from "./../../haxe/ds/StringMap";', 
      'import { default as lime_utils_ObjectPool } from "./../../lime/utils/ObjectPool";'
    ]);
  }
  
  if (filePath.indexOf('openfl/display/BitmapData.') > -1) {
    
    result = exportInit(result, 'BitmapData');
    
    result = moveImportsToTop(result, [
      'import { default as openfl_geom_Rectangle } from "./../../openfl/geom/Rectangle";',
      'import { default as lime_graphics_Image } from "./../../lime/graphics/Image";',
      'import { default as lime_math_Vector2 } from "./../../lime/math/Vector2";'
    ]);
    
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
  if (result.indexOf('require (\'file-saverjs\')') > -1) {
    result = appendImport(result, 'import fileSaverJs from "file-saverjs";');
    result = result.replace(/require \('file-saverjs'\)/g, 'fileSaverJs');
  }
    
  if (result.indexOf('require (\'file-saver\')') > -1) {
    result = appendImport(result, 'import * as fileSaver from "file-saver";');
    result = result.replace(/require \('file-saver'\)/g, 'fileSaver');
  }
  
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
  
  return result;
}


function createDefaultReExportEsm(content, filePath) {
  
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
  // import { default as Lib } from "./../../_gen/openfl/Lib";
  
  
  result = result.replace('module.exports._internal = internal;', 'export { internal as _internal };');
  // Replace (in lib-esm/openfl/utils/AssetLibrary.js)
  // module.exports._internal = internal;
  // with
  // export { internal as _internal };

  return result;
}


function createIndexModules(content, filePath) {
  
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
			let fullPath = _path.resolve(_path.dirname(filePath), p2 + '.js');
			
			if (_fs.statSync(fullPath).isFile()) {
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
  //if (filePath.indexOf('openfl/utils/index.js') > -1)
   // result += 'export { default as AssetLibrary } from "./AssetLibrary";';
  
  return result;
}





function writeAllToFileSystem(dryRun) {

  let summary = delayFS.commit(dryRun);

 // output(`Stats: ${inputGenPath} \n\tfiles read from filesystem: ${summary.getRead('cjs-module').length}`);
  //output('');

  let added = summary.getAdded('esm-module').length;
  let modified = summary.getModified('esm-module').length;
  let unmodified = summary.getUnmodified('esm-module').length;
  if (added > 0 || modified > 0 || unmodified > 0)
    info(`Stats: ${outputGenPath} \n\tfiles added: ${added}, modified: ${modified}, unmodified: ${unmodified}`);
  



  added = summary.getAdded('rexport').length;
  modified = summary.getModified('rexport').length;
  unmodified = summary.getUnmodified('rexport').length;
  if (added > 0 || modified > 0 || unmodified > 0)
    info(`Stats: ${outputLibOpenflPath} \n\tfiles added: ${added}, modified: ${modified}, unmodified: ${unmodified}`);

  
  added = summary.getAdded('index').length;
  modified = summary.getModified('index').length;
  unmodified = summary.getUnmodified('index').length;
  if (added > 0 || modified > 0 || unmodified > 0)
    info(`Stats: index.js and index.d.ts \n\tfiles added: ${added}, modified: ${modified}, unmodified: ${unmodified}`);
 
  
  
  
  info('');
  info(`directories created: ${summary.directoriesCreated}`);
  info(`totalCharsWritten: ${summary.totalWritten}`);
  
  let modifiedAll = summary.getModified().length;
  let addedAll = summary.getAdded();
  let unmodifiedAll = summary.getUnmodified();
  let ignoredAll = summary.getIgnored();
  
  if (addedAll.length > 0) {
    if (!dryRun)
      output(`\n${addedAll.length} files created`);
    else {
      
      output(`\n${addedAll.length} files will be created. Some of them:`);
      for (let i = 0; i < 3; i++) {
        output(`${addedAll[i]}`);
      }
    }
  }
  if (unmodifiedAll.length > 0) {
    if (!dryRun)
      output(`\n${unmodifiedAll.length} files were not modified`);
    else
      output(`\n${unmodifiedAll.length} files will not be modified`);
      
  }
  if (ignoredAll.length > 0) {
    
    output(`\nThe following modules are left alone since they contain custom modifications:`);
    output(summary.getIgnored().join('\n'));
    
  }
  if (modifiedAll > 0) {
    if (dryRun) {
      output(`\n${modifiedAll} files will be modified. Here is the list:`);
      //output('\nList of files that will be modified:');
    } else {
      output(`\n${modifiedAll} files modified. Here is the list:`);
      //output('\nList of modified files:');
    }
    output(summary.getModified().join('\n'));
  }



  return summary.totalFilesAddedOrModified;
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





function info(message) {
  if (debug)
    console.log(message);
}


function output(message, lastOutput) {
  console.log.apply(console, [message]);
  
  if (lastOutput)
  console.log('\n## end of convert-es2015.js');

}
function error() {
  console.log.apply(console, arguments);
}

function normalizePath(path) {
  let segs = path.split(/[/\\]+/);
  path = segs.join('/');
  return path;
}

function init() {

class DelayFS {
  constructor(debug) {
    this.virtualFileSystem = new Map();
    this.directoriesToCreate = new Map();

    this.debug = debug;
  }


  updateOrAddToVirtualFileSystem(fullFilePath, content, options) {

    if (options == null) {
      options = {};
    }

    let value;
    if (this.virtualFileSystem.has(fullFilePath)) {
      value = this.virtualFileSystem.get(fullFilePath);
    } else {
      value = {};
      this.virtualFileSystem.set(fullFilePath, value);
    }
    
    if (options.readFromRealFileSystem != null && options.readFromRealFileSystem) {
      value.originalContent = content;
    }

    if (options.performWrite) {
      value.performWrite = true;
    }

    if (options.tags != null) {
      if (value.tags != null) {
        value.tags.push(options.tags);
      } else {
        value.tags = [options.tags];
      }
    }
    
    if (options.createOnly != null) {
      value.createOnly = options.createOnly;
    }

    value.content = content;

    //this.log(fullFilePath);
    //this.log(value);
  }


  readFileSyncUTF8(filePath, extra) {

    let fullFilePath = _path.resolve(filePath);

    if (this.virtualFileSystem.has(fullFilePath)) {
      return this.virtualFileSystem.get(fullFilePath).content;
    }

    let content = _fs.readFileSync(fullFilePath, 'utf8');

    let tags = null;
    if (typeof extra == 'string') {
      tags = extra;
    } else if (typeof extra == 'object') {
      if (extra.tags != null)
        tags = extra.tags;
    }
    
    this.updateOrAddToVirtualFileSystem(fullFilePath, content, {readFromRealFileSystem: true, tags: tags});

    return content;
  }



  writeFileSyncUTF8(filePath, content, extra) {

    let fullFilePath = _path.resolve(filePath);

    let createOnly = null;

    let tags = null;
    
    if (typeof extra == 'string') {
      tags = extra;
    } else if (typeof extra == 'object') {
      if (extra.createOnly != null)
        createOnly = extra.createOnly;
      else if (extra.tags != null)
        tags = extra.tags;
    }
    
    this.updateOrAddToVirtualFileSystem(fullFilePath, content, {performWrite: true, tags: tags, createOnly: createOnly});
  }


  commit(dryRun) {
    
    this.directoriesThatExist = new Map();


    let summary = new Summary();

    if (dryRun) {
      //output('Doing dry run...');
    }

    this.directoriesToCreate.forEach((value, key) => {
      // Create all the directories that were requested
      let created = this._mkDirByPathSync(key, dryRun);
      
      summary.directoryCreatedCount(created);
    });


    this.virtualFileSystem.forEach((value, fullFilePath) => {

      // If not null then the file was read from the real file system
      if (value.originalContent != null) {
        summary.readFile(fullFilePath, value.tags);
      }

      // Skip those in which no write was requested
      if (!value.performWrite) {
        return;
      }

      // Check if file we are saving already exists on the file system...
      if (value.originalContent != null || _fs.existsSync(fullFilePath)) {

        let originalContent;

        if (value.originalContent == null) {
          originalContent = _fs.readFileSync(fullFilePath);
        } else {
          originalContent = value.originalContent;
        }

        if (value.content == originalContent) {

          // No modifications made to file 
          summary.unmodifiedFile(fullFilePath, value.tags);

        } else {
          
          // Mofications made to existing file
          if (value.createOnly != null && value.createOnly) {
            summary.unmodifiedFile(fullFilePath, value.tags, true);
            return;
          }

          summary.modifiedFile(fullFilePath, value.tags);
          summary.totalWritten += value.content.length;

          if (dryRun) {
          } else {
            _fs.writeFileSync(fullFilePath, value.content, 'utf8');
          }
        }
      } 
      // ... otherwise we are adding new file
      else {
        
        summary.addedFile(fullFilePath, value.tags);
        summary.totalWritten += value.content.length;

        if (dryRun) {
        } else {
          _fs.writeFileSync(fullFilePath, value.content, 'utf8');
        }

      }
    });

    return summary;
  }

  mkDirByPathSync(targetDir, {isRelativeToScript = false} = {}) {
    this.directoriesToCreate.set(targetDir, true);
  }


  _mkDirByPathSync(targetDir, dryRun, {isRelativeToScript = false} = {}) {
    
    const sep = _path.posix.sep;
    const initDir = _path.isAbsolute(targetDir) ? sep : '';
    const baseDir = isRelativeToScript ? __dirname : '.';

    let directoriesCreated = 0;

    targetDir.split(sep).reduce((parentDir, childDir) => {
      const curDir = _path.resolve(baseDir, parentDir, childDir);

      if (this.directoriesThatExist.has(curDir)) {
        //console.log('exists1', curDir);
        return curDir;
      }


      if (_fs.existsSync(curDir)) {
        //console.log('exists2', curDir);
        this.directoriesThatExist.set(curDir, true);
        return curDir;
      }

      try {
        if (dryRun) {
          //console.log('dryRun - true');
          directoriesCreated++;
        } else {
          //info(curDir);
          _fs.mkdirSync(curDir);
        }
        this.directoriesThatExist.set(curDir, true);
      } catch (err) {
        if (err.code !== 'EEXIST') {
          throw err;
        }
      }
  
      return curDir;
    }, initDir);

    return directoriesCreated;
  }

  log() {
    if (this.debug) {
      console.log.apply(console, arguments);
    }
  }

}

class Summary {


  constructor() {
    this.added = [];
    this.modified = [];
    this.unmodified = [];
    this.read = [];

    this.data = new Map();
    this.directoriesCreated = 0;
    this.totalWritten = 0;
    this.totalFilesAddedOrModified = 0;
  }

  directoryCreatedCount(count) {
    this.directoriesCreated += count;
  }

  readFile(path, tags) {
    this.read.push({tags, path});
  }

  addedFile(path, tags) {
    this.totalFilesAddedOrModified++;
    this.added.push({tags, path});
  }

  modifiedFile(path, tags) {
    this.totalFilesAddedOrModified++;
    this.modified.push({tags, path});
  }

  unmodifiedFile(path, tags, ignored) {
    this.unmodified.push({tags, path, ignored});
  }

  toString() {

    return 'summary';
  }

  getAdded(tags) {

    if (tags == null) {
      return this.added.map(value => value.path);
    }

    return this.added.filter(value => {
      return value.tags && value.tags.some(value => value == tags)

    }).map(value => value.path);
  }

  getModified(tags) {
    if (tags == null) {
      return this.modified.map(value => value.path);
    }

    return this.modified.filter(value => {
      return value.tags && value.tags.some(value => value == tags)
    }).map(value => value.path);
  }

  getUnmodified(tags) {
    if (tags == null) {
      return this.unmodified.map(value => value.path);
    }

    return this.unmodified.filter(value => {
      return value.tags && value.tags.some(value => value == tags)
    }).map(value => value.path);
  }
  
  getIgnored(tags) {
    if (tags == null) {
      return this.unmodified.filter(value => value.ignored).map(value => value.path);
    }

    return this.unmodified.filter(value => {
      return value.tags && value.tags.some(value => value == tags) && value.ignored
    }).map(value => value.path);
  }

  getRead(tags) {
    if (tags == null) {
      return this.read.map(value => value.path);
    }

    return this.read.filter(value => {
      return value.tags && value.tags.some(value => value == tags)
    }).map(value => value.path);
  }
}


return DelayFS;

}
