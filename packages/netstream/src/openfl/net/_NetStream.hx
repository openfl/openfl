package openfl.net;

#if openfl_html5
import haxe.Timer;
import js.html.VideoElement;
import js.Browser;
import openfl.events.NetStatusEvent;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
import openfl.net.NetStream;
@:access(openfl.media.SoundMixer)
@:access(openfl.net.NetStream)
@:noCompletion
class _NetStream
{
	public var video:VideoElement;

	private var parent:NetStream;
	private var timer:Timer;

	public function new(parent:NetStream):Void
	{
		this.parent = parent;

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
	}

	public function close():Void
	{
		if (video == null) return;

		video.pause();
		video.src = "";
		parent.time = 0;
	}

	private function dispatchStatus(code:String):Void
	{
		var event = new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code: code});
		parent.__connection.dispatchEvent(event);
		parent.dispatchEvent(event);
	}

	public function dispose():Void
	{
		close();
		video = null;
	}

	public function getSeeking():Bool
	{
		return (video != null && video.seeking);
	}

	public function getSpeed():Float
	{
		return video != null ? video.playbackRate : 1;
	}

	public function pause():Void
	{
		if (video != null) video.pause();
	}

	public function play(url:Dynamic, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null):Void
	{
		if (video == null) return;

		video.volume = SoundMixer.soundTransform.volume * parent.__soundTransform.volume;

		if (Std.is(url, String))
		{
			video.src = url;
		}
		else
		{
			video.srcObject = url;
		}

		video.play();
	}

	public function requestVideoStatus():Void
	{
		if (video == null) return;

		if (timer == null)
		{
			timer = new Timer(1);
		}

		timer.run = function()
		{
			if (video.paused)
			{
				playStatus("NetStream.Play.Stop");
				playStatus("NetStream.Play.pause");
			}
			else
			{
				playStatus("NetStream.Play.Start");
				playStatus("NetStream.Play.playing");
			}

			timer.stop();
		};
	}

	public function resume():Void
	{
		if (video != null) video.play();
	}

	public function seek(time:Float):Void
	{
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
	}

	public function setSoundTransform(value:SoundTransform):Void
	{
		if (video != null)
		{
			video.volume = SoundMixer.soundTransform.volume * parent.__soundTransform.volume;
		}
	}

	public function setSpeed(value:Float):Void
	{
		video != null ? video.playbackRate = value : value;
	}

	public function togglePause():Void
	{
		if (video == null) return;

		if (video.paused)
		{
			video.play();
		}
		else
		{
			video.pause();
		}
	}

	private function playStatus(code:String):Void
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

	// Event Handlers
	private function video_onCanPlay(event:Dynamic):Void
	{
		playStatus("NetStream.Play.canplay");
	}

	private function video_onCanPlayThrough(event:Dynamic):Void
	{
		playStatus("NetStream.Play.canplaythrough");
	}

	private function video_onDurationChanged(event:Dynamic):Void
	{
		playStatus("NetStream.Play.durationchanged");
	}

	private function video_onEnd(event:Dynamic):Void
	{
		dispatchStatus("NetStream.Play.Stop");
		dispatchStatus("NetStream.Play.Complete");
		playStatus("NetStream.Play.Stop");
		playStatus("NetStream.Play.Complete");
	}

	private function video_onError(event:Dynamic):Void
	{
		dispatchStatus("NetStream.Play.Stop");
		playStatus("NetStream.Play.error");
	}

	private function video_onLoadMetaData(event:Dynamic):Void
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

	private function video_onLoadStart(event:Dynamic):Void
	{
		playStatus("NetStream.Play.loadstart");
	}

	private function video_onPause(event:Dynamic):Void
	{
		playStatus("NetStream.Play.pause");
	}

	private function video_onPlaying(event:Dynamic):Void
	{
		dispatchStatus("NetStream.Play.Start");
		playStatus("NetStream.Play.Start");
		playStatus("NetStream.Play.playing");
	}

	private function video_onSeeking(event:Dynamic):Void
	{
		playStatus("NetStream.Play.seeking");

		dispatchStatus("NetStream.Seek.Complete");
	}

	private function video_onStalled(event:Dynamic):Void
	{
		playStatus("NetStream.Play.stalled");
	}

	private function video_onTimeUpdate(event:Dynamic):Void
	{
		if (video == null) return;

		parent.time = video.currentTime;

		playStatus("NetStream.Play.timeupdate");
	}

	private function video_onWaiting(event:Dynamic):Void
	{
		playStatus("NetStream.Play.waiting");
	}
}
#else
import openfl.media.SoundTransform;
import openfl.net.NetStream;

class _NetStream
{
	public function new(parent:NetStream):Void {}

	public function close():Void {}

	public function dispose():Void {}

	public function getSeeking():Bool
	{
		return false;
	}

	public function getSpeed():Float
	{
		return 1;
	}

	public function pause():Void {}

	public function play(url:String, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null):Void {}

	public function requestVideoStatus():Void {}

	public function resume():Void {}

	public function seek(time:Float):Void {}

	public function setSoundTransform(value:SoundTransform):Void {}

	public function setSpeed(value:Float):Void {}

	public function togglePause():Void {}

	private function playStatus(code:String):Void {}

	// Event Handlers
	private function video_onCanPlay(event:Dynamic):Void {}

	private function video_onCanPlayThrough(event:Dynamic):Void {}

	private function video_onDurationChanged(event:Dynamic):Void {}

	private function video_onEnd(event:Dynamic):Void {}

	private function video_onError(event:Dynamic):Void {}

	private function video_onLoadMetaData(event:Dynamic):Void {}

	private function video_onLoadStart(event:Dynamic):Void {}

	private function video_onPause(event:Dynamic):Void {}

	private function video_onPlaying(event:Dynamic):Void {}

	private function video_onSeeking(event:Dynamic):Void {}

	private function video_onStalled(event:Dynamic):Void {}

	private function video_onTimeUpdate(event:Dynamic):Void {}

	private function video_onWaiting(event:Dynamic):Void {}
}
#end
