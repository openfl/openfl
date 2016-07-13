package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.utils.ByteArray;


@:final class RectangleTexture extends TextureBase {
	
	
	private static var __internalFormat:Int = -1;
	private var __optimizeForRenderToTexture:Bool;
	
	
	private function new (context:Context3D, glTexture:GLTexture, optimize:Bool, width:Int, height:Int) {
		
		__optimizeForRenderToTexture = optimize;
		
		if (__internalFormat == -1) {
			
			#if native
			__internalFormat = GL.BGRA_EXT;
			#else
			__internalFormat = GL.RGBA;
			#end
			
		}
		
		super (context, glTexture, width, height);
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		var image = source.image;
		
		if (!image.premultiplied && image.transparent) {
			
			image = image.clone ();
			image.premultiplied = true;
			
		}
		
		__width = image.width;
		__height = image.height;
		
		uploadFromTypedArray (image.data);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		uploadFromTypedArray (__getUInt8ArrayFromByteArray (data, byteArrayOffset));
		
	}
	
	
	// TODO: Should there be a typed array API, or just use ByteArray?
	
	
	@:deprecated("uploadFromUInt8Array is deprecated. Use uploadFromTypedArray instead.")
	@:noCompletion @:dox(hide) public inline function uploadFromUInt8Array (data:UInt8Array):Void {
		
		uploadFromTypedArray (data);
		
	}
	
	
	@:noCompletion @:dox(hide) public function uploadFromTypedArray (data:ArrayBufferView, yFlipped:Bool = false, premultiplied:Bool = true):Void {
		
		// TODO use premultiplied parameter
		
		GL.bindTexture (GL.TEXTURE_2D, __glTexture);
		
		#if (js && html5)
		GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, yFlipped ? 0 : 1);
		#else
		if (!yFlipped) {
			
			data = __flipPixels (data, __width, __height);
			
		}
		#end
		
		GL.texImage2D (GL.TEXTURE_2D, 0, __internalFormat, __width, __height, 0, __internalFormat, GL.UNSIGNED_BYTE, data);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
}