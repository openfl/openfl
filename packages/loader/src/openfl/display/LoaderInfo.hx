package openfl.display;

#if !flash
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;
#if (js && html5)
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class LoaderInfo extends EventDispatcher
{
	@:noCompletion private static var __rootURL:String = #if (js && html5) (Browser.supported ? Browser.document.URL : "") #else "" #end;

	// @:noCompletion @:dox(hide) public var actionScriptVersion (default, never):openfl.display.ActionScriptVersion;
	public var applicationDomain(default, null):ApplicationDomain;
	public var bytes(default, null):ByteArray;
	public var bytesLoaded(default, null):Int;
	public var bytesTotal(default, null):Int;
	public var childAllowsParent(default, null):Bool;
	// @:noCompletion @:dox(hide) @:require(flash11_4) public var childSandboxBridge:Dynamic;
	public var content(default, null):DisplayObject;
	public var contentType(default, null):String;
	public var frameRate(default, null):Float;
	public var height(default, null):Int;
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var isURLInaccessible (default, null):Bool;
	public var loader(default, null):Loader;
	public var loaderURL(default, null):String;
	@SuppressWarnings("checkstyle:Dynamic") public var parameters(default, null):Dynamic<String>;
	public var parentAllowsChild(default, null):Bool;
	// @:noCompletion @:dox(hide) @:require(flash11_4) public var parentSandboxBridge:Dynamic;
	public var sameDomain(default, null):Bool;
	public var sharedEvents(default, null):EventDispatcher;
	// @:noCompletion @:dox(hide) public var swfVersion (default, null):UInt;
	public var uncaughtErrorEvents(default, null):UncaughtErrorEvents;
	public var url(default, null):String;
	public var width(default, null):Int;

	@:noCompletion private var __completed:Bool;

	@:noCompletion private function new()
	{
		super();

		applicationDomain = ApplicationDomain.currentDomain;
		bytesLoaded = 0;
		bytesTotal = 0;
		childAllowsParent = true;
		parameters = {};
	}

	@:noCompletion @:dox(hide)
	@SuppressWarnings("checkstyle:FieldDocComment")
	public static function create(loader:Loader):LoaderInfo
	{
		var loaderInfo = new LoaderInfo();
		loaderInfo.uncaughtErrorEvents = new UncaughtErrorEvents();

		if (loader != null)
		{
			loaderInfo.loader = loader;
		}
		else
		{
			loaderInfo.url = __rootURL;
		}

		return loaderInfo;
	}

	// @:noCompletion @:dox(hide) public static function getLoaderInfoByDefinition (object:Dynamic):LoaderInfo;
	@:noCompletion private function __complete():Void
	{
		if (!__completed)
		{
			if (bytesLoaded < bytesTotal)
			{
				bytesLoaded = bytesTotal;
			}

			__update(bytesLoaded, bytesTotal);
			__completed = true;

			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	@:noCompletion private function __update(bytesLoaded:Int, bytesTotal:Int):Void
	{
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;

		dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
	}
}
#else
typedef LoaderInfo = flash.display.LoaderInfo;
#end
