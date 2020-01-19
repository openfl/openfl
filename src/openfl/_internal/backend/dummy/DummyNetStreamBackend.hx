package openfl._internal.backend.dummy;

import openfl.media.SoundTransform;
import openfl.net.NetStream;

class DummyNetStreamBackend
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
