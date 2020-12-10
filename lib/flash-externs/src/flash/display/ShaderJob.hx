package flash.display;

#if flash
import openfl.events.EventDispatcher;

extern class ShaderJob extends EventDispatcher
{
	public var width:Int;
	public var height:Int;
	public var progress(default, never):Float;
	public var shader:Shader;
	public var target:Dynamic;
	public function new(shader:Shader = null, target:Dynamic = null, width:Int = 0, height:Int = 0);
	public function cancel():Void;
	public function start(waitForCompletion:Bool = false):Void;
}
#else
typedef ShaderJob = openfl.display.ShaderJob;
#end
