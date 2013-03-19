package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;


class BlackBerryPlatform implements IPlatformTool {
	
	
	private var outputDirectory:String;
	private var outputFile:String;
	
	
	public function build (project:NMEProject):Void {
		
		initialize (project);
		
		if (project.app.main != null) {
			
			var hxml = outputDirectory + "/haxe/" + (project.debug ? "debug" : "release") + ".hxml";
			ProcessHelper.runCommand ("", "haxe", [ hxml ] );
			
		}
		
		if (!project.targetFlags.exists ("html5")) {
			
			FileHelper.copyIfNewer (outputDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : ""), outputFile);
			BlackBerryHelper.createPackage (project, outputDirectory, "bin/bar-descriptor.xml", project.meta.packageName + "_" + project.meta.version + ".bar");
			
		} else {
			
			if (project.targetFlags.exists ("minify")) {
				
				HTML5Helper.minify (project, project.app.path + "/blackberry/html5/src/" + project.app.file + ".js");
				
			}
			
			BlackBerryHelper.createWebWorksPackage (project, outputDirectory + "/src", outputDirectory + "/bin");
			
		}
		
	}
	
	
	public function clean (project:NMEProject):Void {
		
		initialize (project);
		
		if (FileSystem.exists (outputDirectory)) {
			
			PathHelper.removeDirectory (outputDirectory);
			
		}
		
	}
	
	
	public function display (project:NMEProject):Void {
		
		var hxml = "";
		var context = project.templateContext;
		
		if (!project.targetFlags.exists ("html5")) {
			
			hxml = PathHelper.findTemplate (project.templatePaths, "blackberry/hxml/" + (project.debug ? "debug" : "release") + ".hxml");
			
			context.CPP_DIR = outputDirectory + "/obj";
			
		} else {
			
			hxml = PathHelper.findTemplate (project.templatePaths, "html5/hxml/" + (project.debug ? "debug" : "release") + ".hxml");
			
			context.OUTPUT_DIR = outputDirectory;
			context.OUTPUT_FILE = outputFile;
			
		}
		
		var template = new Template (File.getContent (hxml));
		Sys.println (template.execute (context));
		
	}
	
	
	private function initialize (project:NMEProject):Void {
		
		if (!project.environment.exists ("BLACKBERRY_SETUP")) {
			
			LogHelper.error ("You need to run \"nme setup blackberry\" before you can use the BlackBerry target");
			
		}
		
		if (!project.targetFlags.exists ("html5")) {
			
			outputDirectory = project.app.path + "/blackberry/cpp";
			outputFile = outputDirectory + "/bin/" + PathHelper.safeFileName (project.app.file);
			
		} else {
			
			outputDirectory = project.app.path + "/blackberry/html5";
			outputFile = outputDirectory + "/src/" + project.app.file + ".js";
			
		}
		
		BlackBerryHelper.initialize (project);
		
	}
	
	
	public function run (project:NMEProject, arguments:Array <String>):Void {
		
		initialize (project);
		
		if (!project.targetFlags.exists ("html5")) {
			
			BlackBerryHelper.deploy (project, outputDirectory, project.meta.packageName + "_" + project.meta.version + ".bar");
			
		} else {
			
			BlackBerryHelper.deploy (project, outputDirectory + "/bin/" + (project.targetFlags.exists ("simulator") ? "simulator" : "device"), PathHelper.safeFileName (project.app.file) + ".bar");
			
		}
		
	}
	
	
	public function trace (project:NMEProject):Void {
		
		initialize (project);
		
		if (!project.targetFlags.exists ("html5")) {
			
			BlackBerryHelper.trace (project, outputDirectory, project.meta.packageName + "_" + project.meta.version + ".bar");
		
		} else {
			
			//BlackBerryHelper.trace (project, outputDirectory + "/bin/" + (project.targetFlags.exists ("simulator") ? "simulator" : "device"), PathHelper.safeFileName (project.app.file) + ".bar");
			
		}
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		project = project.clone ();
		initialize (project);
		
		if (!project.targetFlags.exists ("html5")) {
			
			for (asset in project.assets) {
				
				asset.resourceName = "app/native/" + asset.resourceName;
				
			}
			
		} else {
			
			for (asset in project.assets) {
				
				if (asset.type == AssetType.FONT) {
					
					project.haxeflags.push (HTML5Helper.generateFontData (project, asset));
					
				}
				
			}
			
			project.haxedefs.set ("html5", 1);
			
		}
		
		if (project.targetFlags.exists ("simulator")) {
			
			project.haxedefs.set ("simulator", 1);
			
		}
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + outputDirectory + "/types.xml");
			
		}
		
		var context = project.templateContext;
		var destination = outputDirectory + "/bin/";
		
		if (!project.targetFlags.exists ("html5")) {
			
			context.CPP_DIR = outputDirectory + "/obj";
			
		} else {
			
			destination = outputDirectory + "/src/";
			
			context.WIN_FLASHBACKGROUND = StringTools.hex (project.window.background);
			context.OUTPUT_DIR = outputDirectory;
			context.OUTPUT_FILE = outputFile;
			
		}
		
		context.BLACKBERRY_AUTHOR_ID = BlackBerryHelper.processDebugToken (project, project.app.path + "/blackberry").authorID;
		context.APP_FILE_SAFE = PathHelper.safeFileName (project.app.file);
		
		PathHelper.mkdir (destination);
		
		context.ICONS = [];
		context.HAS_ICON = false;
		
		for (size in [ 114, 86 ]) {
			
			if (IconHelper.createIcon (project.icons, size, size, PathHelper.combine (destination, "icon-" + size + ".png"))) {
				
				context.ICONS.push ("icon-" + size + ".png");
				context.HAS_ICON = true;
				
			}
			
		}
		
		if (!project.targetFlags.exists ("html5")) {
			
			FileHelper.copyFileTemplate (project.templatePaths, "blackberry/template/bar-descriptor.xml", destination + "/bar-descriptor.xml", context);
			FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", outputDirectory + "/haxe", context);
			FileHelper.recursiveCopyTemplate (project.templatePaths, "blackberry/hxml", outputDirectory + "/haxe", context);
			
			var arch = "";
			
			if (project.targetFlags.exists ("simulator")) {
				
				arch = "-x86";
				
			}
			
			var ndlls = project.ndlls.copy ();
			ndlls.push (new NDLL ("libTouchControlOverlay", new Haxelib ("nme")));
			
			for (ndll in ndlls) {
				
				FileHelper.copyLibrary (ndll, "BlackBerry", "", arch + ".so", destination, project.debug, ".so");
				
			}
			
			var linkedLibraries = [ new NDLL ("libSDL", new Haxelib ("nme")) ];
			
			for (ndll in linkedLibraries) {
				
				var deviceLib = ndll.name + ".so";
				var simulatorLib = ndll.name + "-x86.so";
				
				if (project.targetFlags.exists ("simulator")) {
					
					if (FileSystem.exists (destination + deviceLib)) {
						
						FileSystem.deleteFile (destination + deviceLib);
						
					}
					
					FileHelper.copyIfNewer (PathHelper.getLibraryPath (ndll, "BlackBerry", "", "-x86.so"), destination + simulatorLib);
					
				} else {
					
					if (FileSystem.exists (destination + simulatorLib)) {
						
						FileSystem.deleteFile (destination + simulatorLib);
						
					}
					
					FileHelper.copyIfNewer (PathHelper.getLibraryPath (ndll, "BlackBerry", "", ".so"), destination + deviceLib);
					
				}
				
			}
			
		} else {
			
			FileHelper.recursiveCopyTemplate (project.templatePaths, "html5/template", destination, context);
			FileHelper.copyFileTemplate (project.templatePaths, "blackberry/template/config.xml", destination + "/config.xml", context);
			
			if (project.app.main != null) {
				
				FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", outputDirectory + "/haxe", context);
				FileHelper.recursiveCopyTemplate (project.templatePaths, "html5/haxe", outputDirectory + "/haxe", context);
				FileHelper.recursiveCopyTemplate (project.templatePaths, "html5/hxml", outputDirectory + "/haxe", context);
				
			}
			
		}
		
		
		for (asset in project.assets) {
			
			PathHelper.mkdir (Path.directory (destination + asset.targetPath));
			
			if (asset.type != AssetType.TEMPLATE) {
				
				if (asset.type != AssetType.FONT || !project.targetFlags.exists ("html5")) {
					
					FileHelper.copyAssetIfNewer (asset, destination + asset.targetPath);
					
				}
				
			} else {
				
				FileHelper.copyAsset (asset, destination + asset.targetPath, context);
				
			}
			
		}
		
	}
	
	
	public function new () {}
	@ignore public function install (project:NMEProject):Void {}
	@ignore public function uninstall (project:NMEProject):Void {}
	
	
}