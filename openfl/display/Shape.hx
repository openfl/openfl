package openfl.display; #if !openfl_legacy

import openfl.geom.Matrix;


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
	
	public override function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		super.__updateTransforms (overrideTransform);
		
		// :TRICKY: account for the extra offset added to allow anti aliasing on the edges (see CanvasGraphics.render())
		__renderTransform.tx -= 1;
		__renderTransform.ty -= 1;
	}	
}


#else
typedef Shape = openfl._legacy.display.Shape;
#end