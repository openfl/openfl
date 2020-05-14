package openfl.utils;

import openfl.display.MovieClip;
#if lime
import lime.graphics.Image;
import lime.media.AudioBuffer;
import lime.text.Font;
import lime.utils.AssetLibrary as LimeAssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Bytes;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _AssetLibrary
{
	#if lime
	public var __proxy:LimeAssetLibrary;
	#end

	private var assetLibrary:AssetLibrary;

	public function new(assetLibrary:AssetLibrary)
	{
		this.assetLibrary = assetLibrary;
	}

	public static function fromBundle(bundle:AssetBundle):AssetLibrary
	{
		#if lime
		var library = LimeAssetLibrary.fromBundle(bundle);

		if (library != null)
		{
			if (Std.is(library, AssetLibrary))
			{
				return cast library;
			}
			else
			{
				var _library = new AssetLibrary();
				_library._.__proxy = library;
				return _library;
			}
		}
		else
		{
			return null;
		}
		#else
		return null;
		#end
	}

	public static function fromBytes(bytes:ByteArray, rootPath:String = null):AssetLibrary
	{
		#if lime
		return cast fromManifest(AssetManifest.fromBytes(bytes, rootPath));
		#else
		return null;
		#end
	}

	public static function fromFile(path:String, rootPath:String = null):AssetLibrary
	{
		#if lime
		return cast fromManifest(AssetManifest.fromFile(path, rootPath));
		#else
		return null;
		#end
	}

	public static function fromManifest(manifest:AssetManifest):#if (java && lime) LimeAssetLibrary #else AssetLibrary #end
	{
		#if lime
		var library = LimeAssetLibrary.fromManifest(manifest);

		if (library != null)
		{
			if (Std.is(library, AssetLibrary))
			{
				return cast library;
			}
			else
			{
				var _library = new AssetLibrary();
				_library._.__proxy = library;
				return _library;
			}
		}
		else
		{
			return null;
		}
		#else
		return null;
		#end
	}

	public function getMovieClip(id:String):MovieClip
	{
		return null;
	}

	public static function loadFromBytes(bytes:ByteArray, rootPath:String = null):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		#if lime
		return AssetManifest.loadFromBytes(bytes, rootPath).then(function(manifest)
		{
			return loadFromManifest(manifest);
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	public static function loadFromFile(path:String, rootPath:String = null):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		#if lime
		return AssetManifest.loadFromFile(path, rootPath).then(function(manifest)
		{
			return loadFromManifest(manifest);
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	public static function loadFromManifest(manifest:AssetManifest):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		#if lime
		var library:AssetLibrary = cast fromManifest(manifest);

		if (library != null)
		{
			return library.load().then(function(library)
			{
				return Future.withValue(cast library);
			});
		}
		else
		{
			return cast Future.withError("Could not load asset manifest");
		}
		#else
		return cast Future.withValue(null);
		#end
	}

	public function loadMovieClip(id:String):Future<MovieClip>
	{
		return Future.withValue(getMovieClip(id));
	}
}
