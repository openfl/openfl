package openfl._internal.renderer.opengl;


import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.renderer.opengl.GLUtils;
import openfl._internal.formats.agal.SamplerState;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.display.OpenGLRenderer;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.formats.agal.SamplerState)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObjectRenderer)


class GLRectangleTexture {
	
	
	public static function create (rectangleTexture:RectangleTexture):Void {
		
		var gl = rectangleTexture.__context.__gl;
		
		rectangleTexture.__textureTarget = gl.TEXTURE_2D;
		uploadFromTypedArray (rectangleTexture, null);
		
	}
	
	
	public static function uploadFromBitmapData (rectangleTexture:RectangleTexture, source:BitmapData):Void {
		
		if (source == null) return;
		
		var image = rectangleTexture.__getImage (source);
		if (image == null) return;
		
		#if (js && html5)
		if (image.buffer != null && image.buffer.data == null && image.buffer.src != null) {
			
			var context = rectangleTexture.__context;
			var gl = context.__gl;
			
			context.__bindTexture (rectangleTexture.__textureTarget, rectangleTexture.__textureID);
			GLUtils.CheckGLError ();
			
			gl.texImage2D (rectangleTexture.__textureTarget, 0, rectangleTexture.__internalFormat, rectangleTexture.__format, gl.UNSIGNED_BYTE, image.buffer.src);
			GLUtils.CheckGLError ();
			
			context.__bindTexture (rectangleTexture.__textureTarget, null);
			GLUtils.CheckGLError ();
			return;
			
		}
		#end
		
		uploadFromTypedArray (rectangleTexture, image.data);
		
	}
	
	
	public static function uploadFromByteArray (rectangleTexture:RectangleTexture, data:ByteArray, byteArrayOffset:UInt):Void {
		
		#if (js && !display)
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (rectangleTexture, @:privateAccess (data:ByteArrayData).b);
			return;
			
		}
		#end
		
		uploadFromTypedArray (rectangleTexture, new UInt8Array (data.toArrayBuffer (), byteArrayOffset));
		
	}
	
	
	public static function uploadFromTypedArray (rectangleTexture:RectangleTexture, data:ArrayBufferView):Void {
		
		//if (__format != Context3DTextureFormat.BGRA) {
			//
			//throw new IllegalOperationError ();
			//
		//}
		
		var context = rectangleTexture.__context;
		var gl = context.__gl;
		
		context.__bindTexture (rectangleTexture.__textureTarget, rectangleTexture.__textureID);
		GLUtils.CheckGLError ();
		
		gl.texImage2D (rectangleTexture.__textureTarget, 0, rectangleTexture.__internalFormat, rectangleTexture.__width, rectangleTexture.__height, 0, rectangleTexture.__format, gl.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		context.__bindTexture (rectangleTexture.__textureTarget, null);
		GLUtils.CheckGLError ();
		
		// var memUsage = (__width * __height) * 4;
		// __trackMemoryUsage (memUsage);
		
	}
	
	
	public static function setSamplerState (rectangleTexture:RectangleTexture, state:SamplerState) {
		
		if (!state.equals (rectangleTexture.__samplerState)) {
			
			var context = rectangleTexture.__context;
			var gl = context.__gl;
			
			if (state.maxAniso != 0.0) {
				
				gl.texParameterf (gl.TEXTURE_2D, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		GLTextureBase.setSamplerState (rectangleTexture, state);
		
	}
	
	
}