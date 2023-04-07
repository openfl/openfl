package flash.display;

#if flash
import openfl.events.EventDispatcher;

extern class ShaderJob extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var width:Int;
	public var height:Int;
	public var progress(default, never):Float;
	public var shader:Shader;
	public var target:Dynamic;
	#else
	@:flash.property var height(get, set):Int;
	@:flash.property var progress(get, never):Float;
	@:flash.property var shader(get, set):Shader;
	@:flash.property var target(get, set):Dynamic;
	@:flash.property var width(get, set):Int;
	#end

	public function new(shader:Shader = null, target:Dynamic = null, width:Int = 0, height:Int = 0);
	public function cancel():Void;
	public function start(waitForCompletion:Bool = false):Void;

	#if (haxe_ver >= 4.3)
	private function get_height():Int;
	private function get_progress():Float;
	private function get_shader():Shader;
	private function get_target():Dynamic;
	private function get_width():Int;
	private function set_height(value:Int):Int;
	private function set_shader(value:Shader):Shader;
	private function set_target(value:Dynamic):Dynamic;
	private function set_width(value:Int):Int;
	#end
}
#else
typedef ShaderJob = openfl.display.ShaderJob;
#end
