package openfl.printing;


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