package openfl.display._internal;

import haxe.io.Path;
import openfl.display.IDisplayObjectLoader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.AssetLibrary;
import openfl.utils.ByteArray;
import openfl.utils.Future;
import openfl.utils.Promise;
#if lime
import lime.utils.AssetLibrary as LimeAssetLibrary;
import lime.utils.AssetManifest;
#end

class AssetManifestLoader implements IDisplayObjectLoader
{
	public function new() {}

	public function load(request:URLRequest, context:LoaderContext, contentLoaderInfo:LoaderInfo):Future<DisplayObject>
	{
		#if lime
		if (contentLoaderInfo.contentType != null && contentLoaderInfo.contentType.indexOf("/json") > -1)
		{
			var promise = new Promise<DisplayObject>();

			var loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(event)
			{
				var path = request.url;
				var queryIndex = path.indexOf("?");
				if (queryIndex > -1)
				{
					path = path.substring(0, queryIndex);
				}

				var manifest = AssetManifest.parse(loader.data, Path.directory(path));

				if (manifest == null)
				{
					promise.error("Cannot parse asset manifest");
					return;
				}

				var library = LimeAssetLibrary.fromManifest(manifest);

				if (library == null)
				{
					promise.error("Cannot open library");
					return;
				}

				if ((library is AssetLibrary))
				{
					library.load().onComplete(function(_)
					{
						var library:AssetLibrary = cast library;
						@:privateAccess contentLoaderInfo.assetLibrary = cast library;
						Assets.registerLibrary(contentLoaderInfo.url, library);

						if (manifest.name != null && !Assets.hasLibrary(manifest.name))
						{
							Assets.registerLibrary(manifest.name, library);
						}

						var clip = library.getMovieClip("");
						promise.complete(clip);
					}).onProgress(promise.progress).onError(promise.error);
				}
				else
				{
					promise.error("Library is not an OpenFL AssetLibrary");
				}
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent)
			{
				promise.error(event);
			});
			loader.addEventListener(ProgressEvent.PROGRESS, function(event:ProgressEvent)
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
