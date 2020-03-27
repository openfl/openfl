namespace openfl._internal.backend.lime_standalone;

#if(false && openfl_html5)
import haxe.io.Path;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.utils.Future;
#if!macro
import haxe.Json;
#end

class AssetManifest
{
	public assets: Array<Dynamic>;
	public libraryArgs: Array<string>;
	public libraryType: string;
	public name: string;
	public rootPath: string;
	public version: number;

	public constructor()
	{
		assets = [];
		libraryArgs = [];
		version = 2;
	}

	public static fromBytes(bytes: LimeBytes, rootPath: string = null): AssetManifest
	{
		if (bytes != null)
		{
			return parse(bytes.getString(0, bytes.length), rootPath);
		}
		else
		{
			return null;
		}
	}

	public static fromFile(path: string, rootPath: string = null): AssetManifest
	{
		path = __resolvePath(path);
		rootPath = __resolveRootPath(rootPath, path);

		if (path == null) return null;

		return fromBytes(LimeBytes.fromFile(path), rootPath);
	}

	public static loadFromBytes(bytes: LimeBytes, rootPath: string = null): Future<AssetManifest>
	{
		return Future.withValue(fromBytes(bytes, rootPath));
	}

	public static loadFromFile(path: string, rootPath: string = null): Future<AssetManifest>
	{
		path = __resolvePath(path);
		rootPath = __resolveRootPath(rootPath, path);

		if (path == null) return null;

		return LimeBytes.loadFromFile(path).then(function (bytes)
		{
			return Future.withValue(fromBytes(bytes, rootPath));
		});
	}

	public static parse(data: string, rootPath: string = null): AssetManifest
	{
		if (data == null || data == "") return null;

		#if!macro
		var manifestData = Json.parse(data);
		var manifest = new AssetManifest();

		if (Reflect.hasField(manifestData, "name"))
		{
			manifest.name = manifestData.name;
		}

		if (Reflect.hasField(manifestData, "libraryType"))
		{
			manifest.libraryType = manifestData.libraryType;
		}

		if (Reflect.hasField(manifestData, "libraryArgs"))
		{
			manifest.libraryArgs = manifestData.libraryArgs;
		}

		if (Reflect.hasField(manifestData, "assets"))
		{
			var assets: Dynamic = manifestData.assets;
			if (Reflect.hasField(manifestData, "version") && manifestData.version <= 2)
			{
				manifest.assets = Unserializer.run(assets);
			}
			else
			{
				manifest.assets = assets;
			}
		}

		if (Reflect.hasField(manifestData, "rootPath"))
		{
			manifest.rootPath = manifestData.rootPath;
		}

		if (rootPath != null && rootPath != "")
		{
			if (manifest.rootPath == null || manifest.rootPath == "")
			{
				manifest.rootPath = rootPath;
			}
			else
			{
				manifest.rootPath = rootPath + "/" + manifest.rootPath;
			}
		}

		return manifest;
		#else
		return null;
		#end
	}

	public serialize(): string
	{
		#if!macro
		var manifestData: Dynamic = {};
		manifestData.version = version;
		manifestData.libraryType = libraryType;
		manifestData.libraryArgs = libraryArgs;
		manifestData.name = name;
		manifestData.assets = Serializer.run(assets);
		manifestData.rootPath = rootPath;

		return Json.stringify(manifestData);
		#else
		return null;
		#end
	}

	private static __resolvePath(path: string): string
	{
		if (path == null) return null;

		var queryIndex = path.indexOf("?");
		var basePath;

		if (queryIndex > -1)
		{
			basePath = path.substr(0, queryIndex);
		}
		else
		{
			basePath = path;
		}

		basePath = StringTools.replace(basePath, "\\", "/");

		while (StringTools.endsWith(basePath, "/"))
		{
			basePath = basePath.substr(0, basePath.length - 1);
		}

		if (StringTools.endsWith(basePath, ".bundle"))
		{
			if (queryIndex > -1)
			{
				return basePath + "/library.json" + path.substr(queryIndex);
			}
			else
			{
				return basePath + "/library.json";
			}
		}
		else
		{
			return path;
		}
	}

	private static __resolveRootPath(rootPath: string, path: string): string
	{
		if (rootPath != null) return rootPath;

		var queryIndex = path.indexOf("?");

		if (queryIndex > -1)
		{
			rootPath = path.substr(0, queryIndex);
		}
		else
		{
			rootPath = path;
		}

		rootPath = StringTools.replace(rootPath, "\\", "/");

		while (StringTools.endsWith(rootPath, "/"))
		{
			if (rootPath == "/") return rootPath;
			rootPath = rootPath.substr(0, rootPath.length - 1);
		}

		if (StringTools.endsWith(rootPath, ".bundle"))
		{
			return rootPath;
		}
		else
		{
			return Path.directory(rootPath);
		}

		return rootPath;
	}
}
#end
