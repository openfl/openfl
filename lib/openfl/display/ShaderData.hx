package openfl.display; #if (display || !flash)


import openfl.utils.ByteArray;

@:jsRequire("openfl/display/ShaderData", "default")


@:final extern class ShaderData implements Dynamic {
	
	
	public function new (byteArray:ByteArray):Void;
	
	
}


#else
typedef ShaderData = flash.display.ShaderData;
#end