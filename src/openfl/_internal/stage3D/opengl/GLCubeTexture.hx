package openfl._internal.stage3D.opengl;


import lime.utils.ArrayBufferView;
import lime.utils.BytePointer;
import lime.utils.UInt8Array;
import openfl._internal.stage3D.atf.ATFReader;
import openfl._internal.stage3D.atf.ATFGPUFormat;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFormat;
import openfl.display.BitmapData;
import openfl.display.OpenGLRenderer;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
#else
import lime.graphics.opengl.WebGLContext;
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.SamplerState)
@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObjectRenderer)


class GLCubeTexture {
	
	
	public static function create (cubeTexture:CubeTexture, renderer:OpenGLRenderer):Void {
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		cubeTexture.__textureTarget = gl.TEXTURE_CUBE_MAP;
		cubeTexture.__uploadedSides = 0;
		
	}
	
	
	public static function uploadCompressedTextureFromByteArray (cubeTexture:CubeTexture, renderer:OpenGLRenderer, data:ByteArray, byteArrayOffset:UInt):Void {
		
		var reader = new ATFReader (data, byteArrayOffset);
		var alpha = reader.readHeader (cubeTexture.__size, cubeTexture.__size, true);
		
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl:GLRenderContext = renderer.__context;
		#end
		
		gl.bindTexture (cubeTexture.__textureTarget, cubeTexture.__textureID);
		GLUtils.CheckGLError ();
		
		var hasTexture = false;
		
		reader.readTextures (function (side, level, gpuFormat, width, height, blockLength, bytes) {
			
			#if (lime < "7.0.0") // TODO
			var format = GLTextureBase.__compressedTextureFormats.toTextureFormat (alpha, gpuFormat);
			if (format == 0) return;
			
			hasTexture = true;
			var target = __sideToTarget (renderer.__context, side);
			
			cubeTexture.__format = format;
			cubeTexture.__internalFormat = format;
			
			if (alpha && gpuFormat == 2) {
				
				var size = Std.int (blockLength / 2);
				
				gl.compressedTexImage2D (target, level, cubeTexture.__internalFormat, width, height, 0, size, bytes);
				GLUtils.CheckGLError ();
				
				var alphaTexture = new CubeTexture (cubeTexture.__context, cubeTexture.__size, Context3DTextureFormat.COMPRESSED, cubeTexture.__optimizeForRenderToTexture, cubeTexture.__streamingLevels);
				alphaTexture.__format = format;
				alphaTexture.__internalFormat = format;
				
				gl.bindTexture (alphaTexture.__textureTarget, alphaTexture.__textureID);
				GLUtils.CheckGLError ();
				
				gl.compressedTexImage2D (target, level, alphaTexture.__internalFormat, width, height, 0, size, new BytePointer (bytes, size));
				GLUtils.CheckGLError ();
				
				cubeTexture.__alphaTexture = alphaTexture;
				
			} else {
				
				gl.compressedTexImage2D (target, level, cubeTexture.__internalFormat, width, height, 0, blockLength, bytes);
				GLUtils.CheckGLError ();
				
			}
			
			// __trackCompressedMemoryUsage (blockLength);
			#end
			
		});
		
		if (!hasTexture) {
			
			for (side in 0...6) {
				
				var data = new UInt8Array (cubeTexture.__size * cubeTexture.__size * 4);
				gl.texImage2D (__sideToTarget (renderer.__context, side), 0, cubeTexture.__internalFormat, cubeTexture.__size, cubeTexture.__size, 0, cubeTexture.__format, gl.UNSIGNED_BYTE, data);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		gl.bindTexture (cubeTexture.__textureTarget, null);
		GLUtils.CheckGLError ();
		
	}
	
	
	public static function uploadFromBitmapData (cubeTexture:CubeTexture, renderer:OpenGLRenderer, source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		var size = cubeTexture.__size >> miplevel;
		if (size == 0) return;
		
		var image = cubeTexture.__getImage (source);
		if (image == null) return;
		
		// TODO: Improve handling of miplevels with canvas src
		
		#if (js && html5)
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl:WebGLContext = renderer.__context;
			#end
			
			var size = cubeTexture.__size >> miplevel;
			if (size == 0) return;
			
			var target = __sideToTarget (renderer.__context, side);
			
			gl.bindTexture (gl.TEXTURE_CUBE_MAP, cubeTexture.__textureID);
			GLUtils.CheckGLError ();
			
			gl.texImage2D (target, miplevel, cubeTexture.__internalFormat, cubeTexture.__format, gl.UNSIGNED_BYTE, image.buffer.src);
			GLUtils.CheckGLError ();
			
			gl.bindTexture (cubeTexture.__textureTarget, null);
			GLUtils.CheckGLError ();
			
			cubeTexture.__uploadedSides |= 1 << side;
			return;
			
		}
		#end
		
		uploadFromTypedArray (cubeTexture, renderer, image.data, side, miplevel);
		
	}
	
	
	public static function uploadFromByteArray (cubeTexture:CubeTexture, renderer:OpenGLRenderer, data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt):Void {
		
		#if (js && !display)
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (cubeTexture, renderer, @:privateAccess (data:ByteArrayData).b, side, miplevel);
			return;
			
		}
		#end
		
		uploadFromTypedArray (cubeTexture, renderer, new UInt8Array (data.toArrayBuffer (), byteArrayOffset), side, miplevel);
		
	}
	
	
	public static function uploadFromTypedArray (cubeTexture:CubeTexture, renderer:OpenGLRenderer, data:ArrayBufferView, side:UInt, miplevel:UInt):Void {
		
		if (data == null) return;
		#if (lime >= "7.0.0")
		var gl = renderer.__context.webgl;
		#else
		var gl = renderer.__context;
		#end
		
		var size = cubeTexture.__size >> miplevel;
		if (size == 0) return;
		
		var target = __sideToTarget (renderer.__context, side);
		
		gl.bindTexture (gl.TEXTURE_CUBE_MAP, cubeTexture.__textureID);
		GLUtils.CheckGLError ();
		
		gl.texImage2D (target, miplevel, cubeTexture.__internalFormat, size, size, 0, cubeTexture.__format, gl.UNSIGNED_BYTE, data);
		GLUtils.CheckGLError ();
		
		gl.bindTexture (cubeTexture.__textureTarget, null);
		GLUtils.CheckGLError ();
		
		cubeTexture.__uploadedSides |= 1 << side;
		
		// var memUsage = (__size * __size) * 4;
		// __trackMemoryUsage (memUsage);
		
	}
	
	
	public static function setSamplerState (cubeTexture:CubeTexture, renderer:OpenGLRenderer, state:SamplerState) {
		
		if (!state.equals (cubeTexture.__samplerState)) {
			
			#if (lime >= "7.0.0")
			var gl = renderer.__context.webgl;
			#else
			var gl = renderer.__context;
			#end
			
			if (state.minFilter != gl.NEAREST && state.minFilter != gl.LINEAR && !state.mipmapGenerated) {
				
				gl.generateMipmap (gl.TEXTURE_CUBE_MAP);
				GLUtils.CheckGLError ();
				
				state.mipmapGenerated = true;
				
			}
			
			if (state.maxAniso != 0.0) {
				
				gl.texParameterf (gl.TEXTURE_CUBE_MAP, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				GLUtils.CheckGLError ();
				
			}
			
		}
		
		GLTextureBase.setSamplerState (cubeTexture, renderer, state);
		
	}
	
	
	private static function __sideToTarget (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end, side:UInt) {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl = context;
		#end
		
		return switch (side) {
			
			case 0: gl.TEXTURE_CUBE_MAP_NEGATIVE_X;
			case 1: gl.TEXTURE_CUBE_MAP_POSITIVE_X;
			case 2: gl.TEXTURE_CUBE_MAP_NEGATIVE_Y;
			case 3: gl.TEXTURE_CUBE_MAP_POSITIVE_Y;
			case 4: gl.TEXTURE_CUBE_MAP_NEGATIVE_Z;
			case 5: gl.TEXTURE_CUBE_MAP_POSITIVE_Z;
			default: throw new IllegalOperationError ();
			
		}

	}
	
	
}