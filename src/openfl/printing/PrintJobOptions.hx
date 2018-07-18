package openfl.printing; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class PrintJobOptions {
	
	
	public var printAsBitmap:Bool;
	
	
	public function new (printAsBitmap:Bool = false) {
		
		this.printAsBitmap = printAsBitmap;
		
	}
	
	
}


#else
typedef PrintJobOptions = flash.printing.PrintJobOptions;
#end