package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;


class LinuxPlatform implements IPlatformTool {
	
	
	private var applicationDirectory:String;
	private var executablePath:String;
	private var is64:Bool;
	private var isRaspberryPi:Bool;
	private var targetDirectory:String;
	private var useNeko:Bool;
	
	
	public function build (project:NMEProject):Void {
		
		initialize (project);
		
		var hxml = targetDirectory + "/haxe/" + (project.debug ? "debug" : "release") + ".hxml";
		
		PathHelper.mkdir (targetDirectory);
		ProcessHelper.runCommand ("", "haxe", [ hxml ]);
		
		if (useNeko) {
			
			NekoHelper.createExecutable (project.templatePaths, "linux" + (is64 ? "64" : ""), targetDirectory + "/obj/ApplicationMain.n", executablePath);
			NekoHelper.copyLibraries (project.templatePaths, "linux" + (is64 ? "64" : ""), applicationDirectory);
			
		} else {
			
			FileHelper.copyFile (targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : ""), executablePath);
			
		}
		
		if (PlatformHelper.hostPlatform != Platform.WINDOWS) {
			
			ProcessHelper.runCommand ("", "chmod", [ "755", executablePath ]);
			
		}
		
	}
	
	
	public function clean (project:NMEProject):Void {
		
		initialize (project);
		
		if (FileSystem.exists (targetDirectory)) {
			
			PathHelper.removeDirectory (targetDirectory);
			
		}
		
	}
	
	
	public function display (project:NMEProject):Void {
		
		initialize (project);
		
		var hxml = PathHelper.findTemplate (project.templatePaths, (useNeko ? "neko" : "cpp") + "/hxml/" + (project.debug ? "debug" : "release") + ".hxml");
		var template = new Template (File.getContent (hxml));
		Sys.println (template.execute (generateContext (project)));
		
	}
	
	
	private function generateContext (project:NMEProject):Dynamic {
		
		var project = project.clone ();
		
		if (isRaspberryPi) {
			
			project.haxedefs.set ("rpi", 1);
			
		}
		
		var context = project.templateContext;
		
		context.NEKO_FILE = targetDirectory + "/obj/ApplicationMain.n";
		context.CPP_DIR = targetDirectory + "/obj/";
		context.BUILD_DIR = project.app.path + "/linux" + (is64 ? "64" : "") + (isRaspberryPi ? "-rpi" : "");
		context.WIN_ALLOW_SHADERS = false;
		
		return context;
		
	}
	
	
	private function initialize (project:NMEProject):Void {
		
		for (architecture in project.architectures) {
			
			if (architecture == Architecture.X64) {
				
				is64 = true;
				
			}
			
		}
		
		if (project.targetFlags.exists ("rpi")) {
			
			isRaspberryPi = true;
			is64 = true;
			
		} else if (PlatformHelper.hostPlatform == Platform.LINUX) {
			
			var process = new Process ("uname", [ "-a" ]);
			var output = process.stdout.readAll ().toString ();
			var error = process.stderr.readAll ().toString ();
			process.exitCode ();
			process.close ();
			
			if (output.toLowerCase ().indexOf ("raspberrypi") > -1) {
				
				isRaspberryPi = true;
				is64 = true;
				
			}
			
		}
		
		if (project.targetFlags.exists ("neko") || project.target != PlatformHelper.hostPlatform) {
			
			useNeko = true;
			
		}
		
		targetDirectory = project.app.path + "/linux" + (is64 ? "64" : "") + (isRaspberryPi ? "-rpi" : "") + "/" + (useNeko ? "neko" : "cpp");
		applicationDirectory = targetDirectory + "/bin/";
		executablePath = applicationDirectory + "/" + project.app.file;
		
	}
	
	
	public function run (project:NMEProject, arguments:Array <String>):Void {
		
		if (project.target == PlatformHelper.hostPlatform) {
			
			initialize (project);
			ProcessHelper.runCommand (applicationDirectory, "./" + Path.withoutDirectory (executablePath), arguments);
			
		}
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		project = project.clone ();
		initialize (project);
		
		if (is64) {
			
			project.haxedefs.set ("HXCPP_M64", 1);
			
		}
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + targetDirectory + "/types.xml");
			
		}
		
		var context = generateContext (project);
		
		PathHelper.mkdir (targetDirectory);
		PathHelper.mkdir (targetDirectory + "/obj");
		PathHelper.mkdir (targetDirectory + "/haxe");
		PathHelper.mkdir (applicationDirectory);
		
		//SWFHelper.generateSWFClasses (project, targetDirectory + "/haxe");
		
		FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", targetDirectory + "/haxe", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, (useNeko ? "neko" : "cpp") + "/hxml", targetDirectory + "/haxe", context);
		
		for (ndll in project.ndlls) {
			
			if (isRaspberryPi) {
				
				FileHelper.copyLibrary (ndll, "RPi", "", (ndll.haxelib != null && ndll.haxelib.name == "hxcpp") ? ".dso" : ".ndll", applicationDirectory, project.debug);
				
			} else {
				
				FileHelper.copyLibrary (ndll, "Linux" + (is64 ? "64" : ""), "", (ndll.haxelib != null && ndll.haxelib.name == "hxcpp") ? ".dso" : ".ndll", applicationDirectory, project.debug);
				
			}
			
		}
		
		//context.HAS_ICON = IconHelper.createIcon (project.icons, 256, 256, PathHelper.combine (applicationDirectory, "icon.png"));
		
		for (asset in project.assets) {
			
			if (asset.type != AssetType.TEMPLATE) {
				
				PathHelper.mkdir (Path.directory (applicationDirectory + "/" + asset.targetPath));
				FileHelper.copyAssetIfNewer (asset, applicationDirectory + "/" + asset.targetPath);
				
			} else {
				
				PathHelper.mkdir (Path.directory (applicationDirectory + "/" + asset.targetPath));
				FileHelper.copyAsset (asset, applicationDirectory + "/" + asset.targetPath, context);
				
			}
			
		}
		
	}
	
	
	public function new () {}
	@ignore public function install (project:NMEProject):Void {}
	@ignore public function trace (project:NMEProject):Void {}
	@ignore public function uninstall (project:NMEProject):Void {}
	
	
}