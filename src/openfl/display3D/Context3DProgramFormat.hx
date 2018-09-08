package openfl.display3D; #if (!flash && !openfljs)


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DProgramFormat(Null<Int>) {
	
	public var AGAL = 0;
	public var GLSL = 1;
	
	@:from private static function fromString (value:String):Context3DProgramFormat {
		
		return switch (value) {
			
			case "agal": AGAL;
			case "glsl": GLSL;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DProgramFormat.AGAL: "agal";
			case Context3DProgramFormat.GLSL: "glsl";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DProgramFormat, b:Context3DProgramFormat):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DProgramFormat, b:Context3DProgramFormat):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DProgramFormat(String) from String to String {
	
	public var AGAL = "agal";
	public var GLSL = "glsl";
	
}


#end