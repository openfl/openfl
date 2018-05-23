package openfl.display;


import lime.graphics.cairo.Cairo;
import lime.graphics.CairoRenderContext;
import openfl.geom.Matrix;


extern class CairoRenderer extends DisplayObjectRenderer {
	
	
	public var cairo:CairoRenderContext;
	
	public function applyMatrix (transform:Matrix, cairo:Cairo = null):Void;
	
	
}