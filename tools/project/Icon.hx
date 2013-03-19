class Icon {
	
	
	public var height:Int;
	public var path:String;
	public var size:Int;
	public var width:Int;
	
	
	public function new (path:String, size:Int = 0) {
		
		this.path = path;
		this.size = height = width = size;
		
	}
	
	
	public function clone ():Icon {
		
		var icon = new Icon (path);
		icon.size = size;
		icon.width = width;
		icon.height = height;
		
		return icon;
		
	}
	
	
}