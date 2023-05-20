package flash.printing;

#if flash
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Vector;

extern class PrintJob
{
	#if (haxe_ver < 4.3)
	@:require(flash10_1) public static var isSupported(default, never):Bool;
	public var orientation:PrintJobOrientation;
	public var pageHeight(default, never):Int;
	public var pageWidth(default, never):Int;
	public var paperHeight(default, never):Int;
	public var paperWidth(default, never):Int;
	#if air
	public var copies:Int;
	public var firstPage(default, never):Int;
	public var isColor(default, never):Bool;
	public var jobName:String;
	public var lastPage(default, never):Int;
	public var maxPixelsPerInch(default, never):Float;
	public var paperArea(default, never):Rectangle;
	public var printableArea(default, never):Rectangle;
	public var printer:String;
	#end
	#else
	@:flash.property @:require(flash10_1) static var isSupported(get, never):Bool;
	@:flash.property var orientation(get, never):PrintJobOrientation;
	@:flash.property var pageHeight(get, never):Int;
	@:flash.property var pageWidth(get, never):Int;
	@:flash.property var paperHeight(get, never):Int;
	@:flash.property var paperWidth(get, never):Int;
	#if air
	@:flash.property var copies(get, set):Int;
	@:flash.property var firstPage(get, never):Int;
	@:flash.property var isColor(get, never):Bool;
	@:flash.property var jobName(get, set):String;
	@:flash.property var lastPage(get, never):Int;
	@:flash.property var maxPixelsPerInch(get, never):Float;
	@:flash.property var paperArea(get, never):Rectangle;
	@:flash.property var printableArea(get, never):Rectangle;
	@:flash.property var printer(get, set):String;
	#end
	#end
	public static var active(default, never):Bool;
	public static var printers(default, never):Vector<String>;
	public static var supportsPageSetupDialog(default, never):Bool;

	public function new();
	public function addPage(sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:Int = 0):Void;
	public function start():Bool;
	#if air
	public function selectPaperSize(paperSize:PaperSize):Void;
	public function send():Void;
	public function showPageSetupDialog():Bool;
	public function start2(?uiOptions:PrintUIOptions, showPrintDialog:Bool = true):Bool;
	public function terminate():Void;
	#end

	#if (haxe_ver >= 4.3)
	private function get_orientation():PrintJobOrientation;
	private function get_pageHeight():Int;
	private function get_pageWidth():Int;
	private function get_paperHeight():Int;
	private function get_paperWidth():Int;
	private static function get_isSupported():Bool;
	#if air
	private function get_copies():Int;
	private function get_firstPage():Int;
	private function get_isColor():Bool;
	private function get_jobName():String;
	private function get_lastPage():Int;
	private function get_maxPixelsPerInch():Float;
	private function get_paperArea():Rectangle;
	private function get_printableArea():Rectangle;
	private function get_printer():String;
	private function set_copies(value:Int):Int;
	private function set_jobName(value:String):String;
	private function set_printer(value:String):String;
	#end
	#end
}
#else
typedef PrintJob = openfl.printing.PrintJob;
#end
