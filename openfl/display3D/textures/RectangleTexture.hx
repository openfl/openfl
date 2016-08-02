package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.utils.ArrayBufferView;
import openfl._internal.stage3D.GLUtils;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;


@:final class RectangleTexture extends TextureBase {
	
	
	private var __format:String;
	private var __height:Int;
	private var __optimizeForRenderToTexture:Bool;
	private var __width:Int;
	
	
	private function new (context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool) {
		
		super (context, GL.TEXTURE_2D);
		
		__width = width;
		__height = height;
		__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		/* TODO: figure out fixed.
			   fixed (UInt *ptr = source.getRawData()) {
				uploadFromPointer((IntPtr)ptr);
			}*/
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		if (cast(byteArrayOffset, Int) >= data.length) {
			
			throw new RangeError ();
			
		}
		
		/*
			   TODO: Figure out fixed.
			fixed (byte *bytePtr = data.getRawArray()) {
				IntPtr ptr = (IntPtr)bytePtr;
				ptr += (Int)byteArrayOffset;
				uploadFromPointer (ptr);
			}
			*/
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		//if (__format != Context3DTextureFormat.BGRA) {
			//
			//throw new IllegalOperationError ();
			//
		//}
		
		GL.bindTexture (__textureTarget, __textureID);
		GLUtils.CheckGLError ();
		
		GL.texImage2D (__textureTarget, 0, GL.RGBA, __width, __height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
		
		__allocated = true;
		GLUtils.CheckGLError ();
		
		GL.bindTexture (__textureTarget, null);
		GLUtils.CheckGLError ();
		
		var memUsage = (__width * __height) * 4;
		__trackMemoryUsage (memUsage);
		
	}
	
	
}