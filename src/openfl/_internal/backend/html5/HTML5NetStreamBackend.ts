namespace openfl._internal.backend.html5;

#if openfl_html5
import haxe.Timer;
import js.html.VideoElement;
import js.Browser;
import openfl.events.NetStatusEvent;
import openfl.media.SoundMixer;
import SoundTransform from "../media/SoundTransform";
import openfl.net.NetStream;

@: access(openfl.media.SoundMixer)
@: access(openfl.net.NetStream)
class HTML5NetStreamBackend
{
	public video: VideoElement;

	private parent: NetStream;
	private timer: Timer;

	public constructor(parent: NetStream): void
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

	public close(): void
	{
		if (video == null) return;

		video.pause();
		video.src = "";
		parent.time = 0;
	}

	private dispatchStatus(code: string): void
	{
		var event = new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, { code: code });
		parent.__connection.dispatchEvent(event);
		parent.dispatchEvent(event);
	}

	public dispose(): void
	{
		close();
		video = null;
	}

	public getSeeking(): boolean
	{
		return (video != null && video.seeking);
	}

	public getSpeed(): number
	{
		return video != null ? video.playbackRate : 1;
	}

	public pause(): void
	{
		if (video != null) video.pause();
	}

	public play(url: Dynamic, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null): void
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

	public requestVideoStatus(): void
	{
		if (video == null) return;

		if (timer == null)
		{
			timer = new Timer(1);
		}

		timer.run = ()
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

	public resume(): void
	{
		if (video != null) video.play();
	}

	public seek(time: number): void
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

	public setSoundTransform(value: SoundTransform): void
	{
		if (video != null)
		{
			video.volume = SoundMixer.soundTransform.volume * parent.__soundTransform.volume;
		}
	}

	public setSpeed(value: number): void
	{
		video != null ? video.playbackRate = value : value;
	}

	public togglePause(): void
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

	private playStatus(code: string): void
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
			catch (e: Dynamic) { }
		}
	}

	// Event Handlers
	private video_onCanPlay(event: Dynamic): void
	{
		playStatus("NetStream.Play.canplay");
	}

	private video_onCanPlayThrough(event: Dynamic): void
	{
		playStatus("NetStream.Play.canplaythrough");
	}

	private video_onDurationChanged(event: Dynamic): void
	{
		playStatus("NetStream.Play.durationchanged");
	}

	private video_onEnd(event: Dynamic): void
	{
		dispatchStatus("NetStream.Play.Stop");
		dispatchStatus("NetStream.Play.Complete");
		playStatus("NetStream.Play.Stop");
		playStatus("NetStream.Play.Complete");
	}

	private video_onError(event: Dynamic): void
	{
		dispatchStatus("NetStream.Play.Stop");
		playStatus("NetStream.Play.error");
	}

	private video_onLoadMetaData(event: Dynamic): void
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
			catch (e: Dynamic) { }
		}
	}

	private video_onLoadStart(event: Dynamic): void
	{
		playStatus("NetStream.Play.loadstart");
	}

	private video_onPause(event: Dynamic): void
	{
		playStatus("NetStream.Play.pause");
	}

	private video_onPlaying(event: Dynamic): void
	{
		dispatchStatus("NetStream.Play.Start");
		playStatus("NetStream.Play.Start");
		playStatus("NetStream.Play.playing");
	}

	private video_onSeeking(event: Dynamic): void
	{
		playStatus("NetStream.Play.seeking");

		dispatchStatus("NetStream.Seek.Complete");
	}

	private video_onStalled(event: Dynamic): void
	{
		playStatus("NetStream.Play.stalled");
	}

	private video_onTimeUpdate(event: Dynamic): void
	{
		if (video == null) return;

		parent.time = video.currentTime;

		playStatus("NetStream.Play.timeupdate");
	}

	private video_onWaiting(event: Dynamic): void
	{
		playStatus("NetStream.Play.waiting");
	}
}
#end
