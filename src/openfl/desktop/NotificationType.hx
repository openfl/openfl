package openfl.desktop;

#if (!flash && sys)
#if !openfljs
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract NotificationType(Null<Int>)

{
	public var CRITICAL = 0;
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
