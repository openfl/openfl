package openfl.desktop;

#if !flash

#if !openfljs
/**
	The ClipboardTransferMode class defines constants for the modes used as
	values of the `transferMode` parameter of the `Clipboard.getData()`
	method.
	The transfer mode provides a hint about whether to return a reference or a
	copy when accessing an object contained on a clipboard.
**/
@:enum abstract ClipboardTransferMode(Null<Int>)
{
	/**
		The Clipboard object should only return a copy.
	**/
	public var CLONE_ONLY = 0;

	/**
		The Clipboard object should return a copy if available and a reference if not.
	**/
	public var CLONE_PREFERRED = 1;

	/**
		The Clipboard object should only return a reference.
	**/
	public var ORIGINAL_ONLY = 2;

	/**
		The Clipboard object should return a reference if available and a copy if not.
	**/
	public var ORIGINAL_PREFERRED = 3;

	@:from private static function fromString(value:String):ClipboardTransferMode
	{
		return switch (value)
		{
			case "cloneOnly": CLONE_ONLY;
			case "clonePreferred": CLONE_PREFERRED;
			case "originalOnly": ORIGINAL_ONLY;
			case "originalPreferred": ORIGINAL_PREFERRED;
			default: null;
		}
	}

	@:to private static function toString(value:Int):String
	{
		return switch (value)
		{
			case ClipboardTransferMode.CLONE_ONLY: "cloneOnly";
			case ClipboardTransferMode.CLONE_PREFERRED: "clonePreferred";
			case ClipboardTransferMode.ORIGINAL_ONLY: "originalOnly";
			case ClipboardTransferMode.ORIGINAL_PREFERRED: "originalPreferred";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract ClipboardTransferMode(String) from String to String
{
	public var CLONE_ONLY = "cloneOnly";
	public var CLONE_PREFERRED = "clonePreferred";
	public var ORIGINAL_ONLY = "originalOnly";
	public var ORIGINAL_PREFERRED = "originalPreferred";
}
#end
#else
typedef ClipboardTransferMode = flash.desktop.ClipboardTransferMode;
#end
