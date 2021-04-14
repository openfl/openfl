package openfl.geom;

#if !flash
import openfl.display.DisplayObject;

/**
	The Transform class provides access to color adjustment properties and two-
	or three-dimensional transformation objects that can be applied to a
	display object. During the transformation, the color or the orientation and
	position of a display object is adjusted(offset) from the current values
	or coordinates to new values or coordinates. The Transform class also
	collects data about color and two-dimensional matrix transformations that
	are applied to a display object and all of its parent objects. You can
	access these combined transformations through the
	`concatenatedColorTransform` and `concatenatedMatrix`
	properties.

	To apply color transformations: create a ColorTransform object, set the
	color adjustments using the object's methods and properties, and then
	assign the `colorTransformation` property of the
	`transform` property of the display object to the new
	ColorTransformation object.

	To apply two-dimensional transformations: create a Matrix object, set
	the matrix's two-dimensional transformation, and then assign the
	`transform.matrix` property of the display object to the new
	Matrix object.

	To apply three-dimensional transformations: start with a
	three-dimensional display object. A three-dimensional display object has a
	`z` property value other than zero. You do not need to create
	the Matrix3D object. For all three-dimensional objects, a Matrix3D object
	is created automatically when you assign a `z` value to a
	display object. You can access the display object's Matrix3D object through
	the display object's `transform` property. Using the methods of
	the Matrix3D class, you can add to or modify the existing transformation
	settings. Also, you can create a custom Matrix3D object, set the custom
	Matrix3D object's transformation elements, and then assign the new Matrix3D
	object to the display object using the `transform.matrix`
	property.

	To modify a perspective projection of the stage or root object: use the
	`transform.matrix` property of the root display object to gain
	access to the PerspectiveProjection object. Or, apply different perspective
	projection properties to a display object by setting the perspective
	projection properties of the display object's parent. The child display
	object inherits the new properties. Specifically, create a
	PerspectiveProjection object and set its properties, then assign the
	PerspectiveProjection object to the `perspectiveProjection`
	property of the parent display object's `transform` property.
	The specified projection transformation then applies to all the display
	object's three-dimensional children.

	Since both PerspectiveProjection and Matrix3D objects perform
	perspective transformations, do not assign both to a display object at the
	same time. Use the PerspectiveProjection object for focal length and
	projection center changes. For more control over the perspective
	transformation, create a perspective projection Matrix3D object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)
class Transform
{
	/**
		A ColorTransform object containing values that universally adjust the
		colors in the display object.

		@throws TypeError The colorTransform is null when being set
	**/
	public var colorTransform(get, set):ColorTransform;

	/**
		A ColorTransform object representing the combined color transformations
		applied to the display object and all of its parent objects, back to the
		root level. If different color transformations have been applied at
		different levels, all of those transformations are concatenated into one
		ColorTransform object for this property.
	**/
	public var concatenatedColorTransform(default, null):ColorTransform;

	/**
		A Matrix object representing the combined transformation matrixes of the
		display object and all of its parent objects, back to the root level. If
		different transformation matrixes have been applied at different levels,
		all of those matrixes are concatenated into one matrix for this property.
		Also, for resizeable SWF content running in the browser, this property
		factors in the difference between stage coordinates and window coordinates
		due to window resizing. Thus, the property converts local coordinates to
		window coordinates, which may not be the same coordinate space as that of
		the Stage.
	**/
	public var concatenatedMatrix(get, never):Matrix;

	/**
		A Matrix object containing values that alter the scaling, rotation, and
		translation of the display object.

		If the `matrix` property is set to a value (not
		`null`), the `matrix3D` property is
		`null`. And if the `matrix3D` property is set to a
		value(not `null`), the `matrix` property is
		`null`.

		@throws TypeError The matrix is null when being set
	**/
	public var matrix(get, set):Matrix;

	/**
		Provides access to the Matrix3D object of a three-dimensional display
		object. The Matrix3D object represents a transformation matrix that
		determines the display object's position and orientation. A Matrix3D
		object can also perform perspective projection.

		If the `matrix` property is set to a value(not
		`null`), the `matrix3D` property is
		`null`. And if the `matrix3D` property is set to a
		value(not `null`), the `matrix` property is
		`null`.
	**/
	public var matrix3D(get, set):Matrix3D;

	// @:noCompletion @:dox(hide) @:require(flash10) public var perspectiveProjection:PerspectiveProjection;

	/**
		A Rectangle object that defines the bounding rectangle of the display
		object on the stage.
	**/
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
			"matrix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }")
			},
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
	/**
		Returns a Matrix3D object, which can transform the space of a
		specified display object in relation to the current display object's
		space. You can use the `getRelativeMatrix3D()` method to move one
		three-dimensional display object relative to another three-dimensional
		display object.

		@param relativeTo The display object relative to which the
						  transformation occurs. To get a Matrix3D object
						  relative to the stage, set the parameter to the
						  `root` or `stage` object. To get the world-relative
						  matrix of the display object, set the parameter to a
						  display object that has a perspective transformation
						  applied to it.
		@return A Matrix3D object that can be used to transform the space from
				the `relativeTo` display object to the current display object
				space.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public function getRelativeMatrix3D (relativeTo:DisplayObject):Matrix3D;
	#end
	// Get & Set Methods
	@:noCompletion private function get_colorTransform():ColorTransform
	{
		return __colorTransform.__clone();
	}

	@:noCompletion private function set_colorTransform(value:ColorTransform):ColorTransform
	{
		// TODO: Move this to DisplayObject?
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
