package openfl.display; #if (display || !flash)


import openfl.utils.ByteArray;


extern class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data:ShaderData;
	public var glFragmentSource (get, set):String;
	public var glProgram (default, null):Dynamic;
	public var glVertexSource (get, set):String;
	public var precisionHint:ShaderPrecision;
	
	
	public function new (code:ByteArray = null):Void;
	
	
}


#else
typedef Shader = flash.display.Shader;
#end