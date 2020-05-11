package openfl.display;

import openfl.events._EventDispatcher;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.UncaughtErrorEvents;
import openfl.system.ApplicationDomain;
import openfl.utils.ByteArray;
#if openfl_html5
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.LoaderInfo)
@:access(openfl.events.Event)
@:noCompletion
class _LoaderInfo extends _EventDispatcher
{
	public static var __rootURL:String = #if openfl_html5 (Browser.supported ? Browser.document.URL : "") #else "" #end;

	public var applicationDomain:ApplicationDomain;
	public var bytes:ByteArray;
	public var bytesLoaded:Int;
	public var bytesTotal:Int;
	public var childAllowsParent:Bool;
	public var content:DisplayObject;
	public var contentType:String;
	public var frameRate:Float;
	public var height:Int;
	public var loader:Loader;
	public var loaderURL:String;
	public var parameters:Dynamic<String>;
	public var parentAllowsChild:Bool;
	public var sameDomain:Bool;
	public var sharedEvents:EventDispatcher;
	public var uncaughtErrorEvents:UncaughtErrorEvents;
	public var url:String;
	public var width:Int;

	public var __completed:Bool;

	public function new()
	{
		super();

		applicationDomain = ApplicationDomain.currentDomain;
		bytesLoaded = 0;
		bytesTotal = 0;
		childAllowsParent = true;
		parameters = {};
	}

	public static function create(loader:Loader):LoaderInfo
	{
		var loaderInfo = new LoaderInfo();
		loaderInfo._.uncaughtErrorEvents = new UncaughtErrorEvents();

		if (loader != null)
		{
			loaderInfo._.loader = loader;
		}
		else
		{
			loaderInfo._.url = __rootURL;
		}

		return loaderInfo;
	}

	public function __complete():Void
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

	public function __update(bytesLoaded:Int, bytesTotal:Int):Void
	{
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;

		dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal));
	}
}
