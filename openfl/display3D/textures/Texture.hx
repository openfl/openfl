package openfl.display3D.textures;


import openfl.display3D.Context3D;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.ArrayBufferView;
import openfl.utils.ByteArray;
import openfl.utils.UInt8Array;

using openfl.display.BitmapData;


@:final class Texture extends TextureBase {
	
	private static var internalFormat:Int = -1;
	
	public var optimizeForRenderToTexture:Bool;
	
	public var mipmapsGenerated:Bool;
	
	public function new (context:Context3D, glTexture:GLTexture, optimize:Bool, width:Int, height:Int) {
		
		optimizeForRenderToTexture = optimize;

		mipmapsGenerated = false;
		
		if (internalFormat == -1) {
			
			#if native
			internalFormat = GL.BGRA_EXT;
			#else
			internalFormat = GL.RGBA;
			#end
			
		}
		
		super (context, glTexture, width, height);
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		
		// TODO
		
	}
	
	
	public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void {
		
		var image = bitmapData.image;
		
		if (!image.premultiplied && image.transparent) {
			
			image = image.clone ();
			image.premultiplied = true;
			
		}
		
		width = image.width;
		height = image.height;
		
		uploadFromTypedArray (image.data, miplevel);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, miplevel:Int = 0):Void {
		
		uploadFromTypedArray (getUInt8ArrayFromByteArray (data, byteArrayOffset), miplevel);
		
	}
	
	
	@:deprecated("uploadFromUInt8Array is deprecated. Use uploadFromTypedArray instead.")
	public inline function uploadFromUInt8Array (data:UInt8Array, miplevel:Int = 0):Void {
		
		uploadFromTypedArray (data, miplevel);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, miplevel:Int = 0, yFlipped:Bool = false, premultiplied:Bool = true):Void {
		
		// TODO use premultiplied parameter
		
		var size = getSizeForMipLevel (miplevel);
		
		GL.bindTexture (GL.TEXTURE_2D, glTexture);
		
		#if (js && html5)
		GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, yFlipped ? 0 : 1);
		#else
		if (!yFlipped) {
			
			data = flipPixels (data, size.width, size.height);
			
		}
		#end
		
		GL.texImage2D (GL.TEXTURE_2D, miplevel, internalFormat, size.width, size.height, 0, internalFormat, GL.UNSIGNED_BYTE, data);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
}