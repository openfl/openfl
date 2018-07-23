package openfl.display3D.textures; #if !flash


import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.opengl.GLTextureBase;
import openfl._internal.stage3D.SamplerState;
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

@:access(openfl.display3D.Context3D)


class TextureBase extends EventDispatcher {
	
	
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
		//__textureTarget = target;
		
		GLTextureBase.create (this, cast __context.__renderer);
		
		// __memoryUsage = 0;
		// __compressedMemoryUsage = 0;
		
	}
	
	
	public function dispose ():Void {
		
		GLTextureBase.dispose (this, cast __context.__renderer);
		
	}
	
	
	@:noCompletion private function __getImage (bitmapData:BitmapData):Image {
		
		return GLTextureBase.getImage (this, cast __context.__renderer, bitmapData);
		
	}
	
	
	@:noCompletion private function __getTexture ():GLTexture {
		
		return __textureID;
		
	}
	
	
	@:noCompletion private function __setSamplerState (state:SamplerState):Void {
		
		GLTextureBase.setSamplerState (this, cast __context.__renderer, state);
		
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