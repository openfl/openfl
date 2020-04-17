import BitmapData from "../display/BitmapData";
import MovieClip from "../display/MovieClip";
import Event from "../events/Event";
import EventDispatcher from "../events/EventDispatcher";
import Sound from "../media/Sound";
import Font from "../text/Font";
import AssetCache from "../utils/AssetCache";
import AssetLibrary from "../utils/AssetLibrary";
import AssetType from "../utils/AssetType";
import ByteArray from "../utils/ByteArray";
import Future from "../utils/Future";
import IAssetCache from "../utils/IAssetCache";

/**
	The Assets class provides a cross-platform interface to access
	embedded images, fonts, sounds and other resource files.

	The contents are populated automatically when an application
	is compiled using the OpenFL command-line tools, based on the
	contents of the *.xml project file.

	For most platforms, the assets are included in the same directory
	or namespace as the application, and the paths are handled
	automatically. For web content, the assets are preloaded before
	the start of the rest of the application. You can customize the
	preloader by extending the `NMEPreloader` class,
	and specifying a custom preloader using <window preloader="" />
	in the project file.
**/
export default class Assets
{
	public static cache: IAssetCache = new AssetCache();
	protected static dispatcher: EventDispatcher = new EventDispatcher();

	public static addEventListener<T>(type: string, listener: (event: T) => void, useCapture: boolean = false, priority: number = 0, useWeakReference: boolean = false): void
	{
		Assets.dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	public static dispatchEvent(event: Event): boolean
	{
		return Assets.dispatcher.dispatchEvent(event);
	}

	/**
		Returns whether a specific asset exists
		@param	id 		The ID or asset path for the asset
		@param	type	The asset type to match, or null to match any type
		@return		Whether the requested asset ID and type exists
	**/
	public static exists(id: string, type: AssetType = null): boolean
	{
		return false;
	}

	/**
		Gets an instance of an embedded bitmap
		@usage		var bitmap = new Bitmap (Assets.getBitmapData ("image.png"));
		@param	id		The ID or asset path for the bitmap
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		A new BitmapData object
	**/
	public static getBitmapData(id: string, useCache: boolean = true): BitmapData
	{
		return null;
	}

	/**
		Gets an instance of an embedded binary asset
		@usage		var bytes = Assets.getBytes ("file.zip");
		@param	id		The ID or asset path for the asset
		@return		A new ByteArray object
	**/
	public static getBytes(id: string): ByteArray
	{
		return null;
	}

	/**
		Gets an instance of an embedded font
		@usage		var fontName = Assets.getFont ("font.ttf").fontName;
		@param	id		The ID or asset path for the font
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		A new Font object
	**/
	public static getFont(id: string, useCache: boolean = true): Font
	{
		return new Font();
	}

	public static getLibrary(name: string): AssetLibrary
	{
		return null;
	}

	/**
		Gets an instance of an included MovieClip
		@usage		var movieClip = Assets.getMovieClip ("library:BouncingBall");
		@param	id		The ID for the MovieClip
		@return		A new MovieClip object
	**/
	public static getMovieClip(id: string): MovieClip
	{
		return null;
	}

	public static getMusic(id: string, useCache: boolean = true): Sound
	{
		// TODO: Streaming sound

		return this.getSound(id, useCache);
	}

	/**
		Gets the file path (if available) for an asset
		@usage		var path = Assets.getPath ("file.txt");
		@param	id		The ID or asset path for the asset
		@return		The path to the asset, or null if it does not exist
	**/
	public static getPath(id: string): string
	{
		return null;
	}

	/**
		Gets an instance of an embedded sound
		@usage		var sound = Assets.getSound ("sound.wav");
		@param	id		The ID or asset path for the sound
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		A new Sound object
	**/
	public static getSound(id: string, useCache: boolean = true): Sound
	{
		return null;
	}

	/**
		Gets an instance of an embedded text asset
		@usage		var text = Assets.getText ("text.txt");
		@param	id		The ID or asset path for the asset
		@return		A new String object
	**/
	public static getText(id: string): string
	{
		return null;
	}

	public static hasEventListener(type: string): boolean
	{
		return Assets.dispatcher.hasEventListener(type);
	}

	public static hasLibrary(name: string): boolean
	{
		return false;
	}

	/**
		Returns whether an asset is "local", and therefore can be loaded synchronously
		@param	id 		The ID or asset path for the asset
		@param	type	The asset type to match, or null to match any type
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return	Whether the asset is local
	**/
	public static isLocal(id: string, type: AssetType = null, useCache: boolean = true): boolean
	{
		return false;
	}

	private static isValidBitmapData(bitmapData: BitmapData): boolean
	{
		return true;
	}

	/** @hidden */
	private static isValidSound(sound: Sound): boolean
	{
		return true;
	}

	/**
		Returns a list of all embedded assets (by type)
		@param	type	The asset type to match, or null to match any type
		@return	An array of asset ID values
	**/
	public static list(type: AssetType = null): Array<string>
	{
		return [];
	}

	/**
		Loads an included bitmap asset asynchronously
		@usage	Assets.loadBitmapData ("image.png").onComplete (handleImage);
		@param	id 		The ID or asset path for the asset
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		Returns a Future<BitmapData>
	**/
	public static loadBitmapData(id: string, useCache: null | boolean = true): Future<BitmapData>
	{
		if (useCache == null) useCache = true;

		return Future.withValue(this.getBitmapData(id, useCache));
	}

	/**
		Loads an included byte asset asynchronously
		@usage	Assets.loadBytes ("file.zip").onComplete (handleBytes);
		@param	id 		The ID or asset path for the asset
		@return		Returns a Future<ByteArray>
	**/
	public static loadBytes(id: string): Future<ByteArray>
	{
		return Future.withValue(this.getBytes(id));
	}

	/**
		Loads an included font asset asynchronously
		@usage	Assets.loadFont ("font.ttf").onComplete (handleFont);
		@param	id 		The ID or asset path for the asset
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		Returns a Future<Font>
	**/
	public static loadFont(id: string, useCache: null | boolean = true): Future<Font>
	{
		if (useCache == null) useCache = true;

		return Future.withValue(this.getFont(id, useCache));
	}

	/**
		Load an included AssetLibrary
		@param	name		The name of the AssetLibrary to load
		@return		Returns a Future<AssetLibrary>
	**/
	public static loadLibrary(name: string): Future<AssetLibrary>
	{
		return Future.withError("Cannot load library") as Future<AssetLibrary>;
	}

	/**
		Loads an included music asset asynchronously
		@usage	Assets.loadMusic ("music.ogg").onComplete (handleMusic);
		@param	id 		The ID or asset path for the asset
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		Returns a Future<Sound>
	**/
	public static loadMusic(id: string, useCache: null | boolean = true): Future<Sound>
	{
		if (useCache == null) useCache = true;

		return Future.withValue(this.getMusic(id, useCache));
	}

	/**
		Loads an included MovieClip asset asynchronously
		@usage	Assets.loadMovieClip ("library:BouncingBall").onComplete (handleMovieClip);
		@param	id 		The ID for the asset
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		Returns a Future<MovieClip>
	**/
	public static loadMovieClip(id: string): Future<MovieClip>
	{
		return Future.withValue(this.getMovieClip(id));
	}

	/**
		Loads an included sound asset asynchronously
		@usage	Assets.loadSound ("sound.wav").onComplete (handleSound);
		@param	id 		The ID or asset path for the asset
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		Returns a Future<Sound>
	**/
	public static loadSound(id: string, useCache: null | boolean = true): Future<Sound>
	{
		if (useCache == null) useCache = true;

		return Future.withValue(this.getSound(id, useCache));
	}

	/**
		Loads an included text asset asynchronously
		@usage	Assets.loadText ("text.txt").onComplete (handleString);
		@param	id 		The ID or asset path for the asset
		@param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		@return		Returns a Future<string>
	**/
	public static loadText(id: string): Future<string>
	{
		return Future.withValue(this.getText(id));
	}

	/**
		Registers a new AssetLibrary with the Assets class
		@param	name		The name (prefix) to use for the library
		@param	library		An AssetLibrary instance to register
	**/
	public static registerLibrary(name: string, library: AssetLibrary): void
	{
	}

	public static removeEventListener<T>(type: string, listener: (event: T) => void, capture: boolean = false): void
	{
		Assets.dispatcher.removeEventListener(type, listener, capture);
	}

	protected static resolveClass(name: string): any
	{
		// return Type.resolveClass(name);
		return null;
	}

	protected static resolveEnum(name: string): any
	{
		// var value = Type.resolveEnum(name);
		// return value;
		return null;
	}

	public static unloadLibrary(name: string): void
	{
		if (name == null || name == "")
		{
			name = "default";
			// TODO: Do we cache with the default prefix?
			Assets.cache.clear(":");
		}

		var library = this.getLibrary(name);
		if (library != null)
		{
			Assets.cache.clear(name + ":");
		}
	}

	// Event Handlers

	protected static LimeAssets_onChange(): void
	{
		this.dispatchEvent(new Event(Event.CHANGE));
	}
}
