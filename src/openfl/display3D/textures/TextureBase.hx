package openfl.display3D.textures; #if !flash


import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
import openfl._internal.renderer.opengl.GLCompressedTextureFormats;
import openfl._internal.renderer.SamplerState;
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
#else
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.renderer.SamplerState)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)


class TextureBase extends EventDispatcher {
	
	
	@:noCompletion private static var __compressedTextureFormats:Null<GLCompressedTextureFormats> = null;
	@:noCompletion private static var __supportsBGRA:Null<Bool> = null;
	@:noCompletion private static var __textureFormat:Int;
	@:noCompletion private static var __textureInternalFormat:Int;
	
	@:noCompletion private var __alphaTexture:TextureBase;
	// private var __compressedMemoryUsage:Int;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __format:Int;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __internalFormat:Int;
	// private var __memoryUsage:Int;
	@:noCompletion private var __optimizeForRenderToTexture:Bool;
	// private var __outputTextureMemoryUsage:Bool = false;
	@:noCompletion private var __samplerState:SamplerState;
	@:noCompletion private var __streamingLevels:Int;
	@:noCompletion private var __textureContext:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end;
	@:noCompletion private var __textureID:GLTexture;
	@:noCompletion private var __textureTarget:Int;
	@:noCompletion private var __width:Int;
	
	
	@:noCompletion private function new (context:Context3D) {
		
		super ();
		
		__context = context;
		var gl = __context.__gl;
		//__textureTarget = target;
		
		__textureID = gl.createTexture ();
		__textureContext = __context.__context;
		
		if (__supportsBGRA == null) {
			
			__textureInternalFormat = gl.RGBA;
			
			var bgraExtension = null;
			#if (!js || !html5)
			bgraExtension = gl.getExtension ("EXT_bgra");
			if (bgraExtension == null)
				bgraExtension = gl.getExtension ("EXT_texture_format_BGRA8888");
			if (bgraExtension == null)
				bgraExtension = gl.getExtension ("APPLE_texture_format_BGRA8888");
			#end
			
			if (bgraExtension != null) {
				
				__supportsBGRA = true;
				__textureFormat = bgraExtension.BGRA_EXT;
				
				#if (!ios && !tvos)
				if (#if (lime >= "7.0.0") context.__context.type == OPENGLES #else gl.type == GLES #end) {
					
					__textureInternalFormat = bgraExtension.BGRA_EXT;
					
				}
				#end
				
			} else {
				
				__supportsBGRA = false;
				__textureFormat = gl.RGBA;
				
			}
			
		}
		
		if (__compressedTextureFormats == null) {
			
			__compressedTextureFormats = new GLCompressedTextureFormats (context);
			
		}
		
		__internalFormat = __textureInternalFormat;
		__format = __textureFormat;
		
		// __memoryUsage = 0;
		// __compressedMemoryUsage = 0;
		
	}
	
	
	public function dispose ():Void {
		
		var gl = __context.__gl;
		
		if (__alphaTexture != null) {
			
			__alphaTexture.dispose ();
			
		}
		
		gl.deleteTexture (__textureID);
		
		// if (__compressedMemoryUsage > 0) {
			
		// 	__context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_TEXTURE_COMPRESSED);
		// 	var currentCompressedMemory = __context.__statsSubtract (Context3D.Context3DTelemetry.MEM_TEXTURE_COMPRESSED, __compressedMemoryUsage);
			
		// 	#if debug
		// 	if (__outputTextureMemoryUsage) {
				
		// 		trace (" - Texture Compressed GPU Memory (-" + __compressedMemoryUsage + ") - Current Compressed Memory : " + currentCompressedMemory);
				
		// 	}
		// 	#end
			
		// 	__compressedMemoryUsage = 0;
			
		// }
		
		// if (__memoryUsage > 0) {
			
		// 	__context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_TEXTURE);
		// 	var currentMemory = __context.__statsSubtract (Context3D.Context3DTelemetry.MEM_TEXTURE, __memoryUsage);
			
		// 	#if debug
		// 	if (__outputTextureMemoryUsage) {
				
		// 		trace (" - Texture GPU Memory (-" + __memoryUsage + ") - Current Memory : " + currentMemory);
				
		// 	}
		// 	#end
			
		// 	__memoryUsage = 0;
			
		// }
		
	}
	
	
	@:noCompletion private function __getImage (bitmapData:BitmapData):Image {
		
		var image = bitmapData.image;
		
		if (!bitmapData.__isValid || image == null) {
			
			return null;
			
		}
		
		#if (js && html5)
		ImageCanvasUtil.sync (image, false);
		#end
		
		#if (js && html5)
		var gl = __context.__gl;
		
		if (image.type != DATA && !image.premultiplied) {
			
			gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
			
		} else if (!image.premultiplied && image.transparent) {
			
			gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);
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
	
	
	@:noCompletion private function __getTexture ():GLTexture {
		
		return __textureID;
		
	}
	
	
	@:noCompletion private function __setSamplerState (state:SamplerState):Bool {
		
		if (!state.equals (__samplerState)) {
			
			var gl = __context.__gl;
			
			__context.__bindTexture (__textureTarget, __textureID);
			// GLUtils.CheckGLError ();
			gl.texParameteri (__textureTarget, gl.TEXTURE_MIN_FILTER, state.minFilter);
			// GLUtils.CheckGLError ();
			gl.texParameteri (__textureTarget, gl.TEXTURE_MAG_FILTER, state.magFilter);
			// GLUtils.CheckGLError ();
			gl.texParameteri (__textureTarget, gl.TEXTURE_WRAP_S, state.wrapModeS);
			// GLUtils.CheckGLError ();
			gl.texParameteri (__textureTarget, gl.TEXTURE_WRAP_T, state.wrapModeT);
			// GLUtils.CheckGLError ();
			
			if (state.lodBias != 0.0) {
				
				// TODO
				//throw new IllegalOperationError("Lod bias setting not supported yet");
				
			}
			
			if (__samplerState == null) __samplerState = state.clone ();
			__samplerState.copyFrom (state);
			__samplerState.__dirty = false;
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	// private function __trackCompressedMemoryUsage (memory:Int):Void {
		
	// 	if (__compressedMemoryUsage == 0) {
			
	// 		__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_TEXTURE_COMPRESSED);
			
	// 	}
		
	// 	__compressedMemoryUsage += memory;
	// 	var currentCompressedMemory = __context.__statsAdd (Context3D.Context3DTelemetry.MEM_TEXTURE_COMPRESSED, memory);
		
	// 	#if debug
	// 	if (__outputTextureMemoryUsage) {
			
	// 		trace (" + Texture Compressed GPU Memory (+" + memory + ") - Current Compressed Memory : " + currentCompressedMemory);
			
	// 	}
	// 	#end
		
	// 	__trackMemoryUsage (memory);
		
	// }
	
	
	// private function __trackMemoryUsage (memory:Int):Void {
		
	// 	if (__memoryUsage == 0) {
			
	// 		__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_TEXTURE);
			
	// 	}
		
	// 	__memoryUsage += memory;
	// 	var currentMemory = __context.__statsAdd (Context3D.Context3DTelemetry.MEM_TEXTURE, memory);
		
	// 	#if debug
	// 	if (__outputTextureMemoryUsage) {
			
	// 		trace (" + Texture GPU Memory (+" + memory + ") - Current Memory : " + currentMemory);
			
	// 	}
	// 	#end
		
	// }
	
	
}


#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end