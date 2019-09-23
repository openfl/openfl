package openfl._internal.utils;

import openfl.display.FrameLabel;

interface ITimeline
{
	public function addFrameScript(index:Int, method:Void->Void):Void;
	public function enterFrame(deltaTime:Int):Void;
	public function getCurrentFrame():Int;
	public function getCurrentFrameLabel():String;
	public function getCurrentLabel():String;
	public function getCurrentLabels():Array<FrameLabel>;
	public function getFramesLoaded():Int;
	public function getTotalFrames():Int;
	public function gotoAndPlay(frame:Any, scene:String = null):Void;
	public function gotoAndStop(frame:Any, scene:String = null):Void;
	public function isPlaying():Bool;
	public function nextFrame():Void;
	public function play():Void;
	public function prevFrame():Void;
	public function stop():Void;
}
