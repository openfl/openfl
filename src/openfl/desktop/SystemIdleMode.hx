package openfl.desktop;

#if (!flash && sys)

#if !openfljs
/**
	The SystemIdleMode class provides constant values for system idle behaviors.
	These constants are used in the `systemIdleMode` property of the
	`NativeApplication` class.

	@see `openfl.desktop.NativeApplication.systemIdleMode`
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SystemIdleMode(Null<Int>)

{
	/**
		Prevents the system from dropping into an idle mode.

		On Android, the application must specify the Android permissions for
		DISABLE_KEYGUARD and WAKE_LOCK in the application descriptor or the
		operating system will not honor this setting.
	**/
	public var KEEP_AWAKE = 0;

	/**
		The system follows the normal "idle user" behavior.
	**/
	public var NORMAL = 1;

	@:from private static function fromString(value:String):SystemIdleMode
	{
		return switch (value)
		{
			case "keepAwake": KEEP_AWAKE;
			case "normal": NORMAL;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : SystemIdleMode)
		{
			case SystemIdleMode.KEEP_AWAKE: "keepAwake";
			case SystemIdleMode.NORMAL: "normal";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SystemIdleMode(String) from String to String

{
	public var KEEP_AWAKE = "keepAwake";
	public var NORMAL = "normal";
}
#end
#else
#if air
typedef SystemIdleMode = flash.desktop.SystemIdleMode;
#end
#end
