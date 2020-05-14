package openfl.utils;

import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;
#if lime
import lime.utils.Assets as LimeAssets;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _AssetCache
{
	public var enabled(get, set):Bool;
	public var bitmapData:Map<String, BitmapData>;
	public var font:Map<String, Font>;
	public var sound:Map<String, Sound>;

	public var __enabled:Bool = true;

	private var assetCache:AssetCache;

	public function new(assetCache:AssetCache)
	{
		this.assetCache = assetCache;

		bitmapData = new Map<String, BitmapData>();
		font = new Map<String, Font>();
		sound = new Map<String, Sound>();
	}

	public function clear(prefix:String = null):Void
	{
		if (prefix == null)
		{
			bitmapData = new Map<String, BitmapData>();
			font = new Map<String, Font>();
			sound = new Map<String, Sound>();
		}
		else
		{
			var keys = bitmapData.keys();

			for (key in keys)
			{
				if (StringTools.startsWith(key, prefix))
				{
					removeBitmapData(key);
				}
			}

			var keys = font.keys();

			for (key in keys)
			{
				if (StringTools.startsWith(key, prefix))
				{
					removeFont(key);
				}
			}

			var keys = sound.keys();

			for (key in keys)
			{
				if (StringTools.startsWith(key, prefix))
				{
					removeSound(key);
				}
			}
		}
	}

	public function getBitmapData(id:String):BitmapData
	{
		return bitmapData.get(id);
	}

	public function getFont(id:String):Font
	{
		return font.get(id);
	}

	public function getSound(id:String):Sound
	{
		return sound.get(id);
	}

	public function hasBitmapData(id:String):Bool
	{
		return bitmapData.exists(id);
	}

	public function hasFont(id:String):Bool
	{
		return font.exists(id);
	}

	public function hasSound(id:String):Bool
	{
		return sound.exists(id);
	}

	public function removeBitmapData(id:String):Bool
	{
		#if lime
		LimeAssets.cache.image.remove(id);
		#end
		return bitmapData.remove(id);
	}

	public function removeFont(id:String):Bool
	{
		#if lime
		LimeAssets.cache.font.remove(id);
		#end
		return font.remove(id);
	}

	public function removeSound(id:String):Bool
	{
		#if lime
		LimeAssets.cache.audio.remove(id);
		#end
		return sound.remove(id);
	}

	public function setBitmapData(id:String, bitmapData:BitmapData):Void
	{
		this.bitmapData.set(id, bitmapData);
	}

	public function setFont(id:String, font:Font):Void
	{
		this.font.set(id, font);
	}

	public function setSound(id:String, sound:Sound):Void
	{
		this.sound.set(id, sound);
	}

	// Get & Set Methods

	private function get_enabled():Bool
	{
		return __enabled;
	}

	private function set_enabled(value:Bool):Bool
	{
		return __enabled = value;
	}
}
