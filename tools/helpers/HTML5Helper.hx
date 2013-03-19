package;


import haxe.io.Path;
import sys.FileSystem;


class HTML5Helper {
	
	
	public static function generateFontData (project:NMEProject, font:Asset):String {
		
		var sourcePath = font.sourcePath;
		
		//if (!FileSystem.exists (FileSystem.fullPath (sourcePath) + ".hash")) {
			
			ProcessHelper.runCommand (Path.directory (sourcePath), "neko", [ PathHelper.findTemplate (project.templatePaths, "html5/hxswfml.n"), "ttf2hash", Path.withoutDirectory (sourcePath), "-glyphs", font.glyphs ]);
			
		//}
		
		return "-resource " + FileSystem.fullPath (sourcePath) + ".hash@NME_" + font.flatName;
		
	}
	
	
	public static function minify (project:NMEProject, sourceFile:String):Bool {
		
		if (FileSystem.exists (sourceFile)) {
			
			var tempFile = PathHelper.getTemporaryFile (".js");
			
			if (project.targetFlags.exists ("yui")) {
				
				ProcessHelper.runCommand ("", "java", [ "-jar", PathHelper.findTemplate (project.templatePaths, "bin/yuicompressor-2.4.7.jar"), "-o", tempFile, sourceFile ]);
				
			} else {
				
				var args = [ "-jar", PathHelper.findTemplate (project.templatePaths, "bin/compiler.jar"), "--js", sourceFile, "--js_output_file", tempFile ];
				
				if (!LogHelper.verbose) {
					
					args.push ("--jscomp_off=uselessCode");
					
				}
				
				ProcessHelper.runCommand ("", "java", args);
				
			}
			
			FileSystem.deleteFile (sourceFile);
			FileSystem.rename (tempFile, sourceFile);
			
			return true;
			
		}
		
		return false;
		
	}
	
	
}