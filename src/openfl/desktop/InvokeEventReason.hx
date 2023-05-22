package openfl.desktop;

#if (sys && !flash)

#if !openfljs
/**
	The InvokeEventReason class enumerates values returned by the `reason`
	property of an InvokeEvent object.

	@see `openfl.events.InvokeEvent.reason`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract InvokeEventReason(Null<Int>)

{
	/**
		Desktop only; indicates that the InvokeEvent event occurred due to the
		user logging in.
	**/
	public var LOGIN = 0;

	/**
		iOS only; indicates that the InvokeEvent occurred because the
		application was invoked on receiving a remote notification.
	**/
	public var NOTIFICATION = 1;

	/**
		Mobile only; indicates that the InvokeEvent occurred because the
		application was invoked by another application or by the system.
	**/
	public var OPEN_URL = 2;

	/**
		Indicates that the InvokeEvent occured for any reason other than login
		or open url.
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
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract InvokeEventReason(String) from String to String

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
