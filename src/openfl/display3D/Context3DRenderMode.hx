package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DRenderMode(Null<Int>) {
	
	public var AUTO = 0;
	public var SOFTWARE = 1;
	
	@:from private static function fromString (value:String):Context3DRenderMode {
		
		return switch (value) {
			
			case "auto": AUTO;
			case "software": SOFTWARE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DRenderMode.AUTO: "auto";
			case Context3DRenderMode.SOFTWARE: "software";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DRenderMode, b:Context3DRenderMode):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DRenderMode, b:Context3DRenderMode):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DRenderMode(String) from String to String {
	
	public var AUTO = "auto";
	public var SOFTWARE = "software";
	
}


#end