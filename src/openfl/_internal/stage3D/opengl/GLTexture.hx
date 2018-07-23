package openfl._internal.stage3D.opengl;


import haxe.io.Bytes;
import lime.utils.ArrayBufferView;
import lime.utils.BytePointer;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.atf.ATFReader;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFormat;
import openfl.display.BitmapData;
import openfl.display.OpenGLRenderer;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

#if (lime >= "7.0.0")
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.opengl.WebGLContext;
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.SamplerState)
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObjectRenderer)


class GLTexture {
	
	
	public static function create (texture:Texture, renderer:OpenGLRenderer):Void {
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		texture.__textureTarget = gl.TEXTURE_2D;
		
		gl.bindTexture (texture.__textureTarget, texture.__textureID);
		GLUtils.CheckGLError ();
		
		gl.texImage2D (texture.__textureTarget, 0, texture.__internalFormat, texture.__width, texture.__height, 0, texture.__format, gl.UNSIGNED_BYTE, #if (lime >= "7.0.0") null #else 0 #end);
		GLUtils.CheckGLError ();
		
		gl.bindTexture (texture.__textureTarget, null);
		
	}
	
	
	public static function uploadCompressedTextureFromByteArray (texture:Texture, renderer:OpenGLRenderer, data:ByteArray, byteArrayOffset:UInt):Void {
		
		var reader = new ATFReader(data, byteArrayOffset);
		var alpha = reader.readHeader (texture.__width, texture.__height, false);
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl:GLRenderContext = renderer.__context;
		#end
		
		gl.bindTexture (texture.__textureTarget, texture.__textureID);
		GLUtils.CheckGLError ();
		
		var hasTexture = false;
		
		reader.readTextures (function (target, level, gpuFormat, width, height, blockLength, bytes:Bytes) {
			
			#if (lime < "7.0.0") // TODO
			var format = GLTextureBase.__compressedTextureFormats.toTextureFormat (alpha, gpuFormat);
			if (format == 0) return;
			
			hasTexture = true;
			texture.__format = format;
			texture.__internalFormat = format;
			
			if (alpha && gpuFormat == 2) {
				
				var size = Std.int (blockLength / 2);
				
				gl.compressedTexImage2D (texture.__textureTarget, level, texture.__internalFormat, width, height, 0, size, bytes);
				GLUtils.CheckGLError ();
				
				var alphaTexture = new Texture (texture.__context, texture.__width, texture.__height, Context3DTextureFormat.COMPRESSED, texture.__optimizeForRenderToTexture, texture.__streamingLevels);
				alphaTexture.__format = format;
				alphaTexture.__internalFormat = format;
				
				gl.bindTexture (alphaTexture.__textureTarget, alphaTexture.__textureID);
				GLUtils.CheckGLError ();
				
				gl.compressedTexImage2D (alphaTexture.__textureTarget, level, alphaTexture.__internalFormat, width, height, 0, size, new BytePointer (bytes, size));
				GLUtils.CheckGLError ();
				
				texture.__alphaTexture = alphaTexture;
				
			} else {
				
				gl.compressedTexImage2D (texture.__textureTarget, level, texture.__internalFormat, width, height, 0, blockLength, bytes);
				GLUtils.CheckGLError ();
				
			}
			
			// __trackCompressedMemoryUsage (blockLength);
			#end
			
		});
		
		if (!hasTexture) {
			
			var data = new UInt8Array (texture.__width * texture.__height * 4);
			gl.texImage2D (texture.__textureTarget, 0, texture.__internalFormat, texture.__width, texture.__height, 0, texture.__format, gl.UNSIGNED_BYTE, data);
			GLUtils.CheckGLError ();
			
		}
		
		gl.bindTexture (texture.__textureTarget, null);
		GLUtils.CheckGLError ();
		
	}
	
	
	public static function uploadFromBitmapData (texture:Texture, renderer:OpenGLRenderer, source:BitmapData, miplevel:UInt, generateMipmap:Bool):Void {
		
		/* TODO
			if (LowMemoryMode) {
				// shrink bitmap data
				source = source.shrinkToHalfResolution();
				// shrink our dimensions for upload
				width = source.width;
				height = source.height;
			}
			*/
		
		if (source == null) return;
		
		var width = texture.__width >> miplevel;
		var height = texture.__height >> miplevel;
		
		if (width == 0 && height == 0) return;
		
		if (width == 0) width = 1;
		if (height == 0) height = 1;
		
		if (source.width != width || source.height != height) {
			
			var copy = new BitmapData (width, height, true, 0);
			copy.draw (source);
			source = copy;
			
		}
		
		var image = texture.__getImage (source);
		if (image == null) return;
		
		// TODO: Improve handling of miplevels with canvas src
		
		#if (js && html5)
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl:WebGLContext = renderer.__context;
			#end
			
			var width = texture.__width >> miplevel;
			var height = texture.__height >> miplevel;
			
			if (width == 0 && height == 0) return;
			
			if (width == 0) width = 1;
			if (height == 0) height = 1;
			
			gl.bindTexture (texture.__textureTarget, texture.__textureID);
			GLUtils.CheckGLError ();
			
			gl.texImage2D (texture.__textureTarget, miplevel, texture.__internalFormat, texture.__format, gl.UNSIGNED_BYTE, image.buffer.src);
			GLUtils.CheckGLError ();
			
			gl.bindTexture (texture.__textureTarget, null);
			GLUtils.CheckGLError ();
			
			// var memUsage = (width * height) * 4;
			// __trackMemoryUsage (memUsage);
			return;
			
		}
		#end
		
		uploadFromTypedArray (texture, renderer, image.data, miplevel);
		
	}
	
	
	public static function uploadFromByteArray (texture:Texture, renderer:OpenGLRenderer, data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void {
		
		#if (js && !display)
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (texture, renderer, @:privateAccess (data:ByteArrayData).b, miplevel);
			return;
			
		}
		#end
		
		uploadFromTypedArray (texture, renderer, new UInt8Array (data.toArrayBuffer (), byteArrayOffset), miplevel);
		
	}
	
	
	public static function uploadFromTypedArray (texture:Texture, renderer:OpenGLRenderer, data:ArrayBufferView, miplevel:UInt = 0):Void {
		
		if (data == null) return;
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		var width = texture.__width >> miplevel;
		var height = texture.__height >> miplevel;
		
		if (width == 0 && height == 0) return;
		
		if (width == 0) width = 1;
		if (height == 0) height = 1;
		
		gl.bindTexture (texture.__textureTarget, texture.__textureID);
		GLUtils.CheckGLError ();
		
		gl.texImage2D (texture.__textureTarget, miplevel, texture.__internalFormat, width, height, 0, texture.__format, gl.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		gl.bindTexture (texture.__textureTarget, null);
		GLUtils.CheckGLError ();
		
		// var memUsage = (width * height) * 4;
		// __trackMemoryUsage (memUsage);
		
	}
	
	
	public static function setSamplerState (texture:Texture, renderer:OpenGLRenderer, state:SamplerState) {
		
		if (!state.equals (texture.__samplerState)) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl = renderer.__context;
			#end
			
			if (state.minFilter != gl.NEAREST && state.minFilter != gl.LINEAR && !state.mipmapGenerated) {
				
				gl.generateMipmap (gl.TEXTURE_2D);
				GLUtils.CheckGLError ();
				
				state.mipmapGenerated = true;
				
			}
			
			if (state.maxAniso != 0.0) {
				
				gl.texParameterf (gl.TEXTURE_2D, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		GLTextureBase.setSamplerState (texture, renderer, state);
		
	}
	
	
}