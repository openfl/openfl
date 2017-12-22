import BitmapData from "./../display/BitmapData";
import Sound from "./../media/Sound";
import Font from "./../text/Font";



declare namespace openfl.utils {
	
	
	/*@:dox(hide)*/ export class IAssetCache {
		
		public enabled:boolean;
		
		public clear (prefix?:string):void;
		public getBitmapData (id:string):BitmapData;
		public getFont (id:string):Font;
		public getSound (id:string):Sound;
		public hasBitmapData (id:string):boolean;
		public hasFont (id:string):boolean;
		public hasSound (id:string):boolean;
		public removeBitmapData (id:string):boolean;
		public removeFont (id:string):boolean;
		public removeSound (id:string):boolean;
		public setBitmapData (id:string, bitmapData:BitmapData):void;
		public setFont (id:string, font:Font):void;
		public setSound (id:string, sound:Sound):void;
		
		// private get_enabled ():boolean;
		// private set_enabled (value:boolean):boolean;
		
	}
	
	
}


export default openfl.utils.IAssetCache;