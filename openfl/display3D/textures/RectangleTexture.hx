package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.ExtensionAnisotropicFiltering;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;

@:access(openfl._internal.stage3D.SamplerState)


@:final class RectangleTexture extends TextureBase {
	
	
	private function new (context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool) {
		
		super (context, GL.TEXTURE_2D);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		
		uploadFromTypedArray (null);
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		if (source == null) return;
		
		var image = __getImage (source);
		
		if (image == null) return;
		
		uploadFromTypedArray (image.data);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		#if js
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		//if (__format != Context3DTextureFormat.BGRA) {
			//
			//throw new IllegalOperationError ();
			//
		//}
		
		GL.bindTexture (__textureTarget, __textureID);
		GLUtils.CheckGLError ();
		
		GL.texImage2D (__textureTarget, 0, __internalFormat, __width, __height, 0, __format, GL.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		GL.bindTexture (__textureTarget, null);
		GLUtils.CheckGLError ();
		
		var memUsage = (__width * __height) * 4;
		__trackMemoryUsage (memUsage);
		
	}
	
	override private function __setSamplerState (state:SamplerState, forceUpdate:Bool = false) {
		
		if (forceUpdate || !state.equals (__samplerState) || state.__samplerDirty) {
			
			if (state.maxAniso != 0.0) {
				GL.texParameterf (GL.TEXTURE_2D, ExtensionAnisotropicFiltering.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
			}
			
		}

		super.__setSamplerState( state );
	}
	
}