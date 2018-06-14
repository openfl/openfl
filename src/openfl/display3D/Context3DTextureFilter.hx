package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


@:enum abstract Context3DTextureFilter(Null<Int>) {
	
	public var ANISOTROPIC16X = 0;
	public var ANISOTROPIC2X = 1;
	public var ANISOTROPIC4X = 2;
	public var ANISOTROPIC8X = 3;
	public var LINEAR = 4;
	public var NEAREST = 5;
	
	@:from private static function fromString (value:String):Context3DTextureFilter {
		
		return switch (value) {
			
			case "anisotropic16x": ANISOTROPIC16X;
			case "anisotropic2x": ANISOTROPIC2X;
			case "anisotropic4x": ANISOTROPIC4X;
			case "anisotropic8x": ANISOTROPIC8X;
			case "linear": LINEAR;
			case "nearest": NEAREST;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DTextureFilter.ANISOTROPIC16X: "anisotropic16x";
			case Context3DTextureFilter.ANISOTROPIC2X: "anisotropic2x";
			case Context3DTextureFilter.ANISOTROPIC4X: "anisotropic4x";
			case Context3DTextureFilter.ANISOTROPIC8X: "anisotropic8x";
			case Context3DTextureFilter.LINEAR: "linear";
			case Context3DTextureFilter.NEAREST: "nearest";
			default: null;
			
		}
		
	}
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DTextureFilter, b:Context3DTextureFilter):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DTextureFilter, b:Context3DTextureFilter):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DTextureFilter(String) from String to String {
	
	public var ANISOTROPIC16X = "anisotropic16x";
	public var ANISOTROPIC2X = "anisotropic2x";
	public var ANISOTROPIC4X = "anisotropic4x";
	public var ANISOTROPIC8X = "anisotropic8x";
	public var LINEAR = "linear";
	public var NEAREST = "nearest";
	
}


#end