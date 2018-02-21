package openfl.utils;


// import lime.app.Future;
import openfl.utils.Future;
// import lime.utils.AssetLibrary in LimeAssetLibrary;
// import lime.utils.AssetManifest;
import openfl.display.MovieClip;

@:jsRequire("openfl/utils/AssetLibrary", "default")


@:dox(hide) extern class AssetLibrary /*extends LimeAssetLibrary*/ {
	
	
	public function new ();
	
	public static function fromBytes (bytes:ByteArray, rootPath:String = null):AssetLibrary;
	public static function fromFile (path:String, rootPath:String = null):AssetLibrary;
	public static function fromManifest (manifest:AssetManifest):AssetLibrary;
	public function getMovieClip (id:String):MovieClip;
	public static function loadFromBytes (bytes:ByteArray, rootPath:String = null):Future<AssetLibrary>;
	public static function loadFromFile (path:String, rootPath:String = null):Future<AssetLibrary>;
	public static function loadFromManifest (manifest:AssetManifest):Future<AssetLibrary>;	
	public function loadMovieClip (id:String):Future<MovieClip>;
	
	
}