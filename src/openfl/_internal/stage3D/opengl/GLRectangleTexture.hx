package openfl._internal.stage3D.opengl;


import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.display.OpenGLRenderer;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.SamplerState)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.Context3D)


class GLRectangleTexture {
	
	
	public static function create (rectangleTexture:RectangleTexture, renderer:OpenGLRenderer):Void {
		
		var gl = renderer.gl;
		
		rectangleTexture.__textureTarget = gl.TEXTURE_2D;
		uploadFromTypedArray (rectangleTexture, renderer, null);
		
	}
	
	
	public static function uploadFromBitmapData (rectangleTexture:RectangleTexture, renderer:OpenGLRenderer, source:BitmapData):Void {
		
		if (source == null) return;
		
		var image = rectangleTexture.__getImage (source);
		
		if (image == null) return;
		
		uploadFromTypedArray (rectangleTexture, renderer, image.data);
		
	}
	
	
	public static function uploadFromByteArray (rectangleTexture:RectangleTexture, renderer:OpenGLRenderer, data:ByteArray, byteArrayOffset:UInt):Void {
		
		#if js
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (rectangleTexture, renderer, @:privateAccess (data:ByteArrayData).b);
			return;
			
		}
		#end
		
		uploadFromTypedArray (rectangleTexture, renderer, new UInt8Array (data.toArrayBuffer (), byteArrayOffset));
		
	}
	
	
	public static function uploadFromTypedArray (rectangleTexture:RectangleTexture, renderer:OpenGLRenderer, data:ArrayBufferView):Void {
		
		//if (__format != Context3DTextureFormat.BGRA) {
			//
			//throw new IllegalOperationError ();
			//
		//}
		
		var gl = renderer.gl;
		
		gl.bindTexture (rectangleTexture.__textureTarget, rectangleTexture.__textureID);
		GLUtils.CheckGLError ();
		
		gl.texImage2D (rectangleTexture.__textureTarget, 0, rectangleTexture.__internalFormat, rectangleTexture.__width, rectangleTexture.__height, 0, rectangleTexture.__format, gl.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		gl.bindTexture (rectangleTexture.__textureTarget, null);
		GLUtils.CheckGLError ();
		
		// var memUsage = (__width * __height) * 4;
		// __trackMemoryUsage (memUsage);
		
	}
	
	
	public static function setSamplerState (rectangleTexture:RectangleTexture, renderer:OpenGLRenderer, state:SamplerState) {
		
		if (!state.equals (rectangleTexture.__samplerState)) {
			
			var gl = renderer.gl;
			
			if (state.maxAniso != 0.0) {
				
				gl.texParameterf (gl.TEXTURE_2D, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		GLTextureBase.setSamplerState (rectangleTexture, renderer, state);
		
	}
	
	
}