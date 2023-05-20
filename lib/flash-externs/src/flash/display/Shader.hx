package flash.display;

#if flash
import openfl.utils.ByteArray;

@:require(flash10)
extern class Shader
{
	#if (haxe_ver < 4.3)
	public var byteCode(never, default):ByteArray;
	public var data:ShaderData;
	public var precisionHint:ShaderPrecision;
	#else
	@:flash.property var byteCode(never, set):ByteArray;
	@:flash.property var data(get, set):ShaderData;
	@:flash.property var precisionHint(get, set):ShaderPrecision;
	#end

	public var glFragmentSource(get, set):String;
	public var glProgram(get, never):Dynamic;
	public var glVertexSource(get, set):String;

	public function new(code:ByteArray = null):Void;

	@:noCompletion private inline function get_glFragmentSource():String
	{
		return null;
	}
	@:noCompletion private inline function set_glFragmentSource(value:String):String
	{
		return null;
	}
	@:noCompletion private inline function get_glProgram():String
	{
		return null;
	}
	@:noCompletion private inline function get_glVertexSource():String
	{
		return null;
	}
	@:noCompletion private inline function set_glVertexSource(value:String):String
	{
		return null;
	}

	#if (haxe_ver >= 4.3)
	private function get_data():ShaderData;
	private function get_precisionHint():ShaderPrecision;
	private function set_byteCode(value:ByteArray):ByteArray;
	private function set_data(value:ShaderData):ShaderData;
	private function set_precisionHint(value:ShaderPrecision):ShaderPrecision;
	#end
}
#else
typedef Shader = openfl.display.Shader;
#end
