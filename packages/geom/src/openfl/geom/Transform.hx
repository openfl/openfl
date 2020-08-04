package openfl.geom;

#if !flash
import openfl.display.DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)
class Transform
{
	public var colorTransform(get, set):ColorTransform;
	public var concatenatedColorTransform(default, null):ColorTransform;
	public var concatenatedMatrix(get, never):Matrix;
	public var matrix(get, set):Matrix;
	public var matrix3D(get, set):Matrix3D;
	// @:noCompletion @:dox(hide) @:require(flash10) public var perspectiveProjection:PerspectiveProjection;
	public var pixelBounds(default, null):Rectangle;

	@:noCompletion private var __colorTransform:ColorTransform;
	@:noCompletion private var __displayObject:DisplayObject;
	@:noCompletion private var __hasMatrix:Bool;
	@:noCompletion private var __hasMatrix3D:Bool;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Transform.prototype, {
			"colorTransform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_colorTransform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_colorTransform (v); }")
			},
			"concatenatedMatrix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_concatenatedMatrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_concatenatedMatrix (v); }")
			},
			"matrix": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }")},
			"matrix3D": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix3D (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix3D (v); }")
			},
		});
	}
	#end

	public function new(displayObject:DisplayObject)
	{
		__colorTransform = new ColorTransform();
		concatenatedColorTransform = new ColorTransform();
		pixelBounds = new Rectangle();

		__displayObject = displayObject;
		__hasMatrix = true;
	}

	#if false
	// @:noCompletion @:dox(hide) @:require(flash10) public function getRelativeMatrix3D (relativeTo:DisplayObject):Matrix3D;
	#end
	// Get & Set Methods
	@:noCompletion private function get_colorTransform():ColorTransform
	{
		return __colorTransform;
	}

	@:noCompletion private function set_colorTransform(value:ColorTransform):ColorTransform
	{
		if (!__colorTransform.__equals(value, false))
		{
			__colorTransform.__copyFrom(value);

			if (value != null)
			{
				__displayObject.alpha = value.alphaMultiplier;
			}

			__displayObject.__setRenderDirty();
		}

		return __colorTransform;
	}

	@:noCompletion private function get_concatenatedMatrix():Matrix
	{
		if (__hasMatrix)
		{
			return __displayObject.__getWorldTransform().clone();
		}

		return null;
	}

	@:noCompletion private function get_matrix():Matrix
	{
		if (__hasMatrix)
		{
			return __displayObject.__transform.clone();
		}

		return null;
	}

	@:noCompletion private function set_matrix(value:Matrix):Matrix
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

	@:noCompletion private function get_matrix3D():Matrix3D
	{
		if (__hasMatrix3D)
		{
			var matrix = __displayObject.__transform;
			return new Matrix3D(new Vector<Float>([
				matrix.a, matrix.b, 0.0, 0.0, matrix.c, matrix.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, matrix.tx, matrix.ty, 0.0, 1.0
			]));
		}

		return null;
	}

	@:noCompletion private function set_matrix3D(value:Matrix3D):Matrix3D
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

	@:noCompletion private function __setTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		if (__displayObject != null)
		{
			var transform = __displayObject.__transform;
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

			__displayObject.__scaleX = scaleX;
			__displayObject.__scaleY = scaleY;

			var rotation = (180 / Math.PI) * Math.atan2(d, c) - 90;

			if (rotation != __displayObject.__rotation)
			{
				__displayObject.__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				__displayObject.__rotationSine = Math.sin(radians);
				__displayObject.__rotationCosine = Math.cos(radians);
			}

			transform.a = a;
			transform.b = b;
			transform.c = c;
			transform.d = d;
			transform.tx = tx;
			transform.ty = ty;

			__displayObject.__setTransformDirty();
		}
	}
}
#else
typedef Transform = flash.geom.Transform;
#end
