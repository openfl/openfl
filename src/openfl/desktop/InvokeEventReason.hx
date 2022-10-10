package openfl.desktop;

#if (sys && !flash)

#if !openfljs
/**
**/
@:enum abstract InvokeEventReason(Null<Int>)
{
	/**
	**/
	public var LOGIN = 0;

	/**
	**/
	public var NOTIFICATION = 1;

	/**
	**/
	public var OPEN_URL = 2;

	/**
	**/
	public var STANDARD = 3;

	@:from private static function fromString(value:String):InvokeEventReason
	{
		return switch (value)
		{
			case "login": LOGIN;
			case "notification": NOTIFICATION;
			case "openURL": OPEN_URL;
			case "standard": STANDARD;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : InvokeEventReason)
		{
			case InvokeEventReason.LOGIN: "login";
			case InvokeEventReason.NOTIFICATION: "notification";
			case InvokeEventReason.OPEN_URL: "openURL";
			case InvokeEventReason.STANDARD: "standard";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract InvokeEventReason(String) from String to String
{
	public var LOGIN = "login";
	public var NOTIFICATION = "notification";
	public var OPEN_URL = "openURL";
	public var STANDARD = "standard";
}
#end
#else
#if air
typedef InvokeEventReason = flash.desktop.InvokeEventReason;
#end
#end
