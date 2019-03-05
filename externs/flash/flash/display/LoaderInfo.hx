package flash.display;

#if flash
import openfl.events.EventDispatcher;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;

extern class LoaderInfo extends EventDispatcher
{
	#if flash
	public var actionScriptVersion(default, never):flash.display.ActionScriptVersion;
	#end
	public var applicationDomain(default, never):ApplicationDomain;
	public var bytes(default, never):ByteArray;
	public var bytesLoaded(default, never):Int;
	public var bytesTotal(default, never):Int;
	public var childAllowsParent(default, never):Bool;
	#if flash
	@:require(flash11_4) public var childSandboxBridge:Dynamic;
	#end
	public var content(default, never):DisplayObject;
	public var contentType(default, never):String;
	public var frameRate(default, never):Float;
	public var height(default, never):Int;
	#if flash
	@:require(flash10_1) public var isURLInaccessible(default, never):Bool;
	#end
	public var loader(default, never):Loader;
	public var loaderURL(default, never):String;
	public var parameters(default, never):Dynamic<String>;
	public var parentAllowsChild(default, never):Bool;
	#if flash
	@:require(flash11_4) public var parentSandboxBridge:Dynamic;
	#end
	public var sameDomain(default, never):Bool;
	public var sharedEvents(default, never):EventDispatcher;
	#if flash
	public var swfVersion(default, never):UInt;
	#end
	public var uncaughtErrorEvents(default, never):UncaughtErrorEvents;
	public var url(default, never):String;
	public var width(default, never):Int;
	private function new();
	#if flash
	public static function getLoaderInfoByDefinition(object:Dynamic):LoaderInfo;
	#end
}
#else
typedef LoaderInfo = openfl.display.LoaderInfo;
#end
