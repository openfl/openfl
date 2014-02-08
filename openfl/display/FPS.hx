package openfl.display;


import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.Timer;


class FPS extends TextField {
	
	
	public var currentFPS (get, null):Float;
	private inline function get_currentFPS():Float { return currentFPS; }
	
	private var cacheCount:Int;
	private var times:Array <Float>;
	
	
	public function new (x:Float = 10, y:Float = 10, color:Int = 0x000000) {
		
		super ();
		
		this.x = x;
		this.y = y;
		
		currentFPS = 0;
		selectable = false;
		defaultTextFormat = new TextFormat ("_sans", 12, color);
		text = "FPS: ";
		
		cacheCount = 0;
		times = [];
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onEnterFrame (_):Void {
		
		var currentTime = Timer.stamp ();
		times.push (currentTime);
		
		while (times[0] < currentTime - 1) {
			
			times.shift ();
			
		}
		
		var currentCount = times.length;
		currentFPS = Math.round ((currentCount + cacheCount) / 2);
		
		if (currentCount != cacheCount && visible) {
			
			text = "FPS: " + currentFPS;
			
		}
		
		cacheCount = currentCount;
		
	}
	
	
}
