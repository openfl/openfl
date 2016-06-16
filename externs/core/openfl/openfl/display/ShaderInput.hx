package openfl.display; #if (display || !flash)


@:final extern class ShaderInput implements Dynamic {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Int;
	public var input:Dynamic;
	public var width:Int;
	
	
	public function new ();
	
	
}


#else
typedef ShaderInput = flash.display.ShaderInput;
#end