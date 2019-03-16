package flash.display;

#if flash
import haxe.Constraints.Function;

extern class AVM1Movie extends DisplayObject
{
	private function new():Void;
	public function addCallback(functionName:String, closure:Function):Void;
	public function call(functionName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;
}
#else
typedef AVM1Movie = openfl.display.AVM1Movie;
#end
