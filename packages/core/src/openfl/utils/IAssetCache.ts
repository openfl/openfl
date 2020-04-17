import BitmapData from "../display/BitmapData";
import Sound from "../media/Sound";
import Font from "../text/Font";

/**
	The IAssetCache interface provides methods for caching
	resources loaded from openfl.utils.Assets to improve
	performance.
**/
export default interface IAssetCache
{
	/**
		Whether caching is currently enabled.
	**/
	enabled: boolean;

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
	clear(prefix?: string): void;

	/**
		Retrieves a cached BitmapData.

		@param	id	The ID of the cached BitmapData
		@return	The cached BitmapData instance
	**/
	getBitmapData(id: string): BitmapData;

	/**
		Retrieves a cached Font.

		@param	id	The ID of the cached Font
		@return	The cached Font instance
	**/
	getFont(id: string): Font;

	/**
		Retrieves a cached Sound.

		@param	id	The ID of the cached Sound
		@return	The cached Sound instance
	**/
	getSound(id: string): Sound;

	/**
		Checks whether a BitmapData asset is cached.

		@param	id	The ID of a BitmapData asset
		@return	Whether the object has been cached
	**/
	hasBitmapData(id: string): boolean;

	/**
		Checks whether a Font asset is cached.

		@param	id	The ID of a Font asset
		@return	Whether the object has been cached
	**/
	hasFont(id: string): boolean;

	/**
		Checks whether a Sound asset is cached.

		@param	id	The ID of a Sound asset
		@return	Whether the object has been cached
	**/
	hasSound(id: string): boolean;

	/**
		Removes a BitmapData from the cache.

		@param	id	The ID of a BitmapData asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	removeBitmapData(id: string): boolean;

	/**
		Removes a Font from the cache.

		@param	id	The ID of a Font asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	removeFont(id: string): boolean;

	/**
		Removes a Sound from the cache.

		@param	id	The ID of a Sound asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	removeSound(id: string): boolean;

	/**
		Adds or replaces a BitmapData asset in the cache.

		@param	id	The ID of a BitmapData asset
		@param	bitmapData	The matching BitmapData instance
	**/
	setBitmapData(id: string, bitmapData: BitmapData): void;

	/**
		Adds or replaces a Font asset in the cache.

		@param	id	The ID of a Font asset
		@param	bitmapData	The matching Font instance
	**/
	setFont(id: string, font: Font): void;

	/**
		Adds or replaces a Sound asset in the cache.

		@param	id	The ID of a Sound asset
		@param	bitmapData	The matching Sound instance
	**/
	setSound(id: string, sound: Sound): void;
}
