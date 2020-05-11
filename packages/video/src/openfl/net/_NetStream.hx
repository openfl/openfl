package openfl.net;

import haxe.Timer;
import openfl.events.EventDispatcher;
import openfl.events.NetStatusEvent;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
#if openfl_html5
import js.html.VideoElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.media.SoundMixer)
@:access(openfl.net.NetStream)
@:noCompletion
class _NetStream extends _EventDispatcher
{
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
	public var objectEncoding:ObjectEncoding;
	public var soundTransform(get, set):SoundTransform;
	public var speed(get, set):Float;
	public var time:Float;
	#if openfl_html5
	public var video:VideoElement;
	#end
	public var videoCode:Int;

	public var timer:Timer;
	public var __closed:Bool;
	public var __connection:NetConnection;
	public var __soundTransform:SoundTransform;

	public function new(connection:NetConnection, peerID:String = null):Void
	{
		super();

		__connection = connection;
		__soundTransform = new SoundTransform();

		#if openfl_html5
		video = cast Browser.document.createElement("video");

		video.setAttribute("playsinline", "");
		video.setAttribute("webkit-playsinline", "");
		video.setAttribute("crossorigin", "anonymous");

		video.addEventListener("error", video_onError, false);
		video.addEventListener("waiting", video_onWaiting, false);
		video.addEventListener("ended", video_onEnd, false);
		video.addEventListener("pause", video_onPause, false);
		video.addEventListener("seeking", video_onSeeking, false);
		video.addEventListener("playing", video_onPlaying, false);
		video.addEventListener("timeupdate", video_onTimeUpdate, false);
		video.addEventListener("loadstart", video_onLoadStart, false);
		video.addEventListener("stalled", video_onStalled, false);
		video.addEventListener("durationchanged", video_onDurationChanged, false);
		video.addEventListener("canplay", video_onCanPlay, false);
		video.addEventListener("canplaythrough", video_onCanPlayThrough, false);
		video.addEventListener("loadedmetadata", video_onLoadMetaData, false);
		#end
	}

	public function close():Void
	{
		__closed = true;
		#if openfl_html5
		if (video == null) return;

		video.pause();
		video.src = "";
		parent.time = 0;
		#end
	}

	public function dispatchStatus(code:String):Void
	{
		var event = new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code: code});
		parent._.__connection.dispatchEvent(event);
		parent.dispatchEvent(event);
	}

	public function dispose():Void
	{
		close();
		#if openfl_html5
		video = null;
		#end
	}

	public function pause():Void
	{
		#if openfl_html5
		if (video != null) video.pause();
		#end
	}

	public function play(url:#if (openfl_html5 && !openfl_doc_gen) Dynamic #else String #end, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null):Void
	{
		#if openfl_html5
		if (video == null) return;

		video.volume = SoundMixer.soundTransform.volume * parent._.__soundTransform.volume;

		if (Std.is(url, String))
		{
			video.src = url;
		}
		else
		{
			video.srcObject = url;
		}

		video.play();
		#end
	}

	public function playStatus(code:String):Void
	{
		if (video == null) return;

		if (parent.client != null)
		{
			try
			{
				var handler = parent.client.onPlayStatus;
				handler({
					code: code,
					duration: video.duration,
					position: video.currentTime,
					speed: video.playbackRate,
					start: untyped video.startTime
				});
			}
			catch (e:Dynamic) {}
		}
	}

	public function resume():Void
	{
		#if openfl_html5
		if (video != null) video.play();
		#end
	}

	public function seek(time:Float):Void
	{
		#if openfl_html5
		if (video == null) return;

		if (time < 0)
		{
			time = 0;
		}
		else if (time > video.duration)
		{
			time = video.duration;
		}

		dispatchStatus("NetStream.SeekStart.Notify");
		video.currentTime = time;
		#end
	}

	public function togglePause():Void
	{
		#if openfl_html5
		if (video == null) return;

		if (video.paused)
		{
			video.play();
		}
		else
		{
			video.pause();
		}
		#end
	}

	#if openfl_html5
	public function __getVideoElement():VideoElement
	{
		return _.video;
	}
	#end

	// Event Handlers
	public function video_onCanPlay(event:Dynamic):Void
	{
		playStatus("NetStream.Play.canplay");
	}

	public function video_onCanPlayThrough(event:Dynamic):Void
	{
		playStatus("NetStream.Play.canplaythrough");
	}

	public function video_onDurationChanged(event:Dynamic):Void
	{
		playStatus("NetStream.Play.durationchanged");
	}

	public function video_onEnd(event:Dynamic):Void
	{
		dispatchStatus("NetStream.Play.Stop");
		dispatchStatus("NetStream.Play.Complete");
		playStatus("NetStream.Play.Stop");
		playStatus("NetStream.Play.Complete");
	}

	public function video_onError(event:Dynamic):Void
	{
		dispatchStatus("NetStream.Play.Stop");
		playStatus("NetStream.Play.error");
	}

	public function video_onLoadMetaData(event:Dynamic):Void
	{
		if (video == null) return;

		if (parent.client != null)
		{
			try
			{
				var handler = parent.client.onMetaData;
				handler({
					width: video.videoWidth,
					height: video.videoHeight,
					duration: video.duration
				});
			}
			catch (e:Dynamic) {}
		}
	}

	public function video_onLoadStart(event:Dynamic):Void
	{
		playStatus("NetStream.Play.loadstart");
	}

	public function video_onPause(event:Dynamic):Void
	{
		playStatus("NetStream.Play.pause");
	}

	public function video_onPlaying(event:Dynamic):Void
	{
		dispatchStatus("NetStream.Play.Start");
		playStatus("NetStream.Play.Start");
		playStatus("NetStream.Play.playing");
	}

	public function video_onSeeking(event:Dynamic):Void
	{
		playStatus("NetStream.Play.seeking");

		dispatchStatus("NetStream.Seek.Complete");
	}

	public function video_onStalled(event:Dynamic):Void
	{
		playStatus("NetStream.Play.stalled");
	}

	public function video_onTimeUpdate(event:Dynamic):Void
	{
		if (video == null) return;

		parent.time = video.currentTime;

		playStatus("NetStream.Play.timeupdate");
	}

	public function video_onWaiting(event:Dynamic):Void
	{
		playStatus("NetStream.Play.waiting");
	}

	// Get & Set Methods

	private function get_soundTransform():SoundTransform
	{
		return __soundTransform.clone();
	}

	private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		if (value != null)
		{
			__soundTransform.pan = value.pan;
			__soundTransform.volume = value.volume;

			#if openfl_html5
			if (video != null)
			{
				video.volume = SoundMixer.soundTransform.volume * parent._.__soundTransform.volume;
			}
			#end
		}

		return value;
	}

	private function get_speed():Float
	{
		#if openfl_html5
		return video != null ? video.playbackRate : 1;
		#else
		return 1;
		#end
	}

	private function set_speed(value:Float):Float
	{
		#if openfl_html5
		video != null ? video.playbackRate = value : value;
		#end
		return value;
	}
}
