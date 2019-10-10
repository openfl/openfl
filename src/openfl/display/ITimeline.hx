package openfl.display;

import openfl.display.FrameLabel;

interface ITimeline
{
	public var currentFrame:Int;
	public var currentFrameLabel:String;
	public var currentLabel:String;
	public var currentLabels:Array<FrameLabel>;
	public var framesLoaded:Int;
	public var isPlaying:Bool;
	public var totalFrames:Int;

	public function addFrameScript(index:Int, method:Void->Void):Void;
	public function enterFrame(deltaTime:Int):Void;
	public function gotoAndPlay(frame:Any, scene:String = null):Void;
	public function gotoAndStop(frame:Any, scene:String = null):Void;
	public function nextFrame():Void;
	public function play():Void;
	public function prevFrame():Void;
	public function stop():Void;
}
