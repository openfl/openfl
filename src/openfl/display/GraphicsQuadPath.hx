package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
#end
import openfl.Vector;

/**
	Defines a set of quadrilaterals. This is similar to using GraphicsPath `drawRect`
	repeatedly, but each rectangle can use a transform value to rotate, scale or skew
	the result.

	Any type of fill can be used, but if the fill has a transform matrix
	that transform matrix is ignored.

	The optional `indices` parameter allows the use of either repeated
	rectangle geometry, or allows the use of a subset of a broader rectangle
	data Vector, such as Tileset `rectData`.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsQuadPath implements IGraphicsData implements IGraphicsPath
{
	/**
		A Vector containing optional index values to reference the data contained in
		`rects`. Each index is a rectangle index in the Vector, not an array index. If
		this parameter is omitted, each index from `rects` will be used in order.
	**/
	public var indices:Vector<Int>;

	/**
		A Vector containing rectangle coordinates in [ x0, y0, width0, height0, x1, y1 ... ]
		format.
	**/
	public var rects:Vector<Float>;

	/**
		A Vector containing optional transform data to adjust _x_, _y_, _a_, _b_, _c_ or _d_
		value for the resulting quadrilateral. A `transforms` Vector that is double the size
		of the draw count (the length of `indices`, or if omitted, the rectangle count in
		`rects`) will be treated as [ x, y, ... ] pairs. A `transforms` Vector that is four
		times the size of the draw count will be used as matrix [ a, b, c, d, ... ] values.
		A `transforms` object which is six times the draw count in size will use full matrix
		[ a, b, c, d, tx, ty, ... ] values per draw.
	**/
	public var transforms:Vector<Float>;

	#if !flash
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	#end

	/**
		Creates a new GraphicsTrianglePath object.

		@param	rects	A Vector containing rectangle coordinates in [ x0, y0, width0, height0, x1, y1 ... ]
		format.
		@param	indices	A Vector containing optional index values to reference the data contained in
		`rects`
		@param	transforms	A Vector containing optional transform data to adjust _x_, _y_, _a_, _b_, _c_ or _d_
		value for the resulting quadrilateral.
	**/
	public function new(rects:Vector<Float> = null, indices:Vector<Int> = null, transforms:Vector<Float> = null)
	{
		this.rects = rects;
		this.indices = indices;
		this.transforms = transforms;

		#if !flash
		__graphicsDataType = QUAD_PATH;
		#end
	}
}
