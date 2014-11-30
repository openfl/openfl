package openfl.net; #if !flash


import haxe.Timer;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.NetStatusEvent;
import openfl.media.SoundTransform;

#if (js && html5)
import js.html.VideoElement;
import js.Browser;
#end


class NetStream extends EventDispatcher {
	
	
	public var audioCodec:Int;
	public var bufferLength:Float;
	public var bufferTime:Float;
	public var bytesLoaded:Int;
	public var bytesTotal:Int;
	public var checkPolicyFile:Bool;
	public var client:Dynamic;
	public var currentFPS:Float;
	public var decodedFrames:Int;
	public var liveDelay:Float;
	public var objectEncoding:Int;
	public var soundTransform:SoundTransform;
	public var speed (get, set):Float;
	public var time:Float;
	public var videoCodec:Int;
	
	@:noCompletion private var __connection:NetConnection;
	@:noCompletion private var __timer:Timer;
	
	#if (js && html5)
	@:noCompletion private var __video (default, null):VideoElement;
	#end
	
	
	public function new (connection:NetConnection):Void {
		
		super ();
		
		__connection = connection;
		
		#if (js && html5)
		__video = cast Browser.document.createElement ("video");
		
		__video.addEventListener ("error", video_onError, false);
		__video.addEventListener ("waiting", video_onWaiting, false);
		__video.addEventListener ("ended", video_onEnd, false);
		__video.addEventListener ("pause", video_onPause, false);
		__video.addEventListener ("seeking", video_onSeeking, false);
		__video.addEventListener ("playing", video_onPlaying, false);
		__video.addEventListener ("timeupdate", video_onTimeUpdate, false);
		__video.addEventListener ("loadstart", video_onLoadStart, false);
		__video.addEventListener ("stalled", video_onStalled, false);
		__video.addEventListener ("durationchanged", video_onDurationChanged, false);
		__video.addEventListener ("canplay", video_onCanPlay, false);
		__video.addEventListener ("canplaythrough", video_onCanPlayThrough, false);
		#end
		
	}
	
	
	public function pause ():Void {
		
		#if (js && html5)
		__video.pause ();
		#end
		
	}
	
	
	public function play (url:String, ?_, ?_, ?_, ?_, ?_):Void {
		
		#if (js && html5)
		__video.src = url;
		__video.play ();
		#end
		
	}
	
	
	public function requestVideoStatus ():Void {
		
		#if (js && html5)
		if (__timer == null) {
			
			__timer = new Timer (1);
			
		}
		
		__timer.run = function () {
			
			if (__video.paused) {
				
				__playStatus ("NetStream.Play.pause");
				
			} else {
				
				__playStatus ("NetStream.Play.playing");
				
			}
			
			__timer.stop ();
			
		};
		#end
		
	}
	
	
	public function resume ():Void {
		
		#if (js && html5)
		__video.play ();
		#end
		
	}
	
	
	public function seek (offset:Float):Void {
		
		#if (js && html5)
		var time = __video.currentTime + offset;
		
		if (time < 0) {
			
			time = 0;
			
		} else if (time > __video.duration) {
			
			time = __video.duration;
			
		}
		
		__video.currentTime = time;
		#end
		
	}
	
	
	public function togglePause ():Void {
		
		#if (js && html5)
		if (__video.paused) {
			
			__video.play ();
			
		} else {
			
			__video.pause ();
			
		}
		#end
		
	}
	
	
	@:noCompletion private function __playStatus (code:String):Void {
		
		#if (js && html5)
		if (client != null) {
			
			try {
				
				var handler = client.onPlayStatus;
				handler ({ 
					
					code: code,
					duration: __video.duration,
					position: __video.currentTime,
					speed: __video.playbackRate,
					start: __video.startTime
					
				});
				
			} catch (e:Dynamic) {}
			
		}
		#end
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function video_onCanPlay (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.canplay");
		
	}
	
	
	@:noCompletion private function video_onCanPlayThrough (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.canplaythrough");
		
	}
	
	
	@:noCompletion private function video_onDurationChanged (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.durationchanged");
		
	}
	
	
	@:noCompletion private function video_onEnd (event:Dynamic):Void {
		
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : "NetStream.Play.Stop" } ));
		__playStatus ("NetStream.Play.Complete");
		
	}
	
	
	@:noCompletion private function video_onError (event:Dynamic):Void {
		
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : "NetStream.Play.Stop" } ));
		__playStatus ("NetStream.Play.error");
		
	}
	
	
	@:noCompletion private function video_onLoadStart (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.loadstart");
		
	}
	
	
	@:noCompletion private function video_onPause (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.pause");
		
	}
	
	
	@:noCompletion private function video_onPlaying (event:Dynamic):Void {
		
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : "NetStream.Play.Start" } ));
		__playStatus ("NetStream.Play.playing");
		
	}
	
	
	@:noCompletion private function video_onSeeking (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.seeking");
		
	}
	
	
	@:noCompletion private function video_onStalled (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.stalled");
		
	}
	
	
	@:noCompletion private function video_onTimeUpdate (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.timeupdate");
		
	}
	
	
	@:noCompletion private function video_onWaiting (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.waiting");
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_speed ():Float {
		
		#if (js && html5)
		return __video.playbackRate;
		#else
		return 1;
		#end
		
	}
	
	
	@:noCompletion private function set_speed (value:Float):Float {
		
		#if (js && html5)
		return __video.playbackRate = value;
		#else
		return value;
		#end
		
	}
	
	
}


#else
typedef NetStream = flash.net.NetStream;
#end