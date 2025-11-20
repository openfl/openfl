package openfl.display._internal;

import openfl.utils.Promise;
import openfl.display.IDisplayObjectLoader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;
import openfl.utils.Future;

class BitmapDataLoader implements IDisplayObjectLoader
{
	public function new() {}

	public function load(request:URLRequest, context:LoaderContext, contentLoaderInfo:LoaderInfo):Future<DisplayObject>
	{
		// Will attempt to load any request, regardless of contentType

		#if (js && html5)
		if (contentLoaderInfo.contentType.indexOf("image/") > -1
			&& request.method == URLRequestMethod.GET
			&& (request.requestHeaders == null || request.requestHeaders.length == 0)
			&& request.userAgent == null)
		{
			return BitmapData.loadFromFile(request.url).then(function(bitmapData)
			{
				var content:DisplayObject = new Bitmap(bitmapData);
				return Future.withValue(content);
			});
		}
		#end

		var promise = new Promise<DisplayObject>();

		var loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, function(event)
		{
			promise.completeWith(loadBytes(loader.data, context, contentLoaderInfo));
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

	public function loadBytes(buffer:ByteArray, context:LoaderContext, contentLoaderInfo:LoaderInfo):Future<DisplayObject>
	{
		return BitmapData.loadFromBytes(buffer).then(function(bitmapData)
		{
			var content:DisplayObject = new Bitmap(bitmapData);
			return Future.withValue(content);
		});
	}
}
