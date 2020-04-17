import GraphicsDataType from "../_internal/renderer/GraphicsDataType";
import IGraphicsData from "../display/IGraphicsData";
import IGraphicsPath from "../display/IGraphicsPath";
import Vector from "../Vector";

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
export default class GraphicsQuadPath implements IGraphicsData, IGraphicsPath
{
	/**
		A Vector containing optional index values to reference the data contained in
		`rects`. Each index is a rectangle index in the Vector, not an array index. If
		this parameter is omitted, each index from `rects` will be used in order.
	**/
	public indices: Vector<number>;

	/**
		A Vector containing rectangle coordinates in [ x0, y0, width0, height0, x1, y1 ... ]
		format.
	**/
	public rects: Vector<number>;

	/**
		A Vector containing optional transform data to adjust _x_, _y_, _a_, _b_, _c_ or _d_
		value for the resulting quadrilateral. A `transforms` Vector that is double the size
		of the draw count (the length of `indices`, or if omitted, the rectangle count in
		`rects`) will be treated as [ x, y, ... ] pairs. A `transforms` Vector that is four
		times the size of the draw count will be used as matrix [ a, b, c, d, ... ] values.
		A `transforms` object which is six times the draw count in size will use full matrix
		[ a, b, c, d, tx, ty, ... ] values per draw.
	**/
	public transforms: Vector<number>;

	protected __graphicsDataType: GraphicsDataType;

	/**
		Creates a new GraphicsTrianglePath object.

		@param	rects	A Vector containing rectangle coordinates in [ x0, y0, width0, height0, x1, y1 ... ]
		format.
		@param	indices	A Vector containing optional index values to reference the data contained in
		`rects`
		@param	transforms	A Vector containing optional transform data to adjust _x_, _y_, _a_, _b_, _c_ or _d_
		value for the resulting quadrilateral.
	**/
	public constructor(rects: Vector<number> = null, indices: Vector<number> = null, transforms: Vector<number> = null)
	{
		this.rects = rects;
		this.indices = indices;
		this.transforms = transforms;

		this.__graphicsDataType = GraphicsDataType.QUAD_PATH;
	}
}
