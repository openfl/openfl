package;


import haxe.Serializer;
import haxe.Unserializer;
import haxe.io.Path;
import haxe.rtti.Meta;
import platforms.AndroidPlatform;
import platforms.BlackBerryPlatform;
import platforms.FlashPlatform;
import platforms.HTML5Platform;
import platforms.IOSPlatform;
import platforms.IPlatformTool;
import platforms.LinuxPlatform;
import platforms.MacPlatform;
import platforms.WebOSPlatform;
import platforms.WindowsPlatform;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;
import utils.PlatformSetup;
	
	
class CommandLineTools {

	public static var nme:String;
	
	private static var additionalArguments:Array <String>;
	private static var architectures:Array <Architecture>;
	private static var command:String;
	private static var debug:Bool;
	private static var sources:Array <String>;
	private static var haxelibs:Array <Haxelib>;
	private static var haxedefs:Array <String>;
	private static var haxeflags:Array <String>;
	private static var includePaths:Array <String>;
	private static var project:NMEProject;
	private static var projectDefines:Map <String, String>;
	private static var targetFlags:Map <String, String>;
	private static var traceEnabled:Bool;
	private static var userDefines:Map <String, Dynamic>;
	private static var version:String;
	private static var words:Array <String>;
	
	
	private static function buildProject () {
		
		var project = initializeProject ();
		var platform:IPlatformTool = null;
		
		LogHelper.info ("", "Using target platform: " + project.target);
		
		switch (project.target) {
			
			case ANDROID:
				
				platform = new AndroidPlatform ();
				
			case BLACKBERRY:
				
				platform = new BlackBerryPlatform ();
			
			case IOS:
				
				platform = new IOSPlatform ();
			
			case WEBOS:
				
				platform = new WebOSPlatform ();
			
			case WINDOWS:
				
				platform = new WindowsPlatform ();
			
			case MAC:
				
				platform = new MacPlatform ();
				
			case LINUX:
				
				platform = new LinuxPlatform ();
				
			case FLASH:
				
				platform = new FlashPlatform ();
				
			case HTML5:
				
				platform = new HTML5Platform ();
			
		}
		
		var metaFields = Meta.getFields (Type.getClass (platform));
		
		if (platform != null) {
			
			var command = project.command.toLowerCase ();
			
			if (!Reflect.hasField (metaFields.display, "ignore") && (command == "display")) {
				
				platform.display (project);
				
			}
			
			if (!Reflect.hasField (metaFields.clean, "ignore") && (command == "clean" || targetFlags.exists ("clean"))) {
				
				LogHelper.info ("", "\nRunning command: CLEAN");
				platform.clean (project);
				
			}
			
			if (!Reflect.hasField (metaFields.update, "ignore") && (command == "update" || command == "build" || command == "test")) {
				
				LogHelper.info ("", "\nRunning command: UPDATE");
				platform.update (project);
				
			}
			
			if (!Reflect.hasField (metaFields.build, "ignore") && (command == "build" || command == "test")) {
				
				LogHelper.info ("", "\nRunning command: BUILD");
				platform.build (project);
				
			}
			
			if (!Reflect.hasField (metaFields.install, "ignore") && (command == "install" || command == "run" || command == "test")) {
				
				LogHelper.info ("", "\nRunning command: INSTALL");
				platform.install (project);
				
			}
		
			if (!Reflect.hasField (metaFields.run, "ignore") && (command == "run" || command == "rerun" || command == "test")) {
				
				LogHelper.info ("", "\nRunning command: RUN");
				platform.run (project, additionalArguments);
				
			}
		
			if (!Reflect.hasField (metaFields.trace, "ignore") && (command == "test" || command == "trace")) {
				
				if (traceEnabled || command == "trace") {
					
					LogHelper.info ("", "\nRunning command: TRACE");
					platform.trace (project);
					
				}
				
			}
			
		}
		
	}
	
	
	private static function createTemplate () {
		
		if (words.length > 0) {
			
			if (words[0] == "project") {
				
				var id = [ "com", "example", "project" ];
				
				if (words.length > 1) {
					
					var name = words[1];
					id = name.split (".");
					
					if (id.length < 3) {
						
						id = [ "com", "example" ].concat (id);
						
					}
					
				}
				
				var company = "Company Name";
				
				if (words.length > 2) {
					
					company = words[2];
					
				}
				
				var context:Dynamic = { };
				
				var title = id[id.length - 1];
				title = title.substr (0, 1).toUpperCase () + title.substr (1);
				
				var packageName = id.join (".").toLowerCase ();
				
				context.title = title;
				context.packageName = packageName;
				context.version = "1.0.0";
				context.company = company;
				context.file = StringTools.replace (title, " ", "");
				
				for (define in userDefines.keys ()) {
					
					Reflect.setField (context, define, userDefines.get (define));
					
				}
				
				PathHelper.mkdir (title);
				FileHelper.recursiveCopyTemplate ([ nme + "/templates/default" ], "project", title, context);
				
				if (FileSystem.exists (title + "/Project.hxproj")) {
					
					FileSystem.rename (title + "/Project.hxproj", title + "/" + title + ".hxproj");
					
				}
				
			} else if (words[0] == "extension") {
				
				var title = "Extension";
				
				if (words.length > 1) {
					
					title = words[1];
					
				}
				
				var file = StringTools.replace (title, " ", "");
				var extension = StringTools.replace (file, "-", "_");
				var className = extension.substr (0, 1).toUpperCase () + extension.substr (1);
				
				var context:Dynamic = { };
				context.file = file;
				context.extension = extension;
				context.className = className;
				context.extensionLowerCase = extension.toLowerCase ();
				context.extensionUpperCase = extension.toUpperCase ();
				
				PathHelper.mkdir (title);
				FileHelper.recursiveCopyTemplate ([ nme + "/templates/default" ], "extension", title, context);
				
				if (FileSystem.exists (title + "/Extension.hx")) {
					
					FileSystem.rename (title + "/Extension.hx", title + "/" + className + ".hx");
					
				}
				
				if (FileSystem.exists (title + "/project/common/Extension.cpp")) {
					
					FileSystem.rename (title + "/project/common/Extension.cpp", title + "/project/common/" + file + ".cpp");
					
				}
				
				if (FileSystem.exists (title + "/project/include/Extension.h")) {
					
					FileSystem.rename (title + "/project/include/Extension.h", title + "/project/include/" + file + ".h");
					
				}
				
			} else {
				
				var sampleName = words[0];
				
				if (FileSystem.exists (nme + "/samples/" + sampleName)) {
					
					PathHelper.mkdir (sampleName);
					FileHelper.recursiveCopy (nme + "/samples/" + sampleName, Sys.getCwd () + "/" + sampleName);
					
				} else {
					
					LogHelper.error ("Could not find sample project \"" + sampleName + "\"");
					
				}
				
			}
			
		} else {
			
			Sys.println ("You must specify 'project' or a sample name when using the 'create' command.");
			Sys.println ("");
			Sys.println ("Usage: ");
			Sys.println ("");
			Sys.println (" nme create project \"com.package.name\" \"Company Name\"");
			Sys.println (" nme create extension \"ExtensionName\"");
			Sys.println (" nme create SampleName");
			Sys.println ("");
			Sys.println ("");
			Sys.println ("Available samples:");
			Sys.println ("");
			
			for (name in FileSystem.readDirectory (nme + "/samples")) {
				
				if (FileSystem.isDirectory (nme + "/samples/" + name)) {
					
					Sys.println (" - " + name);
					
				}
				
			}
			
			
		}
		
	}
	
	
	private static function document ():Void {
	
	
	}
	
	
	private static function displayHelp ():Void {
		
		displayInfo ();
		
		Sys.println ("");
		Sys.println (" Usage : nme setup (target)");
		Sys.println (" Usage : nme help");
		Sys.println (" Usage : nme [clean|update|build|run|test|display] <project> (target) [options]");
		Sys.println (" Usage : nme create project <package> [options]");
		Sys.println (" Usage : nme create extension <name>");
		Sys.println (" Usage : nme create <sample>");
		Sys.println (" Usage : nme rebuild <extension> (targets)");
		//Sys.println (" Usage : nme document <project> (target)");
		//Sys.println (" Usage : nme generate <args> [options]");
		//Sys.println (" Usage : nme new file.nmml name1=value1 name2=value2 ...");
		Sys.println ("");
		Sys.println (" Commands : ");
		Sys.println ("");
		Sys.println ("  setup : Setup NME or a specific target");
		Sys.println ("  help : Show this information");
		Sys.println ("  clean : Remove the target build directory if it exists");
		Sys.println ("  update : Copy assets for the specified project/target");
		Sys.println ("  build : Compile and package for the specified project/target");
		Sys.println ("  run : Install and run for the specified project/target");
		Sys.println ("  test : Update, build and run in one command");
		Sys.println ("  display : Display information for the specified project/target");
		Sys.println ("  create : Create a new project or extension using templates");
		Sys.println ("  rebuild : Recompile native binaries for extensions");
		//Sys.println ("  document : Generate documentation using haxedoc");
		//Sys.println ("  generate : Tools to help create source code automatically");
		Sys.println ("");
		Sys.println (" Targets : ");
		Sys.println ("");
		Sys.println ("  android : Create Google Android applications");
		Sys.println ("  blackberry : Create BlackBerry applications");
		//Sys.println ("  cpp : Create application for the system you are compiling on");
		Sys.println ("  flash : Create SWF applications for Adobe Flash Player");
		Sys.println ("  html5 : Create HTML5 canvas applications");
		Sys.println ("  ios : Create Apple iOS applications");
		Sys.println ("  linux : Create Linux applications");
		Sys.println ("  mac : Create Apple Mac OS X applications");
		Sys.println ("  webos : Create HP webOS applications");
		Sys.println ("  windows : Create Microsoft Windows applications");
		Sys.println ("");
		Sys.println (" Options : ");
		Sys.println ("");
		Sys.println ("  -D : Specify a define to use when processing other commands");
		Sys.println ("  -debug : Use debug configuration instead of release");
		Sys.println ("  -verbose : Print additional information (when available)");
		Sys.println ("  -clean : Add a \"clean\" action before running the current command");
		Sys.println ("  -xml : Generate XML type information, useful for documentation");
		Sys.println ("  [windows|mac|linux] -neko : Build with Neko instead of C++");
		Sys.println ("  [linux] -64 : Compile for 64-bit instead of 32-bit");
		Sys.println ("  [android] -arm7 : Compile for arm-7a and arm5");
		Sys.println ("  [android] -arm7-only : Compile for arm-7a for testing");
		Sys.println ("  [ios|blackberry] -simulator : Build/test for the device simulator");
		Sys.println ("  [ios] -simulator -ipad : Build/test for the iPad Simulator");
		//Sys.println ("  [flash] -web : Generate web template files");
		//Sys.println ("  [flash] -chrome : Generate Google Chrome app template files");
		//Sys.println ("  [flash] -opera : Generate an Opera Widget");
		Sys.println ("  [html5] -minify : Minify output using the Google Closure compiler");
		Sys.println ("  [html5] -minify -yui : Minify output using the YUI compressor");
		Sys.println ("  (display) -hxml : Print HXML information for the project");
		Sys.println ("  (display) -nmml : Print NMML information for the project");
		//Sys.println ("  (generate) -java-externs : Generate Haxe classes from compiled Java");
		Sys.println ("  (run|test) -args a0 a1 ... : Pass remaining arguments to executable");
		
	}
	
	
	private static function displayInfo (showHint:Bool = false):Void {
		
		Sys.println ("Pazu Command-Line Tools (" + version + ")");
		
		if (showHint) {
			
			//Sys.println ("Use \"pazu setup\" to configure Pazu or \"pazu help\" for more commands");
			
		}
		
	}
	
	
	private static function findProjectFile (path:String):String {
		
		if (FileSystem.exists (PathHelper.combine (path, "Project.hx"))) {
			
			return PathHelper.combine (path, "Project.hx");
			
		} else if (FileSystem.exists (PathHelper.combine (path, "project.nmml"))) {
			
			return PathHelper.combine (path, "project.nmml");
			
		} else if (FileSystem.exists (PathHelper.combine (path, "project.xml"))) {
			
			return PathHelper.combine (path, "project.xml");
			
		} else {
			
			var files = FileSystem.readDirectory (path);
			var matches = [];
			
			for (file in files) {
				
				var path = PathHelper.combine (path, file);
				
				if (FileSystem.exists (path) && !FileSystem.isDirectory (path)) {
					
					if ((Path.extension (file) == "nmml" && file != "include.nmml") || Path.extension (file) == "hx") {
						
						matches.push (path);
						
					}
					
				}
				
			}
			
			if (matches.length > 0) {
				
				return matches[0];
				
			}
			
		}
		
		return "";
		
	}
	
	
	private static function generate ():Void {
		
		
		
	}
	
	
	private static function getBuildNumber (project:NMEProject, increment:Bool = true):Void {
		
		if (project.meta.buildNumber == "1") {
			
			var versionFile = PathHelper.combine (project.app.path, ".build");
			var version = 1;
			
			PathHelper.mkdir (project.app.path);
			
			if (FileSystem.exists (versionFile)) {
				
				var previousVersion = Std.parseInt (File.getBytes (versionFile).toString ());
				
				if (previousVersion != null) {
					
					version = previousVersion;
					
					if (increment) {
						
						version ++;
						
					}
					
				}
				
			}
			
			project.meta.buildNumber = Std.string (version);
			
			try {
				
			   var output = File.write (versionFile, false);
			   output.writeString (Std.string (version));
			   output.close ();
				
			} catch (e:Dynamic) {}
			
		}
		
	}
	
	
	public static function getHXCPPConfig ():NMEProject {
		
		var environment = Sys.environment ();
		var config = "";
		
		if (environment.exists ("HXCPP_CONFIG")) {
			
			config = environment.get ("HXCPP_CONFIG");
			
		} else {
			
			var home = "";
			
			if (environment.exists ("HOME")) {
				
				home = environment.get ("HOME");
				
			} else if (environment.exists ("USERPROFILE")) {
				
				home = environment.get ("USERPROFILE");
				
			} else {
				
				LogHelper.warn ("HXCPP config might be missing (Environment has no \"HOME\" variable)");
				
				return null;
				
			}
			
			config = home + "/.hxcpp_config.xml";
			
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
				
				config = config.split ("/").join ("\\");
				
			}
			
		}
		
		if (FileSystem.exists (config)) {
			
			LogHelper.info ("", "Reading HXCPP config: " + config);
			
			return new NMMLParser (config);
			
		} else {
			
			LogHelper.warn ("", "Could not read HXCPP config: " + config);
			
		}
		
		return null;
		
	}
	
	
	private static function getVersion ():String {
		
		for (element in Xml.parse (File.getContent (nme + "/haxelib.xml")).firstElement ().elements ()) {
			
			if (element.nodeName == "version") {
				
				return element.get ("name");
				
			}
			
		}
		
		return "";
		
	}
	
	
	#if (neko && haxe_210)
	public static function __init__ () {
		
		// Fix for library search paths
		
		var path = PathHelper.getHaxelib (new Haxelib ("nme")) + "ndll/";
		
		switch (PlatformHelper.hostPlatform) {
			
			case WINDOWS:
				
				untyped $loader.path = $array (path + "Windows/", $loader.path);
				
			case MAC:
				
				untyped $loader.path = $array (path + "Mac/", $loader.path);
				
			case LINUX:
				
				var arguments = Sys.args ();
				var raspberryPi = false;
				
				for (argument in arguments) {
					
					if (argument == "-rpi") raspberryPi = true;
					
				}
				
				if (raspberryPi) {
					
					untyped $loader.path = $array (path + "RPi/", $loader.path);
					
				} else if (PlatformHelper.hostArchitecture == Architecture.X64) {
					
					untyped $loader.path = $array (path + "Linux64/", $loader.path);
					
				} else {
					
					untyped $loader.path = $array (path + "Linux/", $loader.path);
					
				}
			
			default:
			
		}
		
	}
	#end
	
	
	private static function initializeProject ():NMEProject {
		
		LogHelper.info ("", "Initializing project...");
		
		var projectFile = "";
		var targetName = "";
		
		if (words.length == 2) {
			
			if (FileSystem.exists (words[0])) {
				
				if (FileSystem.isDirectory (words[0])) {
					
					projectFile = findProjectFile (words[0]);
					
				} else {
					
					projectFile = words[0];
					
				}
				
			}
			
			targetName = words[1].toLowerCase ();
			
		} else {
			
			projectFile = findProjectFile (Sys.getCwd ());
			targetName = words[0].toLowerCase ();
			
		}
		
		if (projectFile == "") {
			
			LogHelper.error ("You must have a \"project.nmml\" file or specify another valid project file when using the '" + command + "' command");
			return null;
			
		} else {
			
			LogHelper.info ("", "Using project file: " + projectFile);
			
		}
		
		var target = null;
		
		switch (targetName) {
			
			case "cpp":
				
				target = PlatformHelper.hostPlatform;
				targetFlags.set ("cpp", "");
				
			case "neko":
				
				target = PlatformHelper.hostPlatform;
				targetFlags.set ("neko", "");
				
			case "iphone", "iphoneos":
				
				target = Platform.IOS;
				
			case "iphonesim":
				
				target = Platform.IOS;
				targetFlags.set ("simulator", "");
			
			default:
				
				try {
					
					target = Type.createEnum (Platform, targetName.toUpperCase ());
					
				} catch (e:Dynamic) {
					
					LogHelper.error ("\"" + targetName + "\" is an unknown target");
					
				}
			
		}
		
		var config = getHXCPPConfig ();
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			if (config != null && config.environment.exists ("JAVA_HOME")) {
				
				Sys.putEnv ("JAVA_HOME", config.environment.get ("JAVA_HOME"));
				
			}
			
			if (Sys.getEnv ("JAVA_HOME") != null) {
				
				var javaPath = PathHelper.combine (Sys.getEnv ("JAVA_HOME"), "bin");
				
				if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
					
					Sys.putEnv ("PATH", javaPath + ";" + Sys.getEnv ("PATH"));
					
				} else {
					
					Sys.putEnv ("PATH", javaPath + ":" + Sys.getEnv ("PATH"));
					
				}
				
			}
			
		}
		
		NMEProject._command = command;
		NMEProject._debug = debug;
		NMEProject._target = target;
		NMEProject._targetFlags = targetFlags;
		NMEProject._templatePaths = [ nme + "/templates/default", nme + "/tools/command-line" ];
		
		try { Sys.setCwd (Path.directory (projectFile)); } catch (e:Dynamic) {}
		
		var project:NMEProject = null;
		
		if (Path.extension (projectFile) == "nmml" || Path.extension (projectFile) == "xml") {
			
			project = new NMMLParser (Path.withoutDirectory (projectFile), userDefines, includePaths);
			
		} else if (Path.extension (projectFile) == "hx") {
			
			var path = FileSystem.fullPath (Path.withoutDirectory (projectFile));
			var name = Path.withoutDirectory (Path.withoutExtension (projectFile));
			
			var tempFile = PathHelper.getTemporaryFile (".n");
			
			ProcessHelper.runCommand ("", "haxe", [ name, "-main", "NMEProject", "-neko", tempFile, "-cp", nme + "/tools/project", "-cp", nme + "/tools/helpers", "-cp", nme + "/tools/command-line", "-lib", "nme", "-lib", "xfl", "-lib", "swf", "-lib", "svg", "--remap", "flash:nme" ]);
			
			var process = new Process ("neko", [ FileSystem.fullPath (tempFile), name, NMEProject._command, Std.string (NMEProject._debug), Std.string (NMEProject._target), Serializer.run (NMEProject._targetFlags), Serializer.run (NMEProject._templatePaths) ]);
			var output = process.stdout.readAll ().toString ();
			var error = process.stderr.readAll ().toString ();
			process.exitCode ();
			process.close ();
			
			try {
				
				var unserializer = new Unserializer (output);
				unserializer.setResolver (cast { resolveEnum: Type.resolveEnum, resolveClass: resolveClass });
				project = unserializer.unserialize ();
				
			} catch (e:Dynamic) {}
			
			FileSystem.deleteFile (tempFile);
			
			if (project != null) {
				
				for (haxelib in project.haxelibs) {
					
					var path = PathHelper.getHaxelib (haxelib);
					
					if (FileSystem.exists (path + "/include.nmml")) {
						
						var includeProject = new NMMLParser (path + "/include.nmml");
						
						for (ndll in includeProject.ndlls) {
							
							if (ndll.haxelib == null) {
								
								ndll.haxelib = haxelib;
								
							}
							
						}
						
						includeProject.sources.push (path);
						project.merge (includeProject);
						
					}
					
				}
				
			}
			
		}
		
		if (project == null) {
			
			LogHelper.error ("You must have a \"project.nmml\" file or specify another NME project file when using the '" + command + "' command");
			return null;
			
		}
		
		project.command = command;
		project.debug = debug;
		project.target = target;
		project.targetFlags = targetFlags;
		project.templatePaths = project.templatePaths.concat ([ nme + "/templates/default", nme + "/tools/command-line" ]);
		
		project.merge (config);
		
		if (architectures.length > 0) {
			
			project.architectures = architectures;
			
		}
		
		project.haxeflags = project.haxeflags.concat (haxeflags);
		project.haxelibs = project.haxelibs.concat(haxelibs);
		project.sources = project.sources.concat(sources);
		
		project.haxedefs.set ("nme_install_tool", 1);
		project.haxedefs.set ("nme_ver", version);
		project.haxedefs.set ("nme" + version.split (".")[0], 1);
		
		for (haxedef in haxedefs) {

			if (!project.haxedefs.exists (haxedef)) {
				
				project.haxedefs.set (haxedef, 1);
				
			}

		}

		for (key in projectDefines.keys ()) {
			
			var components = key.split ("-");
			var field = components.shift ().toLowerCase ();
			var attribute = "";
			
			if (components.length > 0) {
				
				for (i in 1...components.length) {
					
					components[i] = components[i].substr (0, 1).toUpperCase () + components[i].substr (1).toLowerCase ();
					
				}
				
				attribute = components.join ("");
				
			}


			if (field == "template" && attribute == "path") {
						
				project.templatePaths.push (projectDefines.get (key));
						
			} else {
				
				if (Reflect.hasField (project, field)) {
					
					var fieldValue = Reflect.field (project, field);
					
					if (Reflect.hasField (fieldValue, attribute)) {
						
						if (Std.is (Reflect.field (fieldValue, attribute), String)) {
							
							Reflect.setField (fieldValue, attribute, projectDefines.get (key));
							
						} else if (Std.is (Reflect.field (fieldValue, attribute), Float)) {
							
							Reflect.setField (fieldValue, attribute, Std.parseFloat (projectDefines.get (key)));
							
						} else if (Std.is (Reflect.field (fieldValue, attribute), Bool)) {
							
							Reflect.setField (fieldValue, attribute, (projectDefines.get (key).toLowerCase () == "true" || projectDefines.get (key) == "1"));
							
						}
						
					}
					
				}
				
			}
			
		}
		
		StringMapHelper.copyKeys (userDefines, project.haxedefs);
		
		SWFHelper.preprocess (project);
		XFLHelper.preprocess (project);
		
		// Better way to do this?
		
		switch (project.target) {
			
			case ANDROID, IOS, BLACKBERRY:
				
				getBuildNumber (project);
				
			default:
			
		}
		
		return project;
		
	}
	
	
	private static function resolveClass (name:String):Class <Dynamic> {
		
		if (name.toLowerCase ().indexOf ("project") > -1) {
			
			return NMEProject;
			
		} else {
			
			return Type.resolveClass (name);
			
		}
		
	}
	
	
	public static function main ():Void {
		
		additionalArguments = new Array <String> ();
		architectures = new Array <Architecture> ();
		command = "";
		debug = false;
		sources = new Array <String> ();
		haxelibs = new Array <Haxelib> ();
		haxedefs = new Array <String> ();
		haxeflags = new Array <String> ();
		includePaths = new Array <String> ();
		projectDefines = new Map <String, String> ();
		targetFlags = new Map <String, String> ();
		traceEnabled = true;
		userDefines = new Map <String, Dynamic> ();
		words = new Array <String> ();
		
		processArguments ();
		version = getVersion ();
		
		if (LogHelper.verbose) {
			
			displayInfo ();
			Sys.println ("");
			
		}
		
		switch (command) {
			
			case "":
				
				displayInfo (true);
				
			case "help":
				
				//displayHelp ();
				
			case "setup":
				
				platformSetup ();
			
			case "document":
				
				document ();
				
			case "generate":
				
				generate ();
				
			case "create":
				
				createTemplate ();
				
			case "clean", "update", "display", "build", "run", "rerun", "install", "uninstall", "trace", "test":
				
				if (words.length < 1 || words.length > 2) {
					
					LogHelper.error ("Incorrect number of arguments for command '" + command + "'");
					return;
					
				}
				
				buildProject ();
			
			case "installer", "copy-if-newer":
				
				// deprecated?
				
			default:
				
				LogHelper.error ("'" + command + "' is not a valid command");
			
		}
		
	}
	
	
	private static function processArguments ():Void {
		
		var arguments = Sys.args ();
		
		nme = PathHelper.getHaxelib (new Haxelib ("pazu"));
		
		var lastCharacter = nme.substr ( -1, 1);
		
		if (lastCharacter == "/" || lastCharacter == "\\") {
			
			nme = nme.substr (0, -1);
			
		}

		if (arguments.length > 0) {
			
			// When the command-line tools are called from haxelib, 
			// the last argument is the project directory and the
			// path to NME is the current working directory 
			
			var lastArgument = "";
			
			for (i in 0...arguments.length) {
				
				lastArgument = arguments.pop ();
				if (lastArgument.length > 0) break;
				
			}
			
			lastArgument = new Path (lastArgument).toString ();
			
			if (((StringTools.endsWith (lastArgument, "/") && lastArgument != "/") || StringTools.endsWith (lastArgument, "\\")) && !StringTools.endsWith (lastArgument, ":\\")) {
				
				lastArgument = lastArgument.substr (0, lastArgument.length - 1);
				
			}
			
			if (FileSystem.exists (lastArgument) && FileSystem.isDirectory (lastArgument)) {
				
				Sys.setCwd (lastArgument);
				
			}
			
		}
		
		var catchArguments = false;
		var catchHaxeFlag = false;
		
		for (argument in arguments) {

			var equals = argument.indexOf ("=");
			
			if (catchHaxeFlag) {
				
				haxeflags.push (argument);
				catchHaxeFlag = false;
				
			} else if (catchArguments) {
				
				additionalArguments.push (argument);
				
			} else if (equals > 0) {

				var argValue = argument.substr (equals + 1);
				// if quotes remain on the argValue we need to strip them off
				// otherwise the compiler really dislikes the result!
				var r = ~/^['"](.*)['"]$/;
				if (r.match(argValue)) {
					argValue = r.matched(1);
				}
				
				if (argument.substr (0, 2) == "-D") {
					
					userDefines.set (argument.substr (2, equals - 2), argValue);
					
				} else if (argument.substr (0, 2) == "--") {
					
					// this won't work because it assumes there is only ever one of these.
					//projectDefines.set (argument.substr (2, equals - 2), argValue);
					
					var field = argument.substr (2, equals - 2);

					if (field == "haxedef") {

						haxedefs.push(argValue);
						
					} else if (field == "haxeflag") {
						
						haxeflags.push (argValue);
						
					} else if (field == "haxelib") {
						
						var name = argValue;
						var version = "";
						
						if (name.indexOf (":") > -1) {
							
							version = name.substr (name.indexOf (":") + 1);
							name = name.substr (0, name.indexOf (":"));
							
						}

						haxelibs.push (new Haxelib (name, version));
						
					} else if (field == "source") {
						
						sources.push (argValue);
						
					} else {

						projectDefines.set (field, argValue);
					}

				} else {
					
					userDefines.set (argument.substr (0, equals), argValue);
					
				}
				
			} else if (argument.substr (0, 4) == "-arm") {
				
				var name = argument.substr (1).toUpperCase ();
				var value = Type.createEnum (Architecture, name);
				
				if (value != null) {
					
					architectures.push (value);
					
				}
				
			} else if (argument == "-64") {
				
				architectures.push (Architecture.X64);
				
			} else if (argument == "-32") {
				
				architectures.push (Architecture.X86);
				
			} else if (argument.substr (0, 2) == "-D") {
				
				userDefines.set (argument.substr (2), "");
				
			} else if (argument.substr (0, 2) == "-l") {
				
				includePaths.push (argument.substr (2));
				
			} else if (argument == "-v" || argument == "-verbose") {
				
				LogHelper.verbose = true;
				
			} else if (argument == "-args") {
				
				catchArguments = true;
				
			} else if (argument == "-notrace") {
				
				traceEnabled = false;
				
			} else if (argument == "-debug") {
				
				debug = true;
				
			} else if (command.length == 0) {
				
				command = argument;
			
			} else if (argument.substr (0, 1) == "-") {
				
				if (argument.substr (1, 1) == "-") {
					
					haxeflags.push (argument);
					
					if (argument == "--remap" || argument == "--connect") {
						
						catchHaxeFlag = true;
						
					}
					
				} else {
					
					targetFlags.set (argument.substr (1), "");
					
				}
				
			} else {
				
				words.push (argument);
				
			}
			
		}
		
	}
	
	
	private static function platformSetup ():Void {
		
		if (words.length == 0) {
			
			PlatformSetup.run ();
			
		} else if (words.length == 1) {
			
			PlatformSetup.run (words[0]);
			
		} else {
			
			LogHelper.error ("Incorrect number of arguments for command 'setup'");
			return;
			
		}
		
	}
	
	
}
