package openfl.display;

#if !flash

#if !openfljs
/**
	The JointStyle class is an enumeration of constant values that specify the
	joint style to use in drawing lines. These constants are provided for use
	as values in the `joints` parameter of the
	`openfl.display.Graphics.lineStyle()` method. The method supports
	three types of joints: miter, round, and bevel, as the following example
	shows:
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract JointStyle(Null<Int>)

{
	/**
		Specifies beveled joints in the `joints` parameter of the
		`openfl.display.Graphics.lineStyle()` method.
	**/
	public var BEVEL = 0;

	/**
		Specifies mitered joints in the `joints` parameter of the
		`openfl.display.Graphics.lineStyle()` method.
	**/
	public var MITER = 1;

	/**
		Specifies round joints in the `joints` parameter of the
		`openfl.display.Graphics.lineStyle()` method.
	**/
	public var ROUND = 2;

	@:noCompletion private inline static function fromInt(value:Null<Int>):JointStyle
	{
		return cast value;
	}

	@:from private static function fromString(value:String):JointStyle
	{
		return switch (value)
		{
			case "bevel": BEVEL;
			case "miter": MITER;
			case "round": ROUND;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : JointStyle)
		{
			case JointStyle.BEVEL: "bevel";
			case JointStyle.MITER: "miter";
			case JointStyle.ROUND: "round";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract JointStyle(String) from String to String

{
	public var BEVEL = "bevel";
	public var MITER = "miter";
	public var ROUND = "round";

	@:noCompletion private inline static function fromInt(value:Null<Int>):JointStyle
	{
		return switch (value)
		{
			case 0: BEVEL;
			case 1: MITER;
			case 2: ROUND;
			default: null;
		}
	}
}
#end
#else
typedef JointStyle = flash.display.JointStyle;
#end
