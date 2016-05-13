package flash.display; #if (!display && flash)


import openfl.Vector;


@:final extern class GraphicsPath implements IGraphicsData implements IGraphicsPath {
	
	
	public var commands:Vector<Int>;
	public var data:Vector<Float>;
	public var winding:GraphicsPathWinding; /* note: currently ignored */
	
	public function new (commands:Vector<Int> = null, data:Vector<Float> = null, ?winding:GraphicsPathWinding);
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float): Void;
	#end
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;
	public function lineTo (x:Float, y:Float):Void;
	public function moveTo (x:Float, y:Float):Void;
	public function wideLineTo (x:Float, y:Float):Void;
	public function wideMoveTo (x:Float, y:Float):Void;
	
	
}


#else
typedef GraphicsPath = openfl.display.GraphicsPath;
#end