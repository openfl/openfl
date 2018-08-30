package openfl.display3D.textures; #if !flash


import haxe.io.Bytes;
import haxe.Timer;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl._internal.formats.atf.ATFReader;
import openfl._internal.renderer.SamplerState;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


@:final class Texture extends TextureBase {
	
	
	@:noCompletion private static var __lowMemoryMode:Bool = false;
	
	
	@:noCompletion private function new (context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
		var gl = __context.gl;
		
		__textureTarget = gl.TEXTURE_2D;
		
		__context.__bindGLTexture2D (__textureID);
		gl.texImage2D (__textureTarget, 0, __internalFormat, __width, __height, 0, __format, gl.UNSIGNED_BYTE, null);
		__context.__bindGLTexture2D (null);
		
		if (optimizeForRenderToTexture) __getGLFramebuffer (true, 0, 0);
		
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
	
	
	public function uploadFromBitmapData (source:BitmapData, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
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
		
		var width = __width >> miplevel;
		var height = __height >> miplevel;
		
		if (width == 0 && height == 0) return;
		
		if (width == 0) width = 1;
		if (height == 0) height = 1;
		
		if (source.width != width || source.height != height) {
			
			var copy = new BitmapData (width, height, true, 0);
			copy.draw (source);
			source = copy;
			
		}
		
		var image = __getImage (source);
		if (image == null) return;
		
		// TODO: Improve handling of miplevels with canvas src
		
		#if (js && html5)
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null) {
			
			var gl = __context.gl;
			
			var width = __width >> miplevel;
			var height = __height >> miplevel;
			
			if (width == 0 && height == 0) return;
			
			if (width == 0) width = 1;
			if (height == 0) height = 1;
			
			__context.__bindGLTexture2D (__textureID);
			gl.texImage2D (__textureTarget, miplevel, __internalFormat, __format, gl.UNSIGNED_BYTE, image.buffer.src);
			__context.__bindGLTexture2D (null);
			
			return;
			
		}
		#end
		
		uploadFromTypedArray (image.data, miplevel);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void {
		
		#if (js && !display)
		if (byteArrayOffset == 0) {
			
			uploadFromTypedArray (@:privateAccess (data:ByteArrayData).b, miplevel);
			return;
			
		}
		#end
		
		uploadFromTypedArray (new UInt8Array (data.toArrayBuffer (), byteArrayOffset), miplevel);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, miplevel:UInt = 0):Void {
		
		if (data == null) return;
		
		var gl = __context.gl;
		
		var width = __width >> miplevel;
		var height = __height >> miplevel;
		
		if (width == 0 && height == 0) return;
		
		if (width == 0) width = 1;
		if (height == 0) height = 1;
		
		__context.__bindGLTexture2D (__textureID);
		gl.texImage2D (__textureTarget, miplevel, __internalFormat, width, height, 0, __format, gl.UNSIGNED_BYTE, data);
		__context.__bindGLTexture2D (null);
		
	}
	
	
	@:noCompletion private override function __setSamplerState (state:SamplerState):Bool {
		
		if (super.__setSamplerState (state)) {
			
			var gl = __context.gl;
			
			if (state.mipfilter != MIPNONE && !__samplerState.mipmapGenerated) {
				
				gl.generateMipmap (gl.TEXTURE_2D);
				__samplerState.mipmapGenerated = true;
					
			}
			
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
	
	
	@:noCompletion private function __uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		var reader = new ATFReader (data, byteArrayOffset);
		var alpha = reader.readHeader (__width, __height, false);
		
		var context = __context;
		var gl = context.gl;
		
		__context.__bindGLTexture2D (__textureID);
		
		var hasTexture = false;
		
		reader.readTextures (function (target, level, gpuFormat, width, height, blockLength, bytes:Bytes) {
			
			var format = alpha ? TextureBase.__compressedFormatsAlpha[gpuFormat] : TextureBase.__compressedFormats[gpuFormat];
			if (format == 0) return;
			
			hasTexture = true;
			__format = format;
			__internalFormat = format;
			
			if (alpha && gpuFormat == 2) {
				
				var size = Std.int (blockLength / 2);
				
				gl.compressedTexImage2D (__textureTarget, level, __internalFormat, width, height, 0, new UInt8Array (#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));
				
				var alphaTexture = new Texture (__context, __width, __height, Context3DTextureFormat.COMPRESSED, __optimizeForRenderToTexture, __streamingLevels);
				alphaTexture.__format = format;
				alphaTexture.__internalFormat = format;
				
				__context.__bindGLTexture2D (alphaTexture.__textureID);
				gl.compressedTexImage2D (alphaTexture.__textureTarget, level, alphaTexture.__internalFormat, width, height, 0, new UInt8Array (#if js @:privateAccess bytes.b.buffer #else bytes #end, size, size));
				
				__alphaTexture = alphaTexture;
				
			} else {
				
				gl.compressedTexImage2D (__textureTarget, level, __internalFormat, width, height, 0, new UInt8Array (#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, blockLength));
				
			}
			
		});
		
		if (!hasTexture) {
			
			var data = new UInt8Array (__width * __height * 4);
			gl.texImage2D (__textureTarget, 0, __internalFormat, __width, __height, 0, __format, gl.UNSIGNED_BYTE, data);
			
		}
		
		__context.__bindGLTexture2D (null);
		
	}
	
	
}


#else
typedef Texture = flash.display3D.textures.Texture;
#end