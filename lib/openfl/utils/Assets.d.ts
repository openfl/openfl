
declare namespace openfl.utils {

export class Assets {

	static cache:any;
	static dispatcher:any;
	static addEventListener(type:any, listener:any, useCapture?:any, priority?:any, useWeakReference?:any):any;
	static dispatchEvent(event:any):any;
	static exists(id:any, type?:any):any;
	static getBitmapData(id:any, useCache?:any):any;
	static getBytes(id:any):any;
	static getFont(id:any, useCache?:any):any;
	static getLibrary(name:any):any;
	static getMovieClip(id:any):any;
	static getMusic(id:any, useCache?:any):any;
	static getPath(id:any):any;
	static getSound(id:any, useCache?:any):any;
	static getText(id:any):any;
	static hasEventListener(type:any):any;
	static hasLibrary(name:any):any;
	static isLocal(id:any, type?:any, useCache?:any):any;
	static isValidBitmapData(bitmapData:any):any;
	static isValidSound(sound:any):any;
	static list(type?:any):any;
	static loadBitmapData(id:any, useCache?:any):any;
	static loadBytes(id:any):any;
	static loadFont(id:any, useCache?:any):any;
	static loadLibrary(name:any):any;
	static loadMusic(id:any, useCache?:any):any;
	static loadMovieClip(id:any):any;
	static loadSound(id:any, useCache?:any):any;
	static loadText(id:any):any;
	static registerLibrary(name:any, library:any):any;
	static removeEventListener(type:any, listener:any, capture?:any):any;
	static resolveClass(name:any):any;
	static resolveEnum(name:any):any;
	static unloadLibrary(name:any):any;
	static LimeAssets_onChange():any;


}

}

export default openfl.utils.Assets;