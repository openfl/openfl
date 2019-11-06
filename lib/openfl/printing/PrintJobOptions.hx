package openfl.printing;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/printing/PrintJobOptions", "default")
#end
extern class PrintJobOptions
{
	public var printAsBitmap:Bool;
	public function new(printAsBitmap:Bool = false);
}
#else
typedef PrintJobOptions = flash.printing.PrintJobOptions;
#end
