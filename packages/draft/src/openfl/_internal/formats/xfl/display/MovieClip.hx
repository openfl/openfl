package openfl._internal.formats.xfl.display;

import openfl.display.Sprite;
import openfl.display.FrameLabel;

/**
 * Base class for MovieClip-related format libraries
 *
 * Cannot use flash.display.MovieClip, because it does
 * not allow the addition for frames or frame labels at
 * runtime, asynchronously
 */
class MovieClip extends Sprite
{
	public var currentFrame(default, null):Int;
	public var currentFrameLabel(get, never):String;
	public var currentLabel(default, null):String;
	public var currentLabels(default, null):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded(default, null):Int;
	public var totalFrames(default, null):Int;
	public var trackAsMenu:Bool;

	function new()
	{
		super();
	}

	private function get_currentFrameLabel():String
	{
		return null;
	}

	public function flatten():Void {}

	public function gotoAndPlay(frame:Dynamic, scene:String = null):Void {}

	public function gotoAndPlayRange(startFrame:Dynamic, endFrame:Dynamic = null, repeat:Bool = true, scene:String = null):Void {}

	public function gotoAndStop(frame:Dynamic, scene:String = null):Void {}

	public function nextFrame():Void {}

	public function play():Void {}

	public function prevFrame():Void {}

	public function stop():Void {}

	public function unflatten():Void {}
}
