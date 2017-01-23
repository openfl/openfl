package flash.printing; #if (!display && flash)


import openfl.display.Sprite;
import openfl.geom.Rectangle;


extern class PrintJob {
	
	
	#if flash
	@:require(flash10_1)
	#end
	public static var isSupported (default, null):Bool;
	
	public var orientation:PrintJobOrientation;
	public var pageHeight (default, null):Int;
	public var pageWidth (default, null):Int;
	public var paperHeight (default, null):Int;
	public var paperWidth (default, null):Int;
	
	
	public function new ();
	
	public function addPage (sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:Int = 0):Void;
	public function send ():Void;
	public function start ():Bool;
	
	
}


#else
typedef PrintJob = openfl.printing.PrintJob;
#end
