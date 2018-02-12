package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DWrapMode(Null<Int>) {
	
	public var CLAMP = 0;
	public var CLAMP_U_REPEAT_V = 1;
	public var REPEAT = 2;
	public var REPEAT_U_CLAMP_V = 3;
	
	@:from private static function fromString (value:String):Context3DWrapMode {
		
		return switch (value) {
			
			case "clamp": CLAMP;
			case "clamp_u_repeat_y": CLAMP_U_REPEAT_V;
			case "repeat": REPEAT;
			case "repeat_u_clamp_y": REPEAT_U_CLAMP_V;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DWrapMode.CLAMP: "clamp";
			case Context3DWrapMode.CLAMP_U_REPEAT_V: "clamp_u_repeat_y";
			case Context3DWrapMode.REPEAT: "repeat";
			case Context3DWrapMode.REPEAT_U_CLAMP_V: "repeat_u_clamp_y";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DWrapMode, b:Context3DWrapMode):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DWrapMode, b:Context3DWrapMode):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DWrapMode(String) from String to String {
	
	public var CLAMP = "clamp";
	public var CLAMP_U_REPEAT_V = "clamp_u_repeat_y";
	public var REPEAT = "repeat";
	public var REPEAT_U_CLAMP_V = "repeat_u_clamp_y";
	
}


#end