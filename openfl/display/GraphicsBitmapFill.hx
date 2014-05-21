/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


@:final extern class GraphicsBitmapFill implements IGraphicsData  implements IGraphicsFill {
	var bitmapData : BitmapData;
	var matrix : openfl.geom.Matrix;
	var repeat : Bool;
	var smooth : Bool;
	function new(?bitmapData : BitmapData, ?matrix : openfl.geom.Matrix, repeat : Bool = true, smooth : Bool = false) : Void;
}


#end
