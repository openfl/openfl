package openfl.display;

#if !flash
import haxe.io.Path;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.UncaughtErrorEvents;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.system.LoaderContext;
import openfl.utils.Assets;
import openfl.utils.AssetLibrary;
import openfl.utils.ByteArray;
#if lime
import lime.utils.AssetLibrary as LimeAssetLibrary;
import lime.utils.AssetManifest;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.LoaderInfo)
@:access(openfl.events.Event)
class Loader extends DisplayObjectContainer
{
	public var content(default, null):DisplayObject;
	public var contentLoaderInfo(default, null):LoaderInfo;
	public var uncaughtErrorEvents(default, null):UncaughtErrorEvents;

	@:noCompletion private var __library:AssetLibrary;
	@:noCompletion private var __path:String;
	@:noCompletion private var __unloaded:Bool;

	public function new()
	{
		super();

		contentLoaderInfo = LoaderInfo.create(this);
		uncaughtErrorEvents = contentLoaderInfo.uncaughtErrorEvents;
		__unloaded = true;
	}

	#if (openfl >= "9.1.0")
	#error "Need to move addChild and sundry to private __addChild internally"
	public override function addChild(child:DisplayObject):DisplayObject
	{
		throw new Error("Error #2069: The Loader class does not implement this method.", 2069);
		return null;
	}

	public override function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		throw new Error("Error #2069: The Loader class does not implement this method.", 2069);
		return null;
	}
	#end

	#if !openfl_strict
	public function close():Void
	{
		openfl._internal.Lib.notImplemented();
	}
	#end

	public function load(request:URLRequest, context:LoaderContext = null):Void
	{
		unload();

		contentLoaderInfo.loaderURL = Lib.current.loaderInfo.url;
		contentLoaderInfo.url = request.url;
		__unloaded = false;

		if (request.contentType == null || request.contentType == "")
		{
			var extension = "";
			__path = request.url;

			var queryIndex = __path.indexOf("?");
			if (queryIndex > -1)
			{
				__path = __path.substring(0, queryIndex);
			}

			while (StringTools.endsWith(__path, "/"))
			{
				__path = __path.substring(0, __path.length - 1);
			}

			if (StringTools.endsWith(__path, ".bundle"))
			{
				__path += "/library.json";

				if (queryIndex > -1)
				{
					request.url = __path + request.url.substring(queryIndex);
				}
				else
				{
					request.url = __path;
				}
			}

			var extIndex = __path.lastIndexOf(".");
			if (extIndex > -1)
			{
				extension = __path.substring(extIndex + 1);
			}

			contentLoaderInfo.contentType = switch (extension)
			{
				case "json": "application/json";
				case "swf": "application/x-shockwave-flash";
				case "jpg", "jpeg": "image/jpeg";
				case "png": "image/png";
				case "gif": "image/gif";
				case "js": "application/javascript";
				default:
					"application/x-www-form-urlencoded"; /*throw "Unrecognized file " + request.url;*/
			}
		}
		else
		{
			contentLoaderInfo.contentType = request.contentType;
		}

		#if (js && html5)
		if (contentLoaderInfo.contentType.indexOf("image/") > -1
			&& request.method == URLRequestMethod.GET
			&& (request.requestHeaders == null || request.requestHeaders.length == 0)
			&& request.userAgent == null)
		{
			BitmapData.loadFromFile(request.url)
				.onComplete(BitmapData_onLoad)
				.onError(BitmapData_onError)
				.onProgress(BitmapData_onProgress);
			return;
		}
		#end

		var loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;

		if (contentLoaderInfo.contentType.indexOf("/json") > -1
			|| contentLoaderInfo.contentType.indexOf("/javascript") > -1
			|| contentLoaderInfo.contentType.indexOf("/ecmascript") > -1)
		{
			loader.dataFormat = TEXT;
		}

		loader.addEventListener(Event.COMPLETE, loader_onComplete);
		loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onError);
		loader.addEventListener(ProgressEvent.PROGRESS, loader_onProgress);
		loader.load(request);
	}

	public function loadBytes(buffer:ByteArray, context:LoaderContext = null):Void
	{
		BitmapData.loadFromBytes(buffer).onComplete(BitmapData_onLoad).onError(BitmapData_onError);
	}

	#if (openfl >= "9.1.0")
	public override function removeChild(child:DisplayObject):DisplayObject
	{
		throw new Error("Error #2069: The Loader class does not implement this method.", 2069);
		return null;
	}

	public override function removeChildAt(index:Int):DisplayObject
	{
		throw new Error("Error #2069: The Loader class does not implement this method.", 2069);
		return null;
	}

	public override function setChildIndex(child:DisplayObject, index:Int):Void
	{
		throw new Error("Error #2069: The Loader class does not implement this method.", 2069);
	}
	#end

	public function unload():Void
	{
		if (!__unloaded)
		{
			if (content != null && content.parent == this)
			{
				super.removeChild(content);
			}

			if (__library != null)
			{
				Assets.unloadLibrary(contentLoaderInfo.url);
				__library = null;
			}

			content = null;
			contentLoaderInfo.url = null;
			contentLoaderInfo.contentType = null;
			contentLoaderInfo.content = null;
			contentLoaderInfo.bytesLoaded = 0;
			contentLoaderInfo.bytesTotal = 0;
			contentLoaderInfo.width = 0;
			contentLoaderInfo.height = 0;
			__unloaded = true;

			contentLoaderInfo.dispatchEvent(new Event(Event.UNLOAD));
		}
	}

	public function unloadAndStop(gc:Bool = true):Void
	{
		if (content != null)
		{
			content.__stopAllMovieClips();
		}

		for (i in 0...numChildren)
		{
			getChildAt(i).__stopAllMovieClips();
		}

		unload();

		if (gc)
		{
			#if cpp
			cpp.vm.Gc.run(false);
			#elseif neko
			neko.vm.Gc.run(false);
			#end
		}
	}

	@:noCompletion private function __dispatchError(text:String):Void
	{
		var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
		event.text = text;
		contentLoaderInfo.dispatchEvent(event);
	}

	@:noCompletion private function __setContent(content:DisplayObject, width:Int, height:Int):Void
	{
		this.content = content;

		contentLoaderInfo.content = content;
		contentLoaderInfo.width = width;
		contentLoaderInfo.height = height;

		if (content != null)
		{
			super.addChildAt(content, 0);
		}
	}

	// Event Handlers

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function BitmapData_onError(error:Dynamic):Void
	{
		// TODO: Dispatch HTTPStatusEvent

		__dispatchError(Std.string(error));
	}

	@:noCompletion private function BitmapData_onLoad(bitmapData:BitmapData):Void
	{
		// TODO: Dispatch HTTPStatusEvent

		if (bitmapData == null)
		{
			__dispatchError("Unknown error");
			return;
		}

		__setContent(new Bitmap(bitmapData), bitmapData.width, bitmapData.height);

		contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
	}

	@:noCompletion private function BitmapData_onProgress(bytesLoaded:Int, bytesTotal:Int):Void
	{
		var event = new ProgressEvent(ProgressEvent.PROGRESS);
		event.bytesLoaded = bytesLoaded;
		event.bytesTotal = bytesTotal;
		contentLoaderInfo.dispatchEvent(event);
	}

	@:noCompletion private function loader_onComplete(event:Event):Void
	{
		// TODO: Dispatch HTTPStatusEvent

		var loader:URLLoader = cast event.target;

		#if lime
		if (contentLoaderInfo.contentType != null && contentLoaderInfo.contentType.indexOf("/json") > -1)
		{
			var manifest = AssetManifest.parse(loader.data, Path.directory(__path));

			if (manifest == null)
			{
				__dispatchError("Cannot parse asset manifest");
				return;
			}

			var library = LimeAssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				__dispatchError("Cannot open library");
				return;
			}

			if ((library is AssetLibrary))
			{
				library.load().onComplete(function(_)
				{
					__library = cast library;
					Assets.registerLibrary(contentLoaderInfo.url, __library);

					if (manifest.name != null && !Assets.hasLibrary(manifest.name))
					{
						Assets.registerLibrary(manifest.name, __library);
					}

					var clip = __library.getMovieClip("");
					__setContent(clip, Std.int(clip.width), Std.int(clip.height));

					contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
				}).onError(function(e)
				{
					__dispatchError(e);
				});
			}
		}
		else
		#end
		if (contentLoaderInfo.contentType != null
			&& (contentLoaderInfo.contentType.indexOf("/javascript") > -1 || contentLoaderInfo.contentType.indexOf("/ecmascript") > -1))
		{
			__setContent(new Sprite(), 0, 0);

			#if (js && html5)
			// var script:ScriptElement = cast Browser.document.createElement ("script");
			// script.innerHTML = loader.data;
			// Browser.document.head.appendChild (script);

			untyped #if haxe4 js.Syntax.code #else __js__ #end ("eval")("(function () {" + loader.data + "})()");
			#end

			contentLoaderInfo.dispatchEvent(new Event(Event.COMPLETE));
		}
		else
		{
			contentLoaderInfo.bytes = loader.data;
			BitmapData.loadFromBytes(loader.data).onComplete(BitmapData_onLoad).onError(BitmapData_onError);
		}
	}

	@:noCompletion private function loader_onError(event:IOErrorEvent):Void
	{
		// TODO: Dispatch HTTPStatusEvent

		event.target = contentLoaderInfo;
		contentLoaderInfo.dispatchEvent(event);
	}

	@:noCompletion private function loader_onProgress(event:ProgressEvent):Void
	{
		event.target = contentLoaderInfo;
		contentLoaderInfo.dispatchEvent(event);
	}
}
#else
typedef Loader = flash.display.Loader;
#end
