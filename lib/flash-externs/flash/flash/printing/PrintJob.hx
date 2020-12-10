package flash.printing;

#if flash
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Vector;

extern class PrintJob
{
	#if air
	public static var active(default, never):Bool;
	#end
	#if flash
	@:require(flash10_1)
	#end
	public static var isSupported(default, never):Bool;
	#if air
	static var printers(default, never):Vector<String>;
	static var supportsPageSetupDialog(default, never):Bool;
	#end
	#if air
	public var copies:Int;
	public var firstPage(default, never):Int;
	public var isColor(default, never):Bool;
	public var jobName:String;
	public var lastPage(default, never):Int;
	public var maxPixelsPerInch(default, never):Float;
	#end
	public var orientation:PrintJobOrientation;
	public var pageHeight(default, never):Int;
	public var pageWidth(default, never):Int;
	#if air
	public var paperArea(default, never):flash.geom.Rectangle;
	#end
	public var paperHeight(default, never):Int;
	public var paperWidth(default, never):Int;
	#if air
	public var printableArea(default, never):flash.geom.Rectangle;
	public var printer:String;
	#end
	public function new();
	public function addPage(sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:Int = 0):Void;
	#if air
	public function selectPaperSize(paperSize:PaperSize):Void;
	#end
	public function send():Void;
	#if air
	public function showPageSetupDialog():Bool;
	#end
	public function start():Bool;
	#if air
	public function start2(?uiOptions:PrintUIOptions, showPrintDialog:Bool = true):Bool;
	public function terminate():Void;
	#end
}
#else
typedef PrintJob = openfl.printing.PrintJob;
#end
