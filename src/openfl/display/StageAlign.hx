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
		if (value == null)
		{
			return null;
		}
		// interestingly, Flash accepts string values that are not defined on
		// the StageAlign class.
		var upperCaseValue = value.toUpperCase();
		var value = "";
		if (upperCaseValue.indexOf("T") != -1)
		{
			value += "T";
		}
		else if (upperCaseValue.indexOf("B") != -1)
		{
			// if a string contains both T and B, T takes precedence
			value += "B";
		}
		if (upperCaseValue.indexOf("L") != -1)
		{
			value += "L";
		}
		else if (upperCaseValue.indexOf("R") != -1)
		{
			// if a string contains both L and R, R takes precedence
			value += "R";
		}
		return switch (value)
		{
			case "B": BOTTOM;
			case "BL": BOTTOM_LEFT;
			case "BR": BOTTOM_RIGHT;
			case "L": LEFT;
			case "R": RIGHT;
			case "T": TOP;
			case "TL": TOP_LEFT;
			case "TR": TOP_RIGHT;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : StageAlign)
		{
			case StageAlign.BOTTOM: "B";
			case StageAlign.BOTTOM_LEFT: "BL";
			case StageAlign.BOTTOM_RIGHT: "BR";
			case StageAlign.LEFT: "L";
			case StageAlign.RIGHT: "R";
			case StageAlign.TOP: "T";
			case StageAlign.TOP_LEFT: "TL";
			case StageAlign.TOP_RIGHT: "TR";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment") #if (haxe_ver >= 4.0) enum #else @:enum #end abstract StageAlign(String) from String to String
{
	public var BOTTOM = "B";
	public var BOTTOM_LEFT = "BL";
	public var BOTTOM_RIGHT = "BR";
	public var LEFT = "L";
	public var RIGHT = "R";
	public var TOP = "T";
	public var TOP_LEFT = "TL";
	public var TOP_RIGHT = "TR";
}
#end
#else
typedef StageAlign = flash.display.StageAlign;
#end
