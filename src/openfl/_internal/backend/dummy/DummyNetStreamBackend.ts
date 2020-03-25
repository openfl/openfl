namespace openfl._internal.backend.dummy;

import SoundTransform from "openfl/media/SoundTransform";
import openfl.net.NetStream;

class DummyNetStreamBackend
{
	public new(parent: NetStream): void { }

	public close(): void { }

	public dispose(): void { }

	public getSeeking(): boolean
	{
		return false;
	}

	public getSpeed(): number
	{
		return 1;
	}

	public pause(): void { }

	public play(url: string, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null): void { }

	public requestVideoStatus(): void { }

	public resume(): void { }

	public seek(time: number): void { }

	public setSoundTransform(value: SoundTransform): void { }

	public setSpeed(value: number): void { }

	public togglePause(): void { }

	private playStatus(code: string): void { }

	// Event Handlers
	private video_onCanPlay(event: Dynamic): void { }

	private video_onCanPlayThrough(event: Dynamic): void { }

	private video_onDurationChanged(event: Dynamic): void { }

	private video_onEnd(event: Dynamic): void { }

	private video_onError(event: Dynamic): void { }

	private video_onLoadMetaData(event: Dynamic): void { }

	private video_onLoadStart(event: Dynamic): void { }

	private video_onPause(event: Dynamic): void { }

	private video_onPlaying(event: Dynamic): void { }

	private video_onSeeking(event: Dynamic): void { }

	private video_onStalled(event: Dynamic): void { }

	private video_onTimeUpdate(event: Dynamic): void { }

	private video_onWaiting(event: Dynamic): void { }
}
