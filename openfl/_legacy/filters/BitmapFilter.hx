package openfl._legacy.filters; #if openfl_legacy


class BitmapFilter {
	
	
	private var type:String;
	
	
	public function new (type:String = "") {
		
		this.type = type;
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter (type);
		
		//throw ("clone not implemented");
		//return null;
		
	}
	
	
}


#end