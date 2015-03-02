package openfl._v2.filters; #if lime_legacy


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