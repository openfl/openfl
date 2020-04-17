import * as internal from "../_internal/utils/InternalAccess";
import BlendMode from "../display/BlendMode";
import ITileContainer from "../display/ITileContainer";
import Shader from "../display/Shader";
import Tileset from "../display/Tileset";
import ColorTransform from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";

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
export default class Tile
{
	/**
		An additional field for custom user-data
	**/
	public data: any;

	protected __alpha: number;
	protected __blendMode: BlendMode;
	protected __colorTransform: ColorTransform;
	protected __dirty: boolean;
	protected __id: number;
	protected __length: number;
	protected __matrix: Matrix;
	protected __originX: number;
	protected __originY: number;
	protected __parent: ITileContainer;
	protected __rect: Rectangle;
	protected __rotation: null | number;
	protected __rotationCosine: number;
	protected __rotationSine: number;
	protected __scaleX: null | number;
	protected __scaleY: null | number;
	protected __shader: Shader;
	protected __tileset: Tileset;
	protected __visible: boolean;

	public constructor(id: number = 0, x: number = 0, y: number = 0, scaleX: number = 1, scaleY: number = 1, rotation: number = 0, originX: number = 0, originY: number = 0)
	{
		this.__id = id;

		this.__matrix = new Matrix();
		if (x != 0) this.x = x;
		if (y != 0) this.y = y;
		if (scaleX != 1) this.scaleX = scaleX;
		if (scaleY != 1) this.scaleY = scaleY;
		if (rotation != 0) this.rotation = rotation;

		this.__dirty = true;
		this.__length = 0;
		this.__originX = originX;
		this.__originY = originY;
		this.__alpha = 1;
		this.__blendMode = null;
		this.__visible = true;
	}

	/**
		Duplicates an instance of a Tile subclass.

		@return A new Tile object that is identical to the original.
	**/
	public clone(): Tile
	{
		var tile = new Tile(this.__id);
		tile.__alpha = this.__alpha;
		tile.__blendMode = this.__blendMode;
		tile.__originX = this.__originX;
		tile.__originY = this.__originY;

		if (this.__rect != null) tile.__rect = this.__rect.clone();

		tile.matrix = this.__matrix.clone();
		tile.__shader = this.__shader;
		tile.tileset = this.__tileset;

		if (this.__colorTransform != null)
		{
			tile.__colorTransform = (<internal.ColorTransform><any>this.__colorTransform).__clone();
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
	public getBounds(targetCoordinateSpace: Tile): Rectangle
	{
		var result: Rectangle = new Rectangle();

		this.__findTileRect(result);

		// Copied from DisplayObject. Create the translation matrix.
		var matrix = (<internal.Matrix><any>Matrix).__pool.get();

		if (targetCoordinateSpace != null && targetCoordinateSpace != this)
		{
			matrix.copyFrom(this.__getWorldTransform()); // ? Is this correct?
			var targetMatrix = (<internal.Matrix><any>Matrix).__pool.get();

			targetMatrix.copyFrom(targetCoordinateSpace.__getWorldTransform());
			targetMatrix.invert();

			matrix.concat(targetMatrix);

			(<internal.Matrix><any>Matrix).__pool.release(targetMatrix);
		}
		else
		{
			matrix.identity();
		}

		this.__getBounds(result, matrix);

		(<internal.Matrix><any>Matrix).__pool.release(matrix);

		return result;
	}

	protected __getBounds(result: Rectangle, matrix: Matrix): void
	{
		(<internal.Rectangle><any>result).__transform(result, matrix);
	}

	/**
		Evaluates the bounding box of the tile to see if it overlaps or
		intersects with the bounding box of the `obj` tile.
		Both tiles must be under the same Tilemap for this to work.

		@param obj The tile to test against.
		@return `true` if the bounding boxes of the tiles
				intersect; `false` if not.
	**/
	public hitTestTile(obj: Tile): boolean
	{
		if (obj != null && obj.parent != null && parent != null)
		{
			var currentBounds = this.getBounds(this);
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
	public invalidate(): void
	{
		this.__setRenderDirty();
	}

	protected __findTileRect(result: Rectangle): void
	{
		if (this.tileset == null)
		{
			if (parent != null)
			{
				var parentTileset: Tileset = (<internal.Tile><any>parent).__findTileset();
				if (parentTileset == null)
				{
					result.setTo(0, 0, 0, 0);
				}
				else
				{
					var rect = parentTileset.getRect(this.id);
					if (rect == null)
					{
						result.setTo(0, 0, 0, 0);
					}
					else
					{
						result.copyFrom(rect);
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
			result.copyFrom(this.tileset.getRect(this.id));
		}

		result.x = 0;
		result.y = 0;
	}

	protected __findTileset(): Tileset
	{
		// TODO: Avoid Std.is

		if (this.tileset != null) return this.tileset;
		if (this.parent == null) return null;
		return (<internal.Tile><any>this.parent).__findTileset();
	}

	/**
		Climbs all the way up to get a transformation matrix
		adds his own matrix and then returns it.
		@return Matrix The final transformation matrix from stage to this point.
	**/
	protected __getWorldTransform(): Matrix
	{
		var retval = this.matrix.clone();

		if (parent != null)
		{
			retval.concat((<internal.Tile><any>this.parent).__getWorldTransform());
		}

		return retval;
	}

	protected __setRenderDirty(): void
	{
		if (!this.__dirty)
		{
			this.__dirty = true;

			if (parent != null)
			{
				(<internal.Tile><any>parent).__setRenderDirty();
			}
		}
	}

	// Get & Set Methods

	/**
		Indicates the alpha transparency value of the object specified. Valid
		values are 0 (fully transparent) to 1 (fully opaque). The default value is 1.
		Tile objects with `alpha` set to 0 _are_ active, even though they are invisible.
	**/
	public get alpha(): number
	{
		return this.__alpha;
	}

	public set alpha(value: number)
	{
		if (value != this.__alpha)
		{
			this.__alpha = value;
			this.__setRenderDirty();
		}
	}

	/**
		A value from the BlendMode class that specifies which blend mode to use.

		This property is supported only when using hardware rendering or the Flash target.
	**/
	public get blendMode(): BlendMode
	{
		return this.__blendMode;
	}

	public set blendMode(value: BlendMode)
	{
		if (value != this.__blendMode)
		{
			this.__blendMode = value;
			this.__setRenderDirty();
		}
	}

	/**
		A ColorTransform object containing values that universally adjust the
		colors in the display object.

		This property is supported only when using hardware rendering.
	**/
	public get colorTransform(): ColorTransform
	{
		return this.__colorTransform;
	}

	public set colorTransform(value: ColorTransform)
	{
		if (value != this.__colorTransform)
		{
			this.__colorTransform = value;
			this.__setRenderDirty();
		}
	}

	/**
		Indicates the height of the tile, in pixels. The height is
		calculated based on the bounds of the tile after local transformations.
		When you set the `height` property, the `scaleY` property
		is adjusted accordingly.
		If a tile has a height of zero, no change is applied
	**/
	public get height(): number
	{
		var result: Rectangle = (<internal.Rectangle><any>Rectangle).__pool.get();

		this.__findTileRect(result);

		this.__getBounds(result, this.matrix);
		var h = result.height;
		(<internal.Rectangle><any>Rectangle).__pool.release(result);
		return h;
	}

	public set height(value: number)
	{
		var result: Rectangle = (<internal.Rectangle><any>Rectangle).__pool.get();

		this.__findTileRect(result);
		if (result.height != 0)
		{
			this.scaleY = value / result.height;
		}
		(<internal.Rectangle><any>Rectangle).__pool.release(result);
	}

	/**
		The ID of the tile to draw from the Tileset
	**/
	public get id(): number
	{
		return this.__id;
	}

	public set id(value: number)
	{
		if (value != this.__id)
		{
			this.__id = value;
			this.__setRenderDirty();
		}
	}

	/**
		A Matrix object containing values that alter the scaling, rotation, and
		translation of the tile object.

		If the `matrix` property is set to a value (not `null`), the `x`, `y`,
		`scaleX`, `scaleY` and the `rotation` values will be overwritten.
	**/
	public get matrix(): Matrix
	{
		return this.__matrix;
	}

	public set matrix(value: Matrix)
	{
		if (value != this.__matrix)
		{
			this.__rotation = null;
			this.__scaleX = null;
			this.__scaleY = null;
			this.__matrix = value;
			this.__setRenderDirty();
		}
	}

	/**
		Modifies the origin x coordinate for this tile, which is the center value
		used when determining position, scale and rotation.
	**/
	public get originX(): number
	{
		return this.__originX;
	}

	public set originX(value: number)
	{
		if (value != this.__originX)
		{
			this.__originX = value;
			this.__setRenderDirty();
		}
	}

	/**
		Modifies the origin y coordinate for this tile, which is the center value
		used when determining position, scale and rotation.
	**/
	public get originY(): number
	{
		return this.__originY;
	}

	public set originY(value: number)
	{
		if (value != this.__originY)
		{
			this.__originY = value;
			this.__setRenderDirty();
		}
	}

	/**
		Indicates the ITileContainer object that contains this display
		object. Use the `parent` property to specify a relative path to
		tile objects that are above the current tile object in the tile
		list hierarchy.
	**/
	public get parent(): ITileContainer
	{
		return this.__parent;
	}

	/**
		The custom rectangle to draw from the Tileset
	**/
	public get rect(): Rectangle
	{
		return this.__rect;
	}

	public set rect(value: Rectangle)
	{
		if (value != this.__rect)
		{
			this.__rect = value;
			this.__setRenderDirty();
		}
	}

	/**
		Indicates the rotation of the Tile instance, in degrees, from its
		original orientation. Values from 0 to 180 represent clockwise rotation;
		values from 0 to -180 represent counterclockwise rotation. Values outside
		this range are added to or subtracted from 360 to obtain a value within
		the range. For example, the statement `tile.rotation = 450`
		is the same as ` tile.rotation = 90`.
	**/
	public get rotation(): number
	{
		if (this.__rotation == null)
		{
			if (this.__matrix.b == 0 && this.__matrix.c == 0)
			{
				this.__rotation = 0;
				this.__rotationSine = 0;
				this.__rotationCosine = 1;
			}
			else
			{
				var radians = Math.atan2(this.__matrix.d, this.__matrix.c) - (Math.PI / 2);

				this.__rotation = radians * (180 / Math.PI);
				this.__rotationSine = Math.sin(radians);
				this.__rotationCosine = Math.cos(radians);
			}
		}

		return this.__rotation;
	}

	public set rotation(value: number)
	{
		if (value != this.__rotation)
		{
			this.__rotation = value;
			var radians = value * (Math.PI / 180);
			this.__rotationSine = Math.sin(radians);
			this.__rotationCosine = Math.cos(radians);

			var __scaleX = this.scaleX;
			var __scaleY = this.scaleY;

			this.__matrix.a = this.__rotationCosine * __scaleX;
			this.__matrix.b = this.__rotationSine * __scaleX;
			this.__matrix.c = -this.__rotationSine * __scaleY;
			this.__matrix.d = this.__rotationCosine * __scaleY;

			this.__setRenderDirty();
		}
	}

	/**
		Indicates the horizontal scale (percentage) of the object as applied from
		the origin point. The default origin point is (0,0). 1.0
		equals 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	public get scaleX(): number
	{
		if (this.__scaleX == null)
		{
			if (this.matrix.b == 0)
			{
				this.__scaleX = this.__matrix.a;
			}
			else
			{
				this.__scaleX = Math.sqrt(this.__matrix.a * this.__matrix.a + this.__matrix.b * this.__matrix.b);
			}
		}

		return this.__scaleX;
	}

	public set scaleX(value: number)
	{
		if (value != this.__scaleX)
		{
			this.__scaleX = value;

			if (this.__matrix.b == 0)
			{
				this.__matrix.a = value;
			}
			else
			{
				var rotation = this.rotation;

				var a = this.__rotationCosine * value;
				var b = this.__rotationSine * value;

				this.__matrix.a = a;
				this.__matrix.b = b;
			}

			this.__setRenderDirty();
		}
	}

	/**
		Indicates the vertical scale (percentage) of an object as applied from the
		origin point of the object. The default origin point is (0,0).
		1.0 is 100% scale.

		Scaling the local coordinate system changes the `x` and
		`y` property values, which are defined in whole pixels.
	**/
	public get scaleY(): number
	{
		if (this.__scaleY == null)
		{
			if (this.__matrix.c == 0)
			{
				this.__scaleY = this.matrix.d;
			}
			else
			{
				this.__scaleY = Math.sqrt(this.__matrix.c * this.__matrix.c + this.__matrix.d * this.__matrix.d);
			}
		}

		return this.__scaleY;
	}

	public set scaleY(value: number)
	{
		if (value != this.__scaleY)
		{
			this.__scaleY = value;

			if (this.__matrix.c == 0)
			{
				this.__matrix.d = value;
			}
			else
			{
				var rotation = this.rotation;

				var c = -this.__rotationSine * value;
				var d = this.__rotationCosine * value;

				this.__matrix.c = c;
				this.__matrix.d = d;
			}

			this.__setRenderDirty();
		}
	}

	/**
		Uses a custom Shader instance when rendering this tile.

		This property is only supported when using hardware rendering.
	**/
	public get shader(): Shader
	{
		return this.__shader;
	}

	public set shader(value: Shader)
	{
		if (value != this.__shader)
		{
			this.__shader = value;
			this.__setRenderDirty();
		}
	}

	/**
		The Tileset that this Tile is rendered from.

		If `null`, this Tile will use the Tileset value of its parent.
	**/
	public get tileset(): Tileset
	{
		return this.__tileset;
	}

	public set tileset(value: Tileset)
	{
		if (value != this.__tileset)
		{
			this.__tileset = value;
			this.__setRenderDirty();
		}
	}

	/**
		Whether or not the tile object is visible.
	**/
	public get visible(): boolean
	{
		return this.__visible;
	}

	public set visible(value: boolean)
	{
		if (value != this.__visible)
		{
			this.__visible = value;
			this.__setRenderDirty();
		}
	}

	/**
		Indicates the width of the tile, in pixels. The width is
		calculated based on the bounds of the tile after local transformations.
		When you set the `width` property, the `scaleX` property
		is adjusted accordingly.
		If a tile has a width of zero, no change is applied
	**/
	public get width(): number
	{
		// TODO how does pooling work with flash target?
		var result: Rectangle = (<internal.Rectangle><any>Rectangle).__pool.get();

		this.__findTileRect(result);

		this.__getBounds(result, this.matrix);
		var w = result.width;
		(<internal.Rectangle><any>Rectangle).__pool.release(result);
		return w;
	}

	public set width(value: number)
	{
		var result: Rectangle = (<internal.Rectangle><any>Rectangle).__pool.get();

		this.__findTileRect(result);
		if (result.width != 0)
		{
			this.scaleX = value / result.width;
		}
		(<internal.Rectangle><any>Rectangle).__pool.release(result);
	}

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
	public get x(): number
	{
		return this.__matrix.tx;
	}

	public set x(value: number)
	{
		if (value != this.__matrix.tx)
		{
			this.__matrix.tx = value;
			this.__setRenderDirty();
		}
	}

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
	public get y(): number
	{
		return this.__matrix.ty;
	}

	public set y(value: number)
	{
		if (value != this.__matrix.ty)
		{
			this.__matrix.ty = value;
			this.__setRenderDirty();
		}
	}
}
