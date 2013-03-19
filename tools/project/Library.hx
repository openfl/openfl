package;


import haxe.io.Path;


class Library {
	
	
	public var name:String;
	public var sourcePath:String;
	public var type:LibraryType;
	
	
	public function new (sourcePath:String, name:String = "", type:LibraryType = null) {
		
		this.sourcePath = sourcePath;
		
		if (name == "") {
			
			this.name = Path.withoutDirectory (Path.withoutExtension (sourcePath));
			
		} else {
			
			this.name = name;
			
		}
		
		if (type == null) {
			
			if (Path.extension (sourcePath) == "swf") {
				
				this.type = LibraryType.SWF;
				
			} else {
				
				this.type = LibraryType.XFL;
				
			}
			
		} else {
			
			this.type = type;
			
		}
		
	}
	
	
	public function clone ():Library {
		
		return new Library (sourcePath, name, type);
		
	}
	
	
}