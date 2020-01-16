package flash.system;

#if flash
@:final extern class System
{
	#if flash
	@:require(flash10_1) public static var freeMemory(default, never):Float;
	#end
	#if flash
	public static var ime(default, never):flash.system.IME;
	#end
	#if flash
	@:require(flash10_1) public static var privateMemory(default, never):Float;
	#end
	#if flash
	@:require(flash11) public static var processCPUUsage(default, never):Float;
	#end
	public static var totalMemory(default, never):Int;
	#if flash
	@:require(flash10_1) public static var totalMemoryNumber(default, never):Float;
	#end
	public static var useCodePage:Bool;
	public static var vmVersion(default, never):String;
	#if flash
	@:require(flash10_1) public static function disposeXML(node:flash.xml.XML):Void;
	#end
	public static function exit(code:UInt):Void;
	public static function gc():Void;
	public static function pause():Void;
	#if flash
	@:require(flash11) public static function pauseForGCIfCollectionImminent(imminence:Float = 0.75):Void;
	#end
	public static function resume():Void;
	public static function setClipboard(string:String):Void;
}
#else
typedef System = openfl.system.System;
#end
