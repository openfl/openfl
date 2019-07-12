package openfl._internal.formats.swf;

import openfl._internal.symbols.BitmapSymbol;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.Assets;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetType;
import openfl.utils.Future;
#if lime
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.math.Vector2;
// import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#else
import openfl.utils.AssetManifest;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:keep class SWFLiteLibrary extends AssetLibrary
{
	private var alphaCheck:Map<String, Bool>;
	private var id:String;
	private var imageClassNames:Map<String, String>;
	private var instanceID:String;
	private var preloading:Bool;
	private var rootPath:String;
	private var swf:SWFLite;

	public function new(id:String, uuid:String = null)
	{
		super();

		this.id = id;

		instanceID = uuid != null ? uuid : id;

		alphaCheck = new Map();
		imageClassNames = new Map();

		#if (ios || tvos)
		rootPath = "assets/";
		#else
		rootPath = "";
		#end

		// Hack to include filter classes, macro.include is not working properly

		// var filter = flash.filters.BlurFilter;
		// var filter = flash.filters.DropShadowFilter;
		// var filter = flash.filters.GlowFilter;
	}

	#if lime
	public override function exists(id:String, type:String):Bool
	{
		if (swf == null) return false;

		if (id == "" && type == (cast AssetType.MOVIE_CLIP))
		{
			return true;
		}

		if (type == (cast AssetType.IMAGE) || type == (cast AssetType.MOVIE_CLIP))
		{
			return (swf != null && swf.hasSymbol(id));
		}

		return false;
	}
	#end

	#if lime
	public override function getImage(id:String):Image
	{
		if (imageClassNames.exists(id))
		{
			id = imageClassNames.get(id);
		}

		// TODO: Better system?

		if (!alphaCheck.exists(id))
		{
			for (symbol in swf.symbols)
			{
				if (Std.is(symbol, BitmapSymbol) && cast(symbol, BitmapSymbol).path == id)
				{
					var bitmapSymbol:BitmapSymbol = cast symbol;

					if (bitmapSymbol.alpha != null)
					{
						var image = super.getImage(id);
						var alpha = super.getImage(bitmapSymbol.alpha);

						__copyChannel(image, alpha);

						cachedImages.set(id, image);
						cachedImages.remove(bitmapSymbol.alpha);
						alphaCheck.set(id, true);

						return image;
					}
				}
			}

			alphaCheck.set(id, true);
		}

		return super.getImage(id);
	}
	#end

	#if lime
	public override function getMovieClip(id:String):MovieClip
	{
		return (swf != null) ? swf.createMovieClip(id) : null;
	}
	#end

	#if lime
	public override function isLocal(id:String, type:String):Bool
	{
		return true;
	}
	#end

	#if lime
	public override function load():Future<lime.utils.AssetLibrary>
	{
		if (id != null)
		{
			preload.set(id, true);
		}

		var promise = new Promise<lime.utils.AssetLibrary>();
		preloading = true;

		var onComplete = function(data)
		{
			cachedText.set(id, data);

			swf = SWFLite.unserialize(data);
			swf.library = this;

			var bitmapSymbol:BitmapSymbol;

			for (symbol in swf.symbols)
			{
				if (Std.is(symbol, BitmapSymbol))
				{
					bitmapSymbol = cast symbol;

					if (bitmapSymbol.className != null)
					{
						imageClassNames.set(bitmapSymbol.className, bitmapSymbol.path);
					}
				}
			}

			SWFLite.instances.set(instanceID, swf);

			__load().onProgress(promise.progress).onError(promise.error).onComplete(function(_)
			{
				preloading = false;
				promise.complete(this);
			});
		}

		if (Assets.exists(id))
		{
			#if (js && html5)
			for (id in paths.keys())
			{
				preload.set(id, true);
			}
			#end

			loadText(id).onError(promise.error).onComplete(onComplete);
		}
		else
		{
			for (id in paths.keys())
			{
				preload.set(id, true);
			}

			var path = null;

			if (paths.exists(id))
			{
				path = paths.get(id);
			}
			else
			{
				path = (rootPath != null && rootPath != "") ? rootPath + "/" + id : id;
			}

			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(_) onComplete(loader.data));
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e) promise.error(e));
			loader.load(new URLRequest(path));
		}

		return promise.future;
	}
	#end

	#if lime
	public override function loadImage(id:String):Future<Image>
	{
		if (imageClassNames.exists(id))
		{
			id = imageClassNames.get(id);
		}

		// TODO: Better system?

		if (#if (swf_preload || swflite_preload) true #else !preloading #end && !alphaCheck.exists(id))
		{
			for (symbol in swf.symbols)
			{
				if (Std.is(symbol, BitmapSymbol) && cast(symbol, BitmapSymbol).path == id)
				{
					var bitmapSymbol:BitmapSymbol = cast symbol;

					if (bitmapSymbol.alpha != null)
					{
						var promise = new Promise<Image>();

						__loadImage(id).onError(promise.error).onComplete(function(image)
						{
							__loadImage(bitmapSymbol.alpha).onError(promise.error).onComplete(function(alpha)
							{
								__copyChannel(image, alpha);

								cachedImages.set(id, image);
								cachedImages.remove(bitmapSymbol.alpha);
								alphaCheck.set(id, true);

								promise.complete(image);
							});
						});

						return promise.future;
					}
					else
					{
						alphaCheck.set(id, true);
					}
				}
			}
		}

		return super.loadImage(id);
	}
	#end

	#if lime
	public override function unload():Void
	{
		if (swf == null) return;

		if (SWFLite.instances.exists(instanceID) && SWFLite.instances.get(instanceID) == swf)
		{
			SWFLite.instances.remove(instanceID);
		}

		var bitmap:BitmapSymbol;

		for (symbol in swf.symbols)
		{
			if (Std.is(symbol, BitmapSymbol))
			{
				bitmap = cast symbol;
				Assets.cache.removeBitmapData(bitmap.path);
			}
		}
	}
	#end

	#if lime
	private function __copyChannel(image:Image, alpha:Image):Void
	{
		if (alpha != null)
		{
			image.copyChannel(alpha, alpha.rect, new Vector2(), ImageChannel.RED, ImageChannel.ALPHA);
		}

		image.buffer.premultiplied = true;

		#if !sys
		image.premultiplied = false;
		#end
	}
	#end

	#if lime
	private override function __fromManifest(manifest:AssetManifest):Void
	{
		rootPath = manifest.rootPath;
		super.__fromManifest(manifest);

		bytesTotal = 0;

		for (id in paths.keys())
		{
			bytesTotal += sizes.get(id);
		}
	}
	#end

	#if lime
	private function __load():Future<lime.utils.AssetLibrary>
	{
		return super.load();
	}
	#end

	#if lime
	private function __loadImage(id:String):Future<Image>
	{
		return super.loadImage(id);
	}
	#end
}
