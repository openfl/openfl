package openfl.utils;

import openfl._internal.utils.Log;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;
import openfl.text.Font;
#if lime
import lime.app.Promise;
import lime.utils.AssetLibrary as LimeAssetLibrary;
import lime.utils.Assets as LimeAssets;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.BitmapData)
@:access(openfl.text.Font)
@:access(openfl.utils.AssetLibrary)
class Assets
{
	public static var cache:IAssetCache = new AssetCache();
	@:noCompletion private static var dispatcher:EventDispatcher #if !macro = new EventDispatcher() #end;

	public static function addEventListener(type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		#if lime
		if (!LimeAssets.onChange.has(LimeAssets_onChange))
		{
			LimeAssets.onChange.add(LimeAssets_onChange);
		}
		#end

		dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public static function dispatchEvent(event:Event):Bool
	{
		return dispatcher.dispatchEvent(event);
	}

	public static function exists(id:String, type:AssetType = null):Bool
	{
		#if lime
		return LimeAssets.exists(id, cast type);
		#else
		return false;
		#end
	}

	public static function getBitmapData(id:String, useCache:Bool = true):BitmapData
	{
		#if (lime && tools && !display)
		if (useCache && cache.enabled && cache.hasBitmapData(id))
		{
			var bitmapData = cache.getBitmapData(id);

			if (isValidBitmapData(bitmapData))
			{
				return bitmapData;
			}
		}

		var image = LimeAssets.getImage(id, false);

		if (image != null)
		{
			#if flash
			var bitmapData = image.src;
			#else
			var bitmapData = BitmapData.fromImage(image);
			#end

			if (useCache && cache.enabled)
			{
				cache.setBitmapData(id, bitmapData);
			}

			return bitmapData;
		}
		#end

		return null;
	}

	public static function getBytes(id:String):ByteArray
	{
		#if lime
		return LimeAssets.getBytes(id);
		#else
		return null;
		#end
	}

	public static function getFont(id:String, useCache:Bool = true):Font
	{
		#if (lime && tools && !display && !macro)
		if (useCache && cache.enabled && cache.hasFont(id))
		{
			return cache.getFont(id);
		}

		var limeFont = LimeAssets.getFont(id, false);

		if (limeFont != null)
		{
			#if flash
			var font = limeFont.src;
			#else
			var font = new Font();
			font.__fromLimeFont(limeFont);
			#end

			if (useCache && cache.enabled)
			{
				cache.setFont(id, font);
			}

			return font;
		}
		#end

		return new Font();
	}

	public static function getLibrary(name:String):#if lime LimeAssetLibrary #else AssetLibrary #end
	{
		#if lime
		return LimeAssets.getLibrary(name);
		#else
		return null;
		#end
	}

	public static function getMovieClip(id:String):MovieClip
	{
		#if (lime && tools && !display)
		var libraryName = id.substring(0, id.indexOf(":"));
		var symbolName = id.substr(id.indexOf(":") + 1);
		var limeLibrary = getLibrary(libraryName);

		if (limeLibrary != null)
		{
			if ((limeLibrary is AssetLibrary))
			{
				var library:AssetLibrary = cast limeLibrary;

				if (library.exists(symbolName, cast AssetType.MOVIE_CLIP))
				{
					if (library.isLocal(symbolName, cast AssetType.MOVIE_CLIP))
					{
						return library.getMovieClip(symbolName);
					}
					else
					{
						Log.error("MovieClip asset \"" + id + "\" exists, but only asynchronously");
						return null;
					}
				}
			}

			Log.error("There is no MovieClip asset with an ID of \"" + id + "\"");
		}
		else
		{
			Log.error("There is no asset library named \"" + libraryName + "\"");
		}
		#end

		return null;
	}

	public static function getMusic(id:String, useCache:Bool = true):Sound
	{
		// TODO: Streaming sound

		return getSound(id, useCache);
	}

	public static function getPath(id:String):String
	{
		#if lime
		return LimeAssets.getPath(id);
		#else
		return null;
		#end
	}

	public static function getSound(id:String, useCache:Bool = true):Sound
	{
		#if (lime && tools && !display)
		if (useCache && cache.enabled && cache.hasSound(id))
		{
			var sound = cache.getSound(id);

			if (isValidSound(sound))
			{
				return sound;
			}
		}

		var buffer = LimeAssets.getAudioBuffer(id, false);

		if (buffer != null)
		{
			#if flash
			var sound = buffer.src;
			#else
			var sound = Sound.fromAudioBuffer(buffer);
			#end

			if (useCache && cache.enabled)
			{
				cache.setSound(id, sound);
			}

			return sound;
		}
		#end

		return null;
	}

	public static function getText(id:String):String
	{
		#if lime
		return LimeAssets.getText(id);
		#else
		return null;
		#end
	}

	public static function hasEventListener(type:String):Bool
	{
		return dispatcher.hasEventListener(type);
	}

	public static function hasLibrary(name:String):Bool
	{
		#if lime
		return LimeAssets.hasLibrary(name);
		#else
		return false;
		#end
	}

	public static function isLocal(id:String, type:AssetType = null, useCache:Bool = true):Bool
	{
		#if (lime && tools && !display)
		if (useCache && cache.enabled)
		{
			if (type == AssetType.IMAGE || type == null)
			{
				if (cache.hasBitmapData(id)) return true;
			}

			if (type == AssetType.FONT || type == null)
			{
				if (cache.hasFont(id)) return true;
			}

			if (type == AssetType.SOUND || type == AssetType.MUSIC || type == null)
			{
				if (cache.hasSound(id)) return true;
			}
		}

		var libraryName = id.substring(0, id.indexOf(":"));
		var symbolName = id.substr(id.indexOf(":") + 1);
		var library = getLibrary(libraryName);

		if (library != null)
		{
			return library.isLocal(symbolName, cast type);
		}
		#end

		return false;
	}

	@:analyzer(ignore) private static function isValidBitmapData(bitmapData:BitmapData):Bool
	{
		#if (lime && tools && !display)
		#if flash
		try
		{
			bitmapData.width;
			return true;
		}
		catch (e:Dynamic)
		{
			return false;
		}
		#else
		return (bitmapData != null && #if !lime_hybrid bitmapData.image != null #else bitmapData.__handle != null #end);
		#end
		#else
		return true;
		#end
	}

	@:noCompletion private static function isValidSound(sound:Sound):Bool
	{
		#if ((tools && !display) && (cpp || neko || nodejs))
		return true;
		// return (sound.__handle != null && sound.__handle != 0);
		#else
		return true;
		#end
	}

	public static function list(type:AssetType = null):Array<String>
	{
		#if lime
		return LimeAssets.list(cast type);
		#else
		return [];
		#end
	}

	public static function loadBitmapData(id:String, useCache:Null<Bool> = true):Future<BitmapData>
	{
		if (useCache == null) useCache = true;

		#if (lime && tools && !display)
		var promise = new Promise<BitmapData>();

		if (useCache && cache.enabled && cache.hasBitmapData(id))
		{
			var bitmapData = cache.getBitmapData(id);

			if (isValidBitmapData(bitmapData))
			{
				promise.complete(bitmapData);
				return promise.future;
			}
		}

		LimeAssets.loadImage(id, false).onComplete(function(image)
		{
			if (image != null)
			{
				#if flash
				var bitmapData = image.src;
				#else
				var bitmapData = BitmapData.fromImage(image);
				#end

				if (useCache && cache.enabled)
				{
					cache.setBitmapData(id, bitmapData);
				}

				promise.complete(bitmapData);
			}
			else
			{
				promise.error("[Assets] Could not load Image \"" + id + "\"");
			}
		}).onError(promise.error).onProgress(promise.progress);

		return promise.future;
		#else
		return Future.withValue(getBitmapData(id, useCache));
		#end
	}

	public static function loadBytes(id:String):Future<ByteArray>
	{
		#if lime
		var promise = new Promise<ByteArray>();
		var future = LimeAssets.loadBytes(id);

		future.onComplete(function(bytes) promise.complete(bytes));
		future.onProgress(function(progress, total) promise.progress(progress, total));
		future.onError(function(msg) promise.error(msg));

		return promise.future;
		#else
		return Future.withValue(getBytes(id));
		#end
	}

	public static function loadFont(id:String, useCache:Null<Bool> = true):Future<Font>
	{
		if (useCache == null) useCache = true;

		#if (lime && tools && !display && !macro)
		var promise = new Promise<Font>();

		if (useCache && cache.enabled && cache.hasFont(id))
		{
			promise.complete(cache.getFont(id));
			return promise.future;
		}

		LimeAssets.loadFont(id)
			.onComplete(function(limeFont)
			{
				#if flash
				var font = limeFont.src;
				#else
				var font = new Font();
				font.__fromLimeFont(limeFont);
				#end

				if (useCache && cache.enabled)
				{
					cache.setFont(id, font);
				}

				promise.complete(font);
			})
			.onError(promise.error)
			.onProgress(promise.progress);

		return promise.future;
		#else
		return Future.withValue(getFont(id, useCache));
		#end
	}

	public static function loadLibrary(name:String):#if java Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		#if lime
		return LimeAssets.loadLibrary(name).then(function(library)
		{
			var _library:AssetLibrary = null;

			if (library != null)
			{
				if ((library is AssetLibrary))
				{
					_library = cast library;
				}
				else
				{
					_library = new AssetLibrary();
					_library.__proxy = library;
					LimeAssets.registerLibrary(name, _library);
				}
			}

			return Future.withValue(_library);
		});
		#else
		return cast Future.withError("Cannot load library");
		#end
	}

	public static function loadMusic(id:String, useCache:Null<Bool> = true):Future<Sound>
	{
		if (useCache == null) useCache = true;

		#if lime
		#if !html5
		var promise = new Promise<Sound>();

		LimeAssets.loadAudioBuffer(id, useCache)
			.onComplete(function(buffer)
			{
				if (buffer != null)
				{
					#if flash
					var sound = buffer.src;
					#else
					var sound = Sound.fromAudioBuffer(buffer);
					#end

					if (useCache && cache.enabled)
					{
						cache.setSound(id, sound);
					}

					promise.complete(sound);
				}
				else
				{
					promise.error("[Assets] Could not load Sound \"" + id + "\"");
				}
			})
			.onError(promise.error)
			.onProgress(promise.progress);
		return promise.future;
		#else
		var future = new Future<Sound>(function() return getMusic(id, useCache));
		return future;
		#end
		#else
		return Future.withValue(getMusic(id, useCache));
		#end
	}

	public static function loadMovieClip(id:String):Future<MovieClip>
	{
		#if (lime && tools && !display)
		var promise = new Promise<MovieClip>();

		var libraryName = id.substring(0, id.indexOf(":"));
		var symbolName = id.substr(id.indexOf(":") + 1);
		var limeLibrary = getLibrary(libraryName);

		if (limeLibrary != null)
		{
			if ((limeLibrary is AssetLibrary))
			{
				var library:AssetLibrary = cast limeLibrary;

				if (library.exists(symbolName, cast AssetType.MOVIE_CLIP))
				{
					promise.completeWith(library.loadMovieClip(symbolName));
					return promise.future;
				}
			}

			promise.error("[Assets] There is no MovieClip asset with an ID of \"" + id + "\"");
		}
		else
		{
			promise.error("[Assets] There is no asset library named \"" + libraryName + "\"");
		}

		return promise.future;
		#else
		return Future.withValue(getMovieClip(id));
		#end
	}

	public static function loadSound(id:String, useCache:Null<Bool> = true):Future<Sound>
	{
		if (useCache == null) useCache = true;

		#if lime
		var promise = new Promise<Sound>();

		LimeAssets.loadAudioBuffer(id, useCache)
			.onComplete(function(buffer)
			{
				if (buffer != null)
				{
					#if flash
					var sound = buffer.src;
					#else
					var sound = Sound.fromAudioBuffer(buffer);
					#end

					if (useCache && cache.enabled)
					{
						cache.setSound(id, sound);
					}

					promise.complete(sound);
				}
				else
				{
					promise.error("[Assets] Could not load Sound \"" + id + "\"");
				}
			})
			.onError(promise.error)
			.onProgress(promise.progress);
		return promise.future;
		#else
		return Future.withValue(getSound(id, useCache));
		#end
	}

	public static function loadText(id:String):Future<String>
	{
		#if lime
		var future = LimeAssets.loadText(id);
		return future;
		#else
		return Future.withValue(getText(id));
		#end
	}

	public static function registerLibrary(name:String, library:AssetLibrary):Void
	{
		#if lime
		LimeAssets.registerLibrary(name, library);
		#end
	}

	public static function removeEventListener(type:String, listener:Dynamic, capture:Bool = false):Void
	{
		dispatcher.removeEventListener(type, listener, capture);
	}

	@:noCompletion private static function resolveClass(name:String):Class<Dynamic>
	{
		return Type.resolveClass(name);
	}

	@:noCompletion private static function resolveEnum(name:String):Enum<Dynamic>
	{
		var value = Type.resolveEnum(name);

		#if flash
		if (value == null)
		{
			return cast Type.resolveClass(name);
		}
		#end

		return value;
	}

	public static function unloadLibrary(name:String):Void
	{
		#if lime
		LimeAssets.unloadLibrary(name);
		#end
	}

	// Event Handlers
	@:noCompletion private static function LimeAssets_onChange():Void
	{
		dispatchEvent(new Event(Event.CHANGE));
	}
}
