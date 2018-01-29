package openfl.utils;


import lime.utils.AssetManifest in LimeAssetManifest;


class AssetManifest extends LimeAssetManifest {
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public function addBitmapData (path:String, id:String = null):Void {
		
		assets.push ({ path: path, id: (id != null ? id : path), type: AssetType.IMAGE, preload: true });
		
	}
	
	
	public function addBytes (path:String, id:String = null):Void {
		
		assets.push ({ path: path, id: (id != null ? id : path), type: AssetType.BINARY, preload: true });
		
	}
	
	
	public function addFont (name:String, id:String = null):Void {
		
		assets.push ({ path: name, id: (id != null ? id : name), type: AssetType.FONT, preload: true });
		
	}
	
	
	public function addSound (paths:Array<String>, id:String = null):Void {
		
		assets.push ({ pathGroup: paths, id: (id != null ? id : paths[0]), type: AssetType.SOUND, preload: true });
		
	}
	
	
	public function addText (path:String, id:String = null):Void {
		
		assets.push ({ path: path, id: (id != null ? id : path), type: AssetType.TEXT, preload: true });
		
	}
	
	
}