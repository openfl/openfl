package flash.utils {
	
	
	// import lime.app.Future;
	import flash.utils.Future;
	// import lime.utils.AssetLibrary in LimeAssetLibrary;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.text.Font;
	
	// typedef LimeAssetLibrary = Dynamic;
	
	
	/**
	 * @externs
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
	public class Assets {
		
		
		public static var cache:IAssetCache;
		
		public static function addEventListener (type:String, listener:Object, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {}
		public static function dispatchEvent (event:Event):Boolean { return false; }
		
		/**
		 * Returns whether a specific asset exists
		 * @param	id 		The ID or asset path for the asset
		 * @param	type	The asset type to match, or null to match any type
		 * @return		Whether the requested asset ID and type exists
		 */
		public static function exists (id:String, type:AssetType = null):Boolean { return false; }
		
		/**
		 * Gets an instance of an embedded bitmap
		 * @usage		var bitmap = new Bitmap (Assets.getBitmapData ("image.png"));
		 * @param	id		The ID or asset path for the bitmap
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return		A new BitmapData object
		 */
		public static function getBitmapData (id:String, useCache:Boolean = true):BitmapData { return null; }
		
		/**
		 * Gets an instance of an embedded binary asset
		 * @usage		var bytes = Assets.getBytes ("file.zip");
		 * @param	id		The ID or asset path for the asset
		 * @return		A new ByteArray object
		 */
		public static function getBytes (id:String):ByteArray { return null; }
		
		/**
		 * Gets an instance of an embedded font
		 * @usage		var fontName = Assets.getFont ("font.ttf").fontName;
		 * @param	id		The ID or asset path for the font
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return		A new Font object
		 */
		public static function getFont (id:String, useCache:Boolean = true):Font { return null; }
		
		public static function getLibrary (name:String):* { return null; }
		
		/**
		 * Gets an instance of an included MovieClip
		 * @usage		var movieClip = Assets.getMovieClip ("library:BouncingBall");
		 * @param	id		The ID for the MovieClip
		 * @return		A new MovieClip object
		 */
		public static function getMovieClip (id:String):MovieClip { return null; }
		
		/**
		 * Gets the file path (if available) for an asset
		 * @usage		var path = Assets.getPath ("file.txt");
		 * @param	id		The ID or asset path for the asset
		 * @return		The path to the asset, or null if it does not exist
		 */
		public static function getPath (id:String):String { return null; }
		
		/**
		 * Gets an instance of an embedded sound
		 * @usage		var sound = Assets.getSound ("sound.wav");
		 * @param	id		The ID or asset path for the sound
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return		A new Sound object
		 */
		public static function getSound (id:String, useCache:Boolean = true):Sound { return null; }
		
		/**
		 * Gets an instance of an embedded text asset
		 * @usage		var text = Assets.getText ("text.txt");
		 * @param	id		The ID or asset path for the asset
		 * @return		A new String object
		 */
		public static function getText (id:String):String { return null; }
		
		public static function hasEventListener (type:String):Boolean { return false; }
		public static function hasLibrary (name:String):Boolean { return false; }
		
		/**
		 * Returns whether an asset is "local", and therefore can be loaded synchronously
		 * @param	id 		The ID or asset path for the asset
		 * @param	type	The asset type to match, or null to match any type
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @return	Whether the asset is local
		 */
		public static function isLocal (id:String, type:AssetType = null, useCache:Boolean = true):Boolean { return false; }
		
		/**
		 * Returns a list of all embedded assets (by type)
		 * @param	type	The asset type to match, or null to match any type
		 * @return	An array of asset ID values
		 */
		public static function list (type:AssetType = null):Array { return null; }
		
		/**
		 * Loads an included bitmap asset asynchronously
		 * @usage	Assets.loadBitmapData ("image.png").onComplete (handleImage);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<BitmapData>
		 */
		public static function loadBitmapData (id:String, useCache:Object = true):Future { return null; }
		
		/**
		 * Loads an included byte asset asynchronously
		 * @usage	Assets.loadBytes ("file.zip").onComplete (handleBytes);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<ByteArray>
		 */
		public static function loadBytes (id:String):Future { return null; }
		
		/**
		 * Loads an included font asset asynchronously
		 * @usage	Assets.loadFont ("font.ttf").onComplete (handleFont);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<Font>
		 */
		public static function loadFont (id:String, useCache:Object = true):Future { return null; }
		
		/**
		 * Load an included AssetLibrary
		 * @param	name		The name of the AssetLibrary to load
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<AssetLibrary>
		 */
		public static function loadLibrary (name:String):Future { return null; }
		
		/**
		 * Loads an included music asset asynchronously
		 * @usage	Assets.loadMusic ("music.ogg").onComplete (handleMusic);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<Sound>
		 */
		public static function loadMusic (id:String, useCache:Object = true):Future { return null; }
		
		/**
		 * Loads an included MovieClip asset asynchronously
		 * @usage	Assets.loadMovieClip ("library:BouncingBall").onComplete (handleMovieClip);
		 * @param	id 		The ID for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<MovieClip>
		 */
		public static function loadMovieClip (id:String):Future { return null; }
		
		/**
		 * Loads an included sound asset asynchronously
		 * @usage	Assets.loadSound ("sound.wav").onComplete (handleSound);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<Sound>
		 */
		public static function loadSound (id:String, useCache:Object = true):Future { return null; }
		
		/**
		 * Loads an included text asset asynchronously
		 * @usage	Assets.loadText ("text.txt").onComplete (handleString);
		 * @param	id 		The ID or asset path for the asset
		 * @param	useCache		(Optional) Whether to allow use of the asset cache (Default: true)
		 * @param	handler		(Deprecated) A callback function when the load is completed
		 * @return		Returns a Future<String>
		 */
		public static function loadText (id:String):Future { return null; }
		
		/**
		 * Registers a new AssetLibrary with the Assets class
		 * @param	name		The name (prefix) to use for the library
		 * @param	library		An AssetLibrary instance to register
		 */
		public static function registerLibrary (name:String, library:AssetLibrary):void {}
		
		public static function removeEventListener (type:String, listener:Object, capture:Boolean = false):void {}
		public static function unloadLibrary (name:String):void {}
		
		
	}
	
	
}