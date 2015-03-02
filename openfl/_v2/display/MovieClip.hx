package openfl._v2.display; #if lime_legacy


import openfl.display.FrameLabel;


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
		__currentFrameLabel = null;
		__currentLabel = null;
		__currentLabels = [];
		__totalFrames = 0;
		enabled = true;
		
	}
	
	
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function nextFrame ():Void {
		
		
		
	}
	
	
	@:noCompletion override private function __getType ():String {
		
		return "MovieClip";
		
	}
	
	
	public function play ():Void {
		
		
		
	}
	
	
	public function prevFrame ():Void {
		
		
		
	}
	
	
	public function stop ():Void {
		
		
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_currentFrame ():Int { return __currentFrame; }
	private function get_currentFrameLabel ():String { return __currentFrameLabel; }
	private function get_currentLabel ():String { return __currentLabel; }
	private function get_currentLabels ():Array<FrameLabel> { return __currentLabels; }
	private function get_framesLoaded ():Int { return __totalFrames; }
	private function get_totalFrames ():Int { return __totalFrames; }
	
	
}


#end