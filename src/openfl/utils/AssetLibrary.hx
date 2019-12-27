package openfl.utils;

import openfl.display.MovieClip;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.AssetLibrary as LimeAssetLibrary;
import openfl._internal.backend.lime_standalone.AssetManifest;
import openfl._internal.backend.lime_standalone.AudioBuffer;
import openfl._internal.backend.lime_standalone.LimeBytes as Bytes;
import openfl.text.Font;
import openfl._internal.backend.lime_standalone.Image;
#else
import openfl._internal.backend.lime.AssetLibrary as LimeAssetLibrary;
import openfl._internal.backend.lime.AssetManifest;
import openfl._internal.backend.lime.AudioBuffer;
import openfl._internal.backend.lime.Bytes;
import openfl._internal.backend.lime.Font;
import openfl._internal.backend.lime.Image;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AssetLibrary #if (lime || openfl_html5) extends LimeAssetLibrary #end
{
	#if (lime || openfl_html5)
	@:noCompletion private var __proxy:LimeAssetLibrary;
	#end

	public function new()
	{
		#if (lime || openfl_html5)
		super();
		#end
	}

	#if (lime || openfl_html5)
	public override function exists(id:String, type:String):Bool
	{
		if (__proxy != null)
		{
			return __proxy.exists(id, type);
		}
		else
		{
			return super.exists(id, type);
		}
	}
	#end

	public static function fromBundle(bundle:AssetBundle):AssetLibrary
	{
		#if (lime || openfl_html5)
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
				_library.__proxy = library;
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
		#if (lime || openfl_html5)
		return cast fromManifest(AssetManifest.fromBytes(bytes, rootPath));
		#else
		return null;
		#end
	}

	public static function fromFile(path:String, rootPath:String = null):AssetLibrary
	{
		#if (lime || openfl_html5)
		return cast fromManifest(AssetManifest.fromFile(path, rootPath));
		#else
		return null;
		#end
	}

	public static function fromManifest(manifest:AssetManifest):#if (java && lime) LimeAssetLibrary #else AssetLibrary #end
	{
		#if (lime || openfl_html5)
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
				_library.__proxy = library;
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

	#if (lime || openfl_html5)
	public override function getAsset(id:String, type:String):Dynamic
	{
		if (__proxy != null)
		{
			return __proxy.getAsset(id, type);
		}
		else
		{
			return super.getAsset(id, type);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function getAudioBuffer(id:String):AudioBuffer
	{
		if (__proxy != null)
		{
			return __proxy.getAudioBuffer(id);
		}
		else
		{
			return super.getAudioBuffer(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function getBytes(id:String):Bytes
	{
		if (__proxy != null)
		{
			return __proxy.getBytes(id);
		}
		else
		{
			return super.getBytes(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function getFont(id:String):Font
	{
		if (__proxy != null)
		{
			return __proxy.getFont(id);
		}
		else
		{
			return super.getFont(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function getImage(id:String):Image
	{
		if (__proxy != null)
		{
			return __proxy.getImage(id);
		}
		else
		{
			return super.getImage(id);
		}
	}
	#end

	public function getMovieClip(id:String):MovieClip
	{
		return null;
	}

	#if (lime || openfl_html5)
	public override function getPath(id:String):String
	{
		if (__proxy != null)
		{
			return __proxy.getPath(id);
		}
		else
		{
			return super.getPath(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function getText(id:String):String
	{
		if (__proxy != null)
		{
			return __proxy.getText(id);
		}
		else
		{
			return super.getText(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function isLocal(id:String, type:String):Bool
	{
		if (__proxy != null)
		{
			return __proxy.isLocal(id, type);
		}
		else
		{
			return super.isLocal(id, type);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function list(type:String):Array<String>
	{
		if (__proxy != null)
		{
			return __proxy.list(type);
		}
		else
		{
			return super.list(type);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function loadAsset(id:String, type:String):Future<Dynamic>
	{
		if (__proxy != null)
		{
			return __proxy.loadAsset(id, type);
		}
		else
		{
			return super.loadAsset(id, type);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function load():Future<LimeAssetLibrary>
	{
		if (__proxy != null)
		{
			return __proxy.load();
		}
		else
		{
			return super.load();
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function loadAudioBuffer(id:String):Future<AudioBuffer>
	{
		if (__proxy != null)
		{
			return __proxy.loadAudioBuffer(id);
		}
		else
		{
			return super.loadAudioBuffer(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function loadBytes(id:String):Future<Bytes>
	{
		if (__proxy != null)
		{
			return __proxy.loadBytes(id);
		}
		else
		{
			return super.loadBytes(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function loadFont(id:String):Future<Font>
	{
		if (__proxy != null)
		{
			return __proxy.loadFont(id);
		}
		else
		{
			return super.loadFont(id);
		}
	}
	#end

	public static function loadFromBytes(bytes:ByteArray, rootPath:String = null):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		#if (lime || openfl_html5)
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
		#if (lime || openfl_html5)
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
		#if (lime || openfl_html5)
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

	#if (lime || openfl_html5)
	public override function loadImage(id:String):Future<Image>
	{
		if (__proxy != null)
		{
			return __proxy.loadImage(id);
		}
		else
		{
			return super.loadImage(id);
		}
	}
	#end

	public function loadMovieClip(id:String):Future<MovieClip>
	{
		return Future.withValue(getMovieClip(id));
	}

	#if (lime || openfl_html5)
	public override function loadText(id:String):Future<String>
	{
		if (__proxy != null)
		{
			return __proxy.loadText(id);
		}
		else
		{
			return super.loadText(id);
		}
	}
	#end

	#if (lime || openfl_html5)
	public override function unload():Void
	{
		if (__proxy != null)
		{
			return __proxy.unload();
		}
		else
		{
			return super.unload();
		}
	}
	#end
}
