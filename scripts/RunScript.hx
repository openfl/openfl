package;


import hxp.*;
import sys.FileSystem;


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
		var cacheDirectory = Sys.getCwd ();
		var workingDirectory = args.pop ();
		
		try {
			
			Sys.setCwd (workingDirectory);
			
		} catch (e:Dynamic) {
			
			Log.error ("Cannot set current working directory to \"" + workingDirectory + "\"");
			
		}
		
		if (args.length > 1 && args[0] == "create") {
			
			//args[1] = "openfl:" + args[1];
			
		} else if (args.length > 0 && args[0] == "setup") {
			
			var limeDirectory = Haxelib.getPath (new Haxelib ("lime"));
			
			if (limeDirectory == null || limeDirectory == "" || limeDirectory.indexOf ("is not installed") > -1) {
				
				Sys.command ("haxelib", [ "install", "lime" ]);
				
			}
			
		} else if (args.length > 0 && args[0] == "process") {
			
			Sys.setCwd (cacheDirectory);
			
			if (!FileSystem.exists ("scripts/tools.n")) {
				
				rebuildTools ();
				
			}
			
			Sys.exit (Sys.command ("neko", [ "scripts/tools.n" ].concat (Sys.args ())));
			return;
			
		}
		
		var args = [ "run", "lime" ].concat (args);
		Sys.exit (Sys.command ("haxelib", args.concat ([ "-openfl" ])));
		
	}
	
	
	private static function rebuildTools (rebuildBinaries = true):Void {
		
		var openflDirectory = Haxelib.getPath (new Haxelib ("openfl"), true);
		var scriptsDirectory = Path.combine (openflDirectory, "scripts");
		
		System.runCommand (scriptsDirectory, "haxe", [ "tools.hxml" ]);
		
	}
	
	
}