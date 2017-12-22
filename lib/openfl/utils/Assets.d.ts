import AssetLibrary from "./AssetLibrary";
import AssetType from "./AssetType";
import ByteArray from "./ByteArray";
import Future from "./Future";
import IAssetCache from "./IAssetCache";
import BitmapData from "./../display/BitmapData";
import MovieClip from "./../display/MovieClip";
import Sound from "./../media/Sound";
import Font from "./../text/Font";

type LimeAssetLibrary = any;


declare namespace openfl.utils {
	
	
	/**
	 * The Assets class provides a cross-platform interface to access 
	 * embedded images, fonts, sounds and other resource files.
	 * 
	 * The contents are populated automatically when an application
	 * is compiled using the OpenFL command-line tools, based on the
	 * contents of the *.xml project file.
	 * 
	 * For most platforms, the assets are included in the same directory
	 * or package as the application, and the paths are handled
	 * automatically. For web content, the assets are preloaded before
	 * the start of the rest of the application. You can customize the 
	 * preloader by extending the `NMEPreloader` class,
	 * and specifying a custom preloader using <window preloader="" />
	 * in the project file.
	 */
	export class Assets {
		
		
		public static cache:IAssetCache;
		
		public static addEventListener (type:string, listener:any, useCapture?:boolean, priority?:number, useWeakReference?:boolean):void;
		public static dispatchEvent (event:Event):boolean;
		
		/**
		 * Returns whether a specific asset exists
		 * @param	id 		The ID or asset path for the asset
		 * @param	type	The asset type to match, or null to match any type
		 * @return		Whether the requested asset ID and type exists
		 */
		public static exists (id:string, type?:AssetType):boolean;
		
		/**
		 * Gets an instance of an embedded bitmap
		 * @usage		bitmap = new Bitmap (Assets.getBitmapData ("image.png"));
		 * @param	id		The ID or asset path for the bitmap
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return		A new BitmapData object
		 */
		public static getBitmapData (id:string, useCache?:boolean):BitmapData;
		
		/**
		 * Gets an instance of an embedded binary asset
		 * @usage		bytes = Assets.getBytes ("file.zip");
		 * @param	id		The ID or asset path for the asset
		 * @return		A new ByteArray object
		 */
		public static getBytes (id:string):ByteArray;
		
		/**
		 * Gets an instance of an embedded font
		 * @usage		fontName = Assets.getFont ("font.ttf").fontName;
		 * @param	id		The ID or asset path for the font
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return		A new Font object
		 */
		public static getFont (id:string, useCache?:boolean):Font;
		
		public static getLibrary (name:string):LimeAssetLibrary;
		
		/**
		 * Gets an instance of an included MovieClip
		 * @usage		movieClip = Assets.getMovieClip ("library:BouncingBall");
		 * @param	id		The ID for the MovieClip
		 * @return		A new MovieClip object
		 */
		public static getMovieClip (id:string):MovieClip;
		
		/**
		 * Gets the file path (if available) for an asset
		 * @usage		path = Assets.getPath ("file.txt");
		 * @param	id		The ID or asset path for the asset
		 * @return		The path to the asset, or null if it does not exist
		 */
		public static getPath (id:string):string;
		
		/**
		 * Gets an instance of an embedded sound
		 * @usage		sound = Assets.getSound ("sound.wav");
		 * @param	id		The ID or asset path for the sound
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return		A new Sound object
		 */
		public static getSound (id:string, useCache?:boolean):Sound;
		
		/**
		 * Gets an instance of an embedded text asset
		 * @usage		text = Assets.getText ("text.txt");
		 * @param	id		The ID or asset path for the asset
		 * @return		A new String object
		 */
		public static getText (id:string):string;
		
		public static hasEventListener (type:string):boolean;
		public static hasLibrary (name:string):boolean;
		
		/**
		 * Returns whether an asset is "local", and therefore can be loaded synchronously
		 * @param	id 		The ID or asset path for the asset
		 * @param	type	The asset type to match, or null to match any type
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return	Whether the asset is local
		 */
		public static isLocal (id:string, type?:AssetType, useCache?:boolean):boolean;
		
		/**
		 * Returns a list of all embedded assets (by type)
		 * @param	type	The asset type to match, or null to match any type
		 * @return	An array of asset ID values
		 */
		public static list (type?:AssetType):Array<String>;
		
		/**
		 * Loads an included bitmap asset asynchronously
		 * @usage	Assets.loadBitmapData ("image.png").onComplete (handleImage);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<BitmapData>
		 */
		public static loadBitmapData (id:string, useCache?:boolean | null):Future<BitmapData>;
		
		/**
		 * Loads an included byte asset asynchronously
		 * @usage	Assets.loadBytes ("file.zip").onComplete (handleBytes);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<ByteArray>
		 */
		public static loadBytes (id:string):Future<ByteArray>;
		
		/**
		 * Loads an included font asset asynchronously
		 * @usage	Assets.loadFont ("font.ttf").onComplete (handleFont);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<Font>
		 */
		public static loadFont (id:string, useCache?:boolean | null):Future<Font>;
		
		/**
		 * Load an included AssetLibrary
		 * @param	name		The name of the AssetLibrary to load
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<AssetLibrary>
		 */
		public static loadLibrary (name:string):Future<LimeAssetLibrary>;
		
		/**
		 * Loads an included music asset asynchronously
		 * @usage	Assets.loadMusic ("music.ogg").onComplete (handleMusic);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<Sound>
		 */
		public static loadMusic (id:string, useCache?:boolean | null):Future<Sound>;
		
		/**
		 * Loads an included MovieClip asset asynchronously
		 * @usage	Assets.loadMovieClip ("library:BouncingBall").onComplete (handleMovieClip);
		 * @param	id 		The ID for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<MovieClip>
		 */
		public static loadMovieClip (id:string):Future<MovieClip>;
		
		/**
		 * Loads an included sound asset asynchronously
		 * @usage	Assets.loadSound ("sound.wav").onComplete (handleSound);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<Sound>
		 */
		public static loadSound (id:string, useCache?:boolean | null):Future<Sound>;
		
		/**
		 * Loads an included text asset asynchronously
		 * @usage	Assets.loadText ("text.txt").onComplete (handleString);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback when the load is completed
		 * @return		Returns a Future<String>
		 */
		public static loadText (id:string):Future<String>;
		
		/**
		 * Registers a new AssetLibrary with the Assets class
		 * @param	name		The name (prefix) to use for the library
		 * @param	library		An AssetLibrary instance to register
		 */
		public static registerLibrary (name:string, library:AssetLibrary):void;
		
		public static removeEventListener (type:string, listener:any, capture?:boolean):void;
		public static unloadLibrary (name:string):void;
		
		
	}
	
	
}


export default openfl.utils.Assets;