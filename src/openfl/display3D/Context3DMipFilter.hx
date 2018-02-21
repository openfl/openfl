package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DMipFilter(Null<Int>) {
	
	public var MIPLINEAR = 0;
	public var MIPNEAREST = 1;
	public var MIPNONE = 2;
	
	@:from private static function fromString (value:String):Context3DMipFilter {
		
		return switch (value) {
			
			case "miplinear": MIPLINEAR;
			case "mipnearest": MIPNEAREST;
			case "mipnone": MIPNONE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DMipFilter.MIPLINEAR: "miplinear";
			case Context3DMipFilter.MIPNEAREST: "mipnearest";
			case Context3DMipFilter.MIPNONE: "mipnone";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DMipFilter, b:Context3DMipFilter):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DMipFilter, b:Context3DMipFilter):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DMipFilter(String) from String to String {
	
	public var MIPLINEAR = "miplinear";
	public var MIPNEAREST = "mipnearest";
	public var MIPNONE = "mipnone";
	
}


#end