package openfl.display;

import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
	The Tile class is the base class for all objects that can be contained in a
	ITileContainer object. Use the Tilemap or TileContainer class to arrange the tile
	objects in the tile list. Tilemap or TileContainer objects can contain tile'
	objects, while other the Tile class is a "leaf" node that have only parents and
	siblings, no children.

	The Tile class supports basic functionality like the _x_ and _y_ position of an
	tile, as well as more advanced properties of a tile such as its transformation
	matrix.

	Tile objects render from a Tileset using either an `id` or a `rect` value, to
	reference either an existing rectangle within the Tileset, or a custom rectangle.

	Tile objects cannot be rendered on their own. In order to display a Tile object,
	it should be contained within a Tilemap instance.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class Tile
{
	/**
		Indicates the alpha transparency value of the object specified. Valid
		values are 0 (fully transparent) to 1 (fully opaque). The default value is 1.
		Tile objects with `alpha` set to 0 _are_ active, even though they are invisible.
	**/
	@:keep public var alpha(get, set):Float;

	/**
		A value from the BlendMode class that specifies which blend mode to use.

		This property is supported only when using hardware rendering or the Flash target.
	**/
	public var blendMode(get, set):BlendMode;

	/**
		A ColorTransform object containing values that universally adjust the
		colors in the display object.

		This property is supported only when using hardware rendering.
	**/
	@:beta public var colorTransform(get, set):ColorTransform;

	/**
		An additional field for custom user-data
	**/
	@SuppressWarnings("checkstyle:Dynamic") public var data(get, set):Dynamic;

	/**
		Indicates the height of the tile, in pixels. The height is
		calculated based on the bounds of the tile after local transformations.
		When you set the `height` property, the `scaleY` property
		is adjusted accordingly.
		If a tile has a height of zero, no change is applied
	**/
	@:keep #if (openfl < "9.0.0") @:dox(hide) #end public var height(get, set):Float;

	/**
		The ID of the tile to draw from the Tileset
	**/
	public var id(get, set):Int;

	/**
		A Matrix object containing values that alter the scaling, rotation, and
		translation of the tile object.

		If the `matrix` property is set to a value (not `null`), the `x`, `y`,
		`scaleX`, `scaleY` and the `rotation` values will be overwritten.
	**/
	public var matrix(get, set):Matrix;

	/**
		Modifies the origin x coordinate for this tile, which is the center value
		used when determining position, scale and rotation.
	**/
	@:keep public var originX(get, set):Float;

	/**
		Modifies the origin y coordinate for this tile, which is the center value
		used when determining position, scale and rotation.
	**/
	@:keep public var originY(get, set):Float;

	/**
		Indicates the ITileContainer object that contains this display
		object. Use the `parent` property to specify a relative path to
		tile objects that are above the current tile object in the tile
		list hierarchy.
	**/
	public var parent(get, never):TileContainer;

	/**
		The custom rectangle to draw from the Tileset
	**/
	public var rect(get, set):Rectangle;

	/**
		Indicates the rotation of the Tile instance, in degrees, from its
		original orientation. Values from 0 to 180 represent clockwise rotation;
		values from 0 to -180 represent counterclockwise rotation. Values outside
		this range are added to or subtracted from 360 to obtain a value within
		the range. For example, the statement `tile.rotation = 450`
		is the same as ` tile.rotation = 90`.
	**/
	@:keep public var rotation(get, set):Float;

	/**
		Indicates the horizontal scale (percentage) of the object as applied from
		the origin point. The default origin point is (0,0). 1.0
		equals 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	@:keep public var scaleX(get, set):Float;

	/**
		Indicates the vertical scale (percentage) of an object as applied from the
		origin point of the object. The default origin point is (0,0).
		1.0 is 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	@:keep public var scaleY(get, set):Float;

	/**
		Uses a custom Shader instance when rendering this tile.

		This property is only supported when using hardware rendering.
	**/
	@:beta public var shader(get, set):Shader;

	/**
		The Tileset that this Tile is rendered from.

		If `null`, this Tile will use the Tileset value of its parent.
	**/
	public var tileset(get, set):Tileset;

	/**
		Whether or not the tile object is visible.
	**/
	public var visible(get, set):Bool;

	/**
		Indicates the width of the tile, in pixels. The width is
		calculated based on the bounds of the tile after local transformations.
		When you set the `width` property, the `scaleX` property
		is adjusted accordingly.
		If a tile has a width of zero, no change is applied
	**/
	@:keep #if (openfl < "9.0.0") @:dox(hide) #end public var width(get, set):Float;

	/**
		Indicates the _x_ coordinate of the Tile instance relative
		to the local coordinates of the parent ITileContainer. If the
		object is inside a TileContainer that has transformations, it is
		in the local coordinate system of the enclosing TileContainer.
		Thus, for a TileContainer rotated 90° counterclockwise, the
		TileContainer's children inherit a coordinate system that is
		rotated 90° counterclockwise. The object's coordinates refer to the
		registration point position.
	**/
	@:keep public var x(get, set):Float;

	/**
		Indicates the _y_ coordinate of the Tile instance relative
		to the local coordinates of the parent ITileContainer. If the
		object is inside a TileContainer that has transformations, it is
		in the local coordinate system of the enclosing TileContainer.
		Thus, for a TileContainer rotated 90° counterclockwise, the
		TileContainer's children inherit a coordinate system that is
		rotated 90° counterclockwise. The object's coordinates refer to the
		registration point position.
	**/
	@:keep public var y(get, set):Float;

	@:allow(openfl) @:noCompletion private var _:Any;

	public function new(id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0)
	{
		if (_ == null)
		{
			_ = new _Tile(this, id, x, y, scaleX, scaleY, rotation, originX, originY);
		}
	}

	/**
		Duplicates an instance of a Tile subclass.

		@return A new Tile object that is identical to the original.
	**/
	public function clone():Tile
	{
		return (_ : _Tile).clone();
	}

	/**
		Gets you the bounding box of the Tile.
		It will find a tileset to know the original rect
		Then it will apply all the transformations from his parent.

		@param targetCoordinateSpace The tile that works as a coordinate system.
		@return Rectangle The bounding box. If no box found, this will return {0,0,0,0} rectangle instead of null.
	**/
	public function getBounds(targetCoordinateSpace:Tile):Rectangle
	{
		return (_ : _Tile).getBounds(targetCoordinateSpace);
	}

	/**
		Evaluates the bounding box of the tile to see if it overlaps or
		intersects with the bounding box of the `obj` tile.
		Both tiles must be under the same Tilemap for this to work.

		@param obj The tile to test against.
		@return `true` if the bounding boxes of the tiles
				intersect; `false` if not.
	**/
	public function hitTestTile(obj:Tile):Bool
	{
		return (_ : _Tile).hitTestTile(obj);
	}

	/**
		Calling the `invalidate()` method signals to have the current tile
		redrawn the next time the tile object is eligible to be rendered.

		Invalidation is handled automatically, but in some cases it is
		necessary to trigger it manually, such as changing the parameters
		of a Shader instance attached to this tile.
	**/
	public function invalidate():Void
	{
		(_ : _Tile).invalidate();
	}

	// Get & Set Methods

	@:keep @:noCompletion private function get_alpha():Float
	{
		return (_ : _Tile).alpha;
	}

	@:keep @:noCompletion private function set_alpha(value:Float):Float
	{
		return (_ : _Tile).alpha = value;
	}

	@:noCompletion private function get_blendMode():BlendMode
	{
		return (_ : _Tile).blendMode;
	}

	@:noCompletion private function set_blendMode(value:BlendMode):BlendMode
	{
		return (_ : _Tile).blendMode = value;
	}

	@:noCompletion private function get_colorTransform():ColorTransform
	{
		return (_ : _Tile).colorTransform;
	}

	@:noCompletion private function set_colorTransform(value:ColorTransform):ColorTransform
	{
		return (_ : _Tile).colorTransform = value;
	}

	@:noCompletion private function get_data():Dynamic
	{
		return (_ : _Tile).data;
	}

	@:noCompletion private function set_data(value:Dynamic):Dynamic
	{
		return (_ : _Tile).data = value;
	}

	@:keep @:noCompletion private function get_height():Float
	{
		return (_ : _Tile).height;
	}

	@:keep @:noCompletion private function set_height(value:Float):Float
	{
		return (_ : _Tile).height = value;
	}

	@:noCompletion private function get_id():Int
	{
		return (_ : _Tile).id;
	}

	@:noCompletion private function set_id(value:Int):Int
	{
		return (_ : _Tile).id = value;
	}

	@:noCompletion private function get_matrix():Matrix
	{
		return (_ : _Tile).matrix;
	}

	@:noCompletion private function set_matrix(value:Matrix):Matrix
	{
		return (_ : _Tile).matrix = value;
	}

	@:keep @:noCompletion private function get_originX():Float
	{
		return (_ : _Tile).originX;
	}

	@:keep @:noCompletion private function set_originX(value:Float):Float
	{
		return (_ : _Tile).originX = value;
	}

	@:keep @:noCompletion private function get_originY():Float
	{
		return (_ : _Tile).originY;
	}

	@:keep @:noCompletion private function set_originY(value:Float):Float
	{
		return (_ : _Tile).originY = value;
	}

	@:noCompletion private function get_parent():TileContainer
	{
		return (_ : _Tile).parent;
	}

	@:noCompletion private function get_rect():Rectangle
	{
		return (_ : _Tile).rect;
	}

	@:noCompletion private function set_rect(value:Rectangle):Rectangle
	{
		return (_ : _Tile).rect = value;
	}

	@:keep @:noCompletion private function get_rotation():Float
	{
		return (_ : _Tile).rotation;
	}

	@:keep @:noCompletion private function set_rotation(value:Float):Float
	{
		return (_ : _Tile).rotation = value;
	}

	@:keep @:noCompletion private function get_scaleX():Float
	{
		return (_ : _Tile).scaleX;
	}

	@:keep @:noCompletion private function set_scaleX(value:Float):Float
	{
		return (_ : _Tile).scaleX = value;
	}

	@:keep @:noCompletion private function get_scaleY():Float
	{
		return (_ : _Tile).scaleY;
	}

	@:keep @:noCompletion private function set_scaleY(value:Float):Float
	{
		return (_ : _Tile).scaleY = value;
	}

	@:noCompletion private function get_shader():Shader
	{
		return (_ : _Tile).shader;
	}

	@:noCompletion private function set_shader(value:Shader):Shader
	{
		return (_ : _Tile).shader = value;
	}

	@:noCompletion private function get_tileset():Tileset
	{
		return (_ : _Tile).tileset;
	}

	@:noCompletion private function set_tileset(value:Tileset):Tileset
	{
		return (_ : _Tile).tileset = value;
	}

	@:noCompletion private function get_visible():Bool
	{
		return (_ : _Tile).visible;
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		return (_ : _Tile).visible = value;
	}

	@:keep @:noCompletion private function get_width():Float
	{
		return (_ : _Tile).width;
	}

	@:keep @:noCompletion private function set_width(value:Float):Float
	{
		return (_ : _Tile).width = value;
	}

	@:keep @:noCompletion private function get_x():Float
	{
		return (_ : _Tile).x;
	}

	@:keep @:noCompletion private function set_x(value:Float):Float
	{
		return (_ : _Tile).x = value;
	}

	@:keep @:noCompletion private function get_y():Float
	{
		return (_ : _Tile).y;
	}

	@:keep @:noCompletion private function set_y(value:Float):Float
	{
		return (_ : _Tile).y = value;
	}
}
