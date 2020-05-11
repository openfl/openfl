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
	@:allow(openfl) @:noCompletion private var _:_AssetManifest;

	public function new()
	{
		#if lime
		super();
		#end

		_ = new _AssetManifest();
	}

	public function addBitmapData(path:String, id:String = null):Void
	{
		_.addBitmapData(path, id);
	}

	public function addBytes(path:String, id:String = null):Void
	{
		_.addBytes(path, id);
	}

	public function addFont(name:String, id:String = null):Void
	{
		_.addFont(name, id);
	}

	public function addSound(paths:Array<String>, id:String = null):Void
	{
		_.addSound(paths, id);
	}

	public function addText(path:String, id:String = null):Void
	{
		_.addText(path, id);
	}

	public static function fromBytes(bytes:Bytes, rootPath:String = null):AssetManifest
	{
		return _AssetManifest.fromBytes(bytes, rootPath);
	}

	public static function fromFile(path:String, rootPath:String = null):AssetManifest
	{
		return _AssetManifest.fromFile(path, rootPath);
	}

	public static function loadFromBytes(bytes:Bytes, rootPath:String = null):Future<AssetManifest>
	{
		return _AssetManifest.loadFromBytes(bytes, rootPath);
	}

	public static function loadFromFile(path:String, rootPath:String = null):Future<AssetManifest>
	{
		return _AssetManifest.loadFromFile(path, rootPath);
	}

	public static function parse(data:String, rootPath:String = null):AssetManifest
	{
		return _AssetManifest.fromBytes(bytes, rootPath);
	}
}
