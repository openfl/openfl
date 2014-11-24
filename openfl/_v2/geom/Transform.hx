package openfl._v2.geom; #if (!flash && !html5 && !openfl_next)


import openfl.display.DisplayObject;


class Transform {
	
	
	public var colorTransform (get, set):ColorTransform;
	public var concatenatedColorTransform (get, null):ColorTransform;
	public var concatenatedMatrix (get, null):Matrix;
	public var matrix (get, set):Matrix;
	public var pixelBounds (get, null):Rectangle;
	
	@:noCompletion private var __parent:DisplayObject;
	
	
	public function new (parent:DisplayObject) {
		
		__parent = parent;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_colorTransform ():ColorTransform { return __parent.__getColorTransform (); }
	private function set_colorTransform (value:ColorTransform):ColorTransform { __parent.__setColorTransform (value); return value; }
	private function get_concatenatedColorTransform ():ColorTransform { return __parent.__getConcatenatedColorTransform (); }
	private function get_concatenatedMatrix ():Matrix { return __parent.__getConcatenatedMatrix (); }
	private function get_matrix ():Matrix { return __parent.__getMatrix (); }
	private function set_matrix (value:Matrix):Matrix { __parent.__setMatrix (value); return value; }
	private function get_pixelBounds ():Rectangle { return __parent.__getPixelBounds (); }
	
	
}


#end