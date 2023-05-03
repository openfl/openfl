package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying the Context3D render mode.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DRenderMode(Null<Int>)

{
	/**
		Automatically choose rendering engine.

		A hardware-accelerated rendering engine is used if available on the current
		device. Availability of hardware acceleration is influenced by the device
		capabilites, the wmode when running under Flash Player, and the render mode when
		running under AIR.
	**/
	public var AUTO = 0;

	/**
		Use software 3D rendering.

		Software rendering is not available on mobile devices.
	**/
	public var SOFTWARE = 1;

	@:from private static function fromString(value:String):Context3DRenderMode
	{
		return switch (value)
		{
			case "auto": AUTO;
			case "software": SOFTWARE;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DRenderMode)
		{
			case Context3DRenderMode.AUTO: "auto";
			case Context3DRenderMode.SOFTWARE: "software";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DRenderMode, b:Context3DRenderMode):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DRenderMode, b:Context3DRenderMode):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DRenderMode(String) from String to String

{
	public var AUTO = "auto";
	public var SOFTWARE = "software";
}
#end
#else
typedef Context3DRenderMode = flash.display3D.Context3DRenderMode;
#end
