package flash.system;

#if flash
@:final extern class System
{
	#if (haxe_ver < 4.3)
	@:require(flash10_1) public static var freeMemory(default, never):Float;
	public static var ime(default, never):flash.system.IME;
	@:require(flash10_1) public static var privateMemory(default, never):Float;
	@:require(flash11) public static var processCPUUsage(default, never):Float;
	public static var totalMemory(default, never):Int;
	@:require(flash10_1) public static var totalMemoryNumber(default, never):Float;
	public static var useCodePage:Bool;
	public static var vmVersion(default, never):String;
	#else
	@:flash.property @:require(flash10_1) static var freeMemory(get, never):Float;
	@:flash.property static var ime(get, never):IME;
	@:flash.property @:require(flash10_1) static var privateMemory(get, never):Float;
	@:flash.property @:require(flash11) static var processCPUUsage(get, never):Float;
	@:flash.property static var totalMemory(get, never):UInt;
	@:flash.property @:require(flash10_1) static var totalMemoryNumber(get, never):Float;
	@:flash.property static var useCodePage(get, set):Bool;
	@:flash.property static var vmVersion(get, never):String;
	#end

	@:require(flash10_1) public static function disposeXML(node:flash.xml.XML):Void;
	public static function exit(code:UInt):Void;
	public static function gc():Void;
	public static function pause():Void;
	@:require(flash11) public static function pauseForGCIfCollectionImminent(imminence:Float = 0.75):Void;
	public static function resume():Void;
	public static function setClipboard(string:String):Void;

	#if (haxe_ver >= 4.3)
	private static function get_freeMemory():Float;
	private static function get_ime():IME;
	private static function get_privateMemory():Float;
	private static function get_processCPUUsage():Float;
	private static function get_totalMemory():UInt;
	private static function get_totalMemoryNumber():Float;
	private static function get_useCodePage():Bool;
	private static function get_vmVersion():String;
	private static function set_useCodePage(value:Bool):Bool;
	#end
}
#else
typedef System = openfl.system.System;
#end
