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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class NetStream extends EventDispatcher {
	
	
	// @:noCompletion @:dox(hide) @:require(flash10) public static var CONNECT_TO_FMS:String;
	// @:noCompletion @:dox(hide) @:require(flash10) public static var DIRECT_CONNECTIONS:String;
	
	public var audioCodec (default, null):Int;
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioReliable:Bool;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioSampleAccess:Bool;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferLength (default, null):Float;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferTime:Float;
	
	public var bufferLength (default, null):Float;
	public var bufferTime:Float;
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var bufferTimeMax:Float;
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var checkPolicyFile:Bool;
	public var client:Dynamic;
	public var currentFPS (default, null):Float;
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var dataReliable:Bool;
	
	public var decodedFrames (default, null):Int;
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
	// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var inBufferSeek:Bool;
	// @:noCompletion @:dox(hide) @:require(flash10) public var info (default, null):flash.net.NetStreamInfo;
	
	public var liveDelay (default, null):Float;
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var maxPauseBufferTime:Float;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilitySendToAll:Bool;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilityUpdatePeriod:Float;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastFetchPeriod:Float;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastInfo (default, null):flash.net.NetStreamMulticastInfo;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastPushNeighborLimit:Float;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastRelayMarginDuration:Float;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastWindowDuration:Float;
	// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
	
	public var objectEncoding (default, null):ObjectEncoding;
	
	// @:noCompletion @:dox(hide) @:require(flash10) public var peerStreams (default, null):Array<Dynamic>;
	
	public var soundTransform:SoundTransform;
	public var speed (get, set):Float;
	public var time (default, null):Float;
	
	// @:noCompletion @:dox(hide) @:require(flash11) public var useHardwareDecoder:Bool;
	// @:noCompletion @:dox(hide) @:require(flash11_3) public var useJitterBuffer:Bool;
	
	public var videoCode (default, null):Int;
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoReliable:Bool;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoSampleAccess:Bool;
	// @:noCompletion @:dox(hide) @:require(flash11) public var videoStreamSettings:flash.media.VideoStreamSettings;
	
	
	@:noCompletion private var __closed:Bool;
	@:noCompletion private var __connection:NetConnection;
	@:noCompletion private var __timer:Timer;
	
	#if (js && html5)
	@:noCompletion private var __video (default, null):VideoElement;
	#end
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (NetStream.prototype, "speed", { get: untyped __js__ ("function () { return this.get_speed (); }"), set: untyped __js__ ("function (v) { return this.set_speed (v); }") });
		
	}
	#end
	
	
	public function new (connection:NetConnection, peerID:String = null):Void {
		
		super ();
		
		__connection = connection;
		
		#if (js && html5)
		__video = cast Browser.document.createElement ("video");

		__video.setAttribute("playsinline", "");
		__video.setAttribute("webkit-playsinline", "");

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
		__video.addEventListener ("loadedmetadata", video_onLoadMetaData, false);
		#end
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytes (bytes:ByteArray):Void;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytesAction (netStreamAppendBytesAction:String):Void;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function attach (connection:NetConnection):Void;
	// @:noCompletion @:dox(hide) public function attachAudio (microphone:flash.media.Microphone):Void;
	// @:noCompletion @:dox(hide) public function attachCamera (theCamera:flash.media.Camera, snapshotMilliseconds:Int = -1):Void;
	
	
	public function close ():Void {
		
		#if (js && html5)
		if (__video == null) return;
		
		__closed = true;
		__video.pause ();
		__video.src = "";
		time = 0;
		#end
		
	}
	
	
	public function dispose ():Void {
		
		#if (js && html5)
		close ();
		__video = null;
		#end
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10) public function onPeerConnect (subscriber:NetStream):Bool;
	
	
	public function pause ():Void {
		
		#if (js && html5)
		if (__video != null) __video.pause ();
		#end
		
	}
	
	
	public function play (url:String, ?_, ?_, ?_, ?_, ?_):Void {
		
		#if (js && html5)
		if (__video == null) return;
		
		__video.src = url;
		__video.play ();
		#end
		
	}
	
	
	// @:noCompletion @:dox(hide) @:require(flash10) public function play2 (param:flash.net.NetStreamPlayOptions):Void;
	// @:noCompletion @:dox(hide) public function publish (?name:String, ?type:String):Void;
	// @:noCompletion @:dox(hide) public function receiveAudio (flag:Bool):Void;
	// @:noCompletion @:dox(hide) public function receiveVideo (flag:Bool):Void;
	// @:noCompletion @:dox(hide) public function receiveVideoFPS (FPS:Float):Void;
	// //public function requestVideoStatus ():Void;
	// @:noCompletion @:dox(hide) public static function resetDRMVouchers ():Void;
	
	
	public function requestVideoStatus ():Void {
		
		#if (js && html5)
		if (__video == null) return;
		
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
		if (__video != null) __video.play ();
		#end
		
	}
	
	
	public function seek (time:Float):Void {
		
		#if (js && html5)
		if (__video == null) return;
		
		if (time < 0) {
			
			time = 0;
			
		} else if (time > __video.duration) {
			
			time = __video.duration;
			
		}
		
		__video.currentTime = time;
		
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : "NetStream.Seek.Complete" } ));
		#end
		
	}
	
	
	// @:noCompletion @:dox(hide) public function send (handlerName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function step (frames:Int):Void;
	
	
	public function togglePause ():Void {
		
		#if (js && html5)
		if (__video == null) return;
		
		if (__video.paused) {
			
			__video.play ();
			
		} else {
			
			__video.pause ();
			
		}
		#end
		
	}
	
	
	@:noCompletion private function __playStatus (code:String):Void {
		
		#if (js && html5)
		if (__video == null) return;
		
		if (client != null) {
			
			try {
				
				var handler = client.onPlayStatus;
				handler ({ 
					
					code: code,
					duration: __video.duration,
					position: __video.currentTime,
					speed: __video.playbackRate,
					start: untyped __video.startTime
					
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
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : "NetStream.Play.Complete" } ));
		__playStatus ("NetStream.Play.Complete");
		
	}
	
	
	@:noCompletion private function video_onError (event:Dynamic):Void {
		
		__connection.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, false, { code : "NetStream.Play.Stop" } ));
		__playStatus ("NetStream.Play.error");
		
	}
	
	
	@:noCompletion private function video_onLoadMetaData (event:Dynamic):Void {
		
		#if (js && html5)
		if (__video == null) return;
		
		if (client != null) {
			
			try {
				
				var handler = client.onMetaData;
				handler ({
					
					width: __video.videoWidth,
					height: __video.videoHeight,
					duration: __video.duration
					
				});
				
			} catch (e:Dynamic) {}
			
		}
		#end
		
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
		
		#if (js && html5)
		if (__video == null) return;
		
		time = __video.currentTime;
		#end
		
		__playStatus ("NetStream.Play.timeupdate");
		
	}
	
	
	@:noCompletion private function video_onWaiting (event:Dynamic):Void {
		
		__playStatus ("NetStream.Play.waiting");
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_speed ():Float {
		
		#if (js && html5)
		return __video != null ? __video.playbackRate : 1;
		#else
		return 1;
		#end
		
	}
	
	
	@:noCompletion private function set_speed (value:Float):Float {
		
		#if (js && html5)
		return __video != null ? __video.playbackRate = value : value;
		#else
		return value;
		#end
		
	}
	
	
}


#else
typedef NetStream = flash.net.NetStream;
#end