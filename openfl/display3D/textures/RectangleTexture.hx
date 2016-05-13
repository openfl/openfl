package openfl.display3D.textures;


import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.UInt8Array;


@:final class RectangleTexture extends TextureBase {
	
	
	public var optimizeForRenderToTexture:Bool;
	
	
	public function new (context:Context3D, glTexture:GLTexture, optimize:Bool, width:Int, height:Int) {
		
		optimizeForRenderToTexture = optimize;
		
		#if (js || neko)
		if (optimizeForRenderToTexture == null) optimizeForRenderToTexture = false;
		#end
		
		super (context, glTexture, width, height);
		
		#if (cpp || neko || nodejs)
		if (optimizeForRenderToTexture)
			GL.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1); 
		
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		#end
		
	}
	
	
	//public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		// TODO
	//}
	
	
	public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void {
		
		// TODO: Support upload from UInt8Array directly
		
		#if openfl_legacy
		var p = BitmapData.getRGBAPixels (bitmapData);
		#else
		var p:ByteArray = bitmapData.image.data.buffer;
		#end
		
		width = bitmapData.width;
		height = bitmapData.height;
		
		uploadFromByteArray (p, 0);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int):Void {
		
		GL.bindTexture (GL.TEXTURE_2D, glTexture);
		
		#if (js && html5)
			
			if (optimizeForRenderToTexture)
				GL.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1);
			
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
			var source = new UInt8Array (data.length);
			data.position = byteArrayOffset;
			
			var i:Int = 0;
			
			while (data.position < data.length) {
				
				source[i] = data.readUnsignedByte ();
				i++;
				
			}
			
		#else
			
			if (optimizeForRenderToTexture) {
				
				GL.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1); 
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			 
			}
			
			#if nodejs
			var source = data.byteView;
			#else
			var source = new UInt8Array(data);
			#end
			
		#end
		
		// mipLevel always should be 0 in rectangle textures
		GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
		GL.bindTexture (GL.TEXTURE_2D, null);
		
	}
	
	
}