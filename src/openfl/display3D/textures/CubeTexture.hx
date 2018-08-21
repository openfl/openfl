package openfl.display3D.textures; #if !flash


import haxe.Timer;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.formats.atf.ATFReader;
import openfl._internal.renderer.SamplerState;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


@:final class CubeTexture extends TextureBase {
	
	
	@:noCompletion private var __size:Int;
	@:noCompletion private var __uploadedSides:Int;
	
	
	@:noCompletion private function new (context:Context3D, size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context);
		
		__size = size;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
		__textureTarget = __context.__gl.TEXTURE_CUBE_MAP;
		__uploadedSides = 0;
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void {
		
		if (!async) {
			
			__uploadCompressedTextureFromByteArray (data, byteArrayOffset);
			
		} else {
			
			Timer.delay (function () {
				
				__uploadCompressedTextureFromByteArray (data, byteArrayOffset);
				dispatchEvent (new Event (Event.TEXTURE_READY));
				
			}, 1);
			
		}
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		if (source == null) return;
		var size = __size >> miplevel;
		if (size == 0) return;
		
		var image = __getImage (source);
		if (image == null) return;
		
		// TODO: Improve handling of miplevels with canvas src
		
		#if (js && html5)
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null) {
			
			var gl = __context.__gl;
			
			var size = __size >> miplevel;
			if (size == 0) return;
			
			var target = __sideToTarget (side);
			
			__context.__bindTexture (gl.TEXTURE_CUBE_MAP, __textureID);
			// GLUtils.CheckGLError ();
			
			gl.texImage2D (target, miplevel, __internalFormat, __format, gl.UNSIGNED_BYTE, image.buffer.src);
			// GLUtils.CheckGLError ();
			
			__context.__bindTexture (__textureTarget, null);
			// GLUtils.CheckGLError ();
			
			__uploadedSides |= 1 << side;
			return;
			
		}
		#end
		
		uploadFromTypedArray (image.data, side, miplevel);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void {
		
		#if (js && !display)
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b, side, miplevel);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset), side, miplevel);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, side:UInt, miplevel:UInt = 0):Void {
		
		if (data == null) return;
		
		var gl = __context.__gl;
		
		var size = __size >> miplevel;
		if (size == 0) return;
		
		var target = __sideToTarget (side);
		
		__context.__bindTexture (gl.TEXTURE_CUBE_MAP, __textureID);
		// GLUtils.CheckGLError ();
		
		gl.texImage2D (target, miplevel, __internalFormat, size, size, 0, __format, gl.UNSIGNED_BYTE, data);
		// GLUtils.CheckGLError ();
		
		__context.__bindTexture (__textureTarget, null);
		// GLUtils.CheckGLError ();
		
		__uploadedSides |= 1 << side;
		
		// var memUsage = (__size * __size) * 4;
		// __trackMemoryUsage (memUsage);
		
	}
	
	
	@:noCompletion private override function __setSamplerState (state:SamplerState):Bool {
		
		if (super.__setSamplerState (state)) {
			
			var gl = __context.__gl;
			
			if (state.minFilter != gl.NEAREST && state.minFilter != gl.LINEAR && !__samplerState.mipmapGenerated) {
				
				gl.generateMipmap (gl.TEXTURE_CUBE_MAP);
				// GLUtils.CheckGLError ();
				
				__samplerState.mipmapGenerated = true;
				
			}
			
			if (state.maxAniso != 0.0) {
				
				gl.texParameterf (gl.TEXTURE_CUBE_MAP, Context3D.TEXTURE_MAX_ANISOTROPY_EXT, state.maxAniso);
				// GLUtils.CheckGLError ();
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private function __sideToTarget (side:UInt) {
		
		var gl = __context.__gl;
		
		return switch (side) {
			
			case 0: gl.TEXTURE_CUBE_MAP_POSITIVE_X;
			case 1: gl.TEXTURE_CUBE_MAP_NEGATIVE_X;
			case 2: gl.TEXTURE_CUBE_MAP_POSITIVE_Y;
			case 3: gl.TEXTURE_CUBE_MAP_NEGATIVE_Y;
			case 4: gl.TEXTURE_CUBE_MAP_POSITIVE_Z;
			case 5: gl.TEXTURE_CUBE_MAP_NEGATIVE_Z;
			default: throw new IllegalOperationError ();
			
		}
		
	}
	
	
	@:noCompletion private function __uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		var reader = new ATFReader (data, byteArrayOffset);
		var alpha = reader.readHeader (__size, __size, true);
		
		var gl = __context.__gl;
		
		__context.__bindTexture (__textureTarget, __textureID);
		// GLUtils.CheckGLError ();
		
		var hasTexture = false;
		
		reader.readTextures (function (side, level, gpuFormat, width, height, blockLength, bytes) {
			
			var format = alpha ? TextureBase.__compressedFormatsAlpha[gpuFormat] : TextureBase.__compressedFormats[gpuFormat];
			if (format == 0) return;
			
			hasTexture = true;
			var target = __sideToTarget (side);
			
			__format = format;
			__internalFormat = format;
			
			if (alpha && gpuFormat == 2) {
				
				var size = Std.int (blockLength / 2);
				
				gl.compressedTexImage2D (target, level, __internalFormat, width, height, 0, new UInt8Array (#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));
				// GLUtils.CheckGLError ();
				
				var alphaTexture = new CubeTexture (__context, __size, Context3DTextureFormat.COMPRESSED, __optimizeForRenderToTexture, __streamingLevels);
				alphaTexture.__format = format;
				alphaTexture.__internalFormat = format;
				
				__context.__bindTexture (alphaTexture.__textureTarget, alphaTexture.__textureID);
				// GLUtils.CheckGLError ();
				
				gl.compressedTexImage2D (target, level, alphaTexture.__internalFormat, width, height, 0, new UInt8Array (#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));
				// GLUtils.CheckGLError ();
				
				__alphaTexture = alphaTexture;
				
			} else {
				
				gl.compressedTexImage2D (target, level, __internalFormat, width, height, 0, new UInt8Array (#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, blockLength));
				// GLUtils.CheckGLError ();
				
			}
			
			// __trackCompressedMemoryUsage (blockLength);
			
		});
		
		if (!hasTexture) {
			
			for (side in 0...6) {
				
				var data = new UInt8Array (__size * __size * 4);
				gl.texImage2D (__sideToTarget (side), 0, __internalFormat, __size, __size, 0, __format, gl.UNSIGNED_BYTE, data);
				// GLUtils.CheckGLError ();
				
			}
			
		}
		
		__context.__bindTexture (__textureTarget, null);
		// GLUtils.CheckGLError ();
		
	}
	
	
	
}


#else
typedef CubeTexture = flash.display3D.textures.CubeTexture;
#end