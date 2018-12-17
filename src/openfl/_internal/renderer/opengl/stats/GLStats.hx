package openfl._internal.renderer.opengl.stats; 

import haxe.ds.IntMap;

class GLStats {
	
	private static var drawCallsCounters:IntMap<Counter> = [ DrawCallContext.STAGE => new Counter(), 
																	 DrawCallContext.STAGE3D => new Counter()];

	public static var quadCounter = new Counter ();
	
	
	public static function incrementDrawCall (context: DrawCallContext):Void {
		
		drawCallsCounters.get(context).increment ();
		
	}
	
	
	public static function resetDrawCalls ():Void {
		
		for (dcCounter in drawCallsCounters) {
			dcCounter.reset ();
		}
		
	}
	
	
	public static function totalDrawCalls ():Int { 
		
		var total = 0;
		for (dcCounter in drawCallsCounters) {
			
			total += dcCounter.currentCount;
			
		}
				
		return total;
		
	}
	
	
	public static function contextDrawCalls (context: DrawCallContext):Int { 
		
		return drawCallsCounters.get(context).currentCount;
		
	}
	
	
}