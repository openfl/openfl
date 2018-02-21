package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DCompareMode(Null<Int>) {
	
	public var ALWAYS = 0;
	public var EQUAL = 1;
	public var GREATER = 2;
	public var GREATER_EQUAL = 3;
	public var LESS = 4;
	public var LESS_EQUAL = 5;
	public var NEVER = 6;
	public var NOT_EQUAL = 7;
	
	@:from private static function fromString (value:String):Context3DCompareMode {
		
		return switch (value) {
			
			case "always": ALWAYS;
			case "equal": EQUAL;
			case "greater": GREATER;
			case "greaterEqual": GREATER_EQUAL;
			case "less": LESS;
			case "lessEqual": LESS_EQUAL;
			case "never": NEVER;
			case "notEqual": NOT_EQUAL;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DCompareMode.ALWAYS: "always";
			case Context3DCompareMode.EQUAL: "equal";
			case Context3DCompareMode.GREATER: "greater";
			case Context3DCompareMode.GREATER_EQUAL: "greaterEqual";
			case Context3DCompareMode.LESS: "less";
			case Context3DCompareMode.LESS_EQUAL: "lessEqual";
			case Context3DCompareMode.NEVER: "never";
			case Context3DCompareMode.NOT_EQUAL: "notEqual";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DCompareMode, b:Context3DCompareMode):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DCompareMode, b:Context3DCompareMode):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DCompareMode(String) from String to String {
	
	public var ALWAYS = "always";
	public var EQUAL = "equal";
	public var GREATER = "greater";
	public var GREATER_EQUAL = "greaterEqual";
	public var LESS = "less";
	public var LESS_EQUAL = "lessEqual";
	public var NEVER = "never";
	public var NOT_EQUAL = "notEqual";
	
}


#end