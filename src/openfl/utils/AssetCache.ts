import BitmapData from "../display/BitmapData";
import Sound from "../media/Sound";
import Font from "../text/Font";
import IAssetCache from "../utils/IAssetCache";

/**
	The AssetCache class is the default cache implementation used
	by openfl.utils.Assets, objects will be cached for the lifetime
	of the application unless removed explicitly, or using Assets
	`unloadLibrary`
**/
export default class AssetCache implements IAssetCache
{
	/**
		Whether caching is currently enabled.
	**/
	public enabled(get, set): boolean;

	/**
		Internal
		@hidden
	**/
	public bitmapData: Map<string, BitmapData>;

	/**
		Internal
		@hidden
	**/
	public font: Map<string, Font>;

	/**
		Internal
		@hidden
	**/
	public sound: Map<string, Sound>;

	protected __enabled: boolean = true;

	/**
		Creates a new AssetCache instance.
	**/
	public constructor()
	{
		bitmapData = new Map<string, BitmapData>();
		font = new Map<string, Font>();
		sound = new Map<string, Sound>();
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
	public clear(prefix: string = null): void
	{
		if (prefix == null)
		{
			bitmapData = new Map<string, BitmapData>();
			font = new Map<string, Font>();
			sound = new Map<string, Sound>();
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

	/**
		Retrieves a cached BitmapData.

		@param	id	The ID of the cached BitmapData
		@return	The cached BitmapData instance
	**/
	public getBitmapData(id: string): BitmapData
	{
		return bitmapData.get(id);
	}

	/**
		Retrieves a cached Font.

		@param	id	The ID of the cached Font
		@return	The cached Font instance
	**/
	public getFont(id: string): Font
	{
		return font.get(id);
	}

	/**
		Retrieves a cached Sound.

		@param	id	The ID of the cached Sound
		@return	The cached Sound instance
	**/
	public getSound(id: string): Sound
	{
		return sound.get(id);
	}

	/**
		Checks whether a BitmapData asset is cached.

		@param	id	The ID of a BitmapData asset
		@return	Whether the object has been cached
	**/
	public hasBitmapData(id: string): boolean
	{
		return bitmapData.exists(id);
	}

	/**
		Checks whether a Font asset is cached.

		@param	id	The ID of a Font asset
		@return	Whether the object has been cached
	**/
	public hasFont(id: string): boolean
	{
		return font.exists(id);
	}

	/**
		Checks whether a Sound asset is cached.

		@param	id	The ID of a Sound asset
		@return	Whether the object has been cached
	**/
	public hasSound(id: string): boolean
	{
		return sound.exists(id);
	}

	/**
		Removes a BitmapData from the cache.

		@param	id	The ID of a BitmapData asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public removeBitmapData(id: string): boolean
	{
		return bitmapData.remove(id);
	}

	/**
		Removes a Font from the cache.

		@param	id	The ID of a Font asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public removeFont(id: string): boolean
	{
		return font.remove(id);
	}

	/**
		Removes a Sound from the cache.

		@param	id	The ID of a Sound asset
		@return	`true` if the asset was removed, `false` if it was not in the cache
	**/
	public removeSound(id: string): boolean
	{
		return sound.remove(id);
	}

	/**
		Adds or replaces a BitmapData asset in the cache.

		@param	id	The ID of a BitmapData asset
		@param	bitmapData	The matching BitmapData instance
	**/
	public setBitmapData(id: string, bitmapData: BitmapData): void
	{
		this.bitmapData.set(id, bitmapData);
	}

	/**
		Adds or replaces a Font asset in the cache.

		@param	id	The ID of a Font asset
		@param	bitmapData	The matching Font instance
	**/
	public setFont(id: string, font: Font): void
	{
		this.font.set(id, font);
	}

	/**
		Adds or replaces a Sound asset in the cache.

		@param	id	The ID of a Sound asset
		@param	bitmapData	The matching Sound instance
	**/
	public setSound(id: string, sound: Sound): void
	{
		this.sound.set(id, sound);
	}

		// Get & Set Methods
		/** @hidden */ public get enabled(): boolean
	{
		return __enabled;
	}

		/** @hidden */ public set enabled(value: boolean): void
	{
		__enabled = value;
	}
}
