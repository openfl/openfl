package openfl.printing;

#if (display || !flash)
@:jsRequire("openfl/printing/PrintJobOptions", "default")
extern class PrintJobOptions
{
	public var printAsBitmap:Bool;
	public function new(printAsBitmap:Bool = false);
}
#else
typedef PrintJobOptions = flash.printing.PrintJobOptions;
#end
