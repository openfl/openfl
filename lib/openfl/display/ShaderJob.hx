package openfl.display;

#if (display || !flash)
import openfl.events.EventDispatcher;

@:jsRequire("openfl/display/ShaderJob", "default")
extern class ShaderJob extends EventDispatcher
{
	public var width:Int;
	public var height:Int;
	public var progress(default, null):Float;
	public var shader:Shader;
	public var target:Dynamic;
	public function new(shader:Shader = null, target:Dynamic = null, width:Int = 0, height:Int = 0);
	public function cancel():Void;
	public function start(waitForCompletion:Bool = false):Void;
}
#else
typedef ShaderJob = flash.display.ShaderJob;
#end
