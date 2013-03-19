package;


import haxe.io.Path;


class Asset {
	
	
	public var data:Dynamic;
	public var embed:Bool;
	public var flatName:String;
	public var format:String;
	public var glyphs:String;
	public var id:String;
	//public var path:String;
	//public var rename:String;
	public var resourceName:String;
	public var sourcePath:String;
	public var targetPath:String;
	public var type:AssetType;
	
	
	public function new (path:String = "", rename:String = "", type:AssetType = null, embed:Bool = true) {
		
		this.embed = embed;
		sourcePath = path;
		
		if (rename == "") {
			
			targetPath = path;
			
		} else {
			
			targetPath = rename;
			
		}
		
		id = targetPath;
		resourceName = targetPath;
		flatName = StringHelper.getFlatName (targetPath);
		format = Path.extension (path).toLowerCase ();
		glyphs = "32-255";
		
		if (type == null) {
			
			var extension = Path.extension (path);
			
			switch (extension.toLowerCase ()) {
				
				case "jpg", "jpeg", "png", "gif":
					
					this.type = AssetType.IMAGE;
				
				case "otf", "ttf":
					
					this.type = AssetType.FONT;
				
				case "wav", "ogg":
					
					this.type = AssetType.SOUND;
				
				case "mp3", "mp2":
					
					this.type = AssetType.MUSIC;
				
				case "text", "txt", "json", "xml", "svg", "css":
					
					this.type = AssetType.TEXT;
				
				default:
					
					if (path != "" && FileHelper.isText (path)) {
						
						this.type = AssetType.TEXT;
						
					} else {
						
						this.type = AssetType.BINARY;
						
					}
				
			}
			
		} else {
			
			this.type = type;
			
		}
		
	}
	
	
	public function clone ():Asset {
		
		var asset = new Asset ();
		ObjectHelper.copyFields (this, asset);
		return asset;
		
	}
	
	
}