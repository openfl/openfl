package openfl._internal.renderer.opengl.stats;

class Counter {
	
	public var currentCount (default, null):Int = 0;
	
	private var counter:Int = 0;
	
	
	public function new () {
		
		currentCount = 0;
		counter = 0;
		
	}
	
	public function increment ():Void {
		
		counter ++;
		
	}
	
	
	public function reset ():Void {
		
		currentCount = counter;
		counter = 0;
		
	}
	
	
}
