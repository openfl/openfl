package openfl.display3D.textures; #if !flash


import haxe.Timer;
import lime.graphics.opengl.GL;
import lime.utils.ArrayBufferView;
import openfl._internal.stage3D.opengl.GLTexture;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


@:final class Texture extends TextureBase {
	
	
	@:noCompletion private static var __lowMemoryMode:Bool = false;
	
	
	@:noCompletion private function new (context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int) {
		
		super (context);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		__streamingLevels = streamingLevels;
		
		GLTexture.create (this, cast __context.__renderer);
		
	}
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void {
		
		if (!async) {
			
			GLTexture.uploadCompressedTextureFromByteArray (this, cast __context.__renderer, data, byteArrayOffset);
			
		} else {
			
			Timer.delay (function () {
				
				GLTexture.uploadCompressedTextureFromByteArray (this, cast __context.__renderer, data, byteArrayOffset);
				dispatchEvent (new Event (Event.TEXTURE_READY));
				
			}, 1);
			
		}
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData, miplevel:UInt = 0, generateMipmap:Bool = false):Void {
		
		GLTexture.uploadFromBitmapData (this, cast __context.__renderer, source, miplevel, generateMipmap);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void {
		
		GLTexture.uploadFromByteArray (this, cast __context.__renderer, data, byteArrayOffset, miplevel);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, miplevel:UInt = 0):Void {
		
		GLTexture.uploadFromTypedArray (this, cast __context.__renderer, data, miplevel);
		
	}
	
	
	@:noCompletion private override function __setSamplerState (state:SamplerState) {
		
		GLTexture.setSamplerState (this, cast __context.__renderer, state);
		
	}
	
	
}


#else
typedef Texture = flash.display3D.textures.Texture;
#end