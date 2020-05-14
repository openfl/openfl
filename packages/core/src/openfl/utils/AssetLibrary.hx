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
class AssetLibrary #if lime extends LimeAssetLibrary #end
{
	@:allow(openfl) @:noCompletion private var _:_AssetLibrary;

	public function new()
	{
		if (_ != null)
		{
			_ = new _AssetLibrary(this);
		}

		#if lime
		super();
		#end
	}

	#if lime
	public override function exists(id:String, type:String):Bool
	{
		if (_.__proxy != null)
		{
			return _.__proxy.exists(id, type);
		}
		else
		{
			return super.exists(id, type);
		}
	}
	#end

	public static function fromBundle(bundle:AssetBundle):AssetLibrary
	{
		return _AssetLibrary.fromBundle(bundle);
	}

	public static function fromBytes(bytes:ByteArray, rootPath:String = null):AssetLibrary
	{
		return _AssetLibrary.fromBytes(bytes, rootPath);
	}

	public static function fromFile(path:String, rootPath:String = null):AssetLibrary
	{
		return _AssetLibrary.fromFile(path, rootPath);
	}

	public static function fromManifest(manifest:AssetManifest):#if (java && lime) LimeAssetLibrary #else AssetLibrary #end
	{
		return _AssetLibrary.fromManifest(manifest);
	}

	#if lime
	public override function getAsset(id:String, type:String):Dynamic
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getAsset(id, type);
		}
		else
		{
			return super.getAsset(id, type);
		}
	}
	#end

	#if lime
	public override function getAudioBuffer(id:String):AudioBuffer
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getAudioBuffer(id);
		}
		else
		{
			return super.getAudioBuffer(id);
		}
	}
	#end

	#if lime
	public override function getBytes(id:String):Bytes
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getBytes(id);
		}
		else
		{
			return super.getBytes(id);
		}
	}
	#end

	#if lime
	public override function getFont(id:String):Font
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getFont(id);
		}
		else
		{
			return super.getFont(id);
		}
	}
	#end

	#if lime
	public override function getImage(id:String):Image
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getImage(id);
		}
		else
		{
			return super.getImage(id);
		}
	}
	#end

	public function getMovieClip(id:String):MovieClip
	{
		return _.getMovieClip(id);
	}

	#if lime
	public override function getPath(id:String):String
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getPath(id);
		}
		else
		{
			return super.getPath(id);
		}
	}
	#end

	#if lime
	public override function getText(id:String):String
	{
		if (_.__proxy != null)
		{
			return _.__proxy.getText(id);
		}
		else
		{
			return super.getText(id);
		}
	}
	#end

	#if lime
	public override function isLocal(id:String, type:String):Bool
	{
		if (_.__proxy != null)
		{
			return _.__proxy.isLocal(id, type);
		}
		else
		{
			return super.isLocal(id, type);
		}
	}
	#end

	#if lime
	public override function list(type:String):Array<String>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.list(type);
		}
		else
		{
			return super.list(type);
		}
	}
	#end

	#if lime
	public override function loadAsset(id:String, type:String):Future<Dynamic>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.loadAsset(id, type);
		}
		else
		{
			return super.loadAsset(id, type);
		}
	}
	#end

	#if lime
	public override function load():Future<LimeAssetLibrary>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.load();
		}
		else
		{
			return super.load();
		}
	}
	#end

	#if lime
	public override function loadAudioBuffer(id:String):Future<AudioBuffer>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.loadAudioBuffer(id);
		}
		else
		{
			return super.loadAudioBuffer(id);
		}
	}
	#end

	#if lime
	public override function loadBytes(id:String):Future<Bytes>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.loadBytes(id);
		}
		else
		{
			return super.loadBytes(id);
		}
	}
	#end

	#if lime
	public override function loadFont(id:String):Future<Font>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.loadFont(id);
		}
		else
		{
			return super.loadFont(id);
		}
	}
	#end

	public static function loadFromBytes(bytes:ByteArray, rootPath:String = null):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		return _AssetLibrary.loadFromBytes(bytes, rootPath);
	}

	public static function loadFromFile(path:String, rootPath:String = null):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		return _AssetLibrary.loadFromFile(path, rootPath);
	}

	public static function loadFromManifest(manifest:AssetManifest):#if (java && lime) Future<LimeAssetLibrary> #else Future<AssetLibrary> #end
	{
		return _AssetLibrary.loadFromManifest(manifest);
	}

	#if lime
	public override function loadImage(id:String):Future<Image>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.loadImage(id);
		}
		else
		{
			return super.loadImage(id);
		}
	}
	#end

	public function loadMovieClip(id:String):Future<MovieClip>
	{
		return _.loadMovieClip(id);
	}

	#if lime
	public override function loadText(id:String):Future<String>
	{
		if (_.__proxy != null)
		{
			return _.__proxy.loadText(id);
		}
		else
		{
			return super.loadText(id);
		}
	}
	#end

	#if lime
	public override function unload():Void
	{
		if (_.__proxy != null)
		{
			return _.__proxy.unload();
		}
		else
		{
			return super.unload();
		}
	}
	#end
}
