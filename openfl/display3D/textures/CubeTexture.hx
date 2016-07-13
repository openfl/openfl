package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import openfl.display3D.Context3D;
import openfl.utils.ByteArray;

using openfl.display.BitmapData;


@:final class CubeTexture extends TextureBase {
	
	
	private var __size:Int;
	private var __textures:Array<GLTexture>;
	private var __mipmapsGenerated:Bool;
	
	
	private function new (context:Context3D, glTexture:GLTexture, size:Int) {
		
		super (context, glTexture, size, size);
		
		__size = size;
		__mipmapsGenerated = false;
		
		__textures = [];
		
		for (i in 0...6) {
			
			__textures[i] = GL.createTexture ();
			
		}
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void {
		
		// TODO
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData, side:UInt, miplevel:UInt = 0):Void {
		
		var data = source.image.data;
		
		#if (js && html5)
		GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, 0);
		#end
		
		GL.bindTexture (GL.TEXTURE_CUBE_MAP, __glTexture);
		
		switch (side) {
			
			case 0:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_POSITIVE_X, miplevel, GL.RGBA, source.width, source.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
			
			case 1:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_NEGATIVE_X, miplevel, GL.RGBA, source.width, source.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
			
			case 2:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_POSITIVE_Y, miplevel, GL.RGBA, source.width, source.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
			
			case 3:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_NEGATIVE_Y, miplevel, GL.RGBA, source.width, source.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
			
			case 4:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_POSITIVE_Z, miplevel, GL.RGBA, source.width, source.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
			
			case 5:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_NEGATIVE_Z, miplevel, GL.RGBA, source.width, source.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
			
			default:
				
				throw "unknown side type";
			
		}
		
		GL.bindTexture (GL.TEXTURE_CUBE_MAP, null);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void {
		
		// TODO
		
	}
	
	
	private function __glTextureAt (index:Int):GLTexture {
		
		return __textures[index];
		
	}
	
	
}