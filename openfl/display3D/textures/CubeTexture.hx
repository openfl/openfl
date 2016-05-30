package openfl.display3D.textures;


import openfl.display3D.Context3D;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.ByteArray;

using openfl.display.BitmapData;


@:final class CubeTexture extends TextureBase {
	
	
	public var size : Int;
	public var _textures:Array<GLTexture>;
	public var mipmapsGenerated:Bool;
	
	
	public function new (context:Context3D, glTexture:GLTexture, size:Int) {
		
		super (context, glTexture, size, size);
		this.size = size;
		this.mipmapsGenerated = false;
		
		this._textures = [];
		
		for (i in 0...6) {
			
			this._textures[i] = GL.createTexture ();
			
		}
		
	}
	
	
	public function glTextureAt (index:Int):GLTexture {
		
		return this._textures[index];
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		
		// TODO
		
	}
	
	
	public function uploadFromBitmapData (bitmapData:BitmapData, side:Int, miplevel:Int = 0):Void {
		
		var source = bitmapData.image.data;
		
		#if (js && html5)
		GL.pixelStorei (GL.UNPACK_FLIP_Y_WEBGL, 0);
		#end
		
		GL.bindTexture (GL.TEXTURE_CUBE_MAP, glTexture);
		
		switch (side) {
			
			case 0:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_POSITIVE_X, miplevel, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
			
			case 1:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_NEGATIVE_X, miplevel, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
			
			case 2:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_POSITIVE_Y, miplevel, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
			
			case 3:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_NEGATIVE_Y, miplevel, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
			
			case 4:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_POSITIVE_Z, miplevel, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
			
			case 5:
				
				GL.texImage2D (GL.TEXTURE_CUBE_MAP_NEGATIVE_Z, miplevel, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, source);
			
			default:
				
				throw "unknown side type";
			
		}
		
		GL.bindTexture (GL.TEXTURE_CUBE_MAP, null);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, side:Int, miplevel:Int = 0):Void {
		
		// TODO
		
	}
	
	
}