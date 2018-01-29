#!/usr/bin/env node

var fs = require ("fs");
var child_process = require ("child_process");

function updateLibrary (name, url) {
	
	if (fs.existsSync ("./" + name)) {
		
		if (!fs.lstatSync ("./" + name).isSymbolicLink ()) {
			
			process.chdir ("./" + name);
			child_process.execSync ("git pull", { stdio: "inherit" });
			process.chdir ("..");
			
		}
		
	} else {
		
		child_process.execSync ("git clone " + url, { stdio: "inherit" });
		
	}
	
}

try {
	
	process.chdir ("./node_modules");
	
	updateLibrary ("lime", "https://github.com/openfl/lime");
	// updateLibrary ("hxgenjs", "https://github.com/kevinresol/hxgenjs");
	// updateLibrary ("tink_macro", "https://github.com/haxetink/tink_macro");
	// updateLibrary ("tink_core", "https://github.com/haxetink/tink_core");
	
} catch (error) {
	
	console.error ("Error running postinstall script");
	console.error (error);
	return;
	
}