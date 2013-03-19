package;


import format.xfl.dom.DOMBitmapItem;
import format.XFL;
import haxe.io.Path;
import haxe.Serializer;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import nme.utils.ByteArray;


class XFLHelper {
	
	
	public static function preprocess (project:NMEProject):Void {
		
		for (library in project.libraries) {
			
			if (library.type == LibraryType.XFL) {
				
				var xfl = new XFL (library.sourcePath);
				var path = Path.directory (library.sourcePath);
				var targetPath = "libraries/" + library.name;
				
				//project.includeAssets (path, targetPath, [ "*.xml", "*.xfl" ]);
				
				var asset = new Asset ("", targetPath + "/" + library.name + ".dat", AssetType.TEXT);
				asset.data = Serializer.run (xfl);
				
				project.assets.push (asset);
				
				for (medium in xfl.document.media) {
					
					if (Std.is (medium, DOMBitmapItem)) {
						
						var bitmapItem = cast (medium, DOMBitmapItem);
						
						var source = path + "/bin/" + bitmapItem.bitmapDataHRef;
						var target = targetPath + "/bin/" + bitmapItem.bitmapDataHRef + "." + (bitmapItem.isJPEG ? "jpg" : "png");
						
						var asset = new Asset (source, target, AssetType.IMAGE);
						asset.id = source;
						asset.format = (bitmapItem.isJPEG ? "jpg" : "png");
						
						if (!bitmapItem.isJPEG) {
							
							//var bytes = ByteArray.readFile (source);
							//
							//var format = bytes.readUnsignedByte ();
							//var width = bytes.readUnsignedShort ();
							//var height = bytes.readUnsignedShort ();
							//var tableSize = bytes.readUnsignedShort () + 1;
							//
							//var buffer = new ByteArray ();
							//bytes.readBytes (buffer, 0, bytes.length - bytes.position);
							//buffer.uncompress ();
							//
							//var transparent = true;
							//var colorTable = new Array <Int> ();
							//
							//for (i in 0...tableSize) {
								//
								//var r = buffer.readUnsignedByte ();
								//var g = buffer.readUnsignedByte ();
								//var b = buffer.readUnsignedByte ();
								//
								//if (transparent) {
									//
									//var a = buffer.readUnsignedByte ();
									//colorTable.push ((a << 24) + (r << 16) + (g << 8) + b);
									//
								//} else {
									//
									//colorTable.push ((r << 16) + (g << 8) + b);
									//
								//}
								//
							//}
							//
							//var imageData = new ByteArray ();
							//var padding = Math.ceil (width / 4) - Math.floor (width / 4);
							//
							//for (y in 0...height) {
								//
								//for (x in 0...width) {
									//
									//imageData.writeUnsignedInt (colorTable[buffer.readUnsignedByte ()]);
									//
								//}
								//
								//buffer.position += padding;
								//
							//}
							//
							//buffer = imageData;
							//buffer.position = 0;
							//
							//var bitmapData = new BitmapData (width, height, transparent);
							//bitmapData.setPixels (new Rectangle (0, 0, width, height), buffer);
							
							var bitmapData = new BitmapData (100, 100, true);
							var png = bitmapData.encode ("png");
							asset.data = png;
							asset.sourcePath = "";
							
						}
						
						project.assets.push (asset);
						
					}
					
				}
				
				project.haxelibs.push (new Haxelib ("xfl"));

				
			}
			
		}
		
	}
	
	
}