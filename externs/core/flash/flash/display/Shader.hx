package flash.display; #if (!display && flash)


import openfl.utils.ByteArray;

@:require(flash10)


extern class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data:ShaderData;
	public var precisionHint:ShaderPrecision;
	
	
	public function new (code:ByteArray = null):Void;
	
	
}


#else
typedef Shader = openfl.display.Shader;
#end