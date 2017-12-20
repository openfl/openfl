
declare namespace openfl.utils {

export class AssetLibrary /*extends lime_utils_AssetLibrary*/ {

	constructor();
	getMovieClip(id:any):any;
	loadMovieClip(id:any):any;
	static fromBytes(bytes:any, rootPath?:any):any;
	static fromFile(path:any, rootPath?:any):any;
	static fromManifest(manifest:any):any;
	static loadFromBytes(bytes:any, rootPath?:any):any;
	static loadFromFile(path:any, rootPath?:any):any;
	static loadFromManifest(manifest:any):any;


}

}

export default openfl.utils.AssetLibrary;