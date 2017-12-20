package openfl.display3D.textures;


import haxe.Timer;
import lime.graphics.opengl.GLTexture;
import openfl._internal.stage3D.opengl.GLVideoTexture;
import openfl._internal.stage3D.GLUtils;
import openfl.events.Event;
import openfl.net.NetStream;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.net.NetStream)


@:final class VideoTexture extends TextureBase {
	
	
	public var videoHeight (default, null):Int;
	public var videoWidth (default, null):Int;
	
	private var __netStream:NetStream;
	
	
	private function new (context:Context3D) {
		
		super (context);
		
		GLVideoTexture.create (this, __context.__renderSession);
		
	}
	
	
	//public function attachCamera (theCamera:Camera):Void {}
	
	
	public function attachNetStream (netStream:NetStream):Void {
		
		__netStream = netStream;
		
		#if (js && html5)
		
		if (__netStream.__video.readyState == 4) {
			
			Timer.delay (function () {
				
				__textureReady ();
				
			}, 0);
			
		} else {
			
			__netStream.__video.addEventListener ("canplay", function (_) {
				
				__textureReady ();
				
			}, false);
			
		}
		
		#end
		
	}
	
	
	private override function __getTexture ():GLTexture {
		
		return GLVideoTexture.getTexture (this, __context.__renderSession);
		
	}
	
	
	private function __textureReady ():Void {
		
		#if (js && html5)
		
		videoWidth = __netStream.__video.videoWidth;
		videoHeight = __netStream.__video.videoHeight;
		
		#end
		
		dispatchEvent (new Event (Event.TEXTURE_READY));
		
	}
	
	
}