package openfl._internal.data;


import lime.graphics.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.graphics.GLTexture;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

@:access(openfl.display.BitmapData)


class BitmapDataArray {
	
	
	public static inline function clone (bitmapData:BitmapData):BitmapData {
		
		#if !js
		if (!bitmapData.__isValid) {
			
			return new BitmapData (bitmapData.width, bitmapData.height, bitmapData.transparent);
			
		} else {
			
			return BitmapData.fromImage (new lime.graphics.Image (bitmapData.__sourceBytes, bitmapData.width, bitmapData.height), bitmapData.transparent);
			
		}
		#else
		return null;
		#end
		
	}
	
	
	public static inline function dispose (bitmapData:BitmapData):Void {
		
		#if js
		bitmapData.__sourceBytes = null;
		#end
		
	}
	
	
	public static inline function fromImage (image:lime.graphics.Image, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		image.premultiplyAlpha ();
		bitmapData.__sourceBytes = image.data;
		bitmapData.width = image.width;
		bitmapData.height = image.height;
		bitmapData.rect = new Rectangle (0, 0, image.width, image.height);
		bitmapData.__isValid = true;
		return bitmapData;
		
	}
	
	
}