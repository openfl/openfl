package openfl.system;

#if !flash

#if !openfljs
/**
	The TouchscreenType class is an enumeration class that provides values for
	the different types of touch screens.
	Use the values defined by the TouchscreenType class with the
	`Capabilities.touchscreenType` property.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TouchscreenType(Null<Int>)

{
	/**
		A touchscreen designed to respond to finger touches.
	**/
	public var FINGER = 0;

	/**
		The computer or device does not have a supported touchscreen.
	**/
	public var NONE = 1;

	/**
		A touchscreen designed for use with a stylus.
	**/
	public var STYLUS = 2;

	@:from private static function fromString(value:String):TouchscreenType
	{
		return switch (value)
		{
			case "finger": FINGER;
			case "none": NONE;
			case "stylus": STYLUS;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : TouchscreenType)
		{
			case TouchscreenType.FINGER: "finger";
			case TouchscreenType.NONE: "none";
			case TouchscreenType.STYLUS: "stylus";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TouchscreenType(String) from String to String

{
	public var FINGER = "finger";
	public var NONE = "none";
	public var STYLUS = "stylus";
}
#end
#else
typedef TouchscreenType = flash.system.TouchscreenType;
#end
