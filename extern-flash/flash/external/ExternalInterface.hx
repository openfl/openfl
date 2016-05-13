package flash.external; #if (!display && flash)


@:final extern class ExternalInterface {
	
	
	public static var available (default, null):Bool;
	public static var marshallExceptions:Bool;
	public static var objectID (default, null):String;
	
	public static function addCallback (functionName:String, closure:Dynamic):Void;
	public static function call (functionName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;
	
	
}


#else
typedef ExternalInterface = openfl.external.ExternalInterface;
#end