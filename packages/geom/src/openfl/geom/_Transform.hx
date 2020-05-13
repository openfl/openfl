package openfl.geom;

import openfl.display.DisplayObject;
import openfl.display._DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)
@:noCompletion
class _Transform
{
	public var colorTransform(get, set):ColorTransform;
	public var concatenatedColorTransform:ColorTransform;
	public var concatenatedMatrix(get, never):Matrix;
	public var matrix(get, set):Matrix;
	public var matrix3D(get, set):Matrix3D;
	public var pixelBounds:Rectangle;

	public var __colorTransform:ColorTransform;
	public var __displayObject:DisplayObject;
	public var __hasMatrix:Bool;
	public var __hasMatrix3D:Bool;

	public function new(displayObject:DisplayObject)
	{
		__colorTransform = new ColorTransform();
		concatenatedColorTransform = new ColorTransform();
		pixelBounds = new Rectangle();

		__displayObject = displayObject;
		__hasMatrix = true;
	}

	public function __setTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		if (__displayObject != null)
		{
			var transform = (__displayObject._ : _DisplayObject).__transform;
			if (transform.a == a && transform.b == b && transform.c == c && transform.d == d && transform.tx == tx && transform.ty == ty)
			{
				return;
			}

			var scaleX = 0.0;
			var scaleY = 0.0;

			if (b == 0)
			{
				scaleX = a;
			}
			else
			{
				scaleX = Math.sqrt(a * a + b * b);
			}

			if (c == 0)
			{
				scaleY = d;
			}
			else
			{
				scaleY = Math.sqrt(c * c + d * d);
			}

				(__displayObject._ : _DisplayObject).__scaleX = scaleX;
			(__displayObject._ : _DisplayObject).__scaleY = scaleY;

			var rotation = (180 / Math.PI) * Math.atan2(d, c) - 90;

			if (rotation != (__displayObject._ : _DisplayObject).__rotation)
			{
				(__displayObject._ : _DisplayObject).__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				(__displayObject._ : _DisplayObject).__rotationSine = Math.sin(radians);
				(__displayObject._ : _DisplayObject).__rotationCosine = Math.cos(radians);
			}

			transform.a = a;
			transform.b = b;
			transform.c = c;
			transform.d = d;
			transform.tx = tx;
			transform.ty = ty;

			(__displayObject._ : _DisplayObject).__setTransformDirty();
			(__displayObject._ : _DisplayObject).__setParentRenderDirty();
		}
	}

	// Get & Set Methods

	private function get_colorTransform():ColorTransform
	{
		return __colorTransform;
	}

	private function set_colorTransform(value:ColorTransform):ColorTransform
	{
		if (!__colorTransform._.__equals(value, false))
		{
			__colorTransform._.__copyFrom(value);

			if (value != null)
			{
				__displayObject.alpha = value.alphaMultiplier;
			}

				(__displayObject._ : _DisplayObject).__setRenderDirty();
		}

		return __colorTransform;
	}

	private function get_concatenatedMatrix():Matrix
	{
		if (__hasMatrix)
		{
			return (__displayObject._ : _DisplayObject).__getWorldTransform().clone();
		}

		return null;
	}

	private function get_matrix():Matrix
	{
		if (__hasMatrix)
		{
			return (__displayObject._ : _DisplayObject).__transform.clone();
		}

		return null;
	}

	private function set_matrix(value:Matrix):Matrix
	{
		if (value == null)
		{
			__hasMatrix = false;
			return null;
		}

		__hasMatrix = true;
		__hasMatrix3D = false;

		if (__displayObject != null)
		{
			__setTransform(value.a, value.b, value.c, value.d, value.tx, value.ty);
		}

		return value;
	}

	private function get_matrix3D():Matrix3D
	{
		if (__hasMatrix3D)
		{
			var matrix = (__displayObject._ : _DisplayObject).__transform;
			return new Matrix3D(new Vector<Float>([
				matrix.a, matrix.b, 0.0, 0.0, matrix.c, matrix.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, matrix.tx, matrix.ty, 0.0, 1.0
			]));
		}

		return null;
	}

	private function set_matrix3D(value:Matrix3D):Matrix3D
	{
		if (value == null)
		{
			__hasMatrix3D = false;
			return null;
		}

		__hasMatrix = false;
		__hasMatrix3D = true;

		__setTransform(value.rawData[0], value.rawData[1], value.rawData[5], value.rawData[6], value.rawData[12], value.rawData[13]);

		return value;
	}
}
