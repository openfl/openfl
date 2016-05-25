package openfl.display; #if (display || !flash)


@:final extern class ShaderParameter implements Dynamic {
	
	
	public var index (default, null):Int;
	public var type (default, null):ShaderParameterType;
	public var value:Array<Dynamic>;
	
	public function new ();
	
	
}


#else
typedef ShaderParameter = flash.display.ShaderParameter;
#end