package openfl.profiler;


import haxe.Timer;


/**
	A profiler optimized for very low overhead.
	
	`Profiler.begin ("section_name");`
	...
	`Profiler.begin ("subsection_name");`
	...
	`Profiler.end ();`
	...
	`Profiler.end ();`
	`Profiler.traceResults();`

	If you need more sophisticated features, try https://lib.haxe.org/p/profiler
**/
class Profiler {
	
	
	static var opened : Array<Opened> = [];
	static var blocks : Map<String,Block> = new Map<String,Block> ();
	
	public static function begin (name:String) {
	
		opened.push({ name:name, time:getTime () });
	
	}
	
	public static function end () {
		
		if (opened.length == 0) {
			
			throw "Profiler.end() called but there are no open blocks.";
		
		}
		
		var b = opened.pop ();
		var dt = getTime () - b.time;
		
		var block = blocks.get (b.name);
		if (block == null) {
			
			blocks.set (b.name, { count:1, dt:dt });
		
		} else {
			
			block.count++;
			block.dt += dt;
		
		}
	}
	
	public static function reset () {
		
		opened = [];
		blocks = new Map<String,Block> ();
	
	}
	
	public static function getSummaryResults () : Array<Result> {
		
		var results = new Array<Result> ();
		
		for (name in blocks.keys ()) {
			
			var block = blocks.get (name);
			results.push (new Result (name, block.dt, block.count));
		
		}
		
		results.sort (function(a, b) return Reflect.compare (b.dt, a.dt));
		
		return results;
	
	}
	
	public static function traceResults () {
		
		var results = getSummaryResults ();
	
		var output = "name\tcount\ttime\n";
		for (result in  results) {
			
			output += '${result.name}\t${result.count}\t${result.dt}\n';
		
		}
		trace (output);
	
	}
	
	public static inline function getTime () {
		
		// Haxe JavaScript translates to slower new Date(), therefore forcing Date.now()
		// see https://jsperf.com/date-now-vs-new-date
		#if (js && html5)
		return untyped __js__ ('Date.now() / 1000');
		#else
		return Timer.stamp ();
		#end
	
	}
	
	
}


private typedef Opened =
{
	var name : String;
	var time : Float;
}

private typedef Block =
{
	var count : Int;
	var dt : Float;
}