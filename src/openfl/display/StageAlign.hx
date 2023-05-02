package openfl.display;

#if !flash

#if !openfljs
/**
	The StageAlign class provides constant values to use for the
	`Stage.align` property.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageAlign(Null<Int>)

{
	/**
		Specifies that the Stage is aligned at the bottom.
	**/
	public var BOTTOM = 0;

	/**
		Specifies that the Stage is aligned on the left.
	**/
	public var BOTTOM_LEFT = 1;

	/**
		Specifies that the Stage is aligned to the right.
	**/
	public var BOTTOM_RIGHT = 2;

	/**
		Specifies that the Stage is aligned on the left.
	**/
	public var LEFT = 3;

	/**
		Specifies that the Stage is aligned to the right.
	**/
	public var RIGHT = 4;

	/**
		Specifies that the Stage is aligned at the top.
	**/
	public var TOP = 5;

	/**
		Specifies that the Stage is aligned on the left.
	**/
	public var TOP_LEFT = 6;

	/**
		Specifies that the Stage is aligned to the right.
	**/
	public var TOP_RIGHT = 7;

	@:from private static function fromString(value:String):StageAlign
	{
		return switch (value)
		{
			case "bottom": BOTTOM;
			case "bottomLeft": BOTTOM_LEFT;
			case "bottomRight": BOTTOM_RIGHT;
			case "left": LEFT;
			case "right": RIGHT;
			case "top": TOP;
			case "topLeft": TOP_LEFT;
			case "topRight": TOP_RIGHT;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : StageAlign)
		{
			case StageAlign.BOTTOM: "bottom";
			case StageAlign.BOTTOM_LEFT: "bottomLeft";
			case StageAlign.BOTTOM_RIGHT: "bottomRight";
			case StageAlign.LEFT: "left";
			case StageAlign.RIGHT: "right";
			case StageAlign.TOP: "top";
			case StageAlign.TOP_LEFT: "topLeft";
			case StageAlign.TOP_RIGHT: "topRight";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageAlign(String) from String to String

{
	public var BOTTOM = "bottom";
	public var BOTTOM_LEFT = "bottomLeft";
	public var BOTTOM_RIGHT = "bottomRight";
	public var LEFT = "left";
	public var RIGHT = "right";
	public var TOP = "top";
	public var TOP_LEFT = "topLeft";
	public var TOP_RIGHT = "topRight";
}
#end
#else
typedef StageAlign = flash.display.StageAlign;
#end
