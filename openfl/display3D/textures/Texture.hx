package openfl.display3D.textures;


import openfl.display3D.Context3D;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.gl.GLFramebuffer;
import openfl.geom.Rectangle;
import openfl.utils.ArrayBuffer;
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
		
		if (internalFormat == -1){
			#if (cpp && !openfl_legacy)
			internalFormat = GL.BGRA_EXT;
			#else
			internalFormat = GL.RGBA;
			#end
		}
		
		#if (js || neko)
		if (optimizeForRenderToTexture == null) optimizeForRenderToTexture = false;
		#end
		
		super (context, glTexture, width, height);
		
		#if (cpp || neko || nodejs)
		if (optimizeForRenderToTexture) { 
			
			GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, 1); 
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
		}
		#end
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		
		// TODO
		
	}
	
	
	public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void {
		
		#if openfl_legacy
		
		var pixels = BitmapData.getRGBAPixels (bitmapData);
		
		width = bitmapData.width;
		height = bitmapData.height;
		
		uploadFromByteArray (pixels, 0, miplevel);
		
		#else
		
		var image = bitmapData.image;
		
		if (!image.premultiplied && image.transparent) {
			
			image = image.clone ();
			image.premultiplied = true;
			
		}
		
		width = image.width;
		height = image.height;
		
		uploadFromUInt8Array (image.data, miplevel);
		
		#end
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, miplevel:Int = 0):Void {
		
		#if js
		var source = new UInt8Array (data.length);
		data.position = byteArrayOffset;
		
		var i:Int = 0;
		
		while (data.position < data.length) {
			
			source[i] = data.readUnsignedByte ();
			i++;
			
		}
		#else
		var source = new UInt8Array (data);
		#end
		
		uploadFromUInt8Array (source, miplevel);
		
	}
	
	
	public function uploadFromUInt8Array (data:UInt8Array, miplevel:Int = 0):Void {
		
		GL.bindTexture (GL.TEXTURE_2D, glTexture);
		
		if (optimizeForRenderToTexture) {
			
			GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, 1);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
		}
		
		GL.texImage2D (GL.TEXTURE_2D, miplevel, internalFormat, width, height, 0, internalFormat, GL.UNSIGNED_BYTE, data);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
}