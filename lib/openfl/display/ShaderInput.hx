package openfl.display; #if (display || !flash)


@:jsRequire("openfl/display/ShaderInput", "default")

#if !js @:generic #end


@:final extern class ShaderInput<T> /*implements Dynamic*/ {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Int;
	public var input:T;
	public var width:Int;
	
	
	public function new ();
	
	
}


#else
typedef ShaderInput<T> = flash.display.ShaderInput<T>;
#end