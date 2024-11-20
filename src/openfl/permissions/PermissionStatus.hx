package openfl.permissions;

#if !flash
#if !openfljs
/**
	The PermissionStatus class is an enumeration of constant values that specify
	the authorization status of a permission.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract PermissionStatus(Null<Int>)

{
	/**
		Specifies that the permission has been denied.
	**/
	public var DENIED = 0;

	/**
		Specifies that the permission has been granted.
	**/
	public var GRANTED = 1;

	/**
		Specifies that the permission has been granted only when the app is in use.
	**/
	public var ONLY_WHEN_IN_USE = 2;

	/**
		Specifies that the permission hasn't been requested yet.

		NOTE: On Android, `permissionStatus` will return `UNKNOWN` if permission
		was denied with "Never ask again" option checked.
	**/
	public var UNKNOWN = 3;

	@:from private static function fromString(value:String):PermissionStatus
	{
		return switch (value)
		{
			case "denied": DENIED;
			case "granted": GRANTED;
			case "onlyWhenInUse": ONLY_WHEN_IN_USE;
			case "unknown": UNKNOWN;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : PermissionStatus)
		{
			case PermissionStatus.DENIED: "denied";
			case PermissionStatus.GRANTED: "granted";
			case PermissionStatus.ONLY_WHEN_IN_USE: "onlyWhenInUse";
			case PermissionStatus.UNKNOWN: "unknown";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract PermissionStatus(String) from String to String

{
	public var DENIED = "denied";
	public var GRANTED = "granted";
	public var ONLY_WHEN_IN_USE = "onlyWhenInUse";
	public var UNKNOWN = "unknown";
}
#end
#else
#if air
typedef PermissionStatus = flash.permissions.PermissionStatus;
#end
#end
