package openfl.desktop;

#if (!flash && sys)

#if !openfljs
/**
	The NotificationType class defines constants for use in the priority
	parameter of the DockIcon `bounce()` method and the type parameter of the
	NativeWindow `notifyUser()` method.

	@see `openfl.desktop.DockIcon.bounce()`
	@see `openfl.display.NativeWindow.notifyUser()`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract NotificationType(Null<Int>)

{
	/**
		Specifies that a notification alert is critical in nature and the user
		should attend to it promptly.
	**/
	public var CRITICAL = 0;

	/**
		Specifies that a notification alert is informational in nature and the
		user can safely ignore it.
	**/
	public var INFORMATIONAL = 1;

	@:from private static function fromString(value:String):NotificationType
	{
		return switch (value)
		{
			case "critical": CRITICAL;
			case "informational": INFORMATIONAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : NotificationType)
		{
			case NotificationType.CRITICAL: "critical";
			case NotificationType.INFORMATIONAL: "informational";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract NotificationType(String) from String to String

{
	public var CRITICAL = "critical";
	public var INFORMATIONAL = "informational";
}
#end
#else
#if air
typedef NotificationType = flash.desktop.NotificationType;
#end
#end
