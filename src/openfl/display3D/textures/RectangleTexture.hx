package openfl.display3D.textures; #if !flash


import lime.graphics.Image;
import lime.utils.ArrayBufferView;
import openfl._internal.renderer.opengl.GLRectangleTexture;
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
		
		GLRectangleTexture.create (this);
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		GLRectangleTexture.uploadFromBitmapData (this, source);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		GLRectangleTexture.uploadFromByteArray (this, data, byteArrayOffset);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		GLRectangleTexture.uploadFromTypedArray (this, data);
		
	}
	
	
	@:noCompletion private override function __setSamplerState (state:SamplerState):Bool {
		
		if (super.__setSamplerState (state)) {
			
			var gl = __context.__gl;
			
			if (state.maxAniso != 0.0) {
				
				gl.texParameterf (gl.TEXTURE_2D, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				// GLUtils.CheckGLError ();
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __uploadFromImage (image:Image):Void {
		
		var gl = __context.__gl;
		var internalFormat, format;
		
		if (image.buffer.bitsPerPixel == 1) {
			
			internalFormat = gl.ALPHA;
			format = gl.ALPHA;
			
		} else {
			
			internalFormat = TextureBase.__textureInternalFormat;
			format = TextureBase.__textureFormat;
			
		}
		
		__context.__bindTexture (gl.TEXTURE_2D, __textureID);
		
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
		
		__context.__bindTexture (gl.TEXTURE_2D, null);
		
	}
	
	
}


#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end