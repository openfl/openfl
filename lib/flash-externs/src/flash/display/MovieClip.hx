package flash.display;

#if flash
extern class MovieClip extends Sprite #if openfl_dynamic implements Dynamic #end
{
	public var currentFrame(default, never):Int;
	@:require(flash10) public var currentFrameLabel(default, never):String;
	public var currentLabel(default, never):String;
	public var currentLabels(default, never):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded(default, never):Int;
	@:require(flash11) public var isPlaying(default, never):Bool;
	#if flash
	public var scenes(default, never):Array<flash.display.Scene>;
	#end
	public var totalFrames(default, never):Int;
	#if flash
	public var trackAsMenu:Bool;
	#end
	public function new();
	public function addFrameScript(index:Int, method:Void->Void):Void;
	public function gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void;
	public function gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void;
	public function nextFrame():Void;
	#if flash
	public function nextScene():Void;
	#end
	public function play():Void;
	public function prevFrame():Void;
	#if flash
	public function prevScene():Void;
	#end
	public function stop():Void;
}
#else
typedef MovieClip = openfl.display.MovieClip;
#end
