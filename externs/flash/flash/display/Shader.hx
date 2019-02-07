package flash.display;

#if flash
import openfl.utils.ByteArray;

@:require(flash10)
extern class Shader
{
	public var byteCode(never, default):ByteArray;
	public var data:ShaderData;
	public var glFragmentSource(get, set):String;
	public var glProgram(get, never):Dynamic;
	public var glVertexSource(get, set):String;
	public var precisionHint:ShaderPrecision;
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
}
#else
typedef Shader = openfl.display.Shader;
#end
