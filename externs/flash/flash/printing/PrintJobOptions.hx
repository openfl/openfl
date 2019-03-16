package flash.printing;

#if flash
extern class PrintJobOptions
{
	#if air
	public var pixelsPerInch:Float;
	#end
	public var printAsBitmap:Bool;
	#if air
	public var printMethod:PrintMethod;
	#end
	public function new(printAsBitmap:Bool = false);
}
#else
typedef PrintJobOptions = openfl.printing.PrintJobOptions;
#end
