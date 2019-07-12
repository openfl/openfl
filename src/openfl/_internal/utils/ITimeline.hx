package openfl._internal.utils;

interface ITimeline
{
	public function addFrameScript(index:Int, method:Void->Void):Void;
	public function enterFrame(deltaTime:Int):Void;
	public function gotoAndPlay(frame:Any, scene:String = null):Void;
	public function gotoAndStop(frame:Any, scene:String = null):Void;
	public function nextFrame():Void;
	public function play():Void;
	public function prevFrame():Void;
	public function stop():Void;
}
