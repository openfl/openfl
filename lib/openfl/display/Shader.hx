package openfl.display;

#if (display || !flash)
import openfl.utils.ByteArray;

@:jsRequire("openfl/display/Shader", "default")
extern class Shader
{
	public var byteCode(null, default):ByteArray;
	public var data(get, set):ShaderData;
	@:noCompletion private function get_data():ShaderData;
	@:noCompletion private function set_data(value:ShaderData):ShaderData;
	public var glFragmentSource(get, set):String;
	@:noCompletion private function get_glFragmentSource():String;
	@:noCompletion private function set_glFragmentSource(value:String):String;
	public var glProgram(default, null):Dynamic;
	public var glVertexSource(get, set):String;
	@:noCompletion private function get_glVertexSource():String;
	@:noCompletion private function set_glVertexSource(value:String):String;
	public var precisionHint:ShaderPrecision;
	public function new(code:ByteArray = null):Void;
}
#else
typedef Shader = flash.display.Shader;
#end
