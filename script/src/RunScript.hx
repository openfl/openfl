package;


import helpers.LogHelper;


class RunScript {
	
	
	/*static private function buildDocumentation ():Void {
		
		var openFLDirectory = PathHelper.getHaxelib (new Haxelib ("openfl"), true);
		var scriptPath = PathHelper.combine (openFLDirectory, "script");
		var documentationPath = PathHelper.combine (openFLDirectory, "documentation");
		
		PathHelper.mkdir (documentationPath);
		
		runCommand (scriptPath, "haxe", [ "documentation.hxml" ]);
		
		FileHelper.copyFile (PathHelper.combine (openFLDirectory, "haxedoc.xml"), documentationPath + "/openfl.xml");
		
		runCommand (documentationPath, "haxedoc", [ "openfl.xml", "-f", "openfl", "-f", "flash" ]);
		
	}*/
	
	
	public static function main () {
		
		var args = Sys.args ();
		var workingDirectory = args.pop ();
		
		if (args.length > 1 && args[0] == "create") {
			
			args[1] = "openfl:" + args[1];
			
		}
		
		var args = [ "run", "lime" ].concat (args);
		
		try {
			
			Sys.setCwd (workingDirectory);
			
		} catch (e:Dynamic) {
			
			LogHelper.error ("Cannot set current working directory to \"" + workingDirectory + "\"");
			
		}
		
		Sys.exit (Sys.command ("haxelib", args));
		
	}
	
	
}