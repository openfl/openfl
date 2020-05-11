package openfl.display;

import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:noCompletion
class _Tile
{
	@:keep public var alpha(get, set):Float;
	public var blendMode(get, set):BlendMode;
	@:beta public var colorTransform(get, set):ColorTransform;
	@SuppressWarnings("checkstyle:Dynamic") public var data:Dynamic;
	@:keep #if (openfl < "9.0.0") @:dox(hide) #end public var height(get, set):Float;
	public var id(get, set):Int;
	public var matrix(get, set):Matrix;
	@:keep public var originX(get, set):Float;
	@:keep public var originY(get, set):Float;
	public var parent:TileContainer;
	public var rect(get, set):Rectangle;
	@:keep public var rotation(get, set):Float;
	@:keep public var scaleX(get, set):Float;
	@:keep public var scaleY(get, set):Float;
	@:beta public var shader(get, set):Shader;
	public var tileset(get, set):Tileset;
	public var visible(get, set):Bool;
	@:keep #if (openfl < "9.0.0") @:dox(hide) #end public var width(get, set):Float;
	@:keep public var x(get, set):Float;
	@:keep public var y(get, set):Float;

	public var __alpha:Float;
	public var __blendMode:BlendMode;
	public var __colorTransform:ColorTransform;
	public var __dirty:Bool;
	public var __id:Int;
	public var __length:Int;
	public var __matrix:Matrix;
	public var __originX:Float;
	public var __originY:Float;
	public var __rect:Rectangle;
	public var __rotation:Null<Float>;
	public var __rotationCosine:Float;
	public var __rotationSine:Float;
	public var __scaleX:Null<Float>;
	public var __scaleY:Null<Float>;
	public var __shader:Shader;
	public var __tileset:Tileset;
	public var __visible:Bool;
	#if flash
	public var __tempMatrix = new Matrix();
	public var __tempRectangle = new Rectangle();
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

	public function clone():Tile
	{
		var tile = new Tile(__id);
		tile._.__alpha = __alpha;
		tile._.__blendMode = __blendMode;
		tile._.__originX = __originX;
		tile._.__originY = __originY;

		if (__rect != null) tile._.__rect = __rect.clone();

		tile.matrix = __matrix.clone();
		tile._.__shader = __shader;
		tile.tileset = __tileset;

		if (__colorTransform != null)
		{
			#if flash
			tile._.__colorTransform = new ColorTransform(__colorTransform.redMultiplier, __colorTransform.greenMultiplier, __colorTransform.blueMultiplier,
				__colorTransform.alphaMultiplier, __colorTransform.redOffset, __colorTransform.greenOffset, __colorTransform.blueOffset,
				__colorTransform.alphaOffset);
			#else
			tile._.__colorTransform = __colorTransform._.__clone();
			#end
		}

		return tile;
	}

	public function getBounds(targetCoordinateSpace:Tile):Rectangle
	{
		var result:Rectangle = new Rectangle();

		__findTileRect(result);

		// Copied from DisplayObject. Create the translation matrix.
		var matrix = #if flash __tempMatrix #else _Matrix.__pool.get() #end;

		if (targetCoordinateSpace != null && targetCoordinateSpace != this)
		{
			matrix.copyFrom(__getWorldTransform()); // ? Is this correct?
			var targetMatrix = #if flash new Matrix() #else _Matrix.__pool.get() #end;

			targetMatrix.copyFrom(targetCoordinateSpace._.__getWorldTransform());
			targetMatrix.invert();

			matrix.concat(targetMatrix);

			#if !flash
			_Matrix.__pool.release(targetMatrix);
			#end
		}
		else
		{
			matrix.identity();
		}

		__getBounds(result, matrix);

		#if !flash
		_Matrix.__pool.release(matrix);
		#end

		return result;
	}

	public function __getBounds(result:Rectangle, matrix:Matrix):Void
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
		result._.__transform(result, matrix);
		#end
	}

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

	public function invalidate():Void
	{
		__setRenderDirty();
	}

	public function __findTileRect(result:Rectangle):Void
	{
		if (tileset == null)
		{
			if (parent != null)
			{
				var parentTileset:Tileset = parent._.__findTileset();
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

	public function __findTileset():Tileset
	{
		// TODO: Avoid Std.is

		if (tileset != null) return tileset;
		if (Std.is(parent, Tilemap)) return parent.tileset;
		if (parent == null) return null;
		return parent._.__findTileset();
	}

	public function __getWorldTransform():Matrix
	{
		var retval = matrix.clone();

		if (parent != null)
		{
			retval.concat(parent._.__getWorldTransform());
		}

		return retval;
	}

	public function __setRenderDirty():Void
	{
		#if !flash
		if (!__dirty)
		{
			__dirty = true;

			if (parent != null)
			{
				parent._.__setRenderDirty();
			}
		}
		#end
	}

	// Get & Set Methods

	@:keep private function get_alpha():Float
	{
		return __alpha;
	}

	@:keep private function set_alpha(value:Float):Float
	{
		if (value != __alpha)
		{
			__alpha = value;
			__setRenderDirty();
		}

		return value;
	}

	private function get_blendMode():BlendMode
	{
		return __blendMode;
	}

	private function set_blendMode(value:BlendMode):BlendMode
	{
		if (value != __blendMode)
		{
			__blendMode = value;
			__setRenderDirty();
		}

		return value;
	}

	private function get_colorTransform():ColorTransform
	{
		return __colorTransform;
	}

	private function set_colorTransform(value:ColorTransform):ColorTransform
	{
		if (value != __colorTransform)
		{
			__colorTransform = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep private function get_height():Float
	{
		var result:Rectangle = #if flash __tempRectangle #else _Rectangle.__pool.get() #end;

		__findTileRect(result);

		__getBounds(result, matrix);
		var h = result.height;
		#if !flash
		_Rectangle.__pool.release(result);
		#end
		return h;
	}

	@:keep private function set_height(value:Float):Float
	{
		var result:Rectangle = #if flash __tempRectangle #else _Rectangle.__pool.get() #end;

		__findTileRect(result);
		if (result.height != 0)
		{
			scaleY = value / result.height;
		}
		#if !flash
		_Rectangle.__pool.release(result);
		#end
		return value;
	}

	private function get_id():Int
	{
		return __id;
	}

	private function set_id(value:Int):Int
	{
		if (value != __id)
		{
			__id = value;
			__setRenderDirty();
		}

		return value;
	}

	private function get_matrix():Matrix
	{
		return __matrix;
	}

	private function set_matrix(value:Matrix):Matrix
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

	@:keep private function get_originX():Float
	{
		return __originX;
	}

	@:keep private function set_originX(value:Float):Float
	{
		if (value != __originX)
		{
			__originX = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep private function get_originY():Float
	{
		return __originY;
	}

	@:keep private function set_originY(value:Float):Float
	{
		if (value != __originY)
		{
			__originY = value;
			__setRenderDirty();
		}

		return value;
	}

	private function get_rect():Rectangle
	{
		return __rect;
	}

	private function set_rect(value:Rectangle):Rectangle
	{
		if (value != __rect)
		{
			__rect = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep private function get_rotation():Float
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

	@:keep private function set_rotation(value:Float):Float
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

	@:keep private function get_scaleX():Float
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

	@:keep private function set_scaleX(value:Float):Float
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

	@:keep private function get_scaleY():Float
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

	@:keep private function set_scaleY(value:Float):Float
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

	private function get_shader():Shader
	{
		return __shader;
	}

	private function set_shader(value:Shader):Shader
	{
		if (value != __shader)
		{
			__shader = value;
			__setRenderDirty();
		}

		return value;
	}

	private function get_tileset():Tileset
	{
		return __tileset;
	}

	private function set_tileset(value:Tileset):Tileset
	{
		if (value != __tileset)
		{
			__tileset = value;
			__setRenderDirty();
		}

		return value;
	}

	private function get_visible():Bool
	{
		return __visible;
	}

	private function set_visible(value:Bool):Bool
	{
		if (value != __visible)
		{
			__visible = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep private function get_width():Float
	{
		// TODO how does pooling work with flash target?
		var result:Rectangle = #if flash new Rectangle() #else _Rectangle.__pool.get() #end;

		__findTileRect(result);

		__getBounds(result, matrix);
		var w = result.width;
		#if !flash
		_Rectangle.__pool.release(result);
		#end
		return w;
	}

	@:keep private function set_width(value:Float):Float
	{
		var result:Rectangle = #if flash __tempRectangle #else _Rectangle.__pool.get() #end;

		__findTileRect(result);
		if (result.width != 0)
		{
			scaleX = value / result.width;
		}
		#if !flash
		_Rectangle.__pool.release(result);
		#end
		return value;
	}

	@:keep private function get_x():Float
	{
		return __matrix.tx;
	}

	@:keep private function set_x(value:Float):Float
	{
		if (value != __matrix.tx)
		{
			__matrix.tx = value;
			__setRenderDirty();
		}

		return value;
	}

	@:keep private function get_y():Float
	{
		return __matrix.ty;
	}

	@:keep private function set_y(value:Float):Float
	{
		if (value != __matrix.ty)
		{
			__matrix.ty = value;
			__setRenderDirty();
		}

		return value;
	}
}
