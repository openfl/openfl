package flash.display;

#if flash
import openfl.events.EventDispatcher;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;

extern class LoaderInfo extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var actionScriptVersion(default, never):flash.display.ActionScriptVersion;
	public var applicationDomain(default, never):ApplicationDomain;
	public var bytes(default, never):ByteArray;
	public var bytesLoaded(default, never):Int;
	public var bytesTotal(default, never):Int;
	public var childAllowsParent(default, never):Bool;
	@:require(flash11_4) public var childSandboxBridge:Dynamic;
	public var content(default, never):DisplayObject;
	public var contentType(default, never):String;
	public var frameRate(default, never):Float;
	public var height(default, never):Int;
	@:require(flash10_1) public var isURLInaccessible(default, never):Bool;
	public var loader(default, never):Loader;
	public var loaderURL(default, never):String;
	public var parameters(default, never):Dynamic<String>;
	public var parentAllowsChild(default, never):Bool;
	@:require(flash11_4) public var parentSandboxBridge:Dynamic;
	public var sameDomain(default, never):Bool;
	public var sharedEvents(default, never):EventDispatcher;
	public var swfVersion(default, never):UInt;
	public var uncaughtErrorEvents(default, never):UncaughtErrorEvents;
	public var url(default, never):String;
	public var width(default, never):Int;
	#else
	@:flash.property var actionScriptVersion(get, never):ActionScriptVersion;
	@:flash.property var applicationDomain(get, never):ApplicationDomain;
	@:flash.property var bytes(get, never):ByteArray;
	@:flash.property var bytesLoaded(get, never):UInt;
	@:flash.property var bytesTotal(get, never):UInt;
	@:flash.property var childAllowsParent(get, never):Bool;
	@:flash.property @:require(flash11_4) var childSandboxBridge(get, set):Dynamic;
	@:flash.property var content(get, never):DisplayObject;
	@:flash.property var contentType(get, never):String;
	@:flash.property var frameRate(get, never):Float;
	@:flash.property var height(get, never):Int;
	@:flash.property @:require(flash10_1) var isURLInaccessible(get, never):Bool;
	@:flash.property var loader(get, never):Loader;
	@:flash.property var loaderURL(get, never):String;
	@:flash.property var parameters(get, never):Dynamic<String>;
	@:flash.property var parentAllowsChild(get, never):Bool;
	@:flash.property @:require(flash11_4) var parentSandboxBridge(get, set):Dynamic;
	@:flash.property var sameDomain(get, never):Bool;
	@:flash.property var sharedEvents(get, never):EventDispatcher;
	@:flash.property var swfVersion(get, never):UInt;
	@:flash.property @:require(flash10_1) var uncaughtErrorEvents(get, never):UncaughtErrorEvents;
	@:flash.property var url(get, never):String;
	@:flash.property var width(get, never):Int;
	#end

	private function new();
	public static function getLoaderInfoByDefinition(object:Dynamic):LoaderInfo;

	#if (haxe_ver >= 4.3)
	private function get_actionScriptVersion():ActionScriptVersion;
	private function get_applicationDomain():ApplicationDomain;
	private function get_bytes():ByteArray;
	private function get_bytesLoaded():UInt;
	private function get_bytesTotal():UInt;
	private function get_childAllowsParent():Bool;
	private function get_childSandboxBridge():Dynamic;
	private function get_content():DisplayObject;
	private function get_contentType():String;
	private function get_frameRate():Float;
	private function get_height():Int;
	private function get_isURLInaccessible():Bool;
	private function get_loader():Loader;
	private function get_loaderURL():String;
	private function get_parameters():Dynamic<String>;
	private function get_parentAllowsChild():Bool;
	private function get_parentSandboxBridge():Dynamic;
	private function get_sameDomain():Bool;
	private function get_sharedEvents():EventDispatcher;
	private function get_swfVersion():UInt;
	private function get_uncaughtErrorEvents():UncaughtErrorEvents;
	private function get_url():String;
	private function get_width():Int;
	private function set_childSandboxBridge(value:Dynamic):Dynamic;
	private function set_parentSandboxBridge(value:Dynamic):Dynamic;
	#end
}
#else
typedef LoaderInfo = openfl.display.LoaderInfo;
#end
