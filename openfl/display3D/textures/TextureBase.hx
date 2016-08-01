package openfl.display3D.textures;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.SamplerState;
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;


class TextureBase extends EventDispatcher {
	
	
	private var __allocated:Bool = false;
	private var __alphaTexture:Texture;
	private var __compressedMemoryUsage:Int;
	private var __context:Context3D;
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
	
	
	private function __setSamplerState (state:SamplerState):Void {
		
		if (!state.equals (__samplerState)) {
			
			GL.bindTexture (__textureTarget, __textureID);
			GL.texParameteri (__textureTarget, GL.TEXTURE_MIN_FILTER, state.minFilter);
			GL.texParameteri (__textureTarget, GL.TEXTURE_MAG_FILTER, state.magFilter);
			GL.texParameteri (__textureTarget, GL.TEXTURE_WRAP_S, state.wrapModeS);
			GL.texParameteri (__textureTarget, GL.TEXTURE_WRAP_T, state.wrapModeT);
			
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