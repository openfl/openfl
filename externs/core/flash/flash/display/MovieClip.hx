package flash.display; #if (!display && flash)


extern class MovieClip extends Sprite #if openfl_dynamic implements Dynamic #end {
	
	
	public var currentFrame (default, null):Int;
	@:require(flash10) public var currentFrameLabel (default, null):String;
	public var currentLabel (default, null):String;
	public var currentLabels (default, null):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded (default, null):Int;
	@:require(flash11) public var isPlaying (default, null):Bool;
	
	#if flash
	public var scenes (default, null):Array<flash.display.Scene>;
	#end
	
	public var totalFrames (default, null):Int;
	
	#if flash
	public var trackAsMenu:Bool;
	#end
	
	public function new ();
	public function addFrameScript (index:Int, method:Void->Void):Void;
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void;
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void;
	public function nextFrame ():Void;
	
	#if flash
	public function nextScene ():Void;
	#end
	
	public function play ():Void;
	public function prevFrame ():Void;
	
	#if flash
	public function prevScene ():Void;
	#end
	
	public function stop ():Void;
	
	
}


#else
typedef MovieClip = openfl.display.MovieClip;
#end