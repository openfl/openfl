package openfl.display;


import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class FPS extends TextField {
	
	
	public var currentFPS (default, null):Int;
	
	private var cacheCount:Int;
	private var times:Array <Float>;
	
	
	public function new (x:Float = 10, y:Float = 10, color:Int = 0x000000) {
		
		super ();
		
		this.x = x;
		this.y = y;
		
		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat ("_sans", 12, color);
		text = "FPS: ";
		
		cacheCount = 0;
		times = [];
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function this_onEnterFrame (event:Event):Void {
		
		var currentTime = Timer.stamp ();
		times.push (currentTime);
		
		while (times[0] < currentTime - 1) {
			
			times.shift ();
			
		}
		
		var currentCount = times.length;
		currentFPS = Math.round ((currentCount + cacheCount) / 2);
		
		if (currentCount != cacheCount /*&& visible*/) {
			
			text = "FPS: " + currentFPS;
			
			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
				text += "\ntotalDC: " + GLStats.totalDrawCalls();
				text += "\nstageDC: " + GLStats.contextDrawCalls(DrawCallContext.STAGE);
				text += "\nstage3DDC: " + GLStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end
			
		}
		
		cacheCount = currentCount;
		
	}
	
	
}
