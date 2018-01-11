package openfl._internal.renderer.opengl.stats;

class DrawCallCounter {
	
	public var currentDrawCallsNum (default, null):Int = 0;
	
	private var drawCallsCounter:Int = 0;
	
	
	public function new() {
		
		currentDrawCallsNum = 0;
		drawCallsCounter = 0;
		
	}
	
	public function increment ():Void {
		
		drawCallsCounter ++;
		
	}
	
	
	public function reset ():Void {
		
		currentDrawCallsNum = drawCallsCounter;
		drawCallsCounter = 0;
		
	}
	
	
}
