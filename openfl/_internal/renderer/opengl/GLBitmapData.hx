package openfl._internal.renderer.opengl;


import lime.graphics.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.graphics.GLTexture;
import openfl._internal.renderer.canvas.CanvasBitmapData;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

@:access(openfl.display.BitmapData)


class GLBitmapData {
	
	
	public static inline function clone (bitmapData:BitmapData):BitmapData {
		
		#if js
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
	
	
	public static inline function getTexture (bitmapData:BitmapData, gl:GLRenderContext):GLTexture {
		
		if (bitmapData.__texture == null) {
			
			bitmapData.__texture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, bitmapData.__texture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			#if js
			if (__sourceBytes == null) {
				
				CanvasBitmapData.convertToCanvas (bitmapData);
				
				var pixels = bitmapData.__sourceContext.getImageData (0, 0, width, height);
				var data = new lime.graphics.ImageData (pixels.data);
				data.premultiply ();
				
				bitmapData.__sourceBytes = data;
				
			}
			#end
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, bitmapData.width, bitmapData.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, bitmapData.__sourceBytes);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			gl.bindTexture (gl.TEXTURE_2D, null);
			
		}
		
		return bitmapData.__texture;
		
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