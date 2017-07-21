package openfl.display3D.textures;


import lime.graphics.GLRenderContext;
import lime.graphics.utils.ImageCanvasUtil;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.BitmapData)
@:access(openfl.display3D.Context3D)
@:access(openfl._internal.stage3D.SamplerState)


class TextureBase extends EventDispatcher {
	
	
	private static var __supportsBGRA:Null<Bool> = null;
	private static var __textureFormat:Int;
	private static var __textureInternalFormat:Int;

	private static var __supportsCompressed:Null<Bool> = null;
	private static var __textureFormatCompressed:Int;
	private static var __textureFormatCompressedAlpha:Int;

	private var __alphaTexture:Texture;
	private var __compressedMemoryUsage:Int;
	private var __context:Context3D;
	private var __format:Int;
	private var __height:Int;
	private var __internalFormat:Int;
	private var __memoryUsage:Int;
	private var __optimizeForRenderToTexture:Bool;
	private var __outputTextureMemoryUsage:Bool = false;
	private var __samplerState:SamplerState;
	private var __streamingLevels:Int;
	private var __textureContext:GLRenderContext;
	private var __textureID:GLTexture;
	private var __textureTarget:Int;
	private var __width:Int;
	
	
	private function new (context:Context3D, target:Int) {
		
		super ();
		
		__context = context;
		__textureTarget = target;
		
		__textureID = GL.createTexture ();
		__textureContext = GL.context;

		if (__supportsBGRA == null) {
			
			__textureInternalFormat = GL.RGBA;
			
			var bgraExtension = null;
			#if (!js || !html5)
			bgraExtension = GL.getExtension ("EXT_bgra");
			if (bgraExtension == null)
				bgraExtension = GL.getExtension ("EXT_texture_format_BGRA8888");
			if (bgraExtension == null)
				bgraExtension = GL.getExtension ("APPLE_texture_format_BGRA8888");
			#end
			
			if (bgraExtension != null) {
				
				__supportsBGRA = true;
				__textureFormat = bgraExtension.BGRA_EXT;
				
				#if (!ios && !tvos)
				if (GL.type == GLES) {
					
					__textureInternalFormat = bgraExtension.BGRA_EXT;
					
				}
				#end
				
			} else {
				
				__supportsBGRA = false;
				__textureFormat = GL.RGBA;
				
			}
			
		}

		if (__supportsCompressed == null) {
			
			#if (js && html5)
			var compressedExtension = GL.getExtension ("WEBGL_compressed_texture_s3tc");
			#else
			var compressedExtension = GL.getExtension ("EXT_texture_compression_s3tc");
			#end
			
			if (compressedExtension != null) {

				__supportsCompressed = true;
				__textureFormatCompressed = compressedExtension.COMPRESSED_RGBA_S3TC_DXT1_EXT;
				__textureFormatCompressedAlpha = compressedExtension.COMPRESSED_RGBA_S3TC_DXT5_EXT;

			} else {

				__supportsCompressed = false;

			}
			
		}
		
		__internalFormat = __textureInternalFormat;
		__format = __textureFormat;
		
		__memoryUsage = 0;
		__compressedMemoryUsage = 0;
		
	}
	
	
	public function dispose ():Void {
		
		if (__alphaTexture != null) {
			
			__alphaTexture.dispose ();
			
		}
		
		GL.deleteTexture (__textureID);
		
		if (__compressedMemoryUsage > 0) {
			
			__context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_TEXTURE_COMPRESSED);
			var currentCompressedMemory = __context.__statsSubtract (Context3D.Context3DTelemetry.MEM_TEXTURE_COMPRESSED, __compressedMemoryUsage);
			
			#if debug
			if (__outputTextureMemoryUsage) {
				
				trace (" - Texture Compressed GPU Memory (-" + __compressedMemoryUsage + ") - Current Compressed Memory : " + currentCompressedMemory);
				
			}
			#end
			
			__compressedMemoryUsage = 0;
			
		}
		
		if (__memoryUsage > 0) {
			
			__context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_TEXTURE);
			var currentMemory = __context.__statsSubtract (Context3D.Context3DTelemetry.MEM_TEXTURE, __memoryUsage);
			
			#if debug
			if (__outputTextureMemoryUsage) {
				
				trace (" - Texture GPU Memory (-" + __memoryUsage + ") - Current Memory : " + currentMemory);
				
			}
			#end
			
			__memoryUsage = 0;
			
		}
		
	}
	
	
	private function __getATFVersion (data:ByteArray):UInt {
		
		var signature = data.readUTFBytes (3);
		
		if (signature != "ATF") {
			
			throw new IllegalOperationError ("ATF signature not found");
			
		}
		
		var position = data.position;
		var version = 0;
		
		if (data.bytesAvailable >= 5) {
			
			var sig = __readUInt32 (data);
			
			if (sig == 0xff) {
				
				version = data.readUnsignedByte ();
				
			} else {
				
				data.position = position;
				
			}
			
		}
		
		return version;
		
	}
	
	
	private function __getImage (bitmapData:BitmapData):Image {
		
		var image =	bitmapData.image;
		
		if (!bitmapData.__isValid || image == null) {
			
			return null;
			
		}
		
		#if (js && html5)
		ImageCanvasUtil.sync (image, false);
		#end
		
		#if (js && html5)
		
		if (image.type != DATA && !image.premultiplied) {
			
			GL.pixelStorei (GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
			
		} else if (!image.premultiplied && image.transparent) {
			
			GL.pixelStorei (GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);
			image = image.clone ();
			image.premultiplied = true;
			
		}
		
		// TODO: Some way to support BGRA on WebGL?
		
		if (image.format != RGBA32) {
			
			image = image.clone ();
			image.format = RGBA32;
			image.buffer.premultiplied = true;
			#if openfl_power_of_two
			image.powerOfTwo = true;
			#end
			
		}
		
		#else
		
		if (#if openfl_power_of_two !image.powerOfTwo || #end (!image.premultiplied && image.transparent)) {
			
			image = image.clone ();
			image.premultiplied = true;
			#if openfl_power_of_two
			image.powerOfTwo = true;
			#end
			
		}
		
		#end
		
		return image;
		
	}
	
	
	private function __getTexture ():GLTexture {
		
		return __textureID;
		
	}
	
	
	private function __readUInt24 (data:ByteArray):UInt {
		
		var value:UInt;
		value = (data.readUnsignedByte () << 16);
		value |= (data.readUnsignedByte () << 8);
		value |= data.readUnsignedByte ();
		return value;
		
	}
	
	
	private function __readUInt32 (data:ByteArray):UInt {
		
		var value:UInt;
		value = (data.readUnsignedByte () << 24);
		value |= (data.readUnsignedByte () << 16);
		value |= (data.readUnsignedByte () << 8);
		value |= data.readUnsignedByte ();
		return value;
		
	}
	
	
	private function __setSamplerState (state:SamplerState):Void {
		
		if (!state.equals (__samplerState)) {
			
			GL.bindTexture (__textureTarget, __textureID);
			GLUtils.CheckGLError ();
			GL.texParameteri (__textureTarget, GL.TEXTURE_MIN_FILTER, state.minFilter);
			GLUtils.CheckGLError ();
			GL.texParameteri (__textureTarget, GL.TEXTURE_MAG_FILTER, state.magFilter);
			GLUtils.CheckGLError ();
			GL.texParameteri (__textureTarget, GL.TEXTURE_WRAP_S, state.wrapModeS);
			GLUtils.CheckGLError ();
			GL.texParameteri (__textureTarget, GL.TEXTURE_WRAP_T, state.wrapModeT);
			GLUtils.CheckGLError ();
			
			if (state.lodBias != 0.0) {
				
				// TODO
				//throw new IllegalOperationError("Lod bias setting not supported yet");
				
			}
			
			__samplerState = state;
			__samplerState.__samplerDirty = false;
			
		}
		
	}
	
	
	private function __trackCompressedMemoryUsage (memory:Int):Void {
		
		if (__compressedMemoryUsage == 0) {
			
			__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_TEXTURE_COMPRESSED);
			
		}
		
		__compressedMemoryUsage += memory;
		var currentCompressedMemory = __context.__statsAdd (Context3D.Context3DTelemetry.MEM_TEXTURE_COMPRESSED, memory);
		
		#if debug
		if (__outputTextureMemoryUsage) {
			
			trace (" + Texture Compressed GPU Memory (+" + memory + ") - Current Compressed Memory : " + currentCompressedMemory);
			
		}
		#end
		
		__trackMemoryUsage (memory);
		
	}
	
	
	private function __trackMemoryUsage (memory:Int):Void {
		
		if (__memoryUsage == 0) {
			
			__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_TEXTURE);
			
		}
		
		__memoryUsage += memory;
		var currentMemory = __context.__statsAdd (Context3D.Context3DTelemetry.MEM_TEXTURE, memory);
		
		#if debug
		if (__outputTextureMemoryUsage) {
			
			trace (" + Texture GPU Memory (+" + memory + ") - Current Memory : " + currentMemory);
			
		}
		#end
		
	}
	
	
}