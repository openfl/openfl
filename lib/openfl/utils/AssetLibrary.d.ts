// import AssetManifest from "./AssetManifest";
import ByteArray from "./ByteArray";
import Future from "./Future";
import MovieClip from "./../display/MovieClip";

type AssetManifest = any;


declare namespace openfl.utils {
	
	
	/*@:dox(hide)*/ export class AssetLibrary /*extends LimeAssetLibrary*/ {
		
		
		public constructor ();
		
		public static fromBytes (bytes:ByteArray, rootPath?:string):AssetLibrary;
		public static fromFile (path:string, rootPath?:string):AssetLibrary;
		public static fromManifest (manifest:AssetManifest):AssetLibrary;
		public getMovieClip (id:string):MovieClip;
		public static loadFromBytes (bytes:ByteArray, rootPath?:string):Future<AssetLibrary>;
		public static loadFromFile (path:string, rootPath?:string):Future<AssetLibrary>;
		public static loadFromManifest (manifest:AssetManifest):Future<AssetLibrary>;	
		public loadMovieClip (id:string):Future<MovieClip>;
		
		
	}
	
	
}


export default openfl.utils.AssetLibrary;