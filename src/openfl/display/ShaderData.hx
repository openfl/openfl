package openfl.display; #if !flash


import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:forward()

abstract ShaderData(Dynamic) from Dynamic to Dynamic {
	
	
	public function new (byteArray:ByteArray) {
		
		this = {};
		
	}
	
	
}


#else
typedef ShaderData = flash.display.ShaderData;
#end