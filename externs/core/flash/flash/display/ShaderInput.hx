package flash.display; #if (!display && flash)


@:final extern class ShaderInput<T> implements Dynamic {
	
	
	public var channels (default, null):Int;
	public var height:Int;
	public var index (default, null):Int;
	public var input:T;
	public var width:Int;
	
	
	public function new ();
	
	
}


#else
typedef ShaderInput<T> = openfl.display.ShaderInput<T>;
#end