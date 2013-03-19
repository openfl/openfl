package;


import format.SVG;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.Path;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.geom.Rectangle;
import nme.utils.ByteArray;
import sys.io.File;
import sys.FileSystem;


class IconHelper {
	
	
	public static function createIcon (icons:Array <Icon>, width:Int, height:Int, targetPath:String):Bool {
		
		var icon = findMatch (icons, width, height);
		
		if (icon != null && Path.extension (icon.path) == "png") {
			
			FileHelper.copyFile (icon.path, targetPath);
			return true;
			
		} else {
			
			var bitmapData = getIconBitmap (icons, width, height);
			
			if (bitmapData != null) {
				
				File.saveBytes (targetPath, bitmapData.encode ("png"));
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	public static function createMacIcon (icons:Array <Icon>, targetPath:String):Bool {
		
		var out = new BytesOutput ();
		out.bigEndian = true;
		
		// Not sure why the 128x128 icon is not saving properly. Disabling for now
		
		for (i in 0...3) {
			
			var s =  ([ 16, 32, 48, 128 ])[i];
			var code =  ([ "is32", "il32", "ih32", "it32" ])[i];
			var bmp = getIconBitmap (icons, s, s);
			
			if (bmp != null) {
				
				for (c in 0...4) out.writeByte (code.charCodeAt(c));
				
				var n = s * s;
				var pixels = bmp.getPixels (new Rectangle (0, 0, s, s));
				
				var bytes_r = packBits (pixels, 1, s * s);
				var bytes_g = packBits (pixels, 2, s * s);
				var bytes_b = packBits (pixels, 3, s * s);
				
				out.writeInt32 (bytes_r.length + bytes_g.length + bytes_b.length + 8);
				out.writeBytes (bytes_r, 0, bytes_r.length);
				out.writeBytes (bytes_g, 0, bytes_g.length);
				out.writeBytes (bytes_b, 0, bytes_b.length);
				
				var code =  ([ "s8mk", "l8mk", "h8mk", "t8mk" ])[i];
				
				for (c in 0...4) out.writeByte (code.charCodeAt (c));
				
				var bytes_a = extractBits (pixels, 0, s * s);
				out.writeInt32 (bytes_a.length + 8);
				out.writeBytes (bytes_a, 0, bytes_a.length);
				
			}
			
		}
		
		for (i in 0...5) {
			
			var s =  ([ 32, 64, 256, 512, 1024 ])[i];
			var code =  ([ "ic11", "ic12", "ic08", "ic09", "ic10" ])[i];
			var bmp = getIconBitmap (icons, s, s);
			
			if (bmp != null) {
				
				for (c in 0...4) out.writeByte (code.charCodeAt(c));
				
				var bytes = bmp.encode ("png");
				
				out.writeInt32 (bytes.length + 8);
				out.writeBytes (bytes, 0, bytes.length);
				
			}
			
		}
		
		var bytes = out.getBytes ();
		
		if (bytes.length > 0) {
			
			var file = File.write (targetPath, true);
			file.bigEndian = true;
			
			for (c in 0...4) file.writeByte ("icns".charCodeAt (c));
			
			file.writeInt32 (bytes.length + 8);
			file.writeBytes (bytes, 0, bytes.length);
			file.close ();
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	public static function createWindowsIcon (icons:Array <Icon>, targetPath:String):Bool {
		
		var sizes = [ 16, 24, 32, 48, 64, 128, 256 ];
		var bmps = new Array <BitmapData> ();
		
		var data_pos = 6;
		
		for (size in sizes) {
			
			var bmp = getIconBitmap (icons, size, size);
			
			if (bmp != null) {
				
				bmps.push (bmp);
				data_pos += 16;
				
			}
			
		}
		
		var ico = new ByteArray ();
		ico.bigEndian = false;
		ico.writeShort (0);
		ico.writeShort (1);
		ico.writeShort (bmps.length);
		
		for (bmp in bmps) {
			
			var size = bmp.width;
			var xor_size = size * size * 4;
			var and_size = size * size >> 3;
			ico.writeByte (size);
			ico.writeByte (size);
			ico.writeByte (0); // palette
			ico.writeByte (0); // reserved
			ico.writeShort (1); // planes
			ico.writeShort (32); // bits per pixel
			ico.writeInt (40 + xor_size + and_size); // Data size
			ico.writeInt (data_pos); // Data offset
			data_pos += 40 + xor_size + and_size;
			
		}
		
		for (bmp in bmps) {
			
			var size = bmp.width;
			var xor_size = size * size * 4;
			var and_size = size * size >> 3;
			
			ico.writeInt (40); // size (bytes)
			ico.writeInt (size);
			ico.writeInt (size * 2);
			ico.writeShort (1);
			ico.writeShort (32);
			ico.writeInt (0); // Bit fields...
			ico.writeInt (xor_size + and_size); // Size...
			ico.writeInt (0); // res-x
			ico.writeInt (0); // res-y
			ico.writeInt (0); // cols
			ico.writeInt (0); // important
			
			var bits = bmp.getPixels (new Rectangle (0, 0, size, size));
			var and_mask = new ByteArray ();
			
			for (y in 0...size) {
				
				var mask = 0;
				var bit = 128;
				bits.position = (size-1 - y) * 4 * size;
				
				for (i in 0...size) {
					
					var a = bits.readByte ();
					var r = bits.readByte ();
					var g = bits.readByte ();
					var b = bits.readByte ();
					ico.writeByte (b);
					ico.writeByte (g);
					ico.writeByte (r);
					ico.writeByte (a);
					
					if (a < 128)
						mask |= bit;
					
					bit = bit >> 1;
					
					if (bit == 0) {
						
						and_mask.writeByte (mask);
						bit = 128;
						mask = 0;
						
					}
					
				}
				
			}
			
			ico.writeBytes (and_mask, 0, and_mask.length);
			
		}
		
		if (bmps.length > 0) {
			
			var file = File.write (targetPath, true);
			file.writeBytes (ico, 0, ico.length);
			file.close ();
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private static function extractBits (data:ByteArray, offset:Int, len:Int):Bytes {
		
		var out = new BytesOutput ();
		
		for (i in 0...len) {
			
			out.writeByte (data[i * 4 + offset]);
			
		}
		
		return out.getBytes ();
		
	}
	
	
	public static function findMatch (icons:Array <Icon>, width:Int, height:Int):Icon {
		
		var match = null;
		
		for (icon in icons) {
			
			if (match == null && icon.width == 0 && icon.height == 0) {
				
				match = icon;
				
			} else if (icon.width == width && icon.height == height) {
				
				match = icon;
				
			}
			
		}
		
		return match;
		
	}
	
	
	public static function findNearestMatch (icons:Array <Icon>, width:Int, height:Int):Icon {
		
		var match = null;
		
		for (icon in icons) {
			
			if (icon.width > width / 2 && icon.height > height / 2) {
				
				if (match == null) {
					
					match = icon;
					
				} else {
					
					if (icon.width > match.width && icon.height > match.height) {
						
						if (match.width < width || match.height < height) {
							
							match = icon;
							
						}
						
					} else {
						
						if (icon.width > width && icon.height > height) {
							
							match = icon;
							
						}
						
					}
					
				}
				
			}
			
		}
		
		return match;
		
	}
	
	
	private static function getIconBitmap (icons:Array <Icon>, width:Int, height:Int, backgroundColor:Int = null):BitmapData {
		
		var icon = findMatch (icons, width, height);
		var exactMatch = true;
		
		if (icon == null) {
			
			icon = findNearestMatch (icons, width, height);
			exactMatch = false;
			
		}
		
		if (icon == null) {
			
			return null;
			
		}
		
		if (!FileSystem.exists (icon.path)) {
			
			LogHelper.warn ("Could not find icon path: " + icon.path);
			return null;
			
		}
		
		var extension = Path.extension (icon.path);
		var bitmapData = null;
		
		switch (extension) {
			
			case "png", "jpg", "jpeg":
				
				if (exactMatch ) {
					
					bitmapData = BitmapData.load (icon.path);
					
				} else {
					
					bitmapData = ImageHelper.resizeBitmapData (BitmapData.load (icon.path), width, height);
					
				}
			
			case "svg":
				
				bitmapData = ImageHelper.rasterizeSVG (new SVG (File.getContent (icon.path)), width, height, backgroundColor);
			
		}
		
		return bitmapData;
		
	}
   
   
	private static function packBits (data:ByteArray, offset:Int, len:Int):Bytes {
		
		var out = new BytesOutput ();
		var idx = 0;
		
		while (idx < len) {
			
			var val = data[idx * 4 + offset];
			var same = 1;
			
			/*
			Hmmmm...
			while( ((idx+same) < len) && (data[ (idx+same)*4 + offset ]==val) && (same < 2) )
			same++;
			*/
			
			if (same == 1) {
				
				var raw = idx + 120 < len ? 120 : len - idx;
				out.writeByte (raw - 1);
				
				for (i in 0...raw) {
					
					out.writeByte (data[idx * 4 + offset]);
					idx++;
					
				}
				
			} else {
				
				out.writeByte (257 - same);
				out.writeByte (val);
				idx += same;
				
			}
			
		}
		
		return out.getBytes ();
		
	}
		

}