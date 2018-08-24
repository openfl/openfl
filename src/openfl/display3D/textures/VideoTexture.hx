package openfl.display3D.textures; #if !flash


import haxe.Timer;
import lime.graphics.opengl.GLTexture;
import openfl.events.Event;
import openfl.net.NetStream;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.net.NetStream)


@:final class VideoTexture extends TextureBase {
	
	
	public var videoHeight (default, null):Int;
	public var videoWidth (default, null):Int;
	
	@:noCompletion private var __netStream:NetStream;
	
	
	@:noCompletion private function new (context:Context3D) {
		
		super (context);
		
		__textureTarget = __context.gl.TEXTURE_2D;
		
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
	
	
	@:noCompletion private override function __getTexture ():GLTexture {
		
		#if (js && html5)
		
		if (!__netStream.__video.paused) {
			
			var gl = __context.gl;
			
			__context.__bindGLTexture2D (__textureID);
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, __netStream.__video);
			
		}
		
		#end
		
		return __textureID;
		
	}
	
	
	@:noCompletion private function __textureReady ():Void {
		
		#if (js && html5)
		
		videoWidth = __netStream.__video.videoWidth;
		videoHeight = __netStream.__video.videoHeight;
		
		#end
		
		dispatchEvent (new Event (Event.TEXTURE_READY));
		
	}
	
	
}


#else
typedef VideoTexture = flash.display3D.textures.VideoTexture;
#end