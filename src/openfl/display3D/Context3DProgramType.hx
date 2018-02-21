package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DProgramType(Null<Int>) {
	
	public var FRAGMENT = 0;
	public var VERTEX = 1;
	
	@:from private static function fromString (value:String):Context3DProgramType {
		
		return switch (value) {
			
			case "fragment": FRAGMENT;
			case "vertex": VERTEX;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DProgramType.FRAGMENT: "fragment";
			case Context3DProgramType.VERTEX: "vertex";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DProgramType, b:Context3DProgramType):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DProgramType, b:Context3DProgramType):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DProgramType(String) from String to String {
	
	public var FRAGMENT = "fragment";
	public var VERTEX = "vertex";
	
}


#end