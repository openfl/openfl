package openfl.net;

#if !flash

#if !openfljs
/**
	The SharedObjectFlushStatus class provides values for the code returned
	from a call to the `SharedObject.flush()` method.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SharedObjectFlushStatus(Null<Int>)

{
	/**
		Indicates that the flush completed successfully.
	**/
	public var FLUSHED = 0;

	/**
		Indicates that the user is being prompted to increase disk space for the
		shared object before the flush can occur.
	**/
	public var PENDING = 1;

	@:from private static function fromString(value:String):SharedObjectFlushStatus
	{
		return switch (value)
		{
			case "flushed": FLUSHED;
			case "pending": PENDING;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : SharedObjectFlushStatus)
		{
			case SharedObjectFlushStatus.FLUSHED: "flushed";
			case SharedObjectFlushStatus.PENDING: "pending";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SharedObjectFlushStatus(String) from String to String

{
	public var FLUSHED = "flushed";
	public var PENDING = "pending";
}
#end
#else
typedef SharedObjectFlushStatus = flash.net.SharedObjectFlushStatus;
#end
