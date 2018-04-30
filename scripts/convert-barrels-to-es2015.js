

let fs = require('fs');
let globby = require('globby');

/*
This script will take all the barrel index.js files under lib/openfl and generate es2015 versions of them
and save them as index.esm.js. We then need to make sure we add the key-value pair: 

"module": "lib/openfl/index.esm.js"

to the openfl package.json. This way when webpack is run, it will be able to tree shake our bundle, excluding 
modules that are not used in an openfl app.

*/

// Look for all the index.js files under lib/openfl/ and create index.esm.js versions of them
globby(['../lib/openfl/**/index.js']).then((paths) => {

  let updated = 0;

  for (let path of paths) {
    if (createEsmIndex(path)) {
      updated++;
    }
  }
    
  console.log(__filename, 'Complete -', updated, 'files affected');
});


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
	result = result.replace(/^\s*(.+?): require\(["'](.+?)["']\).*/gm, 'export * from "$2/index.esm";');
	// Replaces: 
	// textures: require("./textures"),
	// with
	// export * from "./textures/index.esm";
	
	// Remove the "module.exports = {" lines
	result = result.replace('module.exports = {', '');
	
	// And remove the end "}"
	result = result.replace(/}\s*$/gm, '');
	
	
	
  if (result == content) {
    // Nothing was changed in the file
    return false;
  }

  try {
		
		// We save the file as index.esm.js and place it in the same directory as the 
		// index.js that we read
		var esmFilePath = filePath.replace(/\.js$/, '.esm.js');
		
		fs.writeFileSync(esmFilePath, result, 'utf8');
		
		var dTSFilePath = filePath.replace(/\.js$/, '.d.ts');
		fs.writeFileSync(dTSFilePath, result, 'utf8');
		
		
  } catch (error) {
    console.error('Could not write to file:', filePath);
    return;
  }
  return true;
  
}