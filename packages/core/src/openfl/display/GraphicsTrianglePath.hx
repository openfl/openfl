package openfl.display;

#if !flash
import openfl._internal.renderer.GraphicsDataType;
import openfl.Vector;

/**
	Defines an ordered set of triangles that can be rendered using either
	(u,v) fill coordinates or a normal fill. Each triangle in the path is
	represented by three sets of (x, y) coordinates, each of which is one
	point of the triangle.
	The triangle vertices do not contain z coordinates and do not necessarily
	represent 3D faces. However a triangle path can be used to support the
	rendering of 3D geometry in a 2D space.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsTrianglePath implements IGraphicsData implements IGraphicsPath
{
	/**
		Specifies whether to render triangles that face in a given direction.
		Used to prevent the rendering of triangles that cannot be seen in the
		current view.
		Can be set to any value defined by the TriangleCulling class.
	**/
	public var culling(get, set):TriangleCulling;

	/**
		A Vector of integers or indexes, where every three indexes define a
		triangle. If the indexes parameter is null then every three vertices
		(six x,y pairs in the vertices Vector) defines a triangle. Otherwise
		each index refers to a vertex, which is a pair of numbers in the
		vertices Vector. For example `indexes[1]` refers to (`vertices[2]`,
		`vertices[3]`).
	**/
	public var indices(get, set):Vector<Int>;

	/**
		A Vector of normalized coordinates used to apply texture mapping. Each
		coordinate refers to a point on the bitmap used for the fill. There
		must be one UV or one UVT coordinate per vertex.
		In UV coordinates, (0,0) is the upper left of the bitmap, and (1,1) is
		the lower right of the bitmap.

		If the length of this vector is twice the length of the `vertices`
		vector then normalized coordinates are used without perspective
		correction.

		If the length of this vector is three times the length of the
		`vertices` vector then the third coordinate is interpreted as 't', the
		distance from the eye to the texture in eye space. This helps the
		rendering engine correctly apply perspective when mapping textures in
		3D.
	**/
	public var uvtData(get, set):Vector<Float>;

	/**
		A Vector of Numbers where each pair of numbers is treated as a point
		(an x, y pair).
	**/
	public var vertices(get, set):Vector<Float>;

	@:allow(openfl) @:noCompletion private var _:Any;

	/**
		Creates a new GraphicsTrianglePath object.

		@param	vertices	A Vector of Numbers where each pair of numbers is treated as a point (an x, y pair).
		Required.
		@param	indices	A Vector of integers or indexes, where every three indexes define a triangle.
		@param	uvtData	A Vector of normalized coordinates used to apply texture mapping.
		@param culling Specifies whether to render triangles that face in a
					   given direction. Used to prevent the rendering of
					   triangles that cannot be seen in the current view. Can
					   be set to any value defined by the TriangleCulling
					   class.
	**/
	public function new(vertices:Vector<Float> = null, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling = NONE)
	{
		_ = new _GraphicsTrianglePath(this, vertices, indices, uvtData, culling);
	}

	// Get & Set Methods

	@:noCompletion private function get_culling():TriangleCulling
	{
		return (_ : _GraphicsTrianglePath).culling;
	}

	@:noCompletion private function set_culling(value:TriangleCulling):TriangleCulling
	{
		return (_ : _GraphicsTrianglePath).culling = value;
	}

	@:noCompletion private function get_indices():Vector<Int>
	{
		return (_ : _GraphicsTrianglePath).indices;
	}

	@:noCompletion private function set_indices(value:Vector<Int>):Vector<Int>
	{
		return (_ : _GraphicsTrianglePath).indices = value;
	}

	@:noCompletion private function get_uvtData():Vector<Float>
	{
		return (_ : _GraphicsTrianglePath).uvtData;
	}

	@:noCompletion private function set_uvtData(value:Vector<Float>):Vector<Float>
	{
		return (_ : _GraphicsTrianglePath).uvtData = value;
	}

	@:noCompletion private function get_vertices():Vector<Float>
	{
		return (_ : _GraphicsTrianglePath).vertices;
	}

	@:noCompletion private function set_vertices(value:Vector<Float>):Vector<Float>
	{
		return (_ : _GraphicsTrianglePath).vertices = value;
	}
}
#else
typedef GraphicsTrianglePath = flash.display.GraphicsTrianglePath;
#end
