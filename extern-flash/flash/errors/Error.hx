package flash.errors; #if (!display && flash)


extern class Error {
	
	
	#if flash
	@:noCompletion @:dox(hide) public static var length:Int;
	#end
	
	public var errorID (default, null):Int;
	public var message:String; //Dynamic
	public var name:String; //Dynamic
	
	
	public function new (message:String = "", id:Int = 0);
	
	#if flash
	@:noCompletion @:dox(hide) public static function getErrorMessage (index:Int):String;
	#end
	
	public function getStackTrace ():String;
	
	#if flash
	@:noCompletion @:dox(hide) public static function throwError (type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;
	#end
	
	
}


#else
typedef Error = openfl.errors.Error;
#end