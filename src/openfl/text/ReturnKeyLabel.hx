package openfl.text;

#if !flash

#if !openfljs
/**
	The ReturnKeyLabel class defines the values to use for the `returnKeyLabel` property of the StageText class.
**/
@:enum abstract ReturnKeyLabel(Null<Int>)
{
	/**
		Use the default label.
	**/
	public var DEFAULT = 0;

	/**
		Use the label, "Done".
	**/
	public var DONE = 1;

	/**
		Use the label, "Go".
	**/
	public var GO = 2;

	/**
		Use the label, "Next".
	**/
	public var NEXT = 3;

	/**
		Use the label, "Search".
	**/
	public var SEARCH = 4;

	@:from private static function fromString(value:String):ReturnKeyLabel
	{
		return switch (value)
		{
			case "default": DEFAULT;
			case "done": DONE;
			case "go": GO;
			case "next": NEXT;
			case "search": SEARCH;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : ReturnKeyLabel)
		{
			case ReturnKeyLabel.DEFAULT: "default";
			case ReturnKeyLabel.DONE: "done";
			case ReturnKeyLabel.GO: "go";
			case ReturnKeyLabel.NEXT: "next";
			case ReturnKeyLabel.SEARCH: "search";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract ReturnKeyLabel(String) from String to String
{
	public var DEFAULT = "default";
	public var DONE = "done";
	public var GO = "go";
	public var NEXT = "next";
	public var SEARCH = "search";
}
#end
#else
typedef ReturnKeyLabel = flash.text.ReturnKeyLabel;
#end
