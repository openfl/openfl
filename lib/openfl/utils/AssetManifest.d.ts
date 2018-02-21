declare namespace openfl.utils {
	
	
	export class AssetManifest /*extends LimeAssetManifest*/ {
		
		
		public constructor ();
		
		public addBitmapData (path:string, id?:string):void;
		public addBytes (path:string, id?:string):void;
		public addFont (name:string, id?:string):void;
		public addSound (paths:Array<string>, id?:string):void;
		public addText (path:string, id?:string):void;
		
		
	}
	
	
}


export default openfl.utils.AssetManifest;