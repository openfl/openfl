package openfl.display;


@:access(openfl.display.Graphics)


class Shape extends DisplayObject {
	
	
	public var graphics (get, never):Graphics;
	
	
	public function new () {
		
		super ();
		
	}


	public override function __setGraphicsDirty ():Void {

		graphics.__dirty = true;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics (this);
			
		}
		
		return __graphics;
		
	}
	
	
}