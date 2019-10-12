package openfl.display;

import openfl.display.FrameLabel;

interface ITimeline
{
	public var frameLabels:Map<Int, Array<String>>;
	public var frameRate:Float;
	public var frameScripts:Map<Int, MovieClip->Void>;
	public var framesLoaded:Int;
	public var totalFrames:Int;

	public function updateMovieClip(movieClip:MovieClip, previousFrame:Int, currentFrame:Int):Void;
}
