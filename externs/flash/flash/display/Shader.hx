package flash.display; #if (!display && flash)


import openfl.utils.ByteArray;

@:require(flash10)


extern class Shader {
	
	
	#if flash
	@:noCompletion @:dox(hide) public var byteCode (null, default):ByteArray;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var data:flash.display.ShaderData;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var precisionHint:flash.display.ShaderPrecision;
	#end
	
	
	public function new (code:ByteArray = null):Void;
	
	
}


#else
typedef Shader = openfl.display.Shader;
#end