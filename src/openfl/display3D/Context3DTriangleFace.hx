package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Constants to specify the orientation of a triangle relative to the view point.
**/
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DTriangleFace(Null<Int>)
{
	public var BACK = 0;
	public var FRONT = 1;
	public var FRONT_AND_BACK = 2;
	public var NONE = 3;

	@:from private static function fromString(value:String):Context3DTriangleFace
	{
		return switch (value)
		{
			case "back": BACK;
			case "front": FRONT;
			case "frontAndBack": FRONT_AND_BACK;
			case "none": NONE;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DTriangleFace)
		{
			case Context3DTriangleFace.BACK: "back";
			case Context3DTriangleFace.FRONT: "front";
			case Context3DTriangleFace.FRONT_AND_BACK: "frontAndBack";
			case Context3DTriangleFace.NONE: "none";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DTriangleFace, b:Context3DTriangleFace):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DTriangleFace, b:Context3DTriangleFace):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DTriangleFace(String) from String to String
{
	public var BACK = "back";
	public var FRONT = "front";
	public var FRONT_AND_BACK = "frontAndBack";
	public var NONE = "none";
}
#end
#else
typedef Context3DTriangleFace = flash.display3D.Context3DTriangleFace;
#end
