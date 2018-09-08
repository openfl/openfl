package openfl.display3D.textures; #if !flash


import lime.graphics.Image;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.renderer.SamplerState;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


@:final class RectangleTexture extends TextureBase {
	
	
	@:noCompletion private function new (context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool) {
		
		super (context);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		
		__textureTarget = __context.gl.TEXTURE_2D;
		uploadFromTypedArray (null);
		
		if (optimizeForRenderToTexture) __getGLFramebuffer (true, 0, 0);
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		if (source == null) return;
		
		var image = __getImage (source);
		if (image == null) return;
		
		#if (js && html5)
		if (image.buffer != null && image.buffer.data == null && image.buffer.src != null) {
			
			var gl = __context.gl;
			
			__context.__bindGLTexture2D (__textureID);
			gl.texImage2D (__textureTarget, 0, __internalFormat, __format, gl.UNSIGNED_BYTE, image.buffer.src);
			__context.__bindGLTexture2D (null);
			return;
			
		}
		#end
		
		uploadFromTypedArray (image.data);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		#if (js && !display)
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		var gl = __context.gl;
		
		__context.__bindGLTexture2D (__textureID);
		gl.texImage2D (__textureTarget, 0, __internalFormat, __width, __height, 0, __format, gl.UNSIGNED_BYTE, data);
		__context.__bindGLTexture2D (null);
		
	}
	
	
	@:noCompletion private override function __setSamplerState (state:SamplerState):Bool {
		
		if (super.__setSamplerState (state)) {
			
			var gl = __context.gl;
			
			if (Context3D.GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT != 0) {
				
				var aniso = switch (state.filter) {
					case ANISOTROPIC2X: 2;
					case ANISOTROPIC4X: 4;
					case ANISOTROPIC8X: 8;
					case ANISOTROPIC16X: 16;
					default: 1;
				}
				
				if (aniso > Context3D.GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT) {
					aniso = Context3D.GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT;
				}
				
				gl.texParameterf (gl.TEXTURE_2D, Context3D.GL_TEXTURE_MAX_ANISOTROPY_EXT, aniso);
					
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __uploadFromImage (image:Image):Void {
		
		var gl = __context.gl;
		var internalFormat, format;
		
		if (image.buffer.bitsPerPixel == 1) {
			
			internalFormat = gl.ALPHA;
			format = gl.ALPHA;
			
		} else {
			
			internalFormat = TextureBase.__textureInternalFormat;
			format = TextureBase.__textureFormat;
			
		}
		
		__context.__bindGLTexture2D (__textureID);
		
		#if (js && html5)
		
		if (image.type != DATA && !image.premultiplied) {
			
			gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
			
		} else if (!image.premultiplied && image.transparent) {
			
			gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
			//gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);
			//textureImage = textureImage.clone ();
			//textureImage.premultiplied = true;
			
		}
		
		if (image.type == DATA) {
			
			gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, image.buffer.width, image.buffer.height, 0, format, gl.UNSIGNED_BYTE, image.data);
			
		} else {
			
			gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, format, gl.UNSIGNED_BYTE, image.src);
			
		}
		
		#else
		
		gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, image.buffer.width, image.buffer.height, 0, format, gl.UNSIGNED_BYTE, image.data);
		
		#end
		
		__context.__bindGLTexture2D (null);
		
	}
	
	
}


#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end