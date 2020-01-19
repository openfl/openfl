package openfl.utils;

import haxe.io.Bytes;
#if lime
import lime.utils.AssetManifest as LimeAssetManifest;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AssetManifest #if lime extends LimeAssetManifest #end
{
	#if !lime
	private var assets:Array<Dynamic>;
	#end

	public function new()
	{
		#if lime
		super();
		#end
	}

	public function addBitmapData(path:String, id:String = null):Void
	{
		assets.push({
			path: path,
			id: (id != null ? id : path),
			type: AssetType.IMAGE,
			preload: true
		});
	}

	public function addBytes(path:String, id:String = null):Void
	{
		assets.push({
			path: path,
			id: (id != null ? id : path),
			type: AssetType.BINARY,
			preload: true
		});
	}

	public function addFont(name:String, id:String = null):Void
	{
		assets.push({
			path: name,
			id: (id != null ? id : name),
			type: AssetType.FONT,
			preload: true
		});
	}

	public function addSound(paths:Array<String>, id:String = null):Void
	{
		assets.push({
			pathGroup: paths,
			id: (id != null ? id : paths[0]),
			type: AssetType.SOUND,
			preload: true
		});
	}

	public function addText(path:String, id:String = null):Void
	{
		assets.push({
			path: path,
			id: (id != null ? id : path),
			type: AssetType.TEXT,
			preload: true
		});
	}

	public static function fromBytes(bytes:Bytes, rootPath:String = null):AssetManifest
	{
		#if lime
		var manifest = LimeAssetManifest.fromBytes(bytes, rootPath);
		return __fromLimeManifest(manifest);
		#else
		return null;
		#end
	}

	public static function fromFile(path:String, rootPath:String = null):AssetManifest
	{
		#if lime
		var manifest = LimeAssetManifest.fromFile(path, rootPath);
		return __fromLimeManifest(manifest);
		#else
		return null;
		#end
	}

	public static function loadFromBytes(bytes:Bytes, rootPath:String = null):Future<AssetManifest>
	{
		#if lime
		return LimeAssetManifest.loadFromBytes(bytes, rootPath).then(function(manifest)
		{
			return Future.withValue(__fromLimeManifest(manifest));
		});
		#else
		return null;
		#end
	}

	public static function loadFromFile(path:String, rootPath:String = null):Future<AssetManifest>
	{
		#if lime
		return LimeAssetManifest.loadFromFile(path, rootPath).then(function(manifest)
		{
			return Future.withValue(__fromLimeManifest(manifest));
		});
		#else
		return null;
		#end
	}

	public static function parse(data:String, rootPath:String = null):AssetManifest
	{
		#if lime
		var manifest = LimeAssetManifest.parse(data, rootPath);
		return __fromLimeManifest(manifest);
		#else
		return null;
		#end
	}

	#if lime
	@:noCompletion private static function __fromLimeManifest(limeManifest:LimeAssetManifest):AssetManifest
	{
		var manifest = null;
		if (limeManifest != null)
		{
			manifest = new AssetManifest();
			manifest.assets = limeManifest.assets;
			manifest.libraryArgs = limeManifest.libraryArgs;
			manifest.libraryType = limeManifest.libraryType;
			manifest.name = limeManifest.name;
			manifest.rootPath = limeManifest.rootPath;
			manifest.version = limeManifest.version;
		}
		return manifest;
	}
	#end
}
