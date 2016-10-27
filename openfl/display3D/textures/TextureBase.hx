package openfl.display3D.textures;


import lime.graphics.utils.ImageCanvasUtil;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.SamplerState;
import openfl._internal.stage3D.GLUtils;
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;

@:access(openfl.display.BitmapData)
@:access(openfl.display3D.Context3D)


class TextureBase extends EventDispatcher {
	
	
	private static var __isGLES:Null<Bool>;
	
	private var __alphaTexture:Texture;
	private var __compressedMemoryUsage:Int;
	private var __context:Context3D;
	private var __format:Int;
	private var __internalFormat:Int;
	private var __memoryUsage:Int;
	private var __outputTextureMemoryUsage:Bool = false;
	private var __samplerState:SamplerState;
	private var __textureID:GLTexture;
	private var __textureTarget:Int;
	
	
	private function new (context:Context3D, target:Int) {
		
		super ();
		
		__context = context;
		__textureTarget = target;
		
		__textureID = GL.createTexture ();
		
		#if !sys
		
		__internalFormat = GL.RGBA;
		__format = GL.RGBA;
		
		#elseif (ios || tvos)
		
		__internalFormat = GL.RGBA;
		__format = GL.BGRA_EXT;
		
		#else
		
		if (__isGLES == null) {
			
			var version:String = GL.getParameter (GL.VERSION);
			__isGLES = (version.indexOf ("OpenGL ES") > -1 && version.indexOf ("WebGL") == -1);
			
		}
		
		__internalFormat = (__isGLES ? GL.BGRA_EXT : GL.RGBA);
		__format = GL.BGRA_EXT;
		
		#end
		
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