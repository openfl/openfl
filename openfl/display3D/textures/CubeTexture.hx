package openfl.display3D.textures; #if !flash


import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.UInt8Array;

using openfl.display.BitmapData;


class CubeTexture extends TextureBase {
	
	
	public var size : Int;
	public var _textures:Array<GLTexture>;
	
	
	public function new (glTexture:GLTexture, size:Int) {
		
		super (glTexture, size, size);
		this.size = size;
		
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
		
		// TODO: Support upload from UInt8Array directly
		
		#if lime_legacy
		var source = new UInt8Array (BitmapData.getRGBAPixels (bitmapData));
		#else
		var source = @:privateAccess (bitmapData.__image).data;
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


#else
typedef CubeTexture = flash.display3D.textures.CubeTexture;
#end