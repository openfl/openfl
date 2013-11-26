package;


import haxe.Json;
import helpers.FileHelper;
import helpers.LogHelper;
import helpers.PathHelper;
import helpers.PlatformHelper;
import project.Architecture;
import project.Haxelib;
import sys.io.File;
import sys.FileSystem;


class RunScript {
	
	
	static private function buildDocumentation ():Void {
		
		var openFLDirectory = PathHelper.getHaxelib (new Haxelib ("openfl"), true);
		var scriptPath = PathHelper.combine (openFLDirectory, "script");
		var documentationPath = PathHelper.combine (openFLDirectory, "documentation");
		
		PathHelper.mkdir (documentationPath);
		
		runCommand (scriptPath, "haxe", [ "documentation.hxml" ]);
		
		FileHelper.copyFile (PathHelper.combine (openFLDirectory, "haxedoc.xml"), documentationPath + "/openfl.xml");
		
		runCommand (documentationPath, "haxedoc", [ "openfl.xml", "-f", "openfl", "-f", "flash" ]);
		
	}
	
	
	private static function getVersion (library:String = "openfl", haxelibFormat:Bool = false):String {
		
		//var libraryPath = openFLNativeDirectory;
		
		//if (library != "openfl-native") {
			
			var libraryPath = PathHelper.getHaxelib (new Haxelib (library));
			
		//}
		
		if (FileSystem.exists (libraryPath + "/haxelib.json")) {
			
			var json = Json.parse (File.getContent (libraryPath + "/haxelib.json"));
			var result:String = json.version;
			
			if (haxelibFormat) {
				
				return StringTools.replace (result, ".", ",");
				
			} else {
				
				return result;
				
			}
			
		} else if (FileSystem.exists (libraryPath + "/haxelib.xml")) {
			
			for (element in Xml.parse (File.getContent (libraryPath + "/haxelib.xml")).firstElement ().elements ()) {
				
				if (element.nodeName == "version") {
					
					if (haxelibFormat) {
						
						return StringTools.replace (element.get ("name"), ".", ",");
						
					} else {
						
						return element.get ("name");
						
					}
					
				}
				
			}
			
		}
		
		return "";
		
	}
	

	public static function runCommand (path:String, command:String, args:Array<String>, throwErrors:Bool = true):Int {
		
		var oldPath:String = "";
		
		if (path != null && path != "") {
			
			oldPath = Sys.getCwd ();
			
			try {
				
				Sys.setCwd (path);
				
			} catch (e:Dynamic) {
				
				LogHelper.error ("Cannot set current working directory to \"" + path + "\"");
				
			}
			
		}
		
		var result:Dynamic = Sys.command (command, args);
		
		if (oldPath != "") {
			
			Sys.setCwd (oldPath);
			
		}
		
		if (throwErrors && result != 0) {
			
			Sys.exit (1);
			//throw ("Error running: " + command + " " + args.join (" ") + " [" + path + "]");
			
		}
		
		return result;
		
	}
	
	
	public static function main () {
		
		var args = Sys.args ();
		var command = args[0];
		
		if (command == "rebuild") {
			
			var workingDirectory = args.pop ();
			var args = [ "run", "lime" ].concat (args);
			
			Sys.exit (runCommand (workingDirectory, "haxelib", args));
			
		} else {
			
			if (command == "setup") {
				
				var toolsDirectory = PathHelper.getHaxelib (new Haxelib ("hxtools"));
				
				if (toolsDirectory == null || toolsDirectory == "" || toolsDirectory.indexOf ("is not installed") > -1) {
					
					Sys.command ("haxelib install hxtools");
					
				}
				
			}
			
			var flags = new Map <String, String> ();
			var defines = new Array <String> ();
			
			for (i in 0...args.length) {
				
				var arg = args[i];
				
				switch (arg) {
					
					case "-rebuild", "-clean", "-32", "-64":
						
						flags.set (arg.substr (1), "");
					
					case "-d", "-debug":
						
						flags.set ("debug", "");
					
					default:
						
						if (arg.indexOf ("--macro") == 0) {
							
							args[i] = '"' + arg +  '"';
							
						}
						
						if (arg.indexOf ("-D") == 0) {
							
							defines.push (arg);
							
						}
					
				}
				
			}
			
			var workingDirectory = args.pop ();
			
			if (flags.exists ("rebuild")) {
				
				var target = "";
				
				for (i in 1...args.length) {
					
					switch (args[i]) {
						
						case "cpp", "neko":
							
							target = Std.string (PlatformHelper.hostPlatform).toLowerCase ();
							continue;
							
						case "windows", "mac", "linux", "emscripten", "ios", "android", "blackberry", "tizen", "webos":
							
							target = args[i];
							continue;
							
						default:
						
					}
					
				}
				
				if (target == "windows") {
					
					flags.set ("win32", "");
					
				} else if (target == "linux" || target == "mac") {
					
					if (!flags.exists ("64") && !flags.exists ("32")) {
						
						if (PlatformHelper.hostArchitecture == Architecture.X64) {
							
							flags.set ("64", "");
							
						} else {
							
							flags.set ("32", "");
							
						}
						
					}
					
				}
				
				if (!flags.exists ("debug")) {
					
					flags.set ("release", "");
					
				}
				
				var args = [ "run", "lime", "rebuild", "tools," + target ];
				
				for (define in defines) {
					
					args.push ("-D" + define);
					
				}
				
				for (flag in flags.keys ()) {
					
					args.push ("-" + flag);
					
				}
				
				runCommand (workingDirectory, "haxelib", args);
				
			}
			
			var define = "-Dopenfl";
			var version = getVersion ();
			
			if (version != null && version != "") {
				
				define += "=" + version.substr (0, 3);
				
			}
			
			var args = [ "run", "hxtools", define ].concat (args);
			Sys.exit (runCommand (workingDirectory, "haxelib", args));
			
		}
		
	}
	
	
}