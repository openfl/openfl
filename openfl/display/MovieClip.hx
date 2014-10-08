package openfl.display; #if !flash #if (display || openfl_next || js)


class MovieClip extends Sprite {
	
	
	public var currentFrame (get, null):Int;
	public var currentFrameLabel (get, null):String;
	public var currentLabel (get, null):String;
	public var currentLabels (get, null):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded (get, null):Int;
	public var totalFrames (get, null):Int;
	
	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __currentFrameLabel:String;
	@:noCompletion private var __currentLabel:String;
	@:noCompletion private var __currentLabels:Array<FrameLabel>;
	@:noCompletion private var __totalFrames:Int;
	
	
	public function new () {
		
		super ();
		
		__currentFrame = 0;
		__currentLabels = [];
		__totalFrames = 0;
		enabled = true;
		
		loaderInfo = LoaderInfo.create (null);
		
	}
	
	
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function nextFrame ():Void {
		
		
		
	}
	
	
	public function play ():Void {
		
		
		
	}
	
	
	public function prevFrame ():Void {
		
		
		
	}
	
	
	public function stop ():Void {
		
		
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_currentFrame ():Int { return __currentFrame; }
	@:noCompletion private function get_currentFrameLabel ():String { return __currentFrameLabel; }
	@:noCompletion private function get_currentLabel ():String { return __currentLabel; }
	@:noCompletion private function get_currentLabels ():Array<FrameLabel> { return __currentLabels; }
	@:noCompletion private function get_framesLoaded ():Int { return __totalFrames; }
	@:noCompletion private function get_totalFrames ():Int { return __totalFrames; }
	
	
}


#else
typedef MovieClip = openfl._v2.display.MovieClip;
#end
#else
typedef MovieClip = flash.display.MovieClip;
#end