package openfl.display3D.textures;


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
	
	
	private function new (context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool) {
		
		super (context);
		
		__width = width;
		__height = height;
		//__format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;
		
		GLRectangleTexture.create (this, __context.__renderSession);
		
	}
	
	
	public function uploadFromBitmapData (source:BitmapData):Void {
		
		GLRectangleTexture.uploadFromBitmapData (this, __context.__renderSession, source);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void {
		
		GLRectangleTexture.uploadFromByteArray (this, __context.__renderSession, data, byteArrayOffset);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		GLRectangleTexture.uploadFromTypedArray (this, __context.__renderSession, data);
		
	}
	
	
	private override function __setSamplerState (state:SamplerState) {
		
		GLRectangleTexture.setSamplerState (this, __context.__renderSession, state);
		
	}
	
	
}