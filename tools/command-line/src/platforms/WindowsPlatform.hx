package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;


class WindowsPlatform implements IPlatformTool {
	
	
	private var applicationDirectory:String;
	private var executablePath:String;
	private var targetDirectory:String;
	private var useNeko:Bool;
	
	
	public function build (project:NMEProject):Void {
		
		initialize (project);
		
		var hxml = targetDirectory + "/haxe/" + (project.debug ? "debug" : "release") + ".hxml";
		
		PathHelper.mkdir (targetDirectory);
		ProcessHelper.runCommand ("", "haxe", [ hxml ]);
		
		if (useNeko) {
			
			NekoHelper.createExecutable (project.templatePaths, "windows", targetDirectory + "/obj/ApplicationMain.n", executablePath);
			NekoHelper.copyLibraries (project.templatePaths, "windows", applicationDirectory);
			
		} else {
			
			FileHelper.copyFile (targetDirectory + "/obj/ApplicationMain" + (project.debug ? "-debug" : "") + ".exe", executablePath);
			
			var iconPath = PathHelper.combine (applicationDirectory, "icon.ico");
			
			if (IconHelper.createWindowsIcon (project.icons, iconPath)) {
				
				ProcessHelper.runCommand ("", PathHelper.findTemplate (project.templatePaths, "bin/ReplaceVistaIcon.exe"), [ executablePath, iconPath ], true, true);
				
			}
			
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
		
		var context = project.templateContext;
		
		context.NEKO_FILE = targetDirectory + "/obj/ApplicationMain.n";
		context.CPP_DIR = targetDirectory + "/obj";
		context.BUILD_DIR = project.app.path + "/windows";
		
		return context;
		
	}
	
	
	private function initialize (project:NMEProject):Void {
		
		targetDirectory = project.app.path + "/windows/cpp";
		
		if (project.targetFlags.exists ("neko") || project.target != PlatformHelper.hostPlatform) {
			
			targetDirectory = project.app.path + "/windows/neko";
			useNeko = true;
			
		}
		
		applicationDirectory = targetDirectory + "/bin/";
		executablePath = applicationDirectory + "/" + project.app.file + ".exe";
		
	}
	
	
	public function run (project:NMEProject, arguments:Array <String>):Void {
		
		if (project.target == PlatformHelper.hostPlatform) {
			
			initialize (project);
			ProcessHelper.runCommand (applicationDirectory, Path.withoutDirectory (executablePath), arguments);
			
		}
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		project = project.clone ();
		
		if (!project.environment.exists ("SHOW_CONSOLE")) {
			
			project.haxedefs.set ("no_console", 1);
			
		}
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + targetDirectory + "/types.xml");
			
		}
		
		initialize (project);
		
		var context = generateContext (project);
		
		PathHelper.mkdir (targetDirectory);
		PathHelper.mkdir (targetDirectory + "/obj");
		PathHelper.mkdir (targetDirectory + "/haxe");
		PathHelper.mkdir (applicationDirectory);
		
		//SWFHelper.generateSWFClasses (project, targetDirectory + "/haxe");
		
		FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", targetDirectory + "/haxe", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, (useNeko ? "neko" : "cpp") + "/hxml", targetDirectory + "/haxe", context);
		
		for (ndll in project.ndlls) {
			
			FileHelper.copyLibrary (ndll, "Windows", "", (ndll.haxelib != null && ndll.haxelib.name == "hxcpp") ? ".dll" : ".ndll", applicationDirectory, project.debug);
			
		}
		
		/*if (IconHelper.createIcon (project.icons, 32, 32, PathHelper.combine (applicationDirectory, "icon.png"))) {
			
			context.HAS_ICON = true;
			context.WIN_ICON = "icon.png";
			
		}*/
		
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