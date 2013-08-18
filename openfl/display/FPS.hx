package openfl.display;


import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import haxe.Timer;


class FPS extends TextField {
	
	
	private var cacheCount:Int;
	private var times:Array <Float>;
	
	
	public function new (x:Float = 10, y:Float = 10, color:Int = 0x000000) {
		
		super ();
		
		this.x = x;
		this.y = y;
		
		selectable = false;
		defaultTextFormat = new TextFormat ("_sans", 12, color);
		text = "FPS: ";
		
		cacheCount = 0;
		times = [];
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		var currentTime = Timer.stamp ();
		times.push (currentTime);
		
		while (times[0] < currentTime - 1) {
			
			times.shift ();
			
		}
		
		var currentCount = times.length;
		
		if (currentCount != cacheCount && visible) {
			
			text = "FPS: " + Math.round ((currentCount + cacheCount) / 2);
			
		}
		
		cacheCount = currentCount;
		
	}
	
	
}