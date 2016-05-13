package flash.system; #if (!display && flash)


@:final extern class System {
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static var freeMemory (default, null):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public static var ime (default, null):flash.system.IME;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static var privateMemory (default, null):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static var processCPUUsage (default, null):Float;
	#end
	
	public static var totalMemory (default, null):Int;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static var totalMemoryNumber (default, null):Float;
	#end
	
	public static var useCodePage:Bool;
	
	public static var vmVersion (default, null):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public static function disposeXML (node:flash.xml.XML):Void;
	#end
	
	public static function exit (code:UInt):Void;
	public static function gc ():Void;
	public static function pause ():Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public static function pauseForGCIfCollectionImminent (imminence:Float = 0.75):Void;
	#end
	
	public static function resume ():Void;
	public static function setClipboard (string:String):Void;
	
	
}


#else
typedef System = openfl.system.System;
#end