import IAssetCache from "./IAssetCache";
import BitmapData from "./../display/BitmapData";
import Sound from "./../media/Sound";
import Font from "./../text/Font";


declare namespace openfl.utils {
	
	
	/*@:dox(hide)*/ export class AssetCache extends IAssetCache {
	
	
		public enabled:boolean;
		
		protected get_enabled ():boolean;
		protected set_enabled (value:boolean):boolean;
		
		public constructor ();
		
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
		
		protected get_enabled ():boolean;
		protected set_enabled (value:boolean):boolean;
		
		
	}
	
	
}


export default openfl.utils.AssetCache;