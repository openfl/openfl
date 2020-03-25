namespace openfl._internal.backend.lime_standalone;

#if(false && openfl_html5)
import haxe.io.Path;
import haxe.CallStack;
import haxe.Unserializer;
import openfl._internal.utils.Log;
import openfl.text.Font;
import openfl.utils.Future;
import openfl.utils.Promise;
#if!macro
import haxe.Json;
#end

@: access(openfl._internal.backend.lime_standalone.AssetLibrary)
class Assets
{
	public static cache: AssetCache = new AssetCache();
	public static onChange = new LimeEvent < Void -> Void > ();

	private static bundlePaths = new Map<string, String>();
	private static libraries(default , null) = new Map<string, AssetLibrary>();
private static libraryPaths = new Map<string, String>();

public static exists(id: string, type: AssetType = null) : boolean
{
		#if(tools && !display)
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

public static getAsset(id: string, type: AssetType, useCache : boolean): Dynamic
{
		#if(tools && !display)
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

public static getAudioBuffer(id: string, useCache : boolean = true): AudioBuffer
{
	return cast getAsset(id, SOUND, useCache);
}

public static getBytes(id: string): LimeBytes
{
	return cast getAsset(id, BINARY, false);
}

public static getFont(id: string, useCache : boolean = true): Font
{
	return getAsset(id, FONT, useCache);
}

public static getImage(id: string, useCache : boolean = true): Image
{
	return getAsset(id, IMAGE, useCache);
}

public static getLibrary(name: string): AssetLibrary
{
	if (name == null || name == "")
	{
		name = "default";
	}

	return libraries.get(name);
}

public static getPath(id: string): string
{
		#if(tools && !display)
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

public static getText(id: string): string
{
	return getAsset(id, TEXT, false);
}

public static hasLibrary(name: string) : boolean
{
	if (name == null || name == "")
	{
		name = "default";
	}

	return libraries.exists(name);
}

public static isLocal(id: string, type: AssetType = null, useCache : boolean = true) : boolean
{
		#if(tools && !display)
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

private static isValidAudio(buffer: AudioBuffer) : boolean
{
	// TODO: Check disposed

	return buffer != null;
}

private static isValidImage(image: Image) : boolean
{
	// TODO: Check disposed

	return (image != null && image.buffer != null);
}

public static list(type: AssetType = null): Array < String >
{
	var items = [];

	for(library in libraries)
	{
	var libraryItems = library.list(type);

	if (libraryItems != null)
	{
		items = items.concat(libraryItems);
	}
}

return items;
}

public static loadAsset(id: string, type: AssetType, useCache : boolean): Future < Dynamic >
{
	#if(tools && !display)
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
			future.onComplete(function (asset) cache.set(id, type, asset));
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

public static loadAudioBuffer(id: string, useCache : boolean = true): Future < AudioBuffer >
{
	return cast loadAsset(id, SOUND, useCache);
}

public static loadBytes(id: string): Future < LimeBytes >
{
	return cast loadAsset(id, BINARY, false);
}

public static loadFont(id: string, useCache : boolean = true): Future < Font >
{
	return cast loadAsset(id, FONT, useCache);
}

public static loadImage(id: string, useCache : boolean = true): Future < Image >
{
	return cast loadAsset(id, IMAGE, useCache);
}

public static loadLibrary(id: string): Future < AssetLibrary >
{
	var promise = new Promise<AssetLibrary>();

	#if(tools && !display && !macro)
var library = getLibrary(id);

if (library != null)
{
	return library.load();
}

var path = id;
var rootPath = null;

if (bundlePaths.exists(id))
{
	AssetBundle.loadFromFile(bundlePaths.get(id)).onComplete(function (bundle)
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
	}).onError(function (_)
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

	AssetManifest.loadFromFile(path, rootPath).onComplete(function (manifest)
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
	}).onError(function (_)
	{
		promise.error("There is no asset library with an ID of \"" + id + "\"");
	});
}
		#end

return promise.future;
}

public static loadText(id: string): Future < String >
{
	return cast loadAsset(id, TEXT, false);
}

public static registerLibrary(name: string, library: AssetLibrary): void
	{
		if(libraries.exists(name))
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

public static unloadLibrary(name: string): void
	{
		#if(tools && !display)
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

	protected static __cacheBreak(path: string): string
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

	protected static __libraryNotFound(name: string): string
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
	protected static library_onChange(): void
	{
		cache.clear();
		onChange.dispatch();
	}
}

private class LibrarySymbol
{
	public library(default , null): AssetLibrary;
	public libraryName(default , null): string;
	public symbolName(default , null): string;

	public inline new(id: string)
	{
		var colonIndex = id.indexOf(":");
		libraryName = id.substring(0, colonIndex);
		symbolName = id.substring(colonIndex + 1);
		library = Assets.getLibrary(libraryName);
	}

	public inline isLocal(?type)
return library.isLocal(symbolName, type);

	public inline exists(?type)
return library.exists(symbolName, type);
}
#end
