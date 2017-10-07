package openfl._internal.stage3D.opengl;


import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.RenderSession;
import openfl._internal.stage3D.atf.ATFReader;
import openfl._internal.stage3D.atf.ATFFormat;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.SamplerState)
@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.Context3D)


class GLCubeTexture {
	
	
	public static function create (cubeTexture:CubeTexture, renderSession:RenderSession):Void {
		
		var gl = renderSession.gl;
		
		cubeTexture.__textureTarget = gl.TEXTURE_CUBE_MAP;
		cubeTexture.__uploadedSides = 0;
		
	}
	
	
	public static function uploadCompressedTextureFromByteArray (cubeTexture:CubeTexture, renderSession:RenderSession, data:ByteArray, byteArrayOffset:UInt):Void {
		
		var reader = new ATFReader(data, byteArrayOffset);
		var atfFormat = reader.readHeader (cubeTexture.__size, cubeTexture.__size, true);

		// Handle the different texture formats
		switch (atfFormat) {
			
			case ATFFormat.RAW_COMPRESSED: cubeTexture.__format = GLTextureBase.__textureFormatCompressed;
			case ATFFormat.RAW_COMPRESSED_ALPHA: cubeTexture.__format = GLTextureBase.__textureFormatCompressedAlpha;
			default: throw new IllegalOperationError("Only ATF block compressed textures without JPEG-XR+LZMA are supported");
		
		}

		var gl = renderSession.gl;
		
		gl.bindTexture (cubeTexture.__textureTarget, cubeTexture.__textureID);
		GLUtils.CheckGLError ();

		reader.readTextures (function(side, level, width, height, blockLength, bytes) {

			var target = __sideToTarget(gl, side);

			gl.compressedTexImage2D (target, level, cubeTexture.__format, width, height, 0, blockLength, bytes);
			GLUtils.CheckGLError ();

			// __trackCompressedMemoryUsage (blockLength);

		});

		gl.bindTexture (cubeTexture.__textureTarget, null);
		GLUtils.CheckGLError ();

	}
	
	
	public static function uploadFromBitmapData (cubeTexture:CubeTexture, renderSession:RenderSession, source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		var size = cubeTexture.__size >> miplevel;
		if (size == 0) return;
		
		//if (source.width != size || source.height != size) {
			//
			//var copy = new BitmapData (size, size, true, 0);
			//copy.draw (source);
			//source = copy;
			//
		//}
		
		var image = cubeTexture.__getImage (source);
		
		uploadFromTypedArray (cubeTexture, renderSession, image.data, side, miplevel);
		
	}
	
	
	public static function uploadFromByteArray (cubeTexture:CubeTexture, renderSession:RenderSession, data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt):Void {
		
		#if js
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (cubeTexture, renderSession, @:privateAccess (data:ByteArrayData).b, side, miplevel);
			return;
			
		}
		#end
		
		uploadFromTypedArray (cubeTexture, renderSession, new UInt8Array (data.toArrayBuffer (), byteArrayOffset), side, miplevel);
		
	}
	
	
	public static function uploadFromTypedArray (cubeTexture:CubeTexture, renderSession:RenderSession, data:ArrayBufferView, side:UInt, miplevel:UInt):Void {
		
		if (data == null) return;
		var gl = renderSession.gl;
		
		var size = cubeTexture.__size >> miplevel;
		if (size == 0) return;
		
		var target = __sideToTarget(gl, side);
		
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
	
	
	public static function setSamplerState (cubeTexture:CubeTexture, renderSession:RenderSession, state:SamplerState) {
		
		if (!state.equals (cubeTexture.__samplerState)) {
			
			var gl = renderSession.gl;
			
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
		
		GLTextureBase.setSamplerState (cubeTexture, renderSession, state);
		
	}
	
	
	private static function __sideToTarget (gl:GLRenderContext, side:UInt) {
		
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