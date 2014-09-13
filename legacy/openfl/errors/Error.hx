package openfl.errors;


import haxe.CallStack;


class Error {
	
	
	public var errorID:Int;
	public var message:String;
	public var name:String;
	
	
	public function new (message:String = "", id:Int = 0) {
		
		this.message = message;
		errorID = id;
		name = "Error";
		
	}
	
	
	public function getStackTrace ():String {
		
		var stack = CallStack.exceptionStack ();
		return CallStack.toString (stack);
		
	}
	
	
	public function toString ():String {
		
		return message;
		
	}
	
	
}