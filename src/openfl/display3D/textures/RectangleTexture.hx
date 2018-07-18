package openfl.display3D.textures; #if !flash


import lime.utils.ArrayBufferView;
import openfl._internal.stage3D.opengl.GLRectangleTexture;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


@:final class RectangleTexture extends TextureBase {
	
	
	@:noCompletion private function new (context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool) {
		
		super (context);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		
		GLRectangleTexture.create (this, cast __context.__renderer);
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		GLRectangleTexture.uploadFromBitmapData (this, cast __context.__renderer, source);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		GLRectangleTexture.uploadFromByteArray (this, cast __context.__renderer, data, byteArrayOffset);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		GLRectangleTexture.uploadFromTypedArray (this, cast __context.__renderer, data);
		
	}
	
	
	@:noCompletion private override function __setSamplerState (state:SamplerState) {
		
		GLRectangleTexture.setSamplerState (this, cast __context.__renderer, state);
		
	}
	
	
}


#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end