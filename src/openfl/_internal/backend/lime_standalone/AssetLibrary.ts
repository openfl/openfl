namespace openfl._internal.backend.lime_standalone;

#if(false && openfl_html5)
import haxe.io.Path;
import openfl._internal.utils.Log;
import openfl.text.Font;
import openfl.utils.Future;
import openfl.utils.Promise;

@: access(openfl._internal.backend.lime_standalone.Assets)
@: access(openfl.text.Font)
class AssetLibrary
{
	public onChange = new LimeEvent < Void -> Void > ();

	protected assetsLoaded: number;
	protected assetsTotal: number;
	protected bytesLoaded: number;
	protected bytesLoadedCache: Map<string, Int>;
	protected bytesTotal: number;
	protected cachedAudioBuffers = new Map<string, AudioBuffer>();
	protected cachedBytes = new Map<string, LimeBytes>();
	protected cachedFonts = new Map<string, Font>();
	protected cachedImages = new Map<string, Image>();
	protected cachedText = new Map<string, String>();
	protected classTypes = new Map<string, Class<Dynamic>>();
	protected loaded: boolean;
	protected pathGroups = new Map<string, Array<string>>();
	protected paths = new Map<string, String>();
	protected preload = new Map<string, Bool>();
	protected promise: Promise<AssetLibrary>;
	protected sizes = new Map<string, Int>();
	protected types = new Map<string, AssetType>();

	public new()
	{
		bytesLoaded = 0;
		bytesTotal = 0;
	}

	public exists(id: string, type: string): boolean
	{
		var requestedType = type != null ? cast(type, AssetType) : null;
		var assetType = types.get(id);

		if (assetType != null)
		{
			if (assetType == requestedType
				|| ((requestedType == SOUND || requestedType == MUSIC) && (assetType == MUSIC || assetType == SOUND)))
			{
				return true;
			}

			if (requestedType == BINARY || requestedType == null || (assetType == BINARY && requestedType == TEXT))
			{
				return true;
			}
		}

		return false;
	}

	public static fromBytes(bytes: LimeBytes, rootPath: string = null): AssetLibrary
	{
		return fromManifest(AssetManifest.fromBytes(bytes, rootPath));
	}

	public static fromFile(path: string, rootPath: string = null): AssetLibrary
	{
		return fromManifest(AssetManifest.fromFile(path, rootPath));
	}

	public static fromBundle(bundle: AssetBundle): AssetLibrary
	{
		if (bundle.data.exists("library.json"))
		{
			var manifest = AssetManifest.fromBytes(bundle.data.get("library.json"));
			if (manifest != null)
			{
				var library: AssetLibrary = null;

				if (manifest.libraryType == null)
				{
					library = new AssetLibrary();
				}
				else
				{
					var libraryClass = Type.resolveClass(manifest.libraryType);

					if (libraryClass != null)
					{
						library = Type.createInstance(libraryClass, manifest.libraryArgs);
					}
					else
					{
						Log.warn("Could not find library type: " + manifest.libraryType);
						return null;
					}
				}

				library.__fromBundle(bundle, manifest);
				return library;
			}
		}
		else
		{
			var library = new AssetLibrary();
			library.__fromBundle(bundle);
			return library;
		}
		return null;
	}

	public static fromManifest(manifest: AssetManifest): AssetLibrary
	{
		if (manifest == null) return null;

		var library: AssetLibrary = null;

		if (manifest.libraryType == null)
		{
			library = new AssetLibrary();
		}
		else
		{
			var libraryClass = Type.resolveClass(manifest.libraryType);

			if (libraryClass != null)
			{
				library = Type.createInstance(libraryClass, manifest.libraryArgs);
			}
			else
			{
				Log.warn("Could not find library type: " + manifest.libraryType);
				return null;
			}
		}

		library.__fromManifest(manifest);

		return library;
	}

	public getAsset(id: string, type: string): Dynamic
	{
		return switch (type)
		{
			case AssetType.BINARY: getBytes(id);
			case AssetType.FONT: getFont(id);
			case AssetType.IMAGE: getImage(id);
			case AssetType.MUSIC, AssetType.SOUND: getAudioBuffer(id);
			case AssetType.TEXT: getText(id);

			case AssetType.TEMPLATE: throw "Not sure how to get template: " + id;
			default: throw "Unknown asset type: " + type;
		}
	}

	public getAudioBuffer(id: string): AudioBuffer
	{
		if (cachedAudioBuffers.exists(id))
		{
			return cachedAudioBuffers.get(id);
		}
		else if (classTypes.exists(id))
		{
			return AudioBuffer.fromBytes(cast(Type.createInstance(classTypes.get(id), []), LimeBytes));
		}
		else
		{
			return AudioBuffer.fromFile(paths.get(id));
		}
	}

	public getBytes(id: string): LimeBytes
	{
		if (cachedBytes.exists(id))
		{
			return cachedBytes.get(id);
		}
		else if (cachedText.exists(id))
		{
			var bytes = LimeBytes.ofString(cachedText.get(id));
			cachedBytes.set(id, bytes);
			return bytes;
		}
		else if (classTypes.exists(id))
		{
			return cast(Type.createInstance(classTypes.get(id), []), LimeBytes);
		}
		else
		{
			return LimeBytes.fromFile(paths.get(id));
		}
	}

	public getFont(id: string): Font
	{
		if (cachedFonts.exists(id))
		{
			return cachedFonts.get(id);
		}
		else if (classTypes.exists(id))
		{
			return cast(Type.createInstance(classTypes.get(id), []), Font);
		}
		else
		{
			return Font.fromFile(paths.get(id));
		}
	}

	public getImage(id: string): Image
	{
		if (cachedImages.exists(id))
		{
			return cachedImages.get(id);
		}
		else if (classTypes.exists(id))
		{
			return cast(Type.createInstance(classTypes.get(id), []), Image);
		}
		else
		{
			return Image.fromFile(paths.get(id));
		}
	}

	public getPath(id: string): string
	{
		if (paths.exists(id))
		{
			return paths.get(id);
		}
		else if (pathGroups.exists(id))
		{
			return pathGroups.get(id)[0];
		}
		else
		{
			return null;
		}
	}

	public getText(id: string): string
	{
		if (cachedText.exists(id))
		{
			return cachedText.get(id);
		}
		else
		{
			var bytes = getBytes(id);

			if (bytes == null)
			{
				return null;
			}
			else
			{
				return bytes.getString(0, bytes.length);
			}
		}
	}

	public isLocal(id: string, type: string): boolean
	{
		#if sys
		return true;
		#else
		if (classTypes.exists(id))
		{
			return true;
		}

		var requestedType = type != null ? cast(type, AssetType) : null;

		return switch (requestedType)
		{
			case IMAGE:
				cachedImages.exists(id);

			case MUSIC, SOUND:
				cachedAudioBuffers.exists(id);

			case FONT:
				cachedFonts.exists(id);

			default: cachedBytes.exists(id) || cachedText.exists(id);
		}
		#end
	}

	public list(type: string): Array<string>
	{
		var requestedType = type != null ? cast(type, AssetType) : null;
		var items = [];

		for (id in types.keys())
		{
			if (requestedType == null || exists(id, type))
			{
				items.push(id);
			}
		}

		return items;
	}

	public loadAsset(id: string, type: string): Future<Dynamic>
	{
		return switch (type)
		{
			case AssetType.BINARY: loadBytes(id);
			case AssetType.FONT: loadFont(id);
			case AssetType.IMAGE: loadImage(id);
			case AssetType.MUSIC, AssetType.SOUND: loadAudioBuffer(id);
			case AssetType.TEXT: loadText(id);

			case AssetType.TEMPLATE: throw "Not sure how to load template: " + id;
			default: throw "Unknown asset type: " + type;
		}
	}

	public load(): Future<AssetLibrary>
	{
		if (loaded)
		{
			return Future.withValue(this);
		}

		if (promise == null)
		{
			promise = new Promise<AssetLibrary>();
			bytesLoadedCache = new Map();

			assetsLoaded = 0;
			assetsTotal = 1;

			for (id in preload.keys())
			{
				if (!preload.get(id)) continue;

				Log.verbose("Preloading asset: " + id + " [" + types.get(id) + "]");

				switch (types.get(id))
				{
					case BINARY:
						assetsTotal++;

						var future = loadBytes(id);
						future.onProgress(load_onProgress.bind(id));
						future.onError(load_onError.bind(id));
						future.onComplete(loadBytes_onComplete.bind(id));

					case FONT:
						assetsTotal++;

						var future = loadFont(id);
						future.onProgress(load_onProgress.bind(id));
						future.onError(load_onError.bind(id));
						future.onComplete(loadFont_onComplete.bind(id));

					case IMAGE:
						assetsTotal++;

						var future = loadImage(id);
						future.onProgress(load_onProgress.bind(id));
						future.onError(load_onError.bind(id));
						future.onComplete(loadImage_onComplete.bind(id));

					case MUSIC, SOUND:
						assetsTotal++;

						var future = loadAudioBuffer(id);
						future.onProgress(load_onProgress.bind(id));
						future.onError(loadAudioBuffer_onError.bind(id));
						future.onComplete(loadAudioBuffer_onComplete.bind(id));

					case TEXT:
						assetsTotal++;

						var future = loadText(id);
						future.onProgress(load_onProgress.bind(id));
						future.onError(load_onError.bind(id));
						future.onComplete(loadText_onComplete.bind(id));

					default:
				}
			}

			__assetLoaded(null);
		}

		return promise.future;
	}

	public loadAudioBuffer(id: string): Future<AudioBuffer>
	{
		if (cachedAudioBuffers.exists(id))
		{
			return Future.withValue(cachedAudioBuffers.get(id));
		}
		else if (classTypes.exists(id))
		{
			return Future.withValue(Type.createInstance(classTypes.get(id), []));
		}
		else
		{
			if (pathGroups.exists(id))
			{
				return AudioBuffer.loadFromFiles(pathGroups.get(id));
			}
			else
			{
				return AudioBuffer.loadFromFile(paths.get(id));
			}
		}
	}

	public loadBytes(id: string): Future<LimeBytes>
	{
		if (cachedBytes.exists(id))
		{
			return Future.withValue(cachedBytes.get(id));
		}
		else if (classTypes.exists(id))
		{
			return Future.withValue(Type.createInstance(classTypes.get(id), []));
		}
		else
		{
			return LimeBytes.loadFromFile(paths.get(id));
		}
	}

	public loadFont(id: string): Future<Font>
	{
		if (cachedFonts.exists(id))
		{
			return Future.withValue(cachedFonts.get(id));
		}
		else if (classTypes.exists(id))
		{
			var font: Font = Type.createInstance(classTypes.get(id), []);
			// return font.__loadFromName(font.name);
			return font.__loadFromName(font.fontName);
		}
		else
		{
			return Font.loadFromName(paths.get(id));
		}
	}

	public static loadFromBytes(bytes: LimeBytes, rootPath: string = null): Future<AssetLibrary>
	{
		return AssetManifest.loadFromBytes(bytes, rootPath).then(function (manifest)
		{
			return loadFromManifest(manifest);
		});
	}

	public static loadFromFile(path: string, rootPath: string = null): Future<AssetLibrary>
	{
		return AssetManifest.loadFromFile(path, rootPath).then(function (manifest)
		{
			return loadFromManifest(manifest);
		});
	}

	public static loadFromManifest(manifest: AssetManifest): Future<AssetLibrary>
	{
		var library = fromManifest(manifest);

		if (library != null)
		{
			return library.load();
		}
		else
		{
			return cast Future.withError("Could not load asset manifest");
		}
	}

	public loadImage(id: string): Future<Image>
	{
		if (cachedImages.exists(id))
		{
			return Future.withValue(cachedImages.get(id));
		}
		else if (classTypes.exists(id))
		{
			return Future.withValue(Type.createInstance(classTypes.get(id), []));
		}
		else if (cachedBytes.exists(id))
		{
			return Image.loadFromBytes(cachedBytes.get(id)).then(function (image)
			{
				cachedBytes.remove(id);
				cachedImages.set(id, image);
				return Future.withValue(image);
			});
		}
		else
		{
			return Image.loadFromFile(paths.get(id));
		}
	}

	public loadText(id: string): Future<string>
	{
		if (cachedText.exists(id))
		{
			return Future.withValue(cachedText.get(id));
		}
		else if (cachedBytes.exists(id) || classTypes.exists(id))
		{
			var bytes = getBytes(id);

			if (bytes == null)
			{
				return cast Future.withValue(null);
			}
			else
			{
				var text = bytes.getString(0, bytes.length);
				cachedText.set(id, text);
				return Future.withValue(text);
			}
		}
		else
		{
			var request = new HTTPRequest<string>();
			return request.load(paths.get(id));
		}
	}

	public unload(): void { }

	protected __assetLoaded(id: string): void
	{
		assetsLoaded++;

		if (id != null)
		{
			Log.verbose("Loaded asset: " + id + " [" + types.get(id) + "] (" + (assetsLoaded - 1) + "/" + (assetsTotal - 1) + ")");
		}

		if (id != null)
		{
			var size = sizes.exists(id) ? sizes.get(id) : 0;

			if (!bytesLoadedCache.exists(id))
			{
				bytesLoaded += size;
			}
			else
			{
				var cache = bytesLoadedCache.get(id);

				if (cache < size)
				{
					bytesLoaded += (size - cache);
				}
			}

			bytesLoadedCache.set(id, size);
		}

		if (assetsLoaded < assetsTotal)
		{
			promise.progress(bytesLoaded, bytesTotal);
		}
		else
		{
			loaded = true;
			promise.progress(bytesTotal, bytesTotal);
			promise.complete(this);
		}
	}

	protected __cacheBreak(path: string): string
	{
		return Assets.__cacheBreak(path);
	}

	protected __fromBundle(bundle: AssetBundle, manifest: AssetManifest = null): void
	{
		if (manifest != null)
		{
			var id, data, type: AssetType;
			for (asset in manifest.assets)
			{
				id = Reflect.hasField(asset, "id") ? asset.id : asset.path;
				data = bundle.data.get(asset.path);

				if (Reflect.hasField(asset, "type"))
				{
					type = asset.type;
					switch (type)
					{
						#if!web
						case IMAGE:
					cachedImages.set(id, Image.fromBytes(data));
						case MUSIC, SOUND:
					cachedAudioBuffers.set(id, AudioBuffer.fromBytes(data));
						case FONT:
					cachedFonts.set(id, Font.fromBytes(data));
						#end
						case TEXT:
					cachedText.set(id, data != null ? String(data) : null);
						default:
		cachedBytes.set(id, data);
					}
types.set(id, asset.type);
				}
				else
{
	cachedBytes.set(id, data);
	types.set(id, BINARY);
}
			}
		}
		else
{
	for (path in bundle.paths)
	{
		cachedBytes.set(path, bundle.data.get(path));
		types.set(path, BINARY);
	}
}
	}

	protected __fromManifest(manifest: AssetManifest): void
	{
		var hasSize = (manifest.version >= 2);
		var size, id, pathGroup: Array < String >, classRef;

		var basePath = manifest.rootPath;
		if(basePath == null) basePath = "";
if (basePath != "") basePath += "/";

for (asset in manifest.assets)
{
	size = hasSize && Reflect.hasField(asset, "size") ? asset.size : 100;
	id = Reflect.hasField(asset, "id") ? asset.id : asset.path;

	if (Reflect.hasField(asset, "path"))
	{
		paths.set(id, __cacheBreak(__resolvePath(basePath + Reflect.field(asset, "path"))));
	}

	if (Reflect.hasField(asset, "pathGroup"))
	{
		pathGroup = Reflect.field(asset, "pathGroup");

		for (i in 0...pathGroup.length)
		{
			pathGroup[i] = __cacheBreak(__resolvePath(basePath + pathGroup[i]));
		}

		pathGroups.set(id, pathGroup);
	}

	sizes.set(id, size);
	types.set(id, asset.type);

	if (Reflect.hasField(asset, "preload"))
	{
		preload.set(id, Reflect.field(asset, "preload"));
	}

	if (Reflect.hasField(asset, "className"))
	{
		classRef = Type.resolveClass(Reflect.field(asset, "className"));

				#if(js && html5 && modular)
		if (classRef == null)
		{
			classRef = untyped $hx_exports[asset.className];
		}
				#end

		classTypes.set(id, classRef);
	}
}

bytesTotal = 0;

for (asset in manifest.assets)
{
	id = Reflect.hasField(asset, "id") ? asset.id : asset.path;

	if (preload.exists(id) && preload.get(id) && sizes.exists(id))
	{
		bytesTotal += sizes.get(id);
	}
}
}

	protected __resolvePath(path: string): string
{
	path = StringTools.replace(path, "\\", "/");

	var colonIdx: number = path.indexOf(":");
	if (StringTools.startsWith(path, "http") && colonIdx > 0)
	{
		var lastSlashIdx: number = colonIdx + 3;
		var httpSection: string = path.substr(0, lastSlashIdx);
		path = httpSection + StringTools.replace(path.substr(lastSlashIdx), "//", "/");
	}
	else
	{
		path = StringTools.replace(path, "//", "/");
	}

		#if android
	if (StringTools.startsWith(path, "./"))
	{
		path = path.substr(2);
	}
		#end

	if (path.indexOf("./") > -1)
	{
		var split = path.split("/");
		var newPath = [];

		for (i in 0...split.length)
		{
			if (split[i] == "..")
			{
				if (i == 0 || newPath[i - 1] == "..")
				{
					newPath.push("..");
				}
				else
				{
					newPath.pop();
				}
			}
			else if (split[i] == ".")
			{
				if (i == 0)
				{
					newPath.push(".");
				}
			}
			else
			{
				newPath.push(split[i]);
			}
		}
		path = newPath.join("/");
	}

	return path;
}

	// Event Handlers
	protected loadAudioBuffer_onComplete(id: string, audioBuffer: AudioBuffer): void
	{
		cachedAudioBuffers.set(id, audioBuffer);

		if(pathGroups.exists(id))
	{
	var pathGroup = pathGroups.get(id);

	for (otherID in pathGroups.keys())
	{
		if (otherID == id) continue;

		for (path in pathGroup)
		{
			if (pathGroups.get(otherID).indexOf(path) > -1)
			{
				cachedAudioBuffers.set(otherID, audioBuffer);
				break;
			}
		}
	}
}

__assetLoaded(id);
}

	protected loadAudioBuffer_onError(id: string, message: Dynamic): void
	{
		if(message != null && message != "")
{
	Log.warn("Could not load \"" + id + "\": " + String(message));
}
	else
{
	Log.warn("Could not load \"" + id + "\"");
}

loadAudioBuffer_onComplete(id, new AudioBuffer());
}

	protected loadBytes_onComplete(id: string, bytes: LimeBytes): void
	{
		cachedBytes.set(id, bytes);
		__assetLoaded(id);
	}

	protected loadFont_onComplete(id: string, font: Font): void
	{
		cachedFonts.set(id, font);
		__assetLoaded(id);
	}

	protected loadImage_onComplete(id: string, image: Image): void
	{
		cachedImages.set(id, image);
		__assetLoaded(id);
	}

	protected loadText_onComplete(id: string, text: string): void
	{
		cachedText.set(id, text);
		__assetLoaded(id);
	}

	protected load_onError(id: string, message: Dynamic): void
	{
		if(message != null && message != "")
{
	promise.error("Error loading asset \"" + id + "\": " + String(message));
}
	else
{
	promise.error("Error loading asset \"" + id + "\"");
}
}

	protected load_onProgress(id: string, bytesLoaded : number, bytesTotal : number): void
	{
		if(bytesLoaded > 0)
{
	var size = sizes.get(id);
	var percent;

	if (bytesTotal > 0)
	{
		// Use a ratio in case the real bytesTotal is different than our precomputed total

		percent = (bytesLoaded / bytesTotal);
		if (percent > 1) percent = 1;
		bytesLoaded = Math.floor(percent * size);
	}
	else if (bytesLoaded > size)
	{
		bytesLoaded = size;
	}

	if (bytesLoadedCache.exists(id))
	{
		var cache = bytesLoadedCache.get(id);

		if (bytesLoaded != cache)
		{
			this.bytesLoaded += (bytesLoaded - cache);
		}
	}
	else
	{
		this.bytesLoaded += bytesLoaded;
	}

	bytesLoadedCache.set(id, bytesLoaded);
	promise.progress(this.bytesLoaded, this.bytesTotal);
}
}
}
#end
