package openfl.display._internal;

import openfl.display.IDisplayObjectLoader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;
import openfl.utils.Future;
import openfl.utils.Promise;

class ScriptLoader implements IDisplayObjectLoader
{
	public function new() {}

	public function load(request:URLRequest, context:LoaderContext, contentLoaderInfo:LoaderInfo):Future<DisplayObject>
	{
		#if (js && html5)
		if (contentLoaderInfo.contentType != null
			&& (contentLoaderInfo.contentType.indexOf("/javascript") > -1 || contentLoaderInfo.contentType.indexOf("/ecmascript") > -1))
		{
			var promise = new Promise<DisplayObject>();

			var loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(event)
			{
				#if (js && html5)
				// var script:ScriptElement = cast Browser.document.createElement ("script");
				// script.innerHTML = loader.data;
				// Browser.document.head.appendChild (script);

				untyped #if haxe4 js.Syntax.code #else __js__ #end ("eval")("(function () {" + loader.data + "})()");
				#end
				promise.complete(new Sprite());
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event)
			{
				promise.error(event);
			});
			loader.addEventListener(ProgressEvent.PROGRESS, function(event)
			{
				promise.progress(Std.int(event.bytesLoaded), Std.int(event.bytesTotal));
			});
			loader.load(request);

			return promise.future;
		}
		else
		#end
		{
			return null;
		}
	}

	public function loadBytes(buffer:ByteArray, context:LoaderContext, contentLoaderInfo:LoaderInfo):Future<DisplayObject>
	{
		return null;
	}
}
