

declare namespace openfl.utils {

export class IAssetCache {

	
	get_enabled():any;
	set_enabled(value:any):any;
	enabled:any;
	clear(prefix?:any):any;
	getBitmapData(id:any):any;
	getFont(id:any):any;
	getSound(id:any):any;
	hasBitmapData(id:any):any;
	hasFont(id:any):any;
	hasSound(id:any):any;
	removeBitmapData(id:any):any;
	removeFont(id:any):any;
	removeSound(id:any):any;
	setBitmapData(id:any, bitmapData:any):any;
	setFont(id:any, font:any):any;
	setSound(id:any, sound:any):any;


}

}

export default openfl.utils.IAssetCache;