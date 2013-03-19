package;


import format.SWF;
#if swfdev
import format.swf.exporters.SWFLiteExporter;
import format.swf.lite.symbols.BitmapSymbol;
#end
import haxe.io.Path;
import haxe.Serializer;
import haxe.Template;
import nme.utils.ByteArray;
import sys.io.File;
import sys.FileSystem;


class SWFHelper {
	
	
	public static function generateSWFClasses (project:NMEProject, outputDirectory:String):Void {
		
		return null;
		
		/*var movieClipTemplate = File.getContent (PathHelper.findTemplate (project.templatePaths, "resources/swf/MovieClip.mtt"));
		var simpleButtonTemplate = File.getContent (PathHelper.findTemplate (project.templatePaths, "resources/swf/SimpleButton.mtt"));
		
		for (asset in project.libraries) {
			
			if (!FileSystem.exists (asset.sourcePath)) {
				
				LogHelper.error ("SWF library path \"" + asset.sourcePath + "\" does not exist");
				
			}
			
			var input = File.read (asset.sourcePath, true);
			var data = new ByteArray ();
			
			try {
				
				while (true) {
					
					data.writeByte (input.readByte ());
					
				}
				
			} catch (e:Dynamic) {
				
			}
			
			data.position = 0;
			
			var swf = new SWF (data);
			
			for (className in swf.symbols.keys ()) {
				
				var lastIndexOfPeriod = className.lastIndexOf (".");
				var packageName = "";
				var name = "";
				
				if (lastIndexOfPeriod == -1) {
					
					name = className;
					
				} else {
					
					packageName = className.substr (0, lastIndexOfPeriod);
					name = className.substr (lastIndexOfPeriod + 1);
					
				}
				
				packageName = packageName.toLowerCase ();
				name = name.substr (0, 1).toUpperCase () + name.substr (1);
				
				var symbolID = swf.symbols.get (className);
				var templateData = null;
				
				switch (swf.getSymbol (symbolID)) {
					
					case spriteSymbol (data):
						
						templateData = movieClipTemplate;
					
					case buttonSymbol (data):
						
						templateData = simpleButtonTemplate;
					
					default:
					
				}
				
				if (templateData != null) {
					
					var context = { PACKAGE_NAME: packageName, CLASS_NAME: name, SWF_ID: asset.id, SYMBOL_ID: symbolID };
					var template = new Template (templateData);
					var result = template.execute (context);
					
					var directory = outputDirectory + "/" + Path.directory (className.split (".").join ("/"));
					var fileName = name + ".hx";
					
					PathHelper.mkdir (directory);
					
					var path = PathHelper.combine (directory, fileName);
					LogHelper.info ("", " - Generating SWF class: " + path);
					
					var fileOutput = File.write (path, true);
					fileOutput.writeString (result);
					fileOutput.close ();
					
				}
				
			}
			
		}*/
		
	}
	
	
	public static function preprocess (project:NMEProject):Void {
		
		for (library in project.libraries) {
			
			if (library.type == LibraryType.SWF) {
				
				project.haxelibs.push (new Haxelib ("swf"));
				
				#if swfdev
				if (project.target == Platform.HTML5) {
					
					var bytes = ByteArray.readFile (library.sourcePath);
					var swf = new SWF (bytes);
					var exporter = new SWFLiteExporter (swf.data);
					var swfLite = exporter.swfLite;
					
					for (id in exporter.bitmaps.keys ()) {
						
						var bitmapData = exporter.bitmaps.get (id);
						var symbol:BitmapSymbol = cast swfLite.symbols.get (id);
						symbol.path = "libraries/bin/" + id + ".png";
						swfLite.symbols.set (id, symbol);
						
						var asset = new Asset ("", symbol.path, AssetType.IMAGE);
						asset.data = bitmapData.encode ("png");
						project.assets.push (asset);
						
					}
					
					var asset = new Asset ("", "libraries/" + library.name + ".dat", AssetType.TEXT);
					asset.data = Serializer.run (swfLite);
					project.assets.push (asset);
					
				} else {
				#end
					
					project.assets.push (new Asset (library.sourcePath, "libraries/" + library.name + ".swf", AssetType.BINARY));
					
				#if swfdev
				}
				#end
				
			}
			
		}
		
	}
	

}
