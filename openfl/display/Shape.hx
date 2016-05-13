package openfl.display; #if !openfl_legacy


@:access(openfl.display.Graphics)
 

class Shape extends DisplayObject {
	
	
	public var graphics (get, null):Graphics;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics ();
			__graphics.__owner = this;
			
		}
		
		return __graphics;
		
	}
	
	
}


#else
typedef Shape = openfl._legacy.display.Shape;
#end