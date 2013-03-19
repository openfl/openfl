package;


import sys.io.File;


class NekoHelper {
	
	
	public static function copyLibraries (templatePaths:Array <String>, platformName:String, targetPath:String) {
		
		FileHelper.recursiveCopyTemplate (templatePaths, "neko/ndll/" + platformName, targetPath);
		
	}
	
	
	public static function createExecutable (templatePaths:Array <String>, platformName:String, source:String, target:String):Void {
		
		var executablePath = PathHelper.findTemplate (templatePaths, "neko/bin/neko-" + platformName);
		var executable = File.getBytes (executablePath);
		var sourceContents = File.getBytes (source);
		
		var output = File.write (target, true);
		output.write (executable);
		output.write (sourceContents);
		output.writeString ("NEKO");
		output.writeInt32 (executable.length);
		output.close ();
		
	}
		

}
