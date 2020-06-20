package openfl.utils;

import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;

/**
	The AssetCache class is the default cache implementation used
	by openfl.utils.Assets, objects will be cached for the lifetime
	of the application unless removed explicitly, or using Assets
	`unloadLibrary`
**/
@:jsRequire("openfl/utils/AssetCache", "default")
@:dox(hide) extern class AssetCache implements IAssetCache
{
	/**
		Whether caching is currently enabled.
	**/
	public var enabled(get, set):Bool;
	@:noCompletion private function get_enabled():Bool;
	@:noCompletion private function set_enabled(value:Bool):Bool;

	/**
		Creates a new AssetCache instance.
	**/
	public function new();

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
	public function clear(prefix:String = null):Void;

	/**
		Retrieves a cached BitmapData.

		@param	id	The ID of the cached BitmapData
		@return	The cached BitmapData instance
	**/
	public function getBitmapData(id:String):BitmapData;
	

	/**
		Retrieves a cached Font.

		@param	id	The ID of the cached Font
		@return	The cached Font instance
	**/
	public function getFont(id:String):Font;

	/**
		Retrieves a cached Sound.

		@param	id	The ID of the cached Sound
		@return	The cached Sound instance
	**/
	public function getSound(id:String):Sound;

	/**
		Checks whether a BitmapData asset is cached.

		@param	id	The ID of a BitmapData asset
		@return	Whether the object has been cached
	**/
	public function hasBitmapData(id:String):Bool;

	/**
		Checks whether a Font asset is cached.

		@param	id	The ID of a Font asset
		@return	Whether the object has been cached
	**/
	public function hasFont(id:String):Bool;

	/**
		Checks whether a Sound asset is cached.

		@param	id	The ID of a Sound asset
		@return	Whether the object has been cached
	**/
	public function hasSound(id:String):Bool;

	/**
		Removes a BitmapData from the cache.

		@param	id	The ID of a BitmapData asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public function removeBitmapData(id:String):Bool;

	/**
		Removes a Font from the cache.

		@param	id	The ID of a Font asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public function removeFont(id:String):Bool;

	/**
		Removes a Sound from the cache.

		@param	id	The ID of a Sound asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public function removeSound(id:String):Bool;

	/**
		Adds or replaces a BitmapData asset in the cache.

		@param	id	The ID of a BitmapData asset
		@param	bitmapData	The matching BitmapData instance
	**/
	public function setBitmapData(id:String, bitmapData:BitmapData):Void;

	/**
		Adds or replaces a Font asset in the cache.

		@param	id	The ID of a Font asset
		@param	bitmapData	The matching Font instance
	**/
	public function setFont(id:String, font:Font):Void;

	/**
		Adds or replaces a Sound asset in the cache.

		@param	id	The ID of a Sound asset
		@param	bitmapData	The matching Sound instance
	**/
	public function setSound(id:String, sound:Sound):Void;
}
