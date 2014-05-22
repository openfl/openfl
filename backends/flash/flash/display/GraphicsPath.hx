package flash.display;

/*
 It was not possible to override flash.Vector with a smarter abstract type, since this is 
 baked into genswf9.ml. Instead, we'll set classes that use flash.Vector to reference
 openfl.Vector instead.
*/

@:final extern class GraphicsPath implements IGraphicsData implements IGraphicsPath {
	var commands : openfl.Vector<Int>;
	var data : openfl.Vector<Float>;
	var winding : GraphicsPathWinding;
	function new(?commands : openfl.Vector<Int>, ?data : openfl.Vector<Float>, ?winding : GraphicsPathWinding) : Void;
	@:require(flash11) function cubicCurveTo(controlX1 : Float, controlY1 : Float, controlX2 : Float, controlY2 : Float, anchorX : Float, anchorY : Float) : Void;
	function curveTo(controlX : Float, controlY : Float, anchorX : Float, anchorY : Float) : Void;
	function lineTo(x : Float, y : Float) : Void;
	function moveTo(x : Float, y : Float) : Void;
	function wideLineTo(x : Float, y : Float) : Void;
	function wideMoveTo(x : Float, y : Float) : Void;
}
