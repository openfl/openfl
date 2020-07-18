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
	@SuppressWarnings("checkstyle:Dynamic") public var data:Dynamic;

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
	public var parent(default, null):TileContainer;

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

	@:noCompletion private var __alpha:Float;
	@:noCompletion private var __blendMode:BlendMode;
	@:noCompletion private var __colorTransform:ColorTransform;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __id:Int;
	@:noCompletion private var __length:Int;
	@:noCompletion private var __matrix:Matrix;
	@:noCompletion private var __originX:Float;
	@:noCompletion private var __originY:Float;
	@:noCompletion private var __rect:Rectangle;
	@:noCompletion private var __rotation:Null<Float>;
	@:noCompletion private var __rotationCosine:Float;
	@:noCompletion private var __rotationSine:Float;
	@:noCompletion private var __scaleX:Null<Float>;
	@:noCompletion private var __scaleY:Null<Float>;
	@:noCompletion private var __shader:Shader;
	@:noCompletion private var __tileset:Tileset;
	@:noCompletion private var __visible:Bool;
	#if flash
	@:noCompletion private var __tempMatrix = new Matrix();
	@:noCompletion private var __tempRectangle = new Rectangle();
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Tile.prototype, {
			"alpha": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_alpha (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_alpha (v); }")
			},
			"blendMode": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blendMode (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blendMode (v); }")
			},
			"colorTransform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_colorTransform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_colorTransform (v); }")
			},
			"id": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_id (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_id (v); }")
			},
			"matrix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }")
			},
			"originX": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_originX (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_originX (v); }")
			},
			"originY": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_originY (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_originY (v); }")
			},
			"rect": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_rect (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_rect (v); }")
			},
			"rotation": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_rotation (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_rotation (v); }")
			},
			"scaleX": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scaleX (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scaleX (v); }")
			},
			"scaleY": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_scaleY (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_scaleY (v); }")
			},
			"shader": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_shader (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_shader (v); }")
			},
			"tileset": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_tileset (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_tileset (v); }")
			},
			"visible": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_visible (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_visible (v); }")
			},
			"x": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_x (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_x (v); }")
			},
			"y": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_y (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_y (v); }")
			},
		});
	}
	#end

	public function new(id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0)
	{
		__id = id;

		__matrix = new Matrix();
		if (x != 0) this.x = x;
		if (y != 0) this.y = y;
		if (scaleX != 1) this.scaleX = scaleX;
		if (scaleY != 1) this.scaleY = scaleY;
		if (rotation != 0) this.rotation = rotation;

		__dirty = true;
		__length = 0;
		__originX = originX;
		__originY = originY;
		__alpha = 1;
		__blendMode = null;
		__visible = true;
	}

	/**
		Duplicates an instance of a Tile subclass.

		@return A new Tile object that is identical to the original.
	**/
	public function clone():Tile
	{
		var tile = new Tile(__id);
		tile.__alpha = __alpha;
		tile.__blendMode = __blendMode;
		tile.__originX = __originX;
		tile.__originY = __originY;

		if (__rect != null) tile.__rect = __rect.clone();

		tile.matrix = __matrix.clone();
		tile.__shader = __shader;
		tile.tileset = __tileset;

		if (__colorTransform != null)
		{
			#if flash
			tile.__colorTransform = new ColorTransform(__colorTransform.redMultiplier, __colorTransform.greenMultiplier, __colorTransform.blueMultiplier,
				__colorTransform.alphaMultiplier, __colorTransform.redOffset, __colorTransform.greenOffset, __colorTransform.blueOffset,
				__colorTransform.alphaOffset);
			#else
			tile.__colorTransform = __colorTransform.__clone();
			#end
		}

		return tile;
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
		var result:Rectangle = new Rectangle();

		__findTileRect(result);

		// Copied from DisplayObject. Create the translation matrix.
		var matrix = #if flash __tempMatrix #else Matrix.__pool.get() #end;

		if (targetCoordinateSpace != null && targetCoordinateSpace != this)
		{
			matrix.copyFrom(__getWorldTransform()); // ? Is this correct?
			var targetMatrix = #if flash new Matrix() #else Matrix.__pool.get() #end;

			targetMatrix.copyFrom(targetCoordinateSpace.__getWorldTransform());
			targetMatrix.invert();

			matrix.concat(targetMatrix);

			#if !flash
			Matrix.__pool.release(targetMatrix);
			#end
		}
		else
		{
			matrix.identity();
		}

		__getBounds(result, matrix);

		#if !flash
		Matrix.__pool.release(matrix);
		#end

		return result;
	}

	@:noCompletion private function __getBounds(result:Rectangle, matrix:Matrix):Void
	{
		#if flash
		function __transform(rect:Rectangle, m:Matrix):Void
		{
			var tx0 = m.a * rect.x + m.c * rect.y;
			var tx1 = tx0;
			var ty0 = m.b * rect.x + m.d * rect.y;
			var ty1 = ty0;

			var tx = m.a * (rect.x + rect.width) + m.c * rect.y;
			var ty = m.b * (rect.x + rect.width) + m.d * rect.y;

			if (tx < tx0) tx0 = tx;
			if (ty < ty0) ty0 = ty;
			if (tx > tx1) tx1 = tx;
			if (ty > ty1) ty1 = ty;

			tx = m.a * (rect.x + rect.width) + m.c * (rect.y + rect.height);
			ty = m.b * (rect.x + rect.width) + m.d * (rect.y + rect.height);

			if (tx < tx0) tx0 = tx;
			if (ty < ty0) ty0 = ty;
			if (tx > tx1) tx1 = tx;
			if (ty > ty1) ty1 = ty;

			tx = m.a * rect.x + m.c * (rect.y + rect.height);
			ty = m.b * rect.x + m.d * (rect.y + rect.height);

			if (tx < tx0) tx0 = tx;
			if (ty < ty0) ty0 = ty;
			if (tx > tx1) tx1 = tx;
			if (ty > ty1) ty1 = ty;

			rect.setTo(tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
		}
		__transform(result, matrix);
		#else
		result.__transform(result, matrix);
		#end
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
		if (obj != null && obj.parent != null && parent != null)
		{
			var currentBounds = getBounds(this);
			var targetBounds = obj.getBounds(this);
			return currentBounds.intersects(targetBounds);
		}

		return false;
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
		__setRenderDirty();
	}

	@:noCompletion private function __findTileRect(result:Rectangle):Void
	{
		if (tileset == null)
		{
			if (parent != null)
			{
				var parentTileset:Tileset = parent.__findTileset();
				if (parentTileset == null)
				{
					result.setTo(0, 0, 0, 0);
				}
				else
				{
					// ? Is this a way to call getRect once without making extra vars? I don't fully grasp haxe pattern matching. Could be done with an if?
					switch parentTileset.getRect(id)
					{
						case null:
							result.setTo(0, 0, 0, 0);
						case not_null:
							result.copyFrom(not_null);
					}
				}
			}
			else
			{
				result.setTo(0, 0, 0, 0);
			}
		}
		else
		{
			result.copyFrom(tileset.getRect(id));
		}

		result.x = 0;
		result.y = 0;
	}

	@:noCompletion private function __findTileset():Tileset
	{
		// TODO: Avoid Std.is

		if (tileset != null) return tileset;
		if ((parent is Tilemap)) return parent.tileset;
		if (parent == null) return null;
		return parent.__findTileset();
	}

	/**
		Climbs all the way up to get a transformation matrix
		adds his own matrix and then returns it.
		@return Matrix The final transformation matrix from stage to this point.
	**/
	@:noCompletion private function __getWorldTransform():Matrix
	{
		var retval = matrix.clone();

		if (parent != null)
		{
			retval.concat(parent.__getWorldTransform());
		}

		return retval;
	}

	@:noCompletion private function __setRenderDirty():Void
	{
		#if !flash
		if (!__dirty)
		{
			__dirty = true;

			if (parent != null)
			{
				parent.__setRenderDirty();
			}
		}
		#end
	}

	// Get & Set Methods
	@:keep @:noCompletion private function get_alpha():Float
	{
		return __alpha;
	}

	@:keep @:noCompletion private function set_alpha(value:Float):Float
	{
		if (value != __alpha)
		{
			__alpha = value;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_blendMode():BlendMode
	{
		return __blendMode;
	}

	@:noCompletion private function set_blendMode(value:BlendMode):BlendMode
	{
		if (value != __blendMode)
		{
			__blendMode = value;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_colorTransform():ColorTransform
	{
		return __colorTransform;
	}

	@:noCompletion private function set_colorTransform(value:ColorTransform):ColorTransform
	{
		if (value != __colorTransform)
		{
			__colorTransform = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_height():Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;

		__findTileRect(result);

		__getBounds(result, matrix);
		var h = result.height;
		#if !flash
		Rectangle.__pool.release(result);
		#end
		return h;
	}

	@:keep @:noCompletion private function set_height(value:Float):Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;

		__findTileRect(result);
		if (result.height != 0)
		{
			scaleY = value / result.height;
		}
		#if !flash
		Rectangle.__pool.release(result);
		#end
		return value;
	}

	@:noCompletion private function get_id():Int
	{
		return __id;
	}

	@:noCompletion private function set_id(value:Int):Int
	{
		if (value != __id)
		{
			__id = value;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_matrix():Matrix
	{
		return __matrix;
	}

	@:noCompletion private function set_matrix(value:Matrix):Matrix
	{
		if (value != __matrix)
		{
			__rotation = null;
			__scaleX = null;
			__scaleY = null;
			__matrix = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_originX():Float
	{
		return __originX;
	}

	@:keep @:noCompletion private function set_originX(value:Float):Float
	{
		if (value != __originX)
		{
			__originX = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_originY():Float
	{
		return __originY;
	}

	@:keep @:noCompletion private function set_originY(value:Float):Float
	{
		if (value != __originY)
		{
			__originY = value;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_rect():Rectangle
	{
		return __rect;
	}

	@:noCompletion private function set_rect(value:Rectangle):Rectangle
	{
		if (value != __rect)
		{
			__rect = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_rotation():Float
	{
		if (__rotation == null)
		{
			if (__matrix.b == 0 && __matrix.c == 0)
			{
				__rotation = 0;
				__rotationSine = 0;
				__rotationCosine = 1;
			}
			else
			{
				var radians = Math.atan2(__matrix.d, __matrix.c) - (Math.PI / 2);

				__rotation = radians * (180 / Math.PI);
				__rotationSine = Math.sin(radians);
				__rotationCosine = Math.cos(radians);
			}
		}

		return __rotation;
	}

	@:keep @:noCompletion private function set_rotation(value:Float):Float
	{
		if (value != __rotation)
		{
			__rotation = value;
			var radians = value * (Math.PI / 180);
			__rotationSine = Math.sin(radians);
			__rotationCosine = Math.cos(radians);

			var __scaleX = this.scaleX;
			var __scaleY = this.scaleY;

			__matrix.a = __rotationCosine * __scaleX;
			__matrix.b = __rotationSine * __scaleX;
			__matrix.c = -__rotationSine * __scaleY;
			__matrix.d = __rotationCosine * __scaleY;

			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_scaleX():Float
	{
		if (__scaleX == null)
		{
			if (matrix.b == 0)
			{
				__scaleX = __matrix.a;
			}
			else
			{
				__scaleX = Math.sqrt(__matrix.a * __matrix.a + __matrix.b * __matrix.b);
			}
		}

		return __scaleX;
	}

	@:keep @:noCompletion private function set_scaleX(value:Float):Float
	{
		if (value != __scaleX)
		{
			__scaleX = value;

			if (__matrix.b == 0)
			{
				__matrix.a = value;
			}
			else
			{
				var rotation = this.rotation;

				var a = __rotationCosine * value;
				var b = __rotationSine * value;

				__matrix.a = a;
				__matrix.b = b;
			}

			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_scaleY():Float
	{
		if (__scaleY == null)
		{
			if (__matrix.c == 0)
			{
				__scaleY = matrix.d;
			}
			else
			{
				__scaleY = Math.sqrt(__matrix.c * __matrix.c + __matrix.d * __matrix.d);
			}
		}

		return __scaleY;
	}

	@:keep @:noCompletion private function set_scaleY(value:Float):Float
	{
		if (value != __scaleY)
		{
			__scaleY = value;

			if (__matrix.c == 0)
			{
				__matrix.d = value;
			}
			else
			{
				var rotation = this.rotation;

				var c = -__rotationSine * value;
				var d = __rotationCosine * value;

				__matrix.c = c;
				__matrix.d = d;
			}

			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_shader():Shader
	{
		return __shader;
	}

	@:noCompletion private function set_shader(value:Shader):Shader
	{
		if (value != __shader)
		{
			__shader = value;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_tileset():Tileset
	{
		return __tileset;
	}

	@:noCompletion private function set_tileset(value:Tileset):Tileset
	{
		if (value != __tileset)
		{
			__tileset = value;
			__setRenderDirty();
		}

		return value;
	}

	@:noCompletion private function get_visible():Bool
	{
		return __visible;
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		if (value != __visible)
		{
			__visible = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_width():Float
	{
		// TODO how does pooling work with flash target?
		var result:Rectangle = #if flash new Rectangle() #else Rectangle.__pool.get() #end;

		__findTileRect(result);

		__getBounds(result, matrix);
		var w = result.width;
		#if !flash
		Rectangle.__pool.release(result);
		#end
		return w;
	}

	@:keep @:noCompletion private function set_width(value:Float):Float
	{
		var result:Rectangle = #if flash __tempRectangle #else Rectangle.__pool.get() #end;

		__findTileRect(result);
		if (result.width != 0)
		{
			scaleX = value / result.width;
		}
		#if !flash
		Rectangle.__pool.release(result);
		#end
		return value;
	}

	@:keep @:noCompletion private function get_x():Float
	{
		return __matrix.tx;
	}

	@:keep @:noCompletion private function set_x(value:Float):Float
	{
		if (value != __matrix.tx)
		{
			__matrix.tx = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep @:noCompletion private function get_y():Float
	{
		return __matrix.ty;
	}

	@:keep @:noCompletion private function set_y(value:Float):Float
	{
		if (value != __matrix.ty)
		{
			__matrix.ty = value;
			__setRenderDirty();
		}

		return value;
	}
}
