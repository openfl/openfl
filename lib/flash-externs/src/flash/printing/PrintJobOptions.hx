package flash.printing;

#if flash
extern class PrintJobOptions
{
	public var printAsBitmap:Bool;
	#if air
	public var pixelsPerInch:Float;
	public var printMethod:PrintMethod;
	#end

	public function new(printAsBitmap:Bool = false);
}
#else
typedef PrintJobOptions = openfl.printing.PrintJobOptions;
#end
