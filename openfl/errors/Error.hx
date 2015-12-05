package openfl.errors; #if (!display && !flash)


import haxe.CallStack;


class Error {
	
	
	private static inline var DEFAULT_TO_STRING = "Error";
	
	public var errorID (default, null):Int;
	public var message:String;
	public var name:String;
	
	
	public function new (message:String = "", id:Int = 0) {
		
		this.message = message;
		this.errorID = id;
		name = "Error";
		
	}
	
	
	public function getStackTrace ():String {
		
		return CallStack.toString (CallStack.exceptionStack ());
		
	}
	
	
	public function toString ():String {
		
		if (message != null) {
			
			return message;
			
		} else {
			
			return DEFAULT_TO_STRING;
			
		}
		
	}
	
	
}


#else


#if flash
@:native("flash.errors.Error")
#end

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


#end