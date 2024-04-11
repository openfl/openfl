package openfl.media;

#if (!flash && sys)

#if !openfljs
/**
	The CameraPosition class defines constants for the `position` property of
	the Camera class.

	@see `openfl.media.Camera`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CameraPosition(Null<Int>)

{
	/**
		The `Camera.position` property returns this value for a back camera.
	**/
	public var BACK = 0;

	/**
		The `Camera.position` property returns this value for a front camera.
	**/
	public var FRONT = 1;

	/**
		The `Camera.position` property returns this value when the position of
		the Camera cannot be determined. This is the default value.
	**/
	public var UNKNOWN = 2;

	@:from private static function fromString(value:String):CameraPosition
	{
		return switch (value)
		{
			case "back": BACK;
			case "front": FRONT;
			case "unknown": UNKNOWN;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : CameraPosition)
		{
			case CameraPosition.BACK: "back";
			case CameraPosition.FRONT: "front";
			case CameraPosition.UNKNOWN: "unknown";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract CameraPosition(String) from String to String

{
	public var BACK = "back";
	public var FRONT = "front";
	public var UNKNOWN = "unknown";
}
#end
#else
#if air
typedef CameraPosition = flash.media.CameraPosition;
#end
#end
