package openfl._internal.backend.lime_standalone;

#if (false && openfl_html5)
import haxe.io.Path;
import haxe.CallStack;
import haxe.Unserializer;
import openfl._internal.utils.Log;
import openfl.text.Font;
import openfl.utils.Future;
import openfl.utils.Promise;
#if !macro
import haxe.Json;
#end

@:access(openfl._internal.backend.lime_standalone.AssetLibrary)
class Assets
{
	public static var cache:AssetCache = new AssetCache();
	public static var onChange = new LimeEvent<Void->Void>();

	private static var bundlePaths = new Map<String, String>();
	private static var libraries(default, null) = new Map<String, AssetLibrary>();
	private static var libraryPaths = new Map<String, String>();

	public static function exists(id:String, type:AssetType = null):Bool
	{
		#if (tools && !display)
		if (type == null)
		{
			type = BINARY;
		}

		var symbol = new LibrarySymbol(id);

		if (symbol.library != null)
		{
			return symbol.exists(type);
		}
		#end

		return false;
	}

	public static function getAsset(id:String, type:AssetType, useCache:Bool):Dynamic
	{
		#if (tools && !display)
		if (useCache && cache.enabled)
		{
			switch (type)
			{
				case BINARY, TEXT: // Not cached

					useCache = false;

				case FONT:
					var font = cache.font.get(id);

					if (font != null)
					{
						return font;
					}

				case IMAGE:
					var image = cache.image.get(id);

					if (isValidImage(image))
					{
						return image;
					}

				case MUSIC, SOUND:
					var audio = cache.audio.get(id);

					if (isValidAudio(audio))
					{
						return audio;
					}

				case TEMPLATE:
					throw "Not sure how to get template: " + id;

				default:
					return null;
			}
		}

		var symbol = new LibrarySymbol(id);

		if (symbol.library != null)
		{
			if (symbol.exists(type))
			{
				if (symbol.isLocal(type))
				{
					var asset = symbol.library.getAsset(symbol.symbolName, type);

					if (useCache && cache.enabled)
					{
						cache.set(id, type, asset);
					}

					return asset;
				}
				else
				{
					Log.error(type + " asset \"" + id + "\" exists, but only asynchronously");
				}
			}
			else
			{
				Log.error("There is no " + type + " asset with an ID of \"" + id + "\"");
			}
		}
		else
		{
			Log.error(__libraryNotFound(symbol.libraryName));
		}
		#end

		return null;
	}

	public static function getAudioBuffer(id:String, useCache:Bool = true):AudioBuffer
	{
		return cast getAsset(id, SOUND, useCache);
	}

	public static function getBytes(id:String):LimeBytes
	{
		return cast getAsset(id, BINARY, false);
	}

	public static function getFont(id:String, useCache:Bool = true):Font
	{
		return getAsset(id, FONT, useCache);
	}

	public static function getImage(id:String, useCache:Bool = true):Image
	{
		return getAsset(id, IMAGE, useCache);
	}

	public static function getLibrary(name:String):AssetLibrary
	{
		if (name == null || name == "")
		{
			name = "default";
		}

		return libraries.get(name);
	}

	public static function getPath(id:String):String
	{
		#if (tools && !display)
		var symbol = new LibrarySymbol(id);

		if (symbol.library != null)
		{
			if (symbol.exists())
			{
				return symbol.library.getPath(symbol.symbolName);
			}
			else
			{
				Log.error("There is no asset with an ID of \"" + id + "\"");
			}
		}
		else
		{
			Log.error(__libraryNotFound(symbol.libraryName));
		}
		#end

		return null;
	}

	public static function getText(id:String):String
	{
		return getAsset(id, TEXT, false);
	}

	public static function hasLibrary(name:String):Bool
	{
		if (name == null || name == "")
		{
			name = "default";
		}

		return libraries.exists(name);
	}

	public static function isLocal(id:String, type:AssetType = null, useCache:Bool = true):Bool
	{
		#if (tools && !display)
		if (useCache && cache.enabled)
		{
			if (cache.exists(id, type)) return true;
		}

		var symbol = new LibrarySymbol(id);
		return symbol.library != null && symbol.isLocal(type);
		#else
		return false;
		#end
	}

	private static function isValidAudio(buffer:AudioBuffer):Bool
	{
		// TODO: Check disposed

		return buffer != null;
	}

	private static function isValidImage(image:Image):Bool
	{
		// TODO: Check disposed

		return (image != null && image.buffer != null);
	}

	public static function list(type:AssetType = null):Array<String>
	{
		var items = [];

		for (library in libraries)
		{
			var libraryItems = library.list(type);

			if (libraryItems != null)
			{
				items = items.concat(libraryItems);
			}
		}

		return items;
	}

	public static function loadAsset(id:String, type:AssetType, useCache:Bool):Future<Dynamic>
	{
		#if (tools && !display)
		if (useCache && cache.enabled)
		{
			switch (type)
			{
				case BINARY, TEXT: // Not cached

					useCache = false;

				case FONT:
					var font = cache.font.get(id);

					if (font != null)
					{
						return Future.withValue(font);
					}

				case IMAGE:
					var image = cache.image.get(id);

					if (isValidImage(image))
					{
						return Future.withValue(image);
					}

				case MUSIC, SOUND:
					var audio = cache.audio.get(id);

					if (isValidAudio(audio))
					{
						return Future.withValue(audio);
					}

				case TEMPLATE:
					throw "Not sure how to get template: " + id;

				default:
					return null;
			}
		}

		var symbol = new LibrarySymbol(id);

		if (symbol.library != null)
		{
			if (symbol.exists(type))
			{
				var future = symbol.library.loadAsset(symbol.symbolName, type);

				if (useCache && cache.enabled)
				{
					future.onComplete(function(asset) cache.set(id, type, asset));
				}

				return future;
			}
			else
			{
				return Future.withError("There is no " + type + " asset with an ID of \"" + id + "\"");
			}
		}
		else
		{
			return Future.withError(__libraryNotFound(symbol.libraryName));
		}
		#else
		return null;
		#end
	}

	public static function loadAudioBuffer(id:String, useCache:Bool = true):Future<AudioBuffer>
	{
		return cast loadAsset(id, SOUND, useCache);
	}

	public static function loadBytes(id:String):Future<LimeBytes>
	{
		return cast loadAsset(id, BINARY, false);
	}

	public static function loadFont(id:String, useCache:Bool = true):Future<Font>
	{
		return cast loadAsset(id, FONT, useCache);
	}

	public static function loadImage(id:String, useCache:Bool = true):Future<Image>
	{
		return cast loadAsset(id, IMAGE, useCache);
	}

	public static function loadLibrary(id:String):Future<AssetLibrary>
	{
		var promise = new Promise<AssetLibrary>();

		#if (tools && !display && !macro)
		var library = getLibrary(id);

		if (library != null)
		{
			return library.load();
		}

		var path = id;
		var rootPath = null;

		if (bundlePaths.exists(id))
		{
			AssetBundle.loadFromFile(bundlePaths.get(id)).onComplete(function(bundle)
			{
				if (bundle == null)
				{
					promise.error("Cannot load bundle for library \"" + id + "\"");
					return;
				}

				var library = AssetLibrary.fromBundle(bundle);

				if (library == null)
				{
					promise.error("Cannot open library \"" + id + "\"");
				}
				else
				{
					libraries.set(id, library);
					library.onChange.add(onChange.dispatch);
					promise.completeWith(library.load());
				}
			}).onError(function(_)
			{
				promise.error("There is no asset library with an ID of \"" + id + "\"");
			});
		}
		else
		{
			if (libraryPaths.exists(id))
			{
				path = libraryPaths[id];
				rootPath = Path.directory(path);
			}
			else
			{
				if (StringTools.endsWith(path, ".bundle"))
				{
					rootPath = path;
					path += "/library.json";
				}
				else
				{
					rootPath = Path.directory(path);
				}
				path = __cacheBreak(path);
			}

			AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
			{
				if (manifest == null)
				{
					promise.error("Cannot parse asset manifest for library \"" + id + "\"");
					return;
				}

				var library = AssetLibrary.fromManifest(manifest);

				if (library == null)
				{
					promise.error("Cannot open library \"" + id + "\"");
				}
				else
				{
					libraries.set(id, library);
					library.onChange.add(onChange.dispatch);
					promise.completeWith(library.load());
				}
			}).onError(function(_)
			{
				promise.error("There is no asset library with an ID of \"" + id + "\"");
			});
		}
		#end

		return promise.future;
	}

	public static function loadText(id:String):Future<String>
	{
		return cast loadAsset(id, TEXT, false);
	}

	public static function registerLibrary(name:String, library:AssetLibrary):Void
	{
		if (libraries.exists(name))
		{
			if (libraries.get(name) == library)
			{
				return;
			}
			else
			{
				unloadLibrary(name);
			}
		}

		if (library != null)
		{
			library.onChange.add(library_onChange);
		}

		libraries.set(name, library);
	}

	public static function unloadLibrary(name:String):Void
	{
		#if (tools && !display)
		if (name == null || name == "")
		{
			name = "default";
		}

		var library = libraries.get(name);

		if (library != null)
		{
			cache.clear(name + ":");
			library.onChange.remove(library_onChange);
			library.unload();
		}

		libraries.remove(name);
		#end
	}

	@:noCompletion private static function __cacheBreak(path:String):String
	{
		#if web
		if (cache.version > 0)
		{
			if (path.indexOf("?") > -1)
			{
				path += "&" + cache.version;
			}
			else
			{
				path += "?" + cache.version;
			}
		}
		#end

		return path;
	}

	@:noCompletion private static function __libraryNotFound(name:String):String
	{
		if (name == null || name == "")
		{
			name = "default";
		}

		if (Application.current != null && Application.current.preloader != null && !Application.current.preloader.complete)
		{
			return "There is no asset library named \"" + name + "\", or it is not yet preloaded";
		}
		else
		{
			return "There is no asset library named \"" + name + "\"";
		}
	}

	// Event Handlers
	@:noCompletion private static function library_onChange():Void
	{
		cache.clear();
		onChange.dispatch();
	}
}

private class LibrarySymbol
{
	public var library(default, null):AssetLibrary;
	public var libraryName(default, null):String;
	public var symbolName(default, null):String;

	public inline function new(id:String)
	{
		var colonIndex = id.indexOf(":");
		libraryName = id.substring(0, colonIndex);
		symbolName = id.substring(colonIndex + 1);
		library = Assets.getLibrary(libraryName);
	}

	public inline function isLocal(?type)
		return library.isLocal(symbolName, type);

	public inline function exists(?type)
		return library.exists(symbolName, type);
}
#end
