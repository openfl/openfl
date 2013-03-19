package;


import haxe.io.Bytes;
import haxe.io.Path;
import haxe.Template;
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;
import neko.Lib;


class FileHelper {
	
	
	public static function copyAsset (asset:Asset, destination:String, context:Dynamic = null) {
		
		if (asset.sourcePath != "") {
			
			copyFile (asset.sourcePath, destination, context);
			
		} else {
			
			if (Std.is (asset.data, Bytes)) {
				
				File.saveBytes (destination, cast asset.data);
				
			} else {
				
				File.saveContent (destination, Std.string (asset.data));
				
			}
			
		}
		
	}
	
	
	public static function copyAssetIfNewer (asset:Asset, destination:String) {
		
		if (asset.sourcePath != "") {
			
			if (isNewer (asset.sourcePath, destination)) {
				
				copyFile (asset.sourcePath, destination);
				
			}
			
		} else {
			
			if (Std.is (asset.data, Bytes)) {
				
				File.saveBytes (destination, cast asset.data);
				
			} else {
				
				File.saveContent (destination, Std.string (asset.data));
				
			}
			
		}
		
	}
	
	
	public static function copyFile (source:String, destination:String, context:Dynamic = null, process:Bool = true) {
		
		var extension = Path.extension (source);
		
		if (process && context != null && 
            (extension == "xml" ||
             extension == "java" ||
             extension == "hx" ||
             extension == "hxml" ||
			 extension == "html" || 
             extension == "ini" ||
             extension == "gpe" ||
             extension == "pch" ||
             extension == "pbxproj" ||
             extension == "plist" ||
             extension == "json" ||
             extension == "cpp" ||
             extension == "mm" ||
			 extension == "properties" ||
			 extension == "hxproj" ||
			 extension == "nmml" ||
			 isText(source))) {
			
			LogHelper.info ("", " - Copying template file: " + source + " -> " + destination);
			
			var fileContents:String = File.getContent (source);
			var template:Template = new Template (fileContents);
			var result:String = template.execute (context);
			var fileOutput:FileOutput = File.write (destination, true);
			fileOutput.writeString (result);
			fileOutput.close ();
			
		} else {
			
			copyIfNewer (source, destination);
			
		}
		
	}
	
	
	public static function copyFileTemplate (templatePaths:Array <String>, source:String, destination:String, context:Dynamic = null, process:Bool = true) {
		
		var path = PathHelper.findTemplate (templatePaths, source);
		
		if (path != null) {
			
			copyFile (path, destination, context, process);
			
		}
		
	}
	
	
	public static function copyIfNewer (source:String, destination:String) {
      
		//allFiles.push (destination);
		
		if (!isNewer (source, destination)) {
			
			return;
			
		}
		
		PathHelper.mkdir (Path.directory (destination));
		
		LogHelper.info ("", " - Copying file: " + source + " -> " + destination);
		File.copy (source, destination);
		
	}
	
	
	public static function copyLibrary (ndll:NDLL, directoryName:String, namePrefix:String, nameSuffix:String, targetDirectory:String, allowDebug:Bool = false, targetSuffix:String = null) {
		
		var path = PathHelper.getLibraryPath (ndll, directoryName, namePrefix, nameSuffix, allowDebug);
		
		if (FileSystem.exists (path)) {
			
			var targetPath = PathHelper.combine (targetDirectory, namePrefix + ndll.name);
			
			if (targetSuffix != null) {
				
				targetPath += targetSuffix;
				
			} else {
				
				targetPath += nameSuffix;
				
			}
			
			PathHelper.mkdir (targetDirectory);
			LogHelper.info ("", " - Copying library file: " + path + " -> " + targetPath);
			File.copy (path, targetPath);
			
		} else {
			
			LogHelper.error ("Source path \"" + path + "\" does not exist");
			
		}
		
	}
	
	
	public static function recursiveCopy (source:String, destination:String, context:Dynamic = null, process:Bool = true) {
		
		PathHelper.mkdir (destination);
		
		var files:Array <String> = null;
		
		try {
			
			files = FileSystem.readDirectory (source);
			
		} catch (e:Dynamic) {
			
			LogHelper.error ("Could not find source directory \"" + source + "\"");
			
		}
		
		for (file in files) {
			
			if (file.substr (0, 1) != ".") {
				
				var itemDestination:String = destination + "/" + file;
				var itemSource:String = source + "/" + file;
				
				if (FileSystem.isDirectory (itemSource)) {
					
					recursiveCopy (itemSource, itemDestination, context, process);
					
				} else {
					
					copyFile (itemSource, itemDestination, context, process);
					
				}
				
			}
			
		}
		
	}
	
	
	public static function recursiveCopyTemplate (templatePaths:Array <String>, source:String, destination:String, context:Dynamic = null, process:Bool = true) {
		
		var paths = PathHelper.findTemplates (templatePaths, source);
		
		for (path in paths) {
			
			recursiveCopy (path, destination, context, process);
			
		}
		
	}
	
	
	public static function isNewer (source:String, destination:String):Bool {
		
		if (source == null || !FileSystem.exists (source)) {
			
			LogHelper.error ("Source path \"" + source + "\" does not exist");
			return false;
			
		}
		
		if (FileSystem.exists (destination)) {
			
			if (FileSystem.stat (source).mtime.getTime () < FileSystem.stat (destination).mtime.getTime ()) {
				
				return false;
				
			}
			
		}
		
		return true;
		
	}
	
	
	public static function isText (source:String):Bool {
		
		if (!FileSystem.exists (source)) {
			
			return false;
			
		}
		
		var input = File.read (source, true);
		
		var numChars = 0;
		var numBytes = 0;
		
		try {
			
			while (numBytes < 512) {
				
				var byte = input.readByte ();
				
				numBytes++;
				
				if (byte == 0) {
					
					return false;
					
				}
				
				if ((byte > 8 && byte < 16) || (byte > 32 && byte < 256) || byte > 287) {
					
					numChars++;
					
				}
				
			}
			
		} catch (e:Dynamic) { }
		
		if (numBytes == 0 || (numChars / numBytes) > 0.7) {
			
			return true;
			
		}
		
		return false;
		
	}
	

}
