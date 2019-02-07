package flash.printing;

#if flash
@:enum abstract PrintJobOrientation(String) from String to String
{
	public var LANDSCAPE = "landscape";
	public var PORTRAIT = "portrait";
}
#else
typedef PrintJobOrientation = openfl.printing.PrintJobOrientation;
#end
