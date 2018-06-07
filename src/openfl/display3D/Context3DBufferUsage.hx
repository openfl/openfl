package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DBufferUsage(Null<Int>) {
	
	public var DYNAMIC_DRAW = 0;
	public var STATIC_DRAW = 1;
	
	@:from private static function fromString (value:String):Context3DBufferUsage {
		
		return switch (value) {
			
			case "dynamicDraw": DYNAMIC_DRAW;
			case "staticDraw": STATIC_DRAW;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DBufferUsage.DYNAMIC_DRAW: "dynamicDraw";
			case Context3DBufferUsage.STATIC_DRAW: "staticDraw";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DBufferUsage, b:Context3DBufferUsage):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DBufferUsage, b:Context3DBufferUsage):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DBufferUsage(String) from String to String {
	
	public var DYNAMIC_DRAW = "dynamicDraw";
	public var STATIC_DRAW = "staticDraw";
	
}


#end