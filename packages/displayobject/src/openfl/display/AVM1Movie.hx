package openfl.display;

#if !flash
#if (!openfl_doc_gen || flash_doc_gen)
import haxe.Constraints.Function;
import openfl.errors.ArgumentError;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
class AVM1Movie extends DisplayObject
{
	@:noCompletion private function new()
	{
		super();
		throw new ArgumentError("Error #2012: AVM1Movie$ class cannot be instantiated.");
	}

	@:noCompletion @:dox(hide) public function addCallback(functionName:String, closure:Function):Void {}

	@:noCompletion @:dox(hide)
	public function call(functionName:String, p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Dynamic
	{
		return null;
	}
}
#end
#else
typedef AVM1Movie = flash.display.AVM1Movie;
#end
