package flash.display; #if (!display && flash)


import openfl.events.EventDispatcher;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;


extern class LoaderInfo extends EventDispatcher {
	
	
	#if flash
	@:noCompletion @:dox(hide) public var actionScriptVersion (default, null):flash.display.ActionScriptVersion;
	#end
	
	public var applicationDomain (default, null):ApplicationDomain;
	public var bytes (default, null):ByteArray;
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var childAllowsParent (default, null):Bool;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public var childSandboxBridge:Dynamic;
	#end
	
	public var content (default, null):DisplayObject;
	public var contentType (default, null):String;
	public var frameRate (default, null):Float;
	public var height (default, null):Int;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var isURLInaccessible (default, null):Bool;
	#end
	
	public var loader (default, null):Loader;
	public var loaderURL (default, null):String;
	public var parameters (default, null):Dynamic<String>;
	public var parentAllowsChild (default, null):Bool;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public var parentSandboxBridge:Dynamic;
	#end
	
	public var sameDomain (default, null):Bool;
	public var sharedEvents (default, null):EventDispatcher;
	
	#if flash
	@:noCompletion @:dox(hide) public var swfVersion (default, null):UInt;
	#end
	
	public var uncaughtErrorEvents (default, null):UncaughtErrorEvents;
	public var url (default, null):String;
	public var width (default, null):Int;
	
	private function new ();
	
	#if flash
	@:noCompletion @:dox(hide) public static function getLoaderInfoByDefinition (object:Dynamic):LoaderInfo;
	#end
	
	
}


#else
typedef LoaderInfo = openfl.display.LoaderInfo;
#end