package openfl.display3D;

#if (!flash && !openfljs)
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying a Program3D source format.
**/
@:enum abstract Context3DProgramFormat(Null<Int>)
{
	/**
		The program will use the AGAL (Adobe Graphics Assembly Language) format
	**/
	public var AGAL = 0;

	/**
		The program will use the GLSL (GL Shader Language) format
	**/
	public var GLSL = 1;

	@:from private static function fromString(value:String):Context3DProgramFormat
	{
		return switch (value)
		{
			case "agal": AGAL;
			case "glsl": GLSL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DProgramFormat)
		{
			case Context3DProgramFormat.AGAL: "agal";
			case Context3DProgramFormat.GLSL: "glsl";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DProgramFormat, b:Context3DProgramFormat):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DProgramFormat, b:Context3DProgramFormat):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DProgramFormat(String) from String to String
{
	public var AGAL = "agal";
	public var GLSL = "glsl";
}
#end
