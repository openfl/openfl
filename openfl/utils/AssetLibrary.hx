package openfl.utils;


import lime.app.Future;
import lime.utils.AssetLibrary in LimeAssetLibrary;
import lime.utils.AssetManifest;
import openfl.display.MovieClip;


@:dox(hide) class AssetLibrary extends LimeAssetLibrary {
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public static function fromBytes (bytes:ByteArray, rootPath:String = null):AssetLibrary {
		
		return fromManifest (AssetManifest.fromBytes (bytes, rootPath));
		
	}
	
	
	public static function fromFile (path:String, rootPath:String = null):AssetLibrary {
		
		return fromManifest (AssetManifest.fromFile (path, rootPath));
		
	}
	
	
	public static function fromManifest (manifest:AssetManifest):AssetLibrary {
		
		var library = LimeAssetLibrary.fromManifest (manifest);
		
		if (library != null && Std.is (library, AssetLibrary)) {
			
			return cast library;
			
		} else {
			
			return null;
			
		}
		
	}
	
	
	public function getMovieClip (id:String):MovieClip {
		
		return null;
		
	}
	
	
	public static function loadFromBytes (bytes:ByteArray, rootPath:String = null):Future<AssetLibrary> {
		
		return AssetManifest.loadFromBytes (bytes, rootPath).then (function (manifest) {
			
			return loadFromManifest (manifest);
			
		});
		
	}
	
	
	public static function loadFromFile (path:String, rootPath:String = null):Future<AssetLibrary> {
		
		return AssetManifest.loadFromFile (path, rootPath).then (function (manifest) {
			
			return loadFromManifest (manifest);
			
		});
		
	}
	
	
	public static function loadFromManifest (manifest:AssetManifest):Future<AssetLibrary> {
		
		var library = fromManifest (manifest);
		
		if (library != null && Std.is (library, AssetLibrary)) {
			
			return library.load ().then (function (library) {
				
				return Future.withValue (cast library);
				
			});
			
		} else {
			
			return cast Future.withError ("Could not load asset manifest");
			
		}
		
	}
	
	
	public function loadMovieClip (id:String):Future<MovieClip> {
		
		return new Future<MovieClip> (function () return getMovieClip (id));
		
	}
	
	
}