package platforms;


import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.FileSystem;


class FlashPlatform implements IPlatformTool {
	
	
	public function build (project:NMEProject):Void {
		
		var destination = project.app.path + "/flash/bin";
		var hxml = project.app.path + "/flash/haxe/" + (project.debug ? "debug" : "release") + ".hxml";
		
		ProcessHelper.runCommand ("", "haxe", [ hxml ] );
		
		var usesNME = false;
		
		for (haxelib in project.haxelibs) {
			
			if (haxelib.name == "nme") {
				
				usesNME = true;
				
			}
			
		}
		
		if (usesNME) {
			
			FlashHelper.embedAssets (destination + "/" + project.app.file + ".swf", project.assets, "nme.");
			
		}
		
		if (project.targetFlags.exists ("web") || project.app.url != "") {
			
			PathHelper.mkdir (destination);
			FileHelper.recursiveCopyTemplate (project.templatePaths, "flash/templates/web", destination, generateContext (project));
			
		}
		
	}
	
	
	public function clean (project:NMEProject):Void {
		
		var targetPath = project.app.path + "/flash";
		
		if (FileSystem.exists (targetPath)) {
			
			PathHelper.removeDirectory (targetPath);
			
		}
		
	}
	
	
	public function display (project:NMEProject):Void {
		
		var hxml = PathHelper.findTemplate (project.templatePaths, "flash/hxml/" + (project.debug ? "debug" : "release") + ".hxml");
		
		var context = project.templateContext;
		context.WIN_FLASHBACKGROUND = StringTools.hex (project.window.background);
		
		var template = new Template (File.getContent (hxml));
		Sys.println (template.execute (context));
		
	}
	
	
	private function generateContext (project:NMEProject):Dynamic {
		
		project = project.clone ();
		
		if (project.targetFlags.exists ("xml")) {
			
			project.haxeflags.push ("-xml " + project.app.path + "/flash/types.xml");
			
		}
		
		var context = project.templateContext;
		context.WIN_FLASHBACKGROUND = StringTools.hex (project.window.background);
		var assets:Array <Dynamic> = cast context.assets;
		
		for (asset in assets) {
			
			var assetType:AssetType = Reflect.field (AssetType, asset.type.toUpperCase ());
			
			switch (assetType) {
				
				case MUSIC : asset.flashClass = "nme.media.Sound";
				case SOUND : asset.flashClass = "nme.media.Sound";
				case IMAGE : asset.flashClass = "nme.display.BitmapData";
				case FONT : asset.flashClass = "nme.text.Font";
				default: asset.flashClass = "nme.utils.ByteArray";
				
			}
			
		}
		
		return context;
		
	}
	
	
	public function run (project:NMEProject, arguments:Array <String>):Void {
		
		if (project.app.url != "") {
			
			ProcessHelper.openURL (project.app.url);
			
		} else {
			
			var destination = project.app.path + "/flash/bin";
			var targetPath = project.app.file + ".swf";
			
			if (project.targetFlags.exists ("web")) {
				
				targetPath = "index.html";
				
			}
			
			FlashHelper.run (project, destination, targetPath);
			
		}
		
	}
	
	
	public function update (project:NMEProject):Void {
		
		var destination = project.app.path + "/flash/bin/";
		PathHelper.mkdir (destination);
		
		/*for (asset in assets) {
			
			if (!asset.embed) {
				
				PathHelper.mkdir (Path.directory (destination + asset.targetPath));
				FileHelper.copyIfNewer (asset.sourcePath, destination + asset.targetPath);
				
			}
			
		}*/
		
		var context = generateContext (project);
		
		FileHelper.recursiveCopyTemplate (project.templatePaths, "haxe", project.app.path + "/flash/haxe", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "flash/hxml", project.app.path + "/flash/haxe", context);
		FileHelper.recursiveCopyTemplate (project.templatePaths, "flash/haxe", project.app.path + "/flash/haxe", context);
		
		//SWFHelper.generateSWFClasses (project, project.app.path + "/flash/haxe");
		
		var usesNME = false;
		
		for (haxelib in project.haxelibs) {
			
			if (haxelib.name == "nme") {
				
				usesNME = true;
				
			}
			
		}
		
		for (asset in project.assets) {
			
			if (asset.type == AssetType.TEMPLATE || asset.embed != true || !usesNME) {
				
				PathHelper.mkdir (Path.directory (destination + asset.targetPath));
				FileHelper.copyAsset (asset, destination + asset.targetPath, context);
				
			}
			
		}
		
		
	}
	
	
	/*private function getIcon (size:Int, targetPath:String):Void {
		
		var icon = icons.findIcon (size, size);
		
		if (icon != "") {
			
			FileHelper.copyIfNewer (icon, targetPath);
			
		} else {
			
			icons.updateIcon (size, size, targetPath);
			
		}
		
	}*/
	
	
	public function new () {}
	@ignore public function install (project:NMEProject):Void { }
	@ignore public function trace (project:NMEProject):Void { }
	@ignore public function uninstall (project:NMEProject):Void { }
	
	
	
}