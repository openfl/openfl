package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;


@:final class CubeTexture extends TextureBase {
	
	
	//private var __format:Context3DTextureFormat;
	private var __optimizeForRenderToTexture:Bool;
	private var __size:Int;
	private var __streamingLevels:Int;
	private var __uploadedSides:Int;
	
	
	private function new (context:Context3D, size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context, GL.TEXTURE_CUBE_MAP);
		
		__size = size;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
		__uploadedSides = 0;
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void {
		
		// TODO
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		GL.bindTexture (__textureTarget, __textureID);
		
		var target = switch (side) {
			
			case 0: GL.TEXTURE_CUBE_MAP_POSITIVE_X;
			case 1: GL.TEXTURE_CUBE_MAP_NEGATIVE_X;
			case 2: GL.TEXTURE_CUBE_MAP_POSITIVE_Y;
			case 3: GL.TEXTURE_CUBE_MAP_NEGATIVE_Y;
			case 4: GL.TEXTURE_CUBE_MAP_POSITIVE_Z;
			case 5: GL.TEXTURE_CUBE_MAP_NEGATIVE_Z;
			default: throw new IllegalOperationError ();
			
		}
		
		// TODO: upload
		
		__uploadedSides |= 1 << side;
		//__trackMemoryUsage (__width * __height * 4);
		
		GL.bindTexture (__textureTarget, null);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void {
		
		// TODO
		
	}
	
	
}