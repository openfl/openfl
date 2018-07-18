package openfl.display; #if !flash #if (!openfl_doc_gen || flash_doc_gen)


import haxe.Constraints.Function;
import openfl.errors.ArgumentError;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class AVM1Movie extends DisplayObject {
	
	
	@:noCompletion private function new () {
		
		super ();
		
		throw new ArgumentError ("Error #2012: AVM1Movie$ class cannot be instantiated.");
		
	}
	
	
	public function addCallback (functionName:String, closure:Function):Void {
		
		
		
	}
	
	
	public function call (functionName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic {
		
		return null;
		
	}
	
	
}


#end
#else
typedef AVM1Movie = flash.display.AVM1Movie;
#end