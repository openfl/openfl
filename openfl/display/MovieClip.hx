package openfl.display; #if !openfl_legacy


class MovieClip extends Sprite {
	
	
	public var currentFrame (get, null):Int;
	public var currentFrameLabel (get, null):String;
	public var currentLabel (get, null):String;
	public var currentLabels (get, null):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded (get, null):Int;
	public var totalFrames (get, null):Int;
	
	private var __currentFrame:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>;
	private var __frameScripts:Map<Int, Void->Void>;
	private var __totalFrames:Int;
	
	
	public function new () {
		
		super ();
		
		__currentFrame = 0;
		__currentLabels = [];
		__totalFrames = 0;
		enabled = true;
		
	}
	
	
	public function addFrameScript (index:Int, method:Void->Void):Void {
		
		if (method != null) {
			
			if (__frameScripts == null) {
				
				__frameScripts = new Map ();
				
			}
			
			__frameScripts.set (index, method);
			
		} else if (__frameScripts != null) {
			
			__frameScripts.remove (index);
			
		}
		
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
	
	
	
	
	private function get_currentFrame ():Int { return __currentFrame; }
	private function get_currentFrameLabel ():String { return __currentFrameLabel; }
	private function get_currentLabel ():String { return __currentLabel; }
	private function get_currentLabels ():Array<FrameLabel> { return __currentLabels; }
	private function get_framesLoaded ():Int { return __totalFrames; }
	private function get_totalFrames ():Int { return __totalFrames; }
	
	
}


#else
typedef MovieClip = openfl._legacy.display.MovieClip;
#end