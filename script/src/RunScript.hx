import haxe.io.Eof;
import haxe.Http;
import haxe.io.Path;
import haxe.Json;
import neko.Lib;
import project.Architecture;
import project.Haxelib;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;
import helpers.FileHelper;
import helpers.PathHelper;
import helpers.PlatformHelper;


class RunScript {
	
	
	private static var isLinux:Bool;
	private static var isMac:Bool;
	private static var isWindows:Bool;
	private static var nmeDirectory:String;
	private static var openFLDirectory:String;
	private static var openFLNativeDirectory:String;
	private static var nmeFilters:Array <String> = [ "obj", ".git", ".gitignore", ".svn", ".DS_Store", "all_objs", "Export", "tools", "project" ];
	
	
	private static function build (path:String = "", targets:Array<String> = null, flags:Map <String, String> = null, defines:Array<String> = null):Void {
		
		if (path == "") {
			
			path = nmeDirectory + "/project";
			
		}
		
		if (targets == null) {
			
			targets = [];
			
			if (isWindows) {
				
				targets.push ("windows");
				
			} else if (isLinux) {
				
				targets.push ("linux");
				
			} else if (isMac) {
				
				targets.push ("mac");
				
			}
			
		}
		
		if (flags == null) {
			
			flags = new Map <String, String> ();
			
		}
		
		if (flags.exists ("clean")) {
			
			targets.unshift ("clean");
			
		}
		
		for (target in targets) {
			
			if (target == "tools") {
				
				var toolsDirectory = PathHelper.getHaxelib (new Haxelib("openfl-tools"));
				
				runCommand (toolsDirectory, "haxe", [ "build.hxml" ]);
				
				FileHelper.copyIfNewer (PathHelper.combine (openFLNativeDirectory, "ndll/Windows/nme.ndll"), PathHelper.combine (toolsDirectory, "ndll/Windows/nme.ndll"));
				FileHelper.copyIfNewer (PathHelper.combine (openFLNativeDirectory, "ndll/Mac/nme.ndll"), PathHelper.combine (toolsDirectory, "ndll/Mac/nme.ndll"));
				FileHelper.copyIfNewer (PathHelper.combine (openFLNativeDirectory, "ndll/Mac64/nme.ndll"), PathHelper.combine (toolsDirectory, "ndll/Mac64/nme.ndll"));
				FileHelper.copyIfNewer (PathHelper.combine (openFLNativeDirectory, "ndll/Linux/nme.ndll"), PathHelper.combine (toolsDirectory, "ndll/Linux/nme.ndll"));
				FileHelper.copyIfNewer (PathHelper.combine (openFLNativeDirectory, "ndll/Linux64/nme.ndll"), PathHelper.combine (toolsDirectory, "ndll/Linux64/nme.ndll"));
				
			} else if (target == "clean") {
				
				var directories = [ PathHelper.combine (path, "obj") ];
				var files = [ PathHelper.combine (path, "all_objs"), PathHelper.combine (path, "vc100.pdb"), PathHelper.combine (path, "vc110.pdb") ];
				
				for (directory in directories) {
					
					removeDirectory (directory);
					
				}
				
				for (file in files) {
					
					if (FileSystem.exists (file)) {
						
						FileSystem.deleteFile (file);
						
					}
					
				}
				
			} else {
				
				if (target == "all") {
					
					runCommand (PathHelper.getHaxelib (new Haxelib ("nmedev")), "haxe", [ "build.hxml" ]);
					
					if (isWindows) {
						
						buildLibrary ("windows", flags, defines, path);
						
					} else if (isLinux) {
						
						buildLibrary ("linux", flags, defines, path);
						//buildLibrary ("linux", flags, defines.concat ([ "rpi" ]));
						
					} else if (isMac) {
						
						buildLibrary ("mac", flags, defines, path);
						buildLibrary ("ios", flags, defines, path);
						
					}
					
					buildLibrary ("android", flags, defines, path);
					buildLibrary ("blackberry", flags, defines, path);
					buildLibrary ("emscripten", flags, defines, path);
					buildLibrary ("webos", flags, defines, path);
					
					buildDocumentation ();
					
				} else if (target == "documentation") {
					
					buildDocumentation ();
					
				} else {
					
					buildLibrary (target, flags, defines, path);
					
				}
				
			}
			
		}
		
	}
	
	
	static private function buildDocumentation ():Void {
		
		if (isWindows) {
			
			//runCommand (nmeDirectory + "/tools/documentation", "haxe", [ "compile-win.hxml" ]);
			
		} else {
			
			//runCommand (nmeDirectory + "/tools/documentation", "haxe", [ "compile.hxml" ]);
			
		}
		
	}
	
	
	static private function buildLibrary (target:String, flags:Map <String, String> = null, defines:Array<String> = null, path:String = ""):Void {
		
		if (flags == null) {
			
			flags = new Map <String, String> ();
			
		}
		
		if (defines == null) {
			
			defines = [];
			
		}
		
		if (path == "") {
			
			path = nmeDirectory + "/project";
			
		}
		
		// The -Ddebug directive creates a debug build of the library, but the -Dfulldebug directive
		// will create a debug library using the ".debug" suffix on the file name, so both the release
		// and debug libraries can exist in the same directory
		
		switch (target) {
			
			case "android":
				
				//mkdir (PathHelper.combine (path, "../ndll/Android"));
				
				if (!flags.exists ("debug")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dandroid" ].concat (defines));
					synchronizeNDLL ("Android/libnme.so");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dandroid", "-DHXCPP_ARMV7", "-DHXCPP_ARM7" ].concat (defines));
					synchronizeNDLL ("Android/libnme-7.so");
					
				}
				
				if (!flags.exists ("release")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dandroid", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("Android/libnme-debug.so");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dandroid", "-DHXCPP_ARMV7", "-DHXCPP_ARM7", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("Android/libnme-debug-7.so");
					
				}
			
			case "blackberry":
				
				//mkdir (nmeDirectory + "/ndll/BlackBerry");
				
				if (!flags.exists ("debug")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dblackberry" ].concat (defines));
					synchronizeNDLL ("BlackBerry/nme.so");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dblackberry", "-Dsimulator" ].concat (defines));
					synchronizeNDLL ("BlackBerry/nme-x86.so");
					
				}
				
				if (!flags.exists ("release")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dblackberry", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("BlackBerry/nme-debug.so");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dblackberry", "-Dsimulator", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("BlackBerry/nme-debug-x86.so");
					
				}
			
			case "emscripten":
				
				if (!flags.exists ("debug")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Demscripten" ].concat (defines));
					synchronizeNDLL ("Emscripten/nme.a");
					
				}
				
				if (!flags.exists ("release")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Demscripten", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("Emscripten/nme-debug.a");
					
				}
			
			case "ios":
				
				//mkdir (nmeDirectory + "/ndll/iPhone");
				
				if (!flags.exists ("debug")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Diphoneos" ].concat (defines));
					synchronizeNDLL ("iPhone/libnme.iphoneos.a");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Diphoneos", "-DHXCPP_ARMV7" ].concat (defines));
					synchronizeNDLL ("iPhone/libnme.iphoneos-v7.a");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Diphonesim" ].concat (defines));
					synchronizeNDLL ("iPhone/libnme.iphonesim.a");
					
				}
				
				if (!flags.exists ("release")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Diphoneos", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("iPhone/libnme-debug.iphoneos.a");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Diphoneos", "-DHXCPP_ARMV7", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("iPhone/libnme-debug.iphoneos-v7.a");
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Diphonesim", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("iPhone/libnme-debug.iphonesim.a");
					
				}
			
			case "linux":
				
				if (!flags.exists ("rpi")) {
					
					if (!flags.exists ("32") && isRunning64 ()) {
						
						//mkdir (nmeDirectory + "/ndll/Linux64");
						
						if (!flags.exists ("debug")) {
							
							runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-DHXCPP_M64" ].concat (defines));
							synchronizeNDLL ("Linux64/nme.ndll");
							
						}
						
						if (!flags.exists ("release")) {
							
							runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-DHXCPP_M64", "-Dfulldebug" ].concat (defines));
							synchronizeNDLL ("Linux64/nme-debug.ndll");
							
						}
						
					}
					
					//mkdir (nmeDirectory + "/ndll/Linux");
					
					if (!flags.exists ("64")) {
						
						if (!flags.exists ("debug")) {
							
							runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml" ].concat (defines));
							synchronizeNDLL ("Linux/nme.ndll");
							
						}
						
						if (!flags.exists ("release")) {
							
							runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dfulldebug" ].concat (defines));
							synchronizeNDLL ("Linux/nme-debug.ndll");
							
						}
						
					}
					
				} else {
					
					//mkdir (nmeDirectory + "/ndll/RPi");
					
					if (!flags.exists ("debug")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Drpi" ].concat (defines));
						synchronizeNDLL ("RPi/nme.ndll");
						
					}
					
					if (!flags.exists ("release")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Drpi", "-Dfulldebug" ].concat (defines));
						synchronizeNDLL ("RPi/nme-debug.ndll");
						
					}
					
				}
			
			case "mac":
				
				//mkdir (nmeDirectory + "/ndll/Mac");
				
				if (!flags.exists ("64")) {
					
					if (!flags.exists ("debug")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-DHXCPP_CLANG" ].concat (defines));
						synchronizeNDLL ("Mac/nme.ndll");
						
					}
					
					if (!flags.exists ("release")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-DHXCPP_CLANG", "-Dfulldebug" ].concat (defines));
						synchronizeNDLL ("Mac/nme-debug.ndll");
						
					}
					
				}
				
				if (!flags.exists ("32")) {
					
					if (!flags.exists ("debug")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-DHXCPP_CLANG", "-DHXCPP_M64" ].concat (defines));
						synchronizeNDLL ("Mac64/nme.ndll");
						
					}
					
					if (!flags.exists ("release")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-DHXCPP_CLANG", "-DHXCPP_M64", "-Dfulldebug" ].concat (defines));
						synchronizeNDLL ("Mac64/nme-debug.ndll");
						
					}
					
				}
			
			case "webos":
				
				//mkdir (nmeDirectory + "/ndll/webOS");
				
				if (!flags.exists ("debug")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dwebos" ].concat (defines));
					synchronizeNDLL ("webOS/nme.so");
					
				}
				
				if (!flags.exists ("release")) {
					
					runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dwebos", "-Dfulldebug" ].concat (defines));
					synchronizeNDLL ("webOS/nme-debug.ndll");
					
				}
			
			case "windows":
				
				//mkdir (nmeDirectory + "/ndll/Windows");
				
				if (!flags.exists ("winrt")) {
					
					if (Sys.environment ().exists ("VS110COMNTOOLS") && Sys.environment ().exists ("VS100COMNTOOLS")) {
						
						Sys.putEnv ("HXCPP_MSVC", Sys.getEnv ("VS100COMNTOOLS"));
						
					}
					
					if (!flags.exists ("debug")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml" ].concat (defines));
						synchronizeNDLL ("Windows/nme.ndll");
						
					}
					
					if (!flags.exists ("release")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dfulldebug" ].concat (defines));
						synchronizeNDLL ("Windows/nme-debug.ndll");
						
					}
					
				}
				
				if (Sys.environment ().exists ("VS110COMNTOOLS") && !flags.exists ("win32")) {
					
					Sys.putEnv ("HXCPP_MSVC", Sys.getEnv ("VS110COMNTOOLS"));
					
					var conflictingFiles = [ PathHelper.combine (path, "obj/lib/nme-debug.pdb") ];
					
					for (file in conflictingFiles) {
						
						if (FileSystem.exists (file)) {
							
							FileSystem.deleteFile (file);
							
						}
						
					}
					
					if (!flags.exists ("debug")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dwinrt" ].concat (defines));
						synchronizeNDLL ("WinRT/nme.ndll");
						
					}
				
					if (!flags.exists ("release")) {
						
						runCommand (path, "haxelib", [ "run", "hxcpp", "Build.xml", "-Dfulldebug", "-Dwinrt" ].concat (defines));
						synchronizeNDLL ("WinRT/nme-debug.ndll");
						
					}
					
				}
			
		}
		
	}
	
	
	private static function downloadFile (remotePath:String, localPath:String) {
		
		var out = File.write (localPath, true);
		var progress = new Progress (out);
		var h = new Http (remotePath);
		
		h.onError = function (e) {
			progress.close();
			FileSystem.deleteFile (localPath);
			throw e;
		};
		
		h.customRequest (false, progress);
		
	}
	
	
	public static function error (message:String = "", e:Dynamic = null):Void {
		
		if (message != "") {
			
			if (nme_error_output == null) {
				
				try {
					
					nme_error_output = Lib.load ("nme", "nme_error_output", 1);
					
				} catch (e:Dynamic) {
					
					nme_error_output = Lib.println;
					
				}
				
			}
			
			try {
				
				nme_error_output ("Error: " + message + "\n");
				
			} catch (e:Dynamic) {}
			
		}
		
		if (e != null) {
			
			Lib.rethrow (e);
			
		}
		
		Sys.exit (1);
		
	}
	
	
	private static function getHostname ():String {
		
		var result = "";
		
		if (!isWindows) {
			
			var proc = new Process ("hostname", []);
			
			try {
				
				result = proc.stdout.readLine ();
				
			} catch (e:Dynamic) { };
			
			proc.close();
			
		}
		
		return result;
		
	}
	
	
	private static function getRevision ():String {
		
		var nmeVersion = getVersion ();
		var result = nmeVersion + "-r0";
		
		if (FileSystem.exists (openFLNativeDirectory + "/.git")) {
			
			var cacheCwd = Sys.getCwd ();
			Sys.setCwd (openFLNativeDirectory);
			
			var proc = new Process ("git", [ "describe", "--tags" ]);
			
			try {
				
				var description = proc.stdout.readLine ();
				result = nmeVersion + description.substr (description.indexOf ("-"));
				
			} catch (e:Dynamic) { };
			
			proc.close();
			Sys.setCwd (cacheCwd);
			
		} else if (FileSystem.exists (openFLNativeDirectory + "/.svn")) {
			
			var cacheCwd = Sys.getCwd ();
			Sys.setCwd (openFLNativeDirectory);
			
			var proc = new Process ("svn", [ "info" ]);
			
			try {
				
				while (true) {
					
					result = proc.stdout.readLine ();
					
					var checkString = "Revision: ";
					var index = result.indexOf (checkString);
					
					if (index > -1) {
						
						result = nmeVersion + "-r" + result.substr (checkString.length);
						break;
						
					}
					
				}
				
			} catch (e:Dynamic) { };
			
			proc.close();
			Sys.setCwd (cacheCwd);
			
		}
		
		return result;
		
	}
	
	
	private static function getVersion (library:String = "openfl-native", haxelibFormat:Bool = false):String {
		
		var libraryPath = openFLNativeDirectory;
		
		if (library != "openfl-native") {
			
			libraryPath = PathHelper.getHaxelib (new Haxelib(library));
			
		}
		
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
	
	
	public static function isRunning64 ():Bool {
		
		if (Sys.systemName () == "Linux") {
			
			var proc = new Process ("uname", [ "-m" ]);
			var result = "";
			
			try {
				
				while (true) {
					
					var line = proc.stdout.readLine ();
					
					if (line.substr (0,1) != "-") {
						
						result = line;
						break;
						
					}
					
				}
				
			} catch (e:Dynamic) { };
			
			proc.close();
			
			return result == "x86_64";
			
		} else {
			
			return false;
			
		}
		
	}
	
	
	public static function mkdir (directory:String):Void {
		
		directory = StringTools.replace (directory, "\\", "/");
		var total = "";
		
		if (directory.substr (0, 1) == "/") {
			
			total = "/";
			
		}
		
		var parts = directory.split("/");
		var oldPath = "";
		
		if (parts.length > 0 && parts[0].indexOf (":") > -1) {
			
			oldPath = Sys.getCwd ();
			Sys.setCwd (parts[0] + "\\");
			parts.shift ();
			
		}
		
		for (part in parts) {
			
			if (part != "." && part != "") {
				
				if (total != "") {
					
					total += "/";
					
				}
				
				total += part;
				
				if (!FileSystem.exists (total)) {
					
					//print("mkdir " + total);
					
					FileSystem.createDirectory (total);
					
				}
				
			}
			
		}
		
		if (oldPath != "") {
			
			Sys.setCwd (oldPath);
			
		}
		
	}
	
	
	private static function param (name:String, ?passwd:Bool):String {
		
		Sys.print (name + ": ");
		
		if (passwd) {
			var s = new StringBuf ();
			var c;
			while ((c = Sys.getChar(false)) != 13)
				s.addChar (c);
			Sys.print ("");
			return s.toString ();
		}
		
		try {
			
			return Sys.stdin ().readLine ();
			
		} catch (e:Eof) {
			
			return "";
			
		}
		
	}
	
	
	private static function removeDirectory (directory:String):Void {
		
		if (FileSystem.exists (directory)) {
			
			for (file in FileSystem.readDirectory (directory)) {
				
				var path = directory + "/" + file;
				
				if (FileSystem.isDirectory (path)) {
					
					removeDirectory (path);
					
				} else {
					
					FileSystem.deleteFile (path);
					
				}
				
			}
			
			FileSystem.deleteDirectory (directory);
			
		}
		
	}
	

	public static function runCommand (path:String, command:String, args:Array<String>, throwErrors:Bool = true):Int {
		
		var oldPath:String = "";
		
		if (path != null && path != "") {
			
			//trace ("cd " + path);
			
			oldPath = Sys.getCwd ();
			Sys.setCwd (path);
			
		}
		
		//trace (command + (args==null ? "": " " + args.join(" ")) );
		
		var result:Dynamic = Sys.command (command, args);
		
		//if (result == 0)
		//	trace("Ok.");
			
		
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
		
		nmeDirectory = PathHelper.getHaxelib (new Haxelib ("nme"), false);
		openFLDirectory = PathHelper.getHaxelib (new Haxelib ("openfl"), true);
		openFLNativeDirectory = PathHelper.getHaxelib (new Haxelib ("openfl-native"), false);
		
		if (new EReg ("window", "i").match (Sys.systemName ())) {
			
			isLinux = false;
			isMac = false;
			isWindows = true;
			
		} else if (new EReg ("linux", "i").match (Sys.systemName ())) {
			
			isLinux = true;
			isMac = false;
			isWindows = false;
			
		} else if (new EReg ("mac", "i").match (Sys.systemName ())) {
			
			isLinux = false;
			isMac = true;
			isWindows = false;
			
		}
		
		var args = Sys.args ();
		var command = args[0];
		
		if (command == "rebuild" || command == "release") {
			
			// When the command-line tools are called from haxelib, 
			// the last argument is the project directory and the
			// path to NME is the current working directory 
			
			var lastArgument = new Path (args[args.length - 1]).toString ();
			
			if (((StringTools.endsWith (lastArgument, "/") && lastArgument != "/") || StringTools.endsWith (lastArgument, "\\")) && !StringTools.endsWith (lastArgument, ":\\")) {
				
				lastArgument = lastArgument.substr (0, lastArgument.length - 1);
				
			}
			
			if (FileSystem.exists (lastArgument) && FileSystem.isDirectory (lastArgument)) {
				
				Sys.setCwd (lastArgument);
				args.pop ();
				
			}
			
			var targets:Array <String> = null;
			var flags = new Map <String, String> ();
			var ignoreLength = 0;
			var defines = [];
			
			for (arg in args) {
				
				if (StringTools.startsWith (arg, "-D")) {
					
					defines.push (arg);
					ignoreLength++;
					
				} else if (StringTools.startsWith (arg, "-")) {
					
					flags.set (arg.substr (1), "");
					ignoreLength++;
					
				}
				
			}
			
			var path = "";
			
			if (args.length == 2 + ignoreLength) {
				
				if (FileSystem.exists (PathHelper.tryFullPath ("include.nmml"))) {
					
					path = PathHelper.tryFullPath ("project");
					
				} else {
					
					if (!FileSystem.exists (nmeDirectory + "/project")) {
						
						//Sys.println ("This command must be run from a development checkout of NME");
						//return;
						
					}
					
					path = nmeDirectory + "/project";
					
				}
				
				targets = args[1].split (",");
				
			} else if (args.length > 2 + ignoreLength) {
				
				path = args[1];
				targets = args[2].split (",");
				
				if (((StringTools.endsWith (path, "/") && path != "/") || StringTools.endsWith (path, "\\")) && !StringTools.endsWith (path, ":\\")) {
					
					path = path.substr (0, path.length - 1);
					
				}
				
				if (!FileSystem.exists (path)) {
					
					if (FileSystem.exists (PathHelper.tryFullPath (path))) {
						
						path = PathHelper.combine (PathHelper.tryFullPath (path), "project");
						
					} else {
						
						path = PathHelper.combine (PathHelper.getHaxelib (new Haxelib (path)), "project");
						
					}
					
				} else {
					
					if (FileSystem.isDirectory (path)) {
						
						path = PathHelper.combine (path, "project");
						
					} else {
						
						path = PathHelper.combine (Path.directory (path), "project");
						
					}
					
				}
				
			}
			
			switch (command) {
				
				case "rebuild":
					
					if (path != nmeDirectory + "/project" && !flags.exists ("debug")) {
						
						flags.set ("release", "");
						
					}
					
					build (path, targets, flags, defines);
				
				case "release":
					
					release (targets);
					
			}
			
		} else {
			
			if (command == "setup") {
				
				var toolsDirectory = PathHelper.getHaxelib (new Haxelib ("openfl-tools"));
				
				if (toolsDirectory == null || toolsDirectory == "" || toolsDirectory.indexOf ("is not installed") > -1) {
					
					Sys.command ("haxelib install openfl-tools");
					
				}
				
			}
			
			var flags = new Map <String, String> ();
			
			for (i in 0...args.length) {
				
				var arg = args[i];
				
				switch (arg.substr (1)) {
					
					case "rebuild", "clean", "32", "64":
						
						flags.set (arg.substr (1), "");
					
					case "d", "debug":
						
						flags.set ("debug", "");
					
					default:
						
						if (arg.indexOf ("--macro") == 0) {
							
							args[i] = '"' + arg +  '"';
							
						}
					
				}
				
			}
			
			if (flags.exists ("rebuild")) {
				
				var target = "";
				
				for (i in 1...args.length) {
					
					switch (args[i]) {
						
						case "cpp", "neko":
							
							target = Std.string (PlatformHelper.hostPlatform).toLowerCase ();
							continue;
							
						case "windows", "mac", "linux", "emscripten", "ios", "android", "blackberry", "webos":
							
							target = args[i];
							continue;
							
						default:
						
					}
					
				}
				
				if (target == "windows") {
					
					flags.set ("win32", "");
					
				} else if (target == "linux") {
					
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
				
				build ("", [ target, "tools" ], flags);
				
			}
			
			var workingDirectory = args.pop ();
			var args = [ "run", "openfl-tools", "-Dopenfl" ].concat (args);
			
			Sys.exit (runCommand (workingDirectory, "haxelib", args));
			
		}
		
	}
	
	
	public static function recursiveCopy (source:String, destination:String, ignore:Array <String> = null) {
		
		if (ignore == null) {
			
			ignore = [];
			
		}
		
		mkdir (destination);
		
		var files = FileSystem.readDirectory (source);
		
		for (file in files) {
			
			var ignoreFile = false;
			
			for (ignoreName in ignore) {
				
				if (StringTools.endsWith (ignoreName, "/")) {
					
					if (FileSystem.isDirectory (source + "/" + file) && file == ignoreName.substr (0, file.length - 1)) {
						
						ignoreFile = true;
						
					}
					
				} else if (file == ignoreName || StringTools.endsWith (source + "/" + file, "/" + ignoreName)) {
					
					ignoreFile = true;
					
				}
				
			}
			
			if (!ignoreFile) {
				
				var itemDestination:String = destination + "/" + file;
				var itemSource:String = source + "/" + file;
				
				if (FileSystem.isDirectory (itemSource)) {
					
					recursiveCopy (itemSource, itemDestination, ignore);
					
				} else {
					
					Sys.println ("Copying " + itemSource);
					File.copy (itemSource, itemDestination);
					
				}
				
			}
			
		}
		
	}
	
	
	private static function release (targets:Array<String> = null):Void {
		
		if (targets == null) {
			
			targets = [ "zip" ];
			
		}
		
		for (target in targets) {
			
			switch (target) {
				
				case "upload":
					
					var user = param ("FTP username");
					var password = param ("FTP password", true);
					
					if (isWindows) {
						
						runCommand (openFLDirectory, "script\\upload-build.bat", [ user, password, openFLNativeDirectory, "Windows/nme.ndll" ]);
						runCommand (openFLDirectory, "script\\upload-build.bat", [ user, password, openFLNativeDirectory, "Windows/nme-debug.ndll" ]);
						
						if (Sys.environment ().exists ("VS110COMNTOOLS")) {
							
							//runCommand (nmeDirectory, "tools\\run-script\\upload-build.bat", [ user, password, openFLNativeDirectory, "WinRTx64/nme.ndll" ]);
							//runCommand (nmeDirectory, "tools\\run-script\\upload-build.bat", [ user, password, openFLNativeDirectory, "WinRTx64/nme-debug.ndll" ]);
							runCommand (openFLDirectory, "script\\upload-build.bat", [ user, password, openFLNativeDirectory, "WinRTx86/nme.ndll" ]);
							runCommand (openFLDirectory, "script\\upload-build.bat", [ user, password, openFLNativeDirectory, "WinRTx86/nme-debug.ndll" ]);
							
						}
						
					} else if (isLinux) {
						
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "Linux/nme.ndll" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "Linux/nme-debug.ndll" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "Linux64/nme.ndll" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "Linux64/nme-debug.ndll" ]);
						
					} else if (isMac) {
						
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "Mac/nme.ndll" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "Mac/nme-debug.ndll" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "iPhone/libnme.iphoneos.a" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "iPhone/libnme.iphoneos-v7.a" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "iPhone/libnme.iphonesim.a" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "iPhone/libnme-debug.iphoneos.a" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "iPhone/libnme-debug.iphoneos-v7.a" ]);
						runCommand (openFLDirectory, "script/upload-build.sh", [ user, password, openFLNativeDirectory, "iPhone/libnme-debug.iphonesim.a" ]);
						
					}
				
				case "download":
					
					if (!isWindows) {
						
						downloadFile ("http://www.nme.io/builds/ndll/Windows/nme.ndll", openFLNativeDirectory + "/ndll/Windows/nme.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/Windows/nme-debug.ndll", openFLNativeDirectory + "/ndll/Windows/nme-debug.ndll");
						//downloadFile ("http://www.nme.io/builds/ndll/WinRTx64/nme.ndll", nmeDirectory + "/ndll/WinRTx64/nme.ndll");
						//downloadFile ("http://www.nme.io/builds/ndll/WinRTx64/nme-debug.ndll", nmeDirectory + "/ndll/WinRTx64/nme-debug.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/WinRTx86/nme.ndll", openFLNativeDirectory + "/ndll/WinRTx86/nme.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/WinRTx86/nme-debug.ndll", openFLNativeDirectory + "/ndll/WinRTx86/nme-debug.ndll");
						
					}
					
					if (!isLinux) {
						
						downloadFile ("http://www.nme.io/builds/ndll/Linux/nme.ndll", openFLNativeDirectory + "/ndll/Linux/nme.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/Linux/nme-debug.ndll", openFLNativeDirectory + "/ndll/Linux/nme-debug.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/Linux64/nme.ndll", openFLNativeDirectory + "/ndll/Linux64/nme.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/Linux64/nme-debug.ndll", openFLNativeDirectory + "/ndll/Linux64/nme-debug.ndll");
						
					}
					
					if (!isMac) {
						
						downloadFile ("http://www.nme.io/builds/ndll/Mac/nme.ndll", openFLNativeDirectory + "/ndll/Mac/nme.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/Mac/nme-debug.ndll", openFLNativeDirectory + "/ndll/Mac/nme-debug.ndll");
						downloadFile ("http://www.nme.io/builds/ndll/iPhone/libnme.iphoneos.a", openFLNativeDirectory + "/ndll/iPhone/libnme.iphoneos.a");
						downloadFile ("http://www.nme.io/builds/ndll/iPhone/libnme.iphoneos-v7.a", openFLNativeDirectory + "/ndll/iPhone/libnme.iphoneos-v7.a");
						downloadFile ("http://www.nme.io/builds/ndll/iPhone/libnme.iphonesim.a", openFLNativeDirectory + "/ndll/iPhone/libnme.iphonesim.a");
						downloadFile ("http://www.nme.io/builds/ndll/iPhone/libnme-debug.iphoneos.a", openFLNativeDirectory + "/ndll/iPhone/libnme-debug.iphoneos.a");
						downloadFile ("http://www.nme.io/builds/ndll/iPhone/libnme-debug.iphoneos-v7.a", openFLNativeDirectory + "/ndll/iPhone/libnme-debug.iphoneos-v7.a");
						downloadFile ("http://www.nme.io/builds/ndll/iPhone/libnme-debug.iphonesim.a", openFLNativeDirectory + "/ndll/iPhone/libnme-debug.iphonesim.a");
						
					}
					
				case "zip":
					
					var tempPath = "../openfl-native-release-zip";
					var targetPath = "";
					
					targetPath = "../openfl-native-" + getRevision () + ".zip";
					
					recursiveCopy (openFLNativeDirectory, openFLNativeDirectory + tempPath + "/openfl-native", nmeFilters);
					
					if (FileSystem.exists (openFLNativeDirectory + targetPath)) {
						
						FileSystem.deleteFile (openFLNativeDirectory + targetPath);
						
					}
					
					if (!isWindows) {
						
						runCommand (openFLNativeDirectory + tempPath, "zip", [ "-r", targetPath, "*" ]);
						removeDirectory (openFLNativeDirectory + tempPath);
						
					}
				
				case "installer":
					
					var hxcppPath = PathHelper.getHaxelib (new Haxelib ("hxcpp"));
					var nmePath = PathHelper.getHaxelib (new Haxelib ("nme"));
					var swfPath = PathHelper.getHaxelib (new Haxelib ("swf"));
					var actuatePath = PathHelper.getHaxelib (new Haxelib ("actuate"));
					var svgPath = PathHelper.getHaxelib (new Haxelib ("svg"));
					
					var hxcppVersion = getVersion ("hxcpp", true);
					var nmeVersion = getVersion ("nme", true);
					var swfVersion = getVersion ("swf", true);
					var actuateVersion = getVersion ("actuate", true);
					var svgVersion = getVersion ("svg", true);
					
					var tempPath = "../nme-release-installer";
					
					if (isMac) {
						
						//var targetPath = "../NME-" + getVersion () + "-Mac-" + getRevision () + ".mpkg";
						
						var haxePath = "/usr/lib/haxe";
						var nekoPath = "/usr/lib/neko";
						
						removeDirectory (nmeDirectory + tempPath);
						recursiveCopy (nmeDirectory + "/tools/installer/mac", nmeDirectory + tempPath, [ ]);
						
						recursiveCopy (haxePath, nmeDirectory + tempPath + "/resources/haxe/usr/lib/haxe", [ "lib" ]);
						recursiveCopy (nekoPath, nmeDirectory + tempPath + "/resources/haxe/usr/lib/neko", []);
						
						recursiveCopy (hxcppPath, nmeDirectory + tempPath + "/resources/hxcpp/usr/lib/haxe/lib/hxcpp/" + hxcppVersion, [ "obj", "all_objs", ".git", ".svn" ]);
						recursiveCopy (nmePath, nmeDirectory + tempPath + "/resources/nme/usr/lib/haxe/lib/nme/" + nmeVersion, nmeFilters);
						recursiveCopy (nmePath + "/tools/project", nmeDirectory + tempPath + "/resources/nme/usr/lib/haxe/lib/nme/" + nmeVersion + "/tools/project");
						recursiveCopy (swfPath, nmeDirectory + tempPath + "/resources/swf/usr/lib/haxe/lib/swf/" + swfVersion, [ ".git", ".svn" ]);
						recursiveCopy (actuatePath, nmeDirectory + tempPath + "/resources/actuate/usr/lib/haxe/lib/actuate/" + actuateVersion, [ ".git", ".svn" ]);
						recursiveCopy (svgPath, nmeDirectory + tempPath + "/resources/svg/usr/lib/haxe/lib/svg/" + svgVersion, [ ".git", ".svn" ]);
						
						File.saveContent (nmeDirectory + tempPath + "/resources/hxcpp/usr/lib/haxe/lib/hxcpp/.current", getVersion ("hxcpp"));
						File.saveContent (nmeDirectory + tempPath + "/resources/nme/usr/lib/haxe/lib/nme/.current", getVersion ("nme"));
						File.saveContent (nmeDirectory + tempPath + "/resources/swf/usr/lib/haxe/lib/swf/.current", getVersion ("swf"));
						File.saveContent (nmeDirectory + tempPath + "/resources/actuate/usr/lib/haxe/lib/actuate/.current", getVersion ("actuate"));
						File.saveContent (nmeDirectory + tempPath + "/resources/svg/usr/lib/haxe/lib/svg/.current", getVersion ("svg"));
						
						runCommand (nmeDirectory + tempPath, "chmod", [ "+x", "./prep.sh" ]);
						runCommand (nmeDirectory + tempPath, "./prep.sh", [ ]);
						
						runCommand (nmeDirectory + tempPath, "/Applications/PackageMaker.app/Contents/MacOS/PackageMaker", [ nmeDirectory + tempPath + "/Installer.pmdoc" ]);
						removeDirectory (nmeDirectory + tempPath);
						
					} else if (isWindows) {
						
						var haxePath = "C:\\Motion-Twin\\haxe";
						var nekoPath = "C:\\Motion-Twin\\neko";
						
						removeDirectory (nmeDirectory + tempPath);
						recursiveCopy (nmeDirectory + "/tools/installer/windows", nmeDirectory + tempPath, []);
						
						recursiveCopy (haxePath, nmeDirectory + tempPath + "/resources/haxe", [ "lib" ]);
						recursiveCopy (nekoPath, nmeDirectory + tempPath + "/resources/neko", []);
						
						recursiveCopy (hxcppPath, nmeDirectory + tempPath + "/resources/hxcpp/" + hxcppVersion, [ "obj", "all_objs", ".git", ".svn" ]);
						recursiveCopy (nmePath, nmeDirectory + tempPath + "/resources/nme/" + nmeVersion, nmeFilters);
						recursiveCopy (nmePath + "/tools/project", nmeDirectory + tempPath + "/resources/nme/" + nmeVersion + "/tools/project");
						recursiveCopy (swfPath, nmeDirectory + tempPath + "/resources/swf/" + swfVersion, [ ".git", ".svn" ]);
						recursiveCopy (actuatePath, nmeDirectory + tempPath + "/resources/actuate/" + actuateVersion, [ ".git", ".svn" ]);
						recursiveCopy (svgPath, nmeDirectory + tempPath + "/resources/svg/" + svgVersion, [ ".git", ".svn" ]);
						
						File.saveContent (nmeDirectory + tempPath + "/resources/hxcpp/.current", getVersion ("hxcpp"));
						File.saveContent (nmeDirectory + tempPath + "/resources/nme/.current", getVersion ("nme"));
						File.saveContent (nmeDirectory + tempPath + "/resources/swf/.current", getVersion ("swf"));
						File.saveContent (nmeDirectory + tempPath + "/resources/actuate/.current", getVersion ("actuate"));
						File.saveContent (nmeDirectory + tempPath + "/resources/svg/.current", getVersion ("svg"));
						
						var args = [ "/DVERSION=" + getVersion ("nme"), "/DVERSION_FOLDER=" + nmeVersion, "/DHAXE_VERSION=2.10", "/DNEKO_VERSION=1.8.2", "/DHXCPP_VERSION=" + getVersion ("hxcpp"), "/DACTUATE_VERSION=" + getVersion ("actuate"), "/DSWF_VERSION=" + getVersion ("swf"), "/DSVG_VERSION=" + getVersion ("svg") ];
						args.push ("/DOUTPUT_PATH=../NME-" + getVersion ("nme") + "-Windows.exe");
						args.push ("Installer.nsi");
						
						Sys.putEnv ("PATH", Sys.getEnv ("PATH") + ";C:\\Program Files (x86)\\NSIS");
						
						runCommand (nmeDirectory + tempPath, "makensis", args);
						removeDirectory (nmeDirectory + tempPath);
						
					}
				
			}
			
		}
		
	}
	
	
	private static function synchronizeNDLL (path:String):Void {
		
		if (FileSystem.exists (nmeDirectory + "ndll/" + path)) {
			
			mkdir (Path.directory (PathHelper.combine (openFLNativeDirectory, "ndll/" + path)));
			File.copy (nmeDirectory + "ndll/" + path, openFLNativeDirectory + "ndll/" + path);
			
		} else if (FileSystem.exists (openFLNativeDirectory + "ndll/" + path)) {
			
			FileSystem.deleteFile (openFLNativeDirectory + "ndll/" + path);
			
		}
		
	}
	
	
	private static var nme_error_output;
	
	
}


class Progress extends haxe.io.Output {

	var o : haxe.io.Output;
	var cur : Int;
	var max : Int;
	var start : Float;

	public function new(o) {
		this.o = o;
		cur = 0;
		start = haxe.Timer.stamp();
	}

	function bytes(n) {
		cur += n;
		if( max == null )
			Lib.print(cur+" bytes\r");
		else
			Lib.print(cur+"/"+max+" ("+Std.int((cur*100.0)/max)+"%)\r");
	}

	public override function writeByte(c) {
		o.writeByte(c);
		bytes(1);
	}

	public override function writeBytes(s,p,l) {
		var r = o.writeBytes(s,p,l);
		bytes(r);
		return r;
	}

	public override function close() {
		super.close();
		o.close();
		var time = haxe.Timer.stamp() - start;
		var speed = (cur / time) / 1024;
		time = Std.int(time * 10) / 10;
		speed = Std.int(speed * 10) / 10;
		Lib.print("Download complete : " + cur + " bytes in " + time + "s (" + speed + "KB/s)\n");
	}

	public override function prepare(m) {
		max = m;
	}

}
