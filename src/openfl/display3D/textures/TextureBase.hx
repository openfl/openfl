package openfl.display3D.textures;


import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.opengl.GLTextureBase;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


class TextureBase extends EventDispatcher {
	
	
	private var __alphaTexture:TextureBase;
	// private var __compressedMemoryUsage:Int;
	private var __context:Context3D;
	private var __format:Int;
	private var __height:Int;
	private var __internalFormat:Int;
	// private var __memoryUsage:Int;
	private var __optimizeForRenderToTexture:Bool;
	// private var __outputTextureMemoryUsage:Bool = false;
	private var __samplerState:SamplerState;
	private var __streamingLevels:Int;
	private var __textureContext:GLRenderContext;
	private var __textureID:GLTexture;
	private var __textureTarget:Int;
	private var __width:Int;
	
	
	private function new (context:Context3D) {
		
		super ();
		
		__context = context;
		//__textureTarget = target;
		
		GLTextureBase.create (this, __context.__renderSession);
		
		// __memoryUsage = 0;
		// __compressedMemoryUsage = 0;
		
	}
	
	
	public function dispose ():Void {
		
		GLTextureBase.dispose (this, __context.__renderSession);
		
	}
	
	
	private function __getImage (bitmapData:BitmapData):Image {
		
		return GLTextureBase.getImage (this, __context.__renderSession, bitmapData);
		
	}
	
	
	private function __getTexture ():GLTexture {
		
		return __textureID;
		
	}
	
	
	private function __setSamplerState (state:SamplerState):Void {
		
		GLTextureBase.setSamplerState (this, __context.__renderSession, state);
		
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