package openfl.display; #if (display || !flash)


@:final #if !js @:generic #end extern class ShaderParameter<T> /*implements Dynamic*/ {
	
	
	public var index (default, null):Int;
	public var type (default, null):ShaderParameterType;
	public var value:Array<T>;
	
	public function new ();
	
	
}


#else
typedef ShaderParameter<T> = flash.display.ShaderParameter<T>;
#end