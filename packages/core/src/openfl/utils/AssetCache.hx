package openfl.utils;

import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;
#if lime
import lime.utils.Assets as LimeAssets;
#end

/**
	The AssetCache class is the default cache implementation used
	by openfl.utils.Assets, objects will be cached for the lifetime
	of the application unless removed explicitly, or using Assets
	`unloadLibrary`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class AssetCache implements IAssetCache
{
	/**
		Whether caching is currently enabled.
	**/
	public var enabled(get, set):Bool;

	@:allow(openfl) @:noCompletion private var _:_AssetCache;

	/**
		Creates a new AssetCache instance.
	**/
	public function new()
	{
		if (_ == null)
		{
			_ = new _AssetCache();
		}
	}

	/**
		Clears all cached assets, or all assets with an ID that
		matches an optional prefix.

		For example:

		```haxe
		Assets.setBitmapData("image1", image1);
		Assets.setBitmapData("assets/image2", image2);

		Assets.clear("assets"); // will clear image2
		Assets.clear("image"); // will clear image1
		```

		@param	prefix	A ID prefix
	**/
	public function clear(prefix:String = null):Void
	{
		_.clear(prefix);
	}

	/**
		Retrieves a cached BitmapData.

		@param	id	The ID of the cached BitmapData
		@return	The cached BitmapData instance
	**/
	public function getBitmapData(id:String):BitmapData
	{
		return _.getBitmapData(id);
	}

	/**
		Retrieves a cached Font.

		@param	id	The ID of the cached Font
		@return	The cached Font instance
	**/
	public function getFont(id:String):Font
	{
		return return _.getFont(id);
	}

	/**
		Retrieves a cached Sound.

		@param	id	The ID of the cached Sound
		@return	The cached Sound instance
	**/
	public function getSound(id:String):Sound
	{
		return _.getSound(id);
	}

	/**
		Checks whether a BitmapData asset is cached.

		@param	id	The ID of a BitmapData asset
		@return	Whether the object has been cached
	**/
	public function hasBitmapData(id:String):Bool
	{
		return _.hasBitmapData(id);
	}

	/**
		Checks whether a Font asset is cached.

		@param	id	The ID of a Font asset
		@return	Whether the object has been cached
	**/
	public function hasFont(id:String):Bool
	{
		return _.hasFont(id);
	}

	/**
		Checks whether a Sound asset is cached.

		@param	id	The ID of a Sound asset
		@return	Whether the object has been cached
	**/
	public function hasSound(id:String):Bool
	{
		return _.hasSound(id);
	}

	/**
		Removes a BitmapData from the cache.

		@param	id	The ID of a BitmapData asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public function removeBitmapData(id:String):Bool
	{
		return _.removeBitmapData(id);
	}

	/**
		Removes a Font from the cache.

		@param	id	The ID of a Font asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public function removeFont(id:String):Bool
	{
		return _.removeFont(id);
	}

	/**
		Removes a Sound from the cache.

		@param	id	The ID of a Sound asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public function removeSound(id:String):Bool
	{
		return _.removeSound(id);
	}

	/**
		Adds or replaces a BitmapData asset in the cache.

		@param	id	The ID of a BitmapData asset
		@param	bitmapData	The matching BitmapData instance
	**/
	public function setBitmapData(id:String, bitmapData:BitmapData):Void
	{
		_.setBitmapData(id, bitmapData);
	}

	/**
		Adds or replaces a Font asset in the cache.

		@param	id	The ID of a Font asset
		@param	bitmapData	The matching Font instance
	**/
	public function setFont(id:String, font:Font):Void
	{
		_.setFont(id, font);
	}

	/**
		Adds or replaces a Sound asset in the cache.

		@param	id	The ID of a Sound asset
		@param	bitmapData	The matching Sound instance
	**/
	public function setSound(id:String, sound:Sound):Void
	{
		_.setSound(id, sound);
	}

	// Get & Set Methods
	@:noCompletion private function get_enabled():Bool
	{
		return _.enabled;
	}

	@:noCompletion private function set_enabled(value:Bool):Bool
	{
		return _.enabled = value;
	}
}
