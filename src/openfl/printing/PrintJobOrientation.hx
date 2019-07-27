package openfl.printing;

#if !flash

#if !openfljs
/**
	This class provides values that are used by the `PrintJob.orientation`
	property for the image position of a printed page.
**/
@:enum abstract PrintJobOrientation(Null<Int>)
{
	/**
		The landscape (horizontal) image orientation for printing. This
		constant is used with the `PrintJob.orientation` property. Use the
		syntax `PrintJobOrientation.LANDSCAPE`.
	**/
	public var LANDSCAPE = 0;

	/**
		The portrait (vertical) image orientation for printing. This constant
		is used with the `PrintJob.orientation` property. Use the syntax
		`PrintJobOrientation.PORTRAIT`.
	**/
	public var PORTRAIT = 1;

	@:from private static function fromString(value:String):PrintJobOrientation
	{
		return switch (value)
		{
			case "landscape": LANDSCAPE;
			case "portrait": PORTRAIT;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : PrintJobOrientation)
		{
			case PrintJobOrientation.LANDSCAPE: "landscape";
			case PrintJobOrientation.PORTRAIT: "portrait";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract PrintJobOrientation(String) from String to String
{
	public var LANDSCAPE = "landscape";
	public var PORTRAIT = "portrait";
}
#end
#else
typedef PrintJobOrientation = flash.printing.PrintJobOrientation;
#end
