package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;


class HTML5Platform implements IPlatformTool {
	
	
	private var outputDirectory:String;
	private var outputFile:String;
	
	
	public function build (project:NMEProject):Void {
		
		initialize (project);
		
		if (project.app.main != null) {
			
			var hxml = outputDirectory + "/haxe/" + (project.debug ? "debug" : "release") + ".hxml";
			ProcessHelper.runCommand ("", "haxe", [ hxml ] );
			
		}
		
		if (project.targetFlags.exists ("minify")) {
			
			HTML5Helper.minify (project, outputDirectory + "/bin/" + project.app.file + ".js");
			
		}
		
	}
	
	
	public function clean (project:NMEProject):Void {
		
		var targetPath = project.app.path + "/html5";
		
		if (FileSystem.exists (targetPath)) {
			
			PathHelper.removeDirectory (targetPath);
			
		}
		
	}
	
	
	public function display (project:NMEProject):Void {
		
		initialize (project);
		
		var hxml = PathHelper.findTemplate (project.templatePaths, "html5/hxml/" + (project.debug ? "debug" : "release") + ".hxml");
		
		var context = project.templateContext;
		context.OUTPUT_DIR = outputDirectory;
		context.OUTPUT_FILE = outputFile;
		
		var template = new Template (File.getContent (hxml));
		Sys.println (template.execute (context));
		
	}
	
	
	private function initialize (project:NMEProject):Void {
		
		outputDirectory = project.app.path + "/html5";
		outputFile = outputDirectory + "/bin/" + project.app.file + ".js";
		
	}
	
	
	public function run (project:NMEProject, arguments:Array < String > ):Void {
		
		initialize (project);
		
		if (project.app.url != "") {
			
			ProcessHelper.openURL (project.app.url);
			
		} else {
			
			ProcessHelper.openFile (project.app.path + "/html5/bin", "index.html");
			
		}
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		initialize (project);
		
		project = project.clone ();
		
		var destination = outputDirectory + "/bin/";
		PathHelper.mkdir (destination);
		
		for (asset in project.assets) {
			
			if (asset.type == AssetType.FONT) {
				
				project.haxeflags.push (HTML5Helper.generateFontData (project, asset));
				
			}
			
		}
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + project.app.path + "/html5/types.xml");
			
		}
		
		var context = project.templateContext;
		
		context.WIN_FLASHBACKGROUND = StringTools.hex (project.window.background, 6);
		context.OUTPUT_DIR = outputDirectory;
		context.OUTPUT_FILE = outputFile;
		
		for (asset in project.assets) {
			
			if (asset.type != AssetType.TEMPLATE) {
				
				PathHelper.mkdir (Path.directory (destination + asset.targetPath));
				
				if (asset.type != AssetType.FONT) {
					
					FileHelper.copyAssetIfNewer (asset, destination + asset.targetPath);
					
				}
				
			}
			
		}
		
		FileHelper.recursiveCopyTemplate (project.templatePaths, "html5/template", destination, context);
		
		if (project.app.main != null) {
			
			FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", outputDirectory + "/haxe", context);
			FileHelper.recursiveCopyTemplate (project.templatePaths, "html5/haxe", outputDirectory + "/haxe", context);
			FileHelper.recursiveCopyTemplate (project.templatePaths, "html5/hxml", outputDirectory + "/haxe", context);
			
		}
		
		for (asset in project.assets) {
			
			if (asset.type == AssetType.TEMPLATE) {
				
				PathHelper.mkdir (Path.directory (destination + asset.targetPath));
				FileHelper.copyAsset (asset, destination + asset.targetPath, context);
				
			}
			
		}
		
	}
	
	
	public function new () {}
	@ignore public function install (project:NMEProject):Void {}
	@ignore public function trace (project:NMEProject):Void {}
	@ignore public function uninstall (project:NMEProject):Void {}
	
	
}