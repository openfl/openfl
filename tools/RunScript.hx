package;


import lime.tools.helpers.LogHelper;
import lime.tools.helpers.PathHelper;
import lime.tools.helpers.ProcessHelper;
import lime.project.Haxelib;
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
		var workingDirectory = args.pop ();
		
		if (args.length > 1 && args[0] == "create") {
			
			//args[1] = "openfl:" + args[1];
			
		} else if (args.length > 0 && args[0] == "setup") {
			
			var limeDirectory = PathHelper.getHaxelib (new Haxelib ("lime"));
			
			if (limeDirectory == null || limeDirectory == "" || limeDirectory.indexOf ("is not installed") > -1) {
				
				Sys.command ("haxelib", [ "install", "lime" ]);
				
			}
			
		} else if (args.length > 0 && args[0] == "process") {
			
			if (!FileSystem.exists ("tools/tools.n")) {
				
				rebuildTools ();
				
			}
			
			Sys.exit (Sys.command ("neko", [ "tools/tools.n" ].concat (Sys.args ())));
			return;
			
		}
		
		var args = [ "run", "lime" ].concat (args);
		
		try {
			
			Sys.setCwd (workingDirectory);
			
		} catch (e:Dynamic) {
			
			LogHelper.error ("Cannot set current working directory to \"" + workingDirectory + "\"");
			
		}
		
		Sys.exit (Sys.command ("haxelib", args.concat ([ "-openfl" ])));
		
	}
	
	
	private static function rebuildTools (rebuildBinaries = true):Void {
		
		var openflDirectory = PathHelper.getHaxelib (new Haxelib ("openfl"), true);
		var toolsDirectory = PathHelper.combine (openflDirectory, "tools");
		
		ProcessHelper.runCommand (toolsDirectory, "haxe", [ "tools.hxml" ]);
		
	}
	
	
}