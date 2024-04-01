package flash.display;

#if flash
import openfl.events.UncaughtErrorEvents;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;

extern class Loader extends DisplayObjectContainer
{
	#if (haxe_ver < 4.3)
	public var content(default, never):DisplayObject;
	public var contentLoaderInfo(default, never):LoaderInfo;
	@:require(flash10_1) public var uncaughtErrorEvents(default, never):UncaughtErrorEvents;
	#else
	@:flash.property var content(get, never):DisplayObject;
	@:flash.property var contentLoaderInfo(get, never):LoaderInfo;
	@:flash.property @:require(flash10_1) var uncaughtErrorEvents(get, never):UncaughtErrorEvents;
	#end

	public function new();
	public function close():Void;
	public function load(request:URLRequest, context:LoaderContext = null):Void;
	public function loadBytes(buffer:ByteArray, context:LoaderContext = null):Void;
	#if air
	public function loadFilePromise(promise:flash.desktop.IFilePromise, ?context:LoaderContext):Void;
	#end
	public function unload():Void;
	@:require(flash10) public function unloadAndStop(gc:Bool = true):Void;

	#if (haxe_ver >= 4.3)
	private function get_content():DisplayObject;
	private function get_contentLoaderInfo():LoaderInfo;
	private function get_uncaughtErrorEvents():UncaughtErrorEvents;
	#end
}
#else
typedef Loader = openfl.display.Loader;
#end
