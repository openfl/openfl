/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


@:final extern class GraphicsGradientFill implements IGraphicsData  implements IGraphicsFill {
	var alphas : Array<Float>;
	var colors : Array<UInt>;
	var focalPointRatio : Float;
	var interpolationMethod : InterpolationMethod;
	var matrix : openfl.geom.Matrix;
	var ratios : Array<Float>;
	var spreadMethod : SpreadMethod;
	var type : GradientType;
	function new(?type : GradientType, ?colors : Array<UInt>, ?alphas : Array<Float>, ?ratios : Array<Float>, ?matrix : openfl.geom.Matrix, ?spreadMethod : SpreadMethod, ?interpolationMethod : InterpolationMethod, focalPointRatio : Float = 0) : Void;
}


#end
