package flash.utils {
	
	
	// import lime.app.Future;
	import flash.utils.Future;
	// import lime.utils.AssetLibrary in LimeAssetLibrary;
	// import lime.utils.AssetManifest;
	import flash.display.MovieClip;
	
	
	/**
	 * @externs
	 */
	public class AssetLibrary /*extends LimeAssetLibrary*/ {
		
		
		public function AssetLibrary () {}
		
		public static function fromBytes (bytes:ByteArray, rootPath:String = null):AssetLibrary { return null; }
		public static function fromFile (path:String, rootPath:String = null):AssetLibrary { return null; }
		public static function fromManifest (manifest:AssetManifest):AssetLibrary { return null; }
		public function getMovieClip (id:String):MovieClip { return null; }
		public static function loadFromBytes (bytes:ByteArray, rootPath:String = null):Future { return null; }
		public static function loadFromFile (path:String, rootPath:String = null):Future { return null; }
		public static function loadFromManifest (manifest:AssetManifest):Future { return null; }
		public function loadMovieClip (id:String):Future { return null; }
		
		
	}
	
	
}