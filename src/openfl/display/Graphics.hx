package openfl.display;

#if !flash
import openfl.display._internal.CairoGraphics;
import openfl.display._internal.CanvasGraphics;
import openfl.display._internal.Context3DBuffer;
import openfl.display._internal.DrawCommandBuffer;
import openfl.display._internal.DrawCommandReader;
import openfl.display._internal.ShaderBuffer;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils._internal.Float32Array;
import openfl.utils._internal.UInt16Array;
import openfl.utils.ObjectPool;
import openfl.Vector;
#if lime
import lime.graphics.cairo.Cairo;
#end
#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end

/**
	The Graphics class contains a set of methods that you can use to create a
	vector shape. Display objects that support drawing include Sprite and Shape
	objects. Each of these classes includes a `graphics` property
	that is a Graphics object. The following are among those helper functions
	provided for ease of use: `drawRect()`,
	`drawRoundRect()`, `drawCircle()`, and
	`drawEllipse()`.

	You cannot create a Graphics object directly from ActionScript code. If
	you call `new Graphics()`, an exception is thrown.

	The Graphics class is final; it cannot be subclassed.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.GraphicsPath)
@:access(openfl.display.IGraphicsData)
@:access(openfl.display.IGraphicsFill)
@:access(openfl.display.Shader)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:final class Graphics
{
	@:noCompletion private static var maxTextureHeight:Null<Int> = null;
	@:noCompletion private static var maxTextureWidth:Null<Int> = null;

	@:noCompletion private var __bounds:Rectangle;
	@:noCompletion private var __commands:DrawCommandBuffer;
	@:noCompletion private var __dirty(default, set):Bool = true;
	@:noCompletion private var __hardwareDirty:Bool;
	@:noCompletion private var __height:Int;
	@:noCompletion private var __managed:Bool;
	@:noCompletion private var __positionX:Float;
	@:noCompletion private var __positionY:Float;
	@:noCompletion private var __quadBuffer:Context3DBuffer;
	@:noCompletion private var __renderTransform:Matrix;
	@:noCompletion private var __shaderBufferPool:ObjectPool<ShaderBuffer>;
	@:noCompletion private var __softwareDirty:Bool;
	@:noCompletion private var __strokePadding:Float;
	@:noCompletion private var __transformDirty:Bool;
	@:noCompletion private var __triangleIndexBuffer:IndexBuffer3D;
	@:noCompletion private var __triangleIndexBufferCount:Int;
	@:noCompletion private var __triangleIndexBufferData:UInt16Array;
	@:noCompletion private var __usedShaderBuffers:List<ShaderBuffer>;
	@:noCompletion private var __vertexBuffer:VertexBuffer3D;
	@:noCompletion private var __vertexBufferCount:Int;
	@:noCompletion private var __vertexBufferCountUVT:Int;
	@:noCompletion private var __vertexBufferData:Float32Array;
	@:noCompletion private var __vertexBufferDataUVT:Float32Array;
	@:noCompletion private var __vertexBufferUVT:VertexBuffer3D;
	@:noCompletion private var __visible:Bool;
	// private var __cachedTexture:RenderTexture;
	@:noCompletion private var __owner:DisplayObject;
	@:noCompletion private var __width:Int;
	@:noCompletion private var __worldTransform:Matrix;
	#if (js && html5)
	@:noCompletion private var __canvas:CanvasElement;
	@:noCompletion private var __context:#if lime CanvasRenderingContext2D #else Dynamic #end;
	#else
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __cairo:#if lime Cairo #else Dynamic #end;
	#end
	@:noCompletion private var __bitmap:BitmapData;

	@:noCompletion private function new(owner:DisplayObject)
	{
		__owner = owner;

		__commands = new DrawCommandBuffer();
		__strokePadding = 0;
		__positionX = 0;
		__positionY = 0;
		__renderTransform = new Matrix();
		__usedShaderBuffers = new List<ShaderBuffer>();
		__worldTransform = new Matrix();
		__width = 0;
		__height = 0;

		__shaderBufferPool = new ObjectPool<ShaderBuffer>(function() return new ShaderBuffer());

		#if (js && html5)
		moveTo(0, 0);
		#end
	}

	/**
		Fills a drawing area with a bitmap image. The bitmap can be repeated or
		tiled to fill the area. The fill remains in effect until you call the
		`beginFill()`, `beginBitmapFill()`,
		`beginGradientFill()`, or `beginShaderFill()`
		method. Calling the `clear()` method clears the fill.

		The application renders the fill whenever three or more points are
		drawn, or when the `endFill()` method is called.

		@param bitmap A transparent or opaque bitmap image that contains the bits
					  to be displayed.
		@param matrix A matrix object(of the openfl.geom.Matrix class), which you
					  can use to define transformations on the bitmap. For
					  example, you can use the following matrix to rotate a bitmap
					  by 45 degrees(pi/4 radians):

		```haxe
		matrix = new openfl.geom.Matrix();
			 	matrix.rotate(Math.PI / 4);
			 	```

		@param repeat If `true`, the bitmap image repeats in a tiled
					  pattern. If `false`, the bitmap image does not
					  repeat, and the edges of the bitmap are used for any fill
					  area that extends beyond the bitmap.

					  For example, consider the following bitmap(a 20 x
					  20-pixel checkerboard pattern):

					  ![20 by 20 pixel checkerboard](/images/movieClip_beginBitmapFill_repeat_1.jpg)

					  When `repeat` is set to `true`(as
					  in the following example), the bitmap fill repeats the
					  bitmap:

					  ![60 by 60 pixel checkerboard](/images/movieClip_beginBitmapFill_repeat_2.jpg)

					  When `repeat` is set to `false`,
					  the bitmap fill uses the edge pixels for the fill area
					  outside the bitmap:

					  ![60 by 60 pixel image with no repeating](/images/movieClip_beginBitmapFill_repeat_3.jpg)
		@param smooth If `false`, upscaled bitmap images are rendered
					  by using a nearest-neighbor algorithm and look pixelated. If
					  `true`, upscaled bitmap images are rendered by
					  using a bilinear algorithm. Rendering by using the nearest
					  neighbor algorithm is faster.
	**/
	public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void
	{
		__commands.beginBitmapFill(bitmap, matrix != null ? matrix.clone() : null, repeat, smooth);

		__visible = true;
	}

	/**
		Specifies a simple one-color fill that subsequent calls to other Graphics
		methods(such as `lineTo()` or `drawCircle()`) use
		when drawing. The fill remains in effect until you call the
		`beginFill()`, `beginBitmapFill()`,
		`beginGradientFill()`, or `beginShaderFill()`
		method. Calling the `clear()` method clears the fill.

		The application renders the fill whenever three or more points are
		drawn, or when the `endFill()` method is called.

		@param color The color of the fill(0xRRGGBB).
		@param alpha The alpha value of the fill(0.0 to 1.0).
	**/
	public function beginFill(color:Int = 0, alpha:Float = 1):Void
	{
		__commands.beginFill(color & 0xFFFFFF, alpha);

		if (alpha > 0) __visible = true;
	}

	/**
		Specifies a gradient fill used by subsequent calls to other Graphics
		methods(such as `lineTo()` or `drawCircle()`) for
		the object. The fill remains in effect until you call the
		`beginFill()`, `beginBitmapFill()`,
		`beginGradientFill()`, or `beginShaderFill()`
		method. Calling the `clear()` method clears the fill.

		The application renders the fill whenever three or more points are
		drawn, or when the `endFill()` method is called.

		@param	type	A value from the GradientType class that specifies which gradient type to use:
		`GradientType.LINEAR` or `GradientType.RADIAL`.

		@param	colors	An array of RGB hexadecimal color values used in the gradient; for example, red is 0xFF0000,
		blue is 0x0000FF, and so on. You can specify up to 15 colors. For each color, specify a corresponding value
		in the `alphas` and `ratios` parameters.

		@param	alphas	An array of alpha values for the corresponding colors in the `colors` array; valid values
		are 0 to 1. If the value is less than 0, the default is 0. If the value is greater than 1, the default is 1.

		@param	ratios	An array of color distribution ratios; valid values are 0-255. This value defines the
		percentage of the width where the color is sampled at 100%. The value 0 represents the left position in the
		gradient box, and 255 represents the right position in the gradient box.

		**Note:** This value represents positions in the gradient box, not the coordinate space of the final gradient,
		which can be wider or thinner than the gradient box. Specify a value for each value in the `colors` parameter.

		For example, for a linear gradient that includes two colors, blue and green, the following example illustrates
		the placement of the colors in the gradient based on different values in the ratios array:

		| ratios | Gradient |
		| --- | --- |
		| `[0, 127]` | ![linear gradient blue to green with ratios 0 and 127](/images/gradient-ratios-1.jpg) |
		| `[0, 255]` | ![linear gradient blue to green with ratios 0 and 255](/images/gradient-ratios-2.jpg) |
		| `[127, 255]` | ![linear gradient blue to green with ratios 127 and 255](/images/gradient-ratios-3.jpg) |

		The values in the array must increase sequentially; for example, `[0, 63, 127, 190, 255]`.

		@param	matrix	A transformation matrix as defined by the openfl.geom.Matrix class. The openfl.geom.Matrix
		class includes a `createGradientBox()` method, which lets you conveniently set up the matrix for use with the
		`beginGradientFill()` method.

		@param	spreadMethod	A value from the SpreadMethod class that specifies which spread method to use, either:
		`SpreadMethod.PAD`, `SpreadMethod.REFLECT`, or `SpreadMethod.REPEAT`.

		For example, consider a simple linear gradient between two colors:

		```as3
		import flash.geom.*
		import flash.display.*
		var fillType:String = GradientType.LINEAR;
		var colors:Array = [0xFF0000, 0x0000FF];
		var alphas:Array = [1, 1];
		var ratios:Array = [0x00, 0xFF];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(20, 20, 0, 0, 0);
		var spreadMethod:String = SpreadMethod.PAD;
		this.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
		this.graphics.drawRect(0,0,100,100);
		```

		This example uses `SpreadMethod.PAD` for the spread method, and the gradient fill looks like the following:

		![linear gradient with SpreadMethod.PAD](/images/beginGradientFill_spread_pad.jpg)

		If you use SpreadMethod.REFLECT for the spread method, the gradient fill looks like the following:

		![linear gradient with SpreadMethod.REFLECT](/images/beginGradientFill_spread_reflect.jpg)

		If you use SpreadMethod.REPEAT for the spread method, the gradient fill looks like the following:

		![linear gradient with SpreadMethod.REPEAT](/images/beginGradientFill_spread_repeat.jpg)

		@param	interpolationMethod	A value from the InterpolationMethod class that specifies which value to use:
		`InterpolationMethod.LINEAR_RGB` or `InterpolationMethod.RGB`

		For example, consider a simple linear gradient between two colors (with the `spreadMethod` parameter set to
		`SpreadMethod.REFLECT`). The different interpolation methods affect the appearance as follows:

		| | |
		| --- | --- |
		| ![linear gradient with InterpolationMethod.LINEAR_RGB](/images/beginGradientFill_interp_linearrgb.jpg)<br>`InterpolationMethod.LINEAR_RGB` | ![linear gradient with InterpolationMethod.RGB](/images/beginGradientFill_interp_rgb.jpg)<br>`InterpolationMethod.RGB` |

		@param	focalPointRatio	A number that controls the location of the focal point of the gradient. 0 means that
		the focal point is in the center. 1 means that the focal point is at one border of the gradient circle. -1
		means that the focal point is at the other border of the gradient circle. A value less than -1 or greater
		than 1 is rounded to -1 or 1. For example, the following example shows a `focalPointRatio` set to 0.75:

		![radial gradient with focalPointRatio set to 0.75](/images/radial_sketch.jpg)

		@throws ArgumentError If the `type` parameter is not valid.
	**/
	public function beginGradientFill(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null,
			spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void
	{
		if (colors == null || colors.length == 0) return;

		if (alphas == null)
		{
			alphas = [];

			for (i in 0...colors.length)
			{
				alphas.push(1);
			}
		}

		if (ratios == null)
		{
			ratios = [];

			for (i in 0...colors.length)
			{
				ratios.push(Math.ceil((i / colors.length) * 255));
			}
		}

		if (alphas.length < colors.length || ratios.length < colors.length) return;

		__commands.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

		for (alpha in alphas)
		{
			if (alpha > 0)
			{
				__visible = true;
				break;
			}
		}
	}

	/**
		Specifies a shader fill used by subsequent calls to other Graphics
		methods (such as `lineTo()` or `drawCircle()`) for the object. The
		fill remains in effect until you call the `beginFill()`,
		`beginBitmapFill()`, `beginGradientFill()`, or `beginShaderFill()`
		method. Calling the `clear()` method clears the fill.
		The application renders the fill whenever three or more points are
		drawn, or when the `endFill()` method is called.

		Shader fills are not supported under GPU rendering; filled areas will
		be colored cyan.

		@param shader The shader to use for the fill. This Shader instance is
					  not required to specify an image input. However, if an
					  image input is specified in the shader, the input must
					  be provided manually. To specify the input, set the
					  `input` property of the corresponding ShaderInput
					  property of the `Shader.data` property.
					  When you pass a Shader instance as an argument the
					  shader is copied internally. The drawing fill operation
					  uses that internal copy, not a reference to the original
					  shader. Any changes made to the shader, such as changing
					  a parameter value, input, or bytecode, are not applied
					  to the copied shader that's used for the fill.
		@param matrix A matrix object (of the openfl.geom.Matrix class), which
					  you can use to define transformations on the shader. For
					  example, you can use the following matrix to rotate a
					  shader by 45 degrees (pi/4 radians):

					  ```haxe
					  matrix = new openfl.geom.Matrix();
					  matrix.rotate(Math.PI / 4);
					  ```

					  The coordinates received in the shader are based on the
					  matrix that is specified for the `matrix` parameter. For
					  a default (`null`) matrix, the coordinates in the shader
					  are local pixel coordinates which can be used to sample
					  an input.
		@throws ArgumentError When the shader output type is not compatible
							  with this operation (the shader must specify a
							  `pixel3` or `pixel4` output).
		@throws ArgumentError When the shader specifies an image input that
							  isn't provided.
		@throws ArgumentError When a ByteArray or Vector.<Number> instance is
							  used as an input and the `width` and `height`
							  properties aren't specified for the ShaderInput,
							  or the specified values don't match the amount
							  of data in the input object. See the
							  `ShaderInput.input` property for more
							  information.
	**/
	public function beginShaderFill(shader:Shader, matrix:Matrix = null):Void
	{
		if (shader != null)
		{
			#if lime
			var shaderBuffer = __shaderBufferPool.get();
			__usedShaderBuffers.add(shaderBuffer);
			shaderBuffer.update(cast shader);

			__commands.beginShaderFill(shaderBuffer);
			#end
		}
	}

	/**
		Clears the graphics that were drawn to this Graphics object, and resets
		fill and line style settings.

	**/
	public function clear():Void
	{
		#if lime
		for (shaderBuffer in __usedShaderBuffers)
		{
			__shaderBufferPool.release(shaderBuffer);
		}
		#end

		__usedShaderBuffers.clear();
		__commands.clear();
		__strokePadding = 0;

		if (__bounds != null)
		{
			__dirty = true;
			__transformDirty = true;
			__bounds = null;
		}

		__visible = false;
		__positionX = 0;
		__positionY = 0;

		#if (js && html5)
		moveTo(0, 0);
		#end
	}

	/**
		Copies all of drawing commands from the source Graphics object into
		the calling Graphics object.

		@param sourceGraphics The Graphics object from which to copy the
							  drawing commands.
	**/
	public function copyFrom(sourceGraphics:Graphics):Void
	{
		__bounds = sourceGraphics.__bounds != null ? sourceGraphics.__bounds.clone() : null;
		__commands = sourceGraphics.__commands.copy();
		__dirty = true;
		__strokePadding = sourceGraphics.__strokePadding;
		__positionX = sourceGraphics.__positionX;
		__positionY = sourceGraphics.__positionY;
		__transformDirty = true;
		__visible = sourceGraphics.__visible;
	}

	/**
		Draws a cubic Bezier curve from the current drawing position to the specified
		anchor point. Cubic Bezier curves consist of two anchor points and two control
		points. The curve interpolates the two anchor points and curves toward the two
		control points.

		![cubic bezier](/images/cubic_bezier.png)

		The four points you use to draw a cubic Bezier curve with the `cubicCurveTo()`
		method are as follows:

		* The current drawing position is the first anchor point.
		* The `anchorX` and `anchorY` parameters specify the second anchor point.
		* The `controlX1` and `controlY1` parameters specify the first control point.
		* The `controlX2` and `controlY2` parameters specify the second control point.

		If you call the `cubicCurveTo()` method before calling the `moveTo()` method, your
		curve starts at position (0, 0).

		If the `cubicCurveTo()` method succeeds, the OpenFL runtime sets the current
		drawing position to (`anchorX`, `anchorY`). If the `cubicCurveTo()` method fails,
		the current drawing position remains unchanged.

		If your movie clip contains content created with the Flash drawing tools, the
		results of calls to the `cubicCurveTo()` method are drawn underneath that content.

		@param	controlX1	Specifies the horizontal position of the first control point
		relative to the registration point of the parent display object.
		@param	controlY1	Specifies the vertical position of the first control point
		relative to the registration point of the parent display object.
		@param	controlX2	Specifies the horizontal position of the second control point
		relative to the registration point of the parent display object.
		@param	controlY2	Specifies the vertical position of the second control point
		relative to the registration point of the parent display object.
		@param	anchorX	Specifies the horizontal position of the anchor point relative to
		the registration point of the parent display object.
		@param	anchorY	Specifies the vertical position of the anchor point relative to
		the registration point of the parent display object.
	**/
	public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void
	{
		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		var ix1, iy1, ix2, iy2;

		ix1 = anchorX;
		ix2 = anchorX;

		if (!(((controlX1 < anchorX && controlX1 > __positionX) || (controlX1 > anchorX && controlX1 < __positionX))
			&& ((controlX2 < anchorX && controlX2 > __positionX) || (controlX2 > anchorX && controlX2 < __positionX))))
		{
			var u = (2 * __positionX - 4 * controlX1 + 2 * controlX2);
			var v = (controlX1 - __positionX);
			var w = (-__positionX + 3 * controlX1 + anchorX - 3 * controlX2);

			var t1 = (-u + Math.sqrt(u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt(u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1)
			{
				ix1 = __calculateBezierCubicPoint(t1, __positionX, controlX1, controlX2, anchorX);
			}

			if (t2 > 0 && t2 < 1)
			{
				ix2 = __calculateBezierCubicPoint(t2, __positionX, controlX1, controlX2, anchorX);
			}
		}

		iy1 = anchorY;
		iy2 = anchorY;

		if (!(((controlY1 < anchorY && controlY1 > __positionX) || (controlY1 > anchorY && controlY1 < __positionX))
			&& ((controlY2 < anchorY && controlY2 > __positionX) || (controlY2 > anchorY && controlY2 < __positionX))))
		{
			var u = (2 * __positionX - 4 * controlY1 + 2 * controlY2);
			var v = (controlY1 - __positionX);
			var w = (-__positionX + 3 * controlY1 + anchorY - 3 * controlY2);

			var t1 = (-u + Math.sqrt(u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt(u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1)
			{
				iy1 = __calculateBezierCubicPoint(t1, __positionX, controlY1, controlY2, anchorY);
			}

			if (t2 > 0 && t2 < 1)
			{
				iy2 = __calculateBezierCubicPoint(t2, __positionX, controlY1, controlY2, anchorY);
			}
		}

		__inflateBounds(ix1 - __strokePadding, iy1 - __strokePadding);
		__inflateBounds(ix1 + __strokePadding, iy1 + __strokePadding);
		__inflateBounds(ix2 - __strokePadding, iy2 - __strokePadding);
		__inflateBounds(ix2 + __strokePadding, iy2 + __strokePadding);

		__positionX = anchorX;
		__positionY = anchorY;

		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		__commands.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);

		__dirty = true;
	}

	/**
		Draws a quadratic curve using the current line style from the current drawing
		position to(anchorX, anchorY) and using the control point that
		(`controlX`, `controlY`) specifies. The current
		drawing position is then set to(`anchorX`,
		`anchorY`). If the movie clip in which you are drawing contains
		content created with the Flash drawing tools, calls to the
		`curveTo()` method are drawn underneath this content. If you
		call the `curveTo()` method before any calls to the
		`moveTo()` method, the default of the current drawing position
		is(0, 0). If any of the parameters are missing, this method fails and the
		current drawing position is not changed.

		The curve drawn is a quadratic Bezier curve. Quadratic Bezier curves
		consist of two anchor points and one control point. The curve interpolates
		the two anchor points and curves toward the control point.

		![quadratic bezier](quad_bezier.png)

		@param controlX A number that specifies the horizontal position of the
						control point relative to the registration point of the
						parent display object.
		@param controlY A number that specifies the vertical position of the
						control point relative to the registration point of the
						parent display object.
		@param anchorX  A number that specifies the horizontal position of the
						next anchor point relative to the registration point of
						the parent display object.
		@param anchorY  A number that specifies the vertical position of the next
						anchor point relative to the registration point of the
						parent display object.
	**/
	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void
	{
		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		var ix, iy;

		if ((controlX < anchorX && controlX > __positionX) || (controlX > anchorX && controlX < __positionX))
		{
			ix = anchorX;
		}
		else
		{
			var tx = ((__positionX - controlX) / (__positionX - 2 * controlX + anchorX));
			ix = __calculateBezierQuadPoint(tx, __positionX, controlX, anchorX);
		}

		if ((controlY < anchorY && controlY > __positionY) || (controlY > anchorY && controlY < __positionY))
		{
			iy = anchorY;
		}
		else
		{
			var ty = ((__positionY - controlY) / (__positionY - (2 * controlY) + anchorY));
			iy = __calculateBezierQuadPoint(ty, __positionY, controlY, anchorY);
		}

		__inflateBounds(ix - __strokePadding, iy - __strokePadding);
		__inflateBounds(ix + __strokePadding, iy + __strokePadding);

		__positionX = anchorX;
		__positionY = anchorY;

		__commands.curveTo(controlX, controlY, anchorX, anchorY);

		__dirty = true;
	}

	public function drawCircle(x:Float, y:Float, radius:Float):Void
	{
		if (radius <= 0) return;

		__inflateBounds(x - radius - __strokePadding, y - radius - __strokePadding);
		__inflateBounds(x + radius + __strokePadding, y + radius + __strokePadding);

		__commands.drawCircle(x, y, radius);

		__dirty = true;
	}

	/**
		Draws an ellipse. Set the line style, fill, or both before you call the
		`drawEllipse()` method, by calling the
		`linestyle()`, `lineGradientStyle()`,
		`beginFill()`, `beginGradientFill()`, or
		`beginBitmapFill()` method.

		@param x      The _x_ location of the top-left of the bounding-box of
					  the ellipse relative to the registration point of the parent
					  display object(in pixels).
		@param y      The _y_ location of the top left of the bounding-box of
					  the ellipse relative to the registration point of the parent
					  display object(in pixels).
		@param width  The width of the ellipse(in pixels).
		@param height The height of the ellipse(in pixels).
	**/
	public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (width <= 0 || height <= 0) return;

		__inflateBounds(x - __strokePadding, y - __strokePadding);
		__inflateBounds(x + width + __strokePadding, y + height + __strokePadding);

		__commands.drawEllipse(x, y, width, height);

		__dirty = true;
	}

	/**
		Submits a series of IGraphicsData instances for drawing. This method
		accepts a Vector containing objects including paths, fills, and strokes
		that implement the IGraphicsData interface. A Vector of IGraphicsData
		instances can refer to a part of a shape, or a complex fully defined set
		of data for rendering a complete shape.

		 Graphics paths can contain other graphics paths. If the
		`graphicsData` Vector includes a path, that path and all its
		sub-paths are rendered during this operation.

	**/
	public function drawGraphicsData(graphicsData:Vector<IGraphicsData>):Void
	{
		var fill:GraphicsSolidFill;
		var bitmapFill:GraphicsBitmapFill;
		var gradientFill:GraphicsGradientFill;
		var shaderFill:GraphicsShaderFill;
		var stroke:GraphicsStroke;
		var path:GraphicsPath;
		var trianglePath:GraphicsTrianglePath;
		var quadPath:GraphicsQuadPath;

		for (graphics in graphicsData)
		{
			switch (graphics.__graphicsDataType)
			{
				case SOLID:
					fill = cast graphics;
					beginFill(fill.color, fill.alpha);

				case BITMAP:
					bitmapFill = cast graphics;
					beginBitmapFill(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);

				case GRADIENT:
					gradientFill = cast graphics;
					beginGradientFill(gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix,
						gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);

				case SHADER:
					shaderFill = cast graphics;
					beginShaderFill(shaderFill.shader, shaderFill.matrix);

				case STROKE:
					stroke = cast graphics;

					if (stroke.fill != null)
					{
						var thickness:Null<Float> = stroke.thickness;

						if (Math.isNaN(thickness))
						{
							thickness = null;
						}

						switch (stroke.fill.__graphicsFillType)
						{
							case SOLID_FILL:
								fill = cast stroke.fill;
								lineStyle(thickness, fill.color, fill.alpha, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints,
									stroke.miterLimit);

							case BITMAP_FILL:
								bitmapFill = cast stroke.fill;
								lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
								lineBitmapStyle(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);

							case GRADIENT_FILL:
								gradientFill = cast stroke.fill;
								lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
								lineGradientStyle(gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix,
									gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);

							default:
						}
					}
					else
					{
						lineStyle();
					}

				case PATH:
					path = cast graphics;
					drawPath(path.commands, path.data, path.winding);

				case TRIANGLE_PATH:
					trianglePath = cast graphics;
					drawTriangles(trianglePath.vertices, trianglePath.indices, trianglePath.uvtData, trianglePath.culling);

				case END:
					endFill();

				case QUAD_PATH:
					quadPath = cast graphics;
					drawQuads(quadPath.rects, quadPath.indices, quadPath.transforms);
			}
		}
	}

	/**
		Submits a series of commands for drawing. The `drawPath()`
		method uses vector arrays to consolidate individual `moveTo()`,
		`lineTo()`, and `curveTo()` drawing commands into a
		single call. The `drawPath()` method parameters combine drawing
		commands with x- and y-coordinate value pairs and a drawing direction. The
		drawing commands are values from the GraphicsPathCommand class. The x- and
		y-coordinate value pairs are Numbers in an array where each pair defines a
		coordinate location. The drawing direction is a value from the
		GraphicsPathWinding class.

		Generally, drawings render faster with `drawPath()` than
		with a series of individual `lineTo()` and
		`curveTo()` methods.

		The `drawPath()` method uses a uses a floating computation
		so rotation and scaling of shapes is more accurate and gives better
		results. However, curves submitted using the `drawPath()`
		method can have small sub-pixel alignment errors when used in conjunction
		with the `lineTo()` and `curveTo()` methods.

		The `drawPath()` method also uses slightly different rules
		for filling and drawing lines. They are:

		* When a fill is applied to rendering a path:
			* A sub-path of less than 3 points is not rendered.(But note that the
			stroke rendering will still occur, consistent with the rules for strokes
			below.)
			* A sub-path that isn't closed(the end point is not equal to the
			begin point) is implicitly closed.
		* When a stroke is applied to rendering a path:
			* The sub-paths can be composed of any number of points.
			* The sub-path is never implicitly closed.

		@param	commands	A Vector of integers representing drawing commands. The set
		of accepted values is defined by the constants in the GraphicsPathCommand class.
		@param	data	A Vector of Number instances where each pair of numbers is treated
		as a coordinate location (an x, y pair). The x- and y-coordinate value pairs are
		not Point objects; the data vector is a series of numbers where each group of two
		numbers represents a coordinate location.
		@param	winding	Specifies the winding rule using a value defined in the
		GraphicsPathWinding class.
	**/
	public function drawPath(commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD):Void
	{
		var dataIndex = 0;

		if (winding == GraphicsPathWinding.NON_ZERO) __commands.windingNonZero();

		for (command in commands)
		{
			switch (command)
			{
				case GraphicsPathCommand.MOVE_TO:
					moveTo(data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;

				case GraphicsPathCommand.LINE_TO:
					lineTo(data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;

				case GraphicsPathCommand.WIDE_MOVE_TO:
					moveTo(data[dataIndex + 2], data[dataIndex + 3]);
					break;
					dataIndex += 4;

				case GraphicsPathCommand.WIDE_LINE_TO:
					lineTo(data[dataIndex + 2], data[dataIndex + 3]);
					break;
					dataIndex += 4;

				case GraphicsPathCommand.CURVE_TO:
					curveTo(data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3]);
					dataIndex += 4;

				case GraphicsPathCommand.CUBIC_CURVE_TO:
					cubicCurveTo(data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3], data[dataIndex + 4], data[dataIndex + 5]);
					dataIndex += 6;

				default:
			}
		}

		// TODO: Reset to EVEN_ODD after current path is filled?
		// if (winding == GraphicsPathWinding.NON_ZERO) __commands.windingEvenOdd ();
	}

	/**
		Renders a set of quadrilaterals. This is similar to calling `drawRect`
		repeatedly, but each rectangle can use a transform value to rotate, scale
		or skew the result.

		Any type of fill can be used, but if the fill has a transform matrix
		that transform matrix is ignored.

		The optional `indices` parameter allows the use of either repeated
		rectangle geometry, or allows the use of a subset of a broader rectangle
		data Vector, such as Tileset `rectData`.

		@param rects A Vector containing rectangle coordinates in
					 [ x0, y0, width0, height0, x1, y1 ... ] format.
		@param indices A Vector containing optional index values to reference
					   the data contained in `rects`. Each index is a rectangle
					   index in the Vector, not an array index. If this parameter
					   is ommitted, each index from `rects` will be used in order.
		@param transforms A Vector containing optional transform data to adjust
						  _x_, _y_, _a_, _b_, _c_ or _d_ value for the resulting
						  quadrilateral. A `transforms` Vector that is double the
						  size of the draw count (the length of `indices`, or if
						  omitted, the rectangle count in `rects`) will be treated
						  as [ x, y, ... ] pairs. A `transforms` Vector that is
						  four times the size of the draw count will be used as
						  matrix [ a, b, c, d, ... ] values. A `transforms` object
						  which is six times the draw count in size will use full
						  matrix [ a, b, c, d, tx, ty, ... ] values per draw.
	**/
	public function drawQuads(rects:Vector<Float>, indices:Vector<Int> = null, transforms:Vector<Float> = null):Void
	{
		if (rects == null) return;

		var hasIndices = (indices != null);
		var transformABCD = false, transformXY = false;

		var length = hasIndices ? indices.length : Math.floor(rects.length / 4);
		if (length == 0) return;

		if (transforms != null)
		{
			if (transforms.length >= length * 6)
			{
				transformABCD = true;
				transformXY = true;
			}
			else if (transforms.length >= length * 4)
			{
				transformABCD = true;
			}
			else if (transforms.length >= length * 2)
			{
				transformXY = true;
			}
		}

		var tileRect = Rectangle.__pool.get();
		var tileTransform = Matrix.__pool.get();

		var minX = Math.POSITIVE_INFINITY;
		var minY = Math.POSITIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;

		var ri, ti;

		for (i in 0...length)
		{
			ri = (hasIndices ? (indices[i] * 4) : i * 4);
			if (ri < 0) continue;
			tileRect.setTo(0, 0, rects[ri + 2], rects[ri + 3]);

			if (tileRect.width <= 0 || tileRect.height <= 0)
			{
				continue;
			}

			if (transformABCD && transformXY)
			{
				ti = i * 6;
				tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], transforms[ti + 4], transforms[ti + 5]);
			}
			else if (transformABCD)
			{
				ti = i * 4;
				tileTransform.setTo(transforms[ti], transforms[ti + 1], transforms[ti + 2], transforms[ti + 3], tileRect.x, tileRect.y);
			}
			else if (transformXY)
			{
				ti = i * 2;
				tileTransform.tx = transforms[ti];
				tileTransform.ty = transforms[ti + 1];
			}
			else
			{
				tileTransform.tx = tileRect.x;
				tileTransform.ty = tileRect.y;
			}

			tileRect.__transform(tileRect, tileTransform);

			if (minX > tileRect.x) minX = tileRect.x;
			if (minY > tileRect.y) minY = tileRect.y;
			if (maxX < tileRect.right) maxX = tileRect.right;
			if (maxY < tileRect.bottom) maxY = tileRect.bottom;
		}

		__inflateBounds(minX, minY);
		__inflateBounds(maxX, maxY);

		__commands.drawQuads(rects, indices, transforms);

		__dirty = true;
		__visible = true;

		Rectangle.__pool.release(tileRect);
		Matrix.__pool.release(tileTransform);
	}

	/**
		Draws a rectangle. Set the line style, fill, or both before you call the
		`drawRect()` method, by calling the `linestyle()`,
		`lineGradientStyle()`, `beginFill()`,
		`beginGradientFill()`, or `beginBitmapFill()`
		method.

		@param x      A number indicating the horizontal position relative to the
					  registration point of the parent display object(in pixels).
		@param y      A number indicating the vertical position relative to the
					  registration point of the parent display object(in pixels).
		@param width  The width of the rectangle(in pixels).
		@param height The height of the rectangle(in pixels).
		@throws ArgumentError If the `width` or `height`
							  parameters are not a number
							 (`Number.NaN`).
	**/
	public function drawRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (width == 0 && height == 0) return;

		var xSign = width < 0 ? -1 : 1;
		var ySign = height < 0 ? -1 : 1;

		__inflateBounds(x - __strokePadding * xSign, y - __strokePadding * ySign);
		__inflateBounds(x + width + __strokePadding * xSign, y + height + __strokePadding * ySign);

		__commands.drawRect(x, y, width, height);

		__dirty = true;
	}

	/**
		Draws a rounded rectangle. Set the line style, fill, or both before you
		call the `drawRoundRect()` method, by calling the
		`linestyle()`, `lineGradientStyle()`,
		`beginFill()`, `beginGradientFill()`, or
		`beginBitmapFill()` method.

		@param x             A number indicating the horizontal position relative
							 to the registration point of the parent display
							 object(in pixels).
		@param y             A number indicating the vertical position relative to
							 the registration point of the parent display object
							(in pixels).
		@param width         The width of the round rectangle(in pixels).
		@param height        The height of the round rectangle(in pixels).
		@param ellipseWidth  The width of the ellipse used to draw the rounded
							 corners(in pixels).
		@param ellipseHeight The height of the ellipse used to draw the rounded
							 corners(in pixels). Optional; if no value is
							 specified, the default value matches that provided
							 for the `ellipseWidth` parameter.
		@throws ArgumentError If the `width`, `height`,
							  `ellipseWidth` or
							  `ellipseHeight` parameters are not a
							  number(`Number.NaN`).
	**/
	public function drawRoundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float> = null):Void
	{
		if (width == 0 && height == 0) return;

		var xSign = width < 0 ? -1 : 1;
		var ySign = height < 0 ? -1 : 1;

		__inflateBounds(x - __strokePadding * xSign, y - __strokePadding * ySign);
		__inflateBounds(x + width + __strokePadding * xSign, y + height + __strokePadding * ySign);

		__commands.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);

		__dirty = true;
	}

	/**
		Undocumented method
	**/
	public function drawRoundRectComplex(x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float,
			bottomRightRadius:Float):Void
	{
		if (width <= 0 || height <= 0) return;

		__inflateBounds(x - __strokePadding, y - __strokePadding);
		__inflateBounds(x + width + __strokePadding, y + height + __strokePadding);

		var xw = x + width;
		var yh = y + height;
		var minSize = width < height ? width * 2 : height * 2;
		topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
		topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
		bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
		bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;

		var anchor = (1 - Math.sin(45 * (Math.PI / 180)));
		var control = (1 - Math.tan(22.5 * (Math.PI / 180)));

		var a = bottomRightRadius * anchor;
		var s = bottomRightRadius * control;
		moveTo(xw, yh - bottomRightRadius);
		curveTo(xw, yh - s, xw - a, yh - a);
		curveTo(xw - s, yh, xw - bottomRightRadius, yh);

		a = bottomLeftRadius * anchor;
		s = bottomLeftRadius * control;
		lineTo(x + bottomLeftRadius, yh);
		curveTo(x + s, yh, x + a, yh - a);
		curveTo(x, yh - s, x, yh - bottomLeftRadius);

		a = topLeftRadius * anchor;
		s = topLeftRadius * control;
		lineTo(x, y + topLeftRadius);
		curveTo(x, y + s, x + a, y + a);
		curveTo(x + s, y, x + topLeftRadius, y);

		a = topRightRadius * anchor;
		s = topRightRadius * control;
		lineTo(xw - topRightRadius, y);
		curveTo(xw - s, y, xw - a, y + a);
		curveTo(xw, y + s, xw, y + topRightRadius);
		lineTo(xw, yh - bottomRightRadius);

		__dirty = true;
	}

	/**
		Renders a set of triangles, typically to distort bitmaps and give them a
		three-dimensional appearance. The `drawTriangles()` method maps
		either the current fill, or a bitmap fill, to the triangle faces using a
		set of(u,v) coordinates.

		 Any type of fill can be used, but if the fill has a transform matrix
		that transform matrix is ignored.

		 A `uvtData` parameter improves texture mapping when a
		bitmap fill is used.

		@param culling Specifies whether to render triangles that face in a
					   specified direction. This parameter prevents the rendering
					   of triangles that cannot be seen in the current view. This
					   parameter can be set to any value defined by the
					   TriangleCulling class.
	**/
	public function drawTriangles(vertices:Vector<Float>, indices:Vector<Int> = null, uvtData:Vector<Float> = null,
			culling:TriangleCulling = TriangleCulling.NONE):Void
	{
		if (vertices == null || vertices.length == 0) return;

		var vertLength = Std.int(vertices.length / 2);

		if (indices == null)
		{
			// TODO: Allow null indices

			if (vertLength % 3 != 0)
			{
				throw new ArgumentError("Not enough vertices to close a triangle.");
			}

			indices = new Vector<Int>();

			for (i in 0...vertLength)
			{
				indices.push(i);
			}
		}

		if (culling == null)
		{
			culling = NONE;
		}

		var x, y;
		var minX = Math.POSITIVE_INFINITY;
		var minY = Math.POSITIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;

		for (i in 0...vertLength)
		{
			x = vertices[i * 2];
			y = vertices[i * 2 + 1];

			if (minX > x) minX = x;
			if (minY > y) minY = y;
			if (maxX < x) maxX = x;
			if (maxY < y) maxY = y;
		}

		__inflateBounds(minX, minY);
		__inflateBounds(maxX, maxY);

		__commands.drawTriangles(vertices, indices, uvtData, culling);

		__dirty = true;
		__visible = true;
	}

	/**
		Applies a fill to the lines and curves that were added since the last call
		to the `beginFill()`, `beginGradientFill()`, or
		`beginBitmapFill()` method. Flash uses the fill that was
		specified in the previous call to the `beginFill()`,
		`beginGradientFill()`, or `beginBitmapFill()`
		method. If the current drawing position does not equal the previous
		position specified in a `moveTo()` method and a fill is
		defined, the path is closed with a line and then filled.

	**/
	public function endFill():Void
	{
		__commands.endFill();
	}

	/**
		Specifies a bitmap to use for the line stroke when drawing lines.

		The bitmap line style is used for subsequent calls to Graphics methods
		such as the `lineTo()` method or the `drawCircle()`
		method. The line style remains in effect until you call the
		`lineStyle()` or `lineGradientStyle()` methods, or
		the `lineBitmapStyle()` method again with different parameters.


		You can call the `lineBitmapStyle()` method in the middle of
		drawing a path to specify different styles for different line segments
		within a path.

		Call the `lineStyle()` method before you call the
		`lineBitmapStyle()` method to enable a stroke, or else the
		value of the line style is `undefined`.

		Calls to the `clear()` method set the line style back to
		`undefined`.

		@param bitmap The bitmap to use for the line stroke.
		@param matrix An optional transformation matrix as defined by the
					  openfl.geom.Matrix class. The matrix can be used to scale or
					  otherwise manipulate the bitmap before applying it to the
					  line style.
		@param repeat Whether to repeat the bitmap in a tiled fashion.
		@param smooth Whether smoothing should be applied to the bitmap.
	**/
	public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void
	{
		__commands.lineBitmapStyle(bitmap, matrix != null ? matrix.clone() : null, repeat, smooth);
	}

	/**
		Specifies a gradient to use for the stroke when drawing lines.

		The gradient line style is used for subsequent calls to Graphics
		methods such as the `lineTo()` methods or the
		`drawCircle()` method. The line style remains in effect until
		you call the `lineStyle()` or `lineBitmapStyle()`
		methods, or the `lineGradientStyle()` method again with
		different parameters.

		You can call the `lineGradientStyle()` method in the middle
		of drawing a path to specify different styles for different line segments
		within a path.

		Call the `lineStyle()` method before you call the
		`lineGradientStyle()` method to enable a stroke, or else the
		value of the line style is `undefined`.

		Calls to the `clear()` method set the line style back to
		`undefined`.

		@param	type	A value from the GradientType class that specifies which gradient type to use:
		`GradientType.LINEAR` or `GradientType.RADIAL`.

		@param	colors	An array of RGB hex color values to be used in the gradient (for example, red is 0xFF0000,
		blue is 0x0000FF, and so on).

		@param	alphas	An array of alpha values for the corresponding colors in the `colors` array; valid values
		are 0 to 1. If the value is less than 0, the default is 0. If the value is greater than 1, the default is 1.

		@param	ratios	An array of color distribution ratios; valid values are from 0 to 255. This value defines the
		percentage of the width where the color is sampled at 100%. The value 0 represents the left position in the
		gradient box, and 255 represents the right position in the gradient box. This value represents positions in
		the gradient box, not the coordinate space of the final gradient, which can be wider or thinner than the
		gradient box. Specify a value for each value in the `colors` parameter.

		For example, for a linear gradient that includes two colors, blue and green, the following figure illustrates
		the placement of the colors in the gradient based on different values in the `ratios` array:

		| ratios | Gradient |
		| --- | --- |
		| `[0, 127]` | ![linear gradient blue to green with ratios 0 and 127](/images/gradient-ratios-1.jpg) |
		| `[0, 255]` | ![linear gradient blue to green with ratios 0 and 255](/images/gradient-ratios-2.jpg) |
		| `[127, 255]` | ![linear gradient blue to green with ratios 127 and 255](/images/gradient-ratios-3.jpg) |

		The values in the array must increase sequentially; for example, `[0, 63, 127, 190, 255]`.

		@param	matrix	A transformation matrix as defined by the openfl.geom.Matrix class. The openfl.geom.Matrix
		class includes a `createGradientBox()` method, which lets you conveniently set up the matrix for use with the
		`lineGradientStyle()` method.

		@param	spreadMethod	A value from the SpreadMethod class that specifies which spread method to use:

		| | | |
		| --- | --- | --- |
		| ![linear gradient with SpreadMethod.PAD](/images/beginGradientFill_spread_pad.jpg)<br>`SpreadMethod.PAD` | ![linear gradient with SpreadMethod.REFLECT](/images/beginGradientFill_spread_reflect.jpg)<br>`SpreadMethod.REFLECT` | ![linear gradient with SpreadMethod.REPEAT](/images/beginGradientFill_spread_repeat.jpg)<br>`SpreadMethod.REPEAT` |

		@param	interpolationMethod	A value from the InterpolationMethod class that specifies which value to use. For
		example, consider a simple linear gradient between two colors (with the `spreadMethod` parameter set to
		`SpreadMethod.REFLECT`). The different interpolation methods affect the appearance as follows:

		| | |
		| --- | --- |
		| ![linear gradient with InterpolationMethod.LINEAR_RGB](/images/beginGradientFill_interp_linearrgb.jpg)<br>`InterpolationMethod.LINEAR_RGB` | ![linear gradient with InterpolationMethod.RGB](/images/beginGradientFill_interp_rgb.jpg)<br>`InterpolationMethod.RGB` |

		@param	focalPointRatio	A number that controls the location of the focal point of the gradient. The value 0
		means the focal point is in the center. The value 1 means the focal point is at one border of the gradient
		circle. The value -1 means that the focal point is at the other border of the gradient circle. Values less
		than -1 or greater than 1 are rounded to -1 or 1. The following image shows a gradient with a
		`focalPointRatio` of -0.75:

		![radial gradient with focalPointRatio set to 0.75](/images/radial_sketch.jpg)
	**/
	public function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null,
			spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void
	{
		__commands.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
	}

	/**
		Specifies a shader to use for the line stroke when drawing lines.

		The shader line style is used for subsequent calls to Graphics methods such as the `lineTo()` method or the
		`drawCircle()` method. The line style remains in effect until you call the `lineStyle()` or
		`lineGradientStyle()` methods, or the `lineBitmapStyle()` method again with different parameters.

		You can call the `lineShaderStyle()` method in the middle of drawing a path to specify different styles for
		different line segments within a path.

		Call the `lineStyle()` method before you call the `lineShaderStyle()` method to enable a stroke, or else the
		value of the line style is undefined.

		Calls to the `clear()` method set the line style back to undefined.
	**/
	// @:require(flash10) public function lineShaderStyle (shader:Shader, ?matrix:Matrix):Void;

	/**
		Specifies a line style used for subsequent calls to Graphics methods such
		as the `lineTo()` method or the `drawCircle()`
		method. The line style remains in effect until you call the
		`lineGradientStyle()` method, the
		`lineBitmapStyle()` method, or the `lineStyle()`
		method with different parameters.

		You can call the `lineStyle()` method in the middle of
		drawing a path to specify different styles for different line segments
		within the path.

		**Note: **Calls to the `clear()` method set the line
		style back to `undefined`.

		**Note: **Flash Lite 4 supports only the first three parameters
		(`thickness`, `color`, and `alpha`).

		@param thickness    An integer that indicates the thickness of the line in
							points; valid values are 0-255. If a number is not
							specified, or if the parameter is undefined, a line is
							not drawn. If a value of less than 0 is passed, the
							default is 0. The value 0 indicates hairline
							thickness; the maximum thickness is 255. If a value
							greater than 255 is passed, the default is 255.
		@param color        A hexadecimal color value of the line; for example,
							red is 0xFF0000, blue is 0x0000FF, and so on. If a
							value is not indicated, the default is 0x000000
						   (black). Optional.
		@param alpha        A number that indicates the alpha value of the color
							of the line; valid values are 0 to 1. If a value is
							not indicated, the default is 1(solid). If the value
							is less than 0, the default is 0. If the value is
							greater than 1, the default is 1.
		@param pixelHinting (Not supported in Flash Lite 4) A Boolean value that
							specifies whether to hint strokes to full pixels. This
							affects both the position of anchors of a curve and
							the line stroke size itself. With
							`pixelHinting` set to `true`,
							line widths are adjusted to full pixel widths. With
							`pixelHinting` set to `false`,
							disjoints can appear for curves and straight lines.
							For example, the following illustrations show how
							Flash Player or Adobe AIR renders two rounded
							rectangles that are identical, except that the
							`pixelHinting` parameter used in the
							`lineStyle()` method is set differently
						   (the images are scaled by 200%, to emphasize the
							difference):

							![pixelHinting false and pixelHinting true](/images/lineStyle_pixelHinting.jpg)

							If a value is not supplied, the line does not use
							pixel hinting.
		@param scaleMode   (Not supported in Flash Lite 4) A value from the
							LineScaleMode class that specifies which scale mode to
							use:

							 *  `LineScaleMode.NORMAL` - Always
							scale the line thickness when the object is scaled
						   (the default).
							 *  `LineScaleMode.NONE` - Never scale
							the line thickness.
							 *  `LineScaleMode.VERTICAL` - Do not
							scale the line thickness if the object is scaled
							vertically _only_. For example, consider the
							following circles, drawn with a one-pixel line, and
							each with the `scaleMode` parameter set to
							`LineScaleMode.VERTICAL`. The circle on the
							left is scaled vertically only, and the circle on the
							right is scaled both vertically and horizontally:

							![A circle scaled vertically, and a circle scaled both vertically and horizontally.](/images/LineScaleMode_VERTICAL.jpg)

							 *  `LineScaleMode.HORIZONTAL` - Do not
							scale the line thickness if the object is scaled
							horizontally _only_. For example, consider the
							following circles, drawn with a one-pixel line, and
							each with the `scaleMode` parameter set to
							`LineScaleMode.HORIZONTAL`. The circle on
							the left is scaled horizontally only, and the circle
							on the right is scaled both vertically and
							horizontally:

							![A circle scaled horizontally, and a circle scaled both vertically and horizontally.](/images/LineScaleMode_HORIZONTAL.jpg)

		@param caps        (Not supported in Flash Lite 4) A value from the
							CapsStyle class that specifies the type of caps at the
							end of lines. Valid values are:
							`CapsStyle.NONE`,
							`CapsStyle.ROUND`, and
							`CapsStyle.SQUARE`. If a value is not
							indicated, Flash uses round caps.

							For example, the following illustrations show the
							different `capsStyle` settings. For each
							setting, the illustration shows a blue line with a
							thickness of 30(for which the `capsStyle`
							applies), and a superimposed black line with a
							thickness of 1(for which no `capsStyle`
							applies):

							![NONE, ROUND, and SQUARE](/images/linecap.jpg)

		@param joints      (Not supported in Flash Lite 4) A value from the
							JointStyle class that specifies the type of joint
							appearance used at angles. Valid values are:
							`JointStyle.BEVEL`,
							`JointStyle.MITER`, and
							`JointStyle.ROUND`. If a value is not
							indicated, Flash uses round joints.

							For example, the following illustrations show the
							different `joints` settings. For each
							setting, the illustration shows an angled blue line
							with a thickness of 30(for which the
							`jointStyle` applies), and a superimposed
							angled black line with a thickness of 1(for which no
							`jointStyle` applies):

							![MITER, ROUND, and BEVEL](/images/linejoin.jpg)

							**Note:** For `joints` set to
							`JointStyle.MITER`, you can use the
							`miterLimit` parameter to limit the length
							of the miter.
		@param miterLimit  (Not supported in Flash Lite 4) A number that
							indicates the limit at which a miter is cut off. Valid
							values range from 1 to 255(and values outside that
							range are rounded to 1 or 255). This value is only
							used if the `jointStyle` is set to
							`"miter"`. The `miterLimit`
							value represents the length that a miter can extend
							beyond the point at which the lines meet to form a
							joint. The value expresses a factor of the line
							`thickness`. For example, with a
							`miterLimit` factor of 2.5 and a
							`thickness` of 10 pixels, the miter is cut
							off at 25 pixels.

							For example, consider the following angled lines,
							each drawn with a `thickness` of 20, but
							with `miterLimit` set to 1, 2, and 4.
							Superimposed are black reference lines showing the
							meeting points of the joints:

							![lines with miterLimit set to 1, 2, and 4](/images/miterLimit.jpg)

							Notice that a given `miterLimit` value
							has a specific maximum angle for which the miter is
							cut off. The following table lists some examples:

							| miterLimit value: | Angles smaller than this are cut off: |
							| --- | --- |
							| 1.414 | 90 degrees |
							| 2 | 60 degrees |
							| 4 | 30 degrees |
							| 8 | 15 degrees |

	**/
	public function lineStyle(thickness:Null<Float> = null, color:Int = 0, alpha:Float = 1, pixelHinting:Bool = false,
			scaleMode:LineScaleMode = LineScaleMode.NORMAL, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void
	{
		if (thickness != null)
		{
			if (joints == JointStyle.MITER)
			{
				if (thickness > __strokePadding) __strokePadding = Math.ceil(thickness);
			}
			else
			{
				if (thickness / 2 > __strokePadding) __strokePadding = Math.ceil(thickness / 2);
			}
		}

		__commands.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

		if (thickness != null) __visible = true;
	}

	/**
		Draws a line using the current line style from the current drawing
		position to(`x`, `y`); the current drawing position
		is then set to(`x`, `y`). If the display object in
		which you are drawing contains content that was created with the Flash
		drawing tools, calls to the `lineTo()` method are drawn
		underneath the content. If you call `lineTo()` before any calls
		to the `moveTo()` method, the default position for the current
		drawing is(_0, 0_). If any of the parameters are missing, this
		method fails and the current drawing position is not changed.

		@param x A number that indicates the horizontal position relative to the
				 registration point of the parent display object(in pixels).
		@param y A number that indicates the vertical position relative to the
				 registration point of the parent display object(in pixels).
	**/
	public function lineTo(x:Float, y:Float):Void
	{
		if (!Math.isFinite(x) || !Math.isFinite(y))
		{
			return;
		}

		// TODO: Should we consider the origin instead, instead of inflating in all directions?

		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding, __positionY + __strokePadding);

		__positionX = x;
		__positionY = y;

		__inflateBounds(__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds(__positionX + __strokePadding * 2, __positionY + __strokePadding);

		__commands.lineTo(x, y);

		__dirty = true;
	}

	/**
		Moves the current drawing position to(`x`, `y`). If
		any of the parameters are missing, this method fails and the current
		drawing position is not changed.

		@param x A number that indicates the horizontal position relative to the
				 registration point of the parent display object(in pixels).
		@param y A number that indicates the vertical position relative to the
				 registration point of the parent display object(in pixels).
	**/
	public function moveTo(x:Float, y:Float):Void
	{
		__positionX = x;
		__positionY = y;

		__commands.moveTo(x, y);
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:dox(hide) @:noCompletion public function overrideBlendMode(blendMode:BlendMode):Void
	{
		if (blendMode == null) blendMode = NORMAL;
		__commands.overrideBlendMode(blendMode);
	}

	/**
		Queries a Sprite or Shape object (and optionally, its children) for its vector
		graphics content. The result is a Vector of IGraphicsData objects. Transformations
		are applied to the display object before the query, so the returned paths are all
		in the same coordinate space. Coordinates in the result data set are relative to
		the stage, not the display object being sampled.

		The result includes the following types of objects, with the specified limitations:

		* GraphicsSolidFill
		* GraphicsGradientFill
			* All properties of the gradient fill are returned by `readGraphicsData()`.
			* The matrix returned is close to, but not exactly the same as, the input
			matrix.
		* GraphicsEndFill
		* GraphicsBitmapFill
			* The matrix returned is close to, but not exactly the same as, the input
			matrix.
			* `repeat` is always `true`.
			* `smooth` is always `false`.
		* GraphicsStroke
			* `thickness` is supported.
			* `fill` supports GraphicsSolidFill, GraphicsGradientFill, and GraphicsBitmapFill
			as described previously
			* All other properties have default values.
		* GraphicsPath
			* The only supported commands are `MOVE_TO`, `CURVE_TO`, and `LINE_TO`.

		The following visual elements and transformations can't be represented and are not
		included in the result:

		* Masks
		* Text, with one exception: Static text that is defined with anti-alias type
		"anti-alias for animation" is rendered as vector shapes so it is included in the
		result.
		* Shader fills
		* Blend modes
		* 9-slice scaling
		* Triangles (created with the `drawTriangles()` method)
		* Opaque background
		* `scrollRect` settings
		* 2.5D transformations
		* Non-visible objects (objects whose `visible` property is `false`)

		@param	recurse	whether the runtime should also query display object children of
		the current display object. A recursive query can take more time and memory to
		execute. The results are returned in a single flattened result set, not separated
		by display object.
		@returns	A Vector of IGraphicsData objects representing the vector graphics
		content of the related display object
	**/
	public function readGraphicsData(recurse:Bool = true):Vector<IGraphicsData>
	{
		var graphicsData = new Vector<IGraphicsData>();
		__owner.__readGraphicsData(graphicsData, recurse);
		return graphicsData;
	}

	@:noCompletion
	private #if !js inline #end function __calculateBezierCubicPoint(t:Float, p1:Float, p2:Float, p3:Float, p4:Float):Float
	{
		var iT = 1 - t;
		return p1 * (iT * iT * iT) + 3 * p2 * t * (iT * iT) + 3 * p3 * iT * (t * t) + p4 * (t * t * t);
	}

	@:noCompletion
	private #if !js inline #end function __calculateBezierQuadPoint(t:Float, p1:Float, p2:Float, p3:Float):Float
	{
		var iT = 1 - t;
		return iT * iT * p1 + 2 * iT * t * p2 + t * t * p3;
	}

	@:noCompletion private function __cleanup():Void
	{
		#if (js && html5)
		if (__bounds != null && __canvas != null)
		{
			__dirty = true;
			__transformDirty = true;
		}
		#else
		if (__bounds != null)
		{
			__dirty = true;
			__transformDirty = true;
		}
		#end

		__bitmap = null;

		#if (js && html5)
		__canvas = null;
		__context = null;
		#else
		__cairo = null;
		#end
	}

	@:noCompletion private function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__bounds == null) return;

		var bounds = Rectangle.__pool.get();
		__bounds.__transform(bounds, matrix);
		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release(bounds);
	}

	@:noCompletion private function __hitTest(x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool
	{
		if (__bounds == null) return false;

		var px = matrix.__transformInverseX(x, y);
		var py = matrix.__transformInverseY(x, y);

		if (px > __bounds.x && py > __bounds.y && __bounds.contains(px, py))
		{
			if (shapeFlag)
			{
				#if (js && html5)
				return CanvasGraphics.hitTest(this, px, py);
				#elseif (lime_cffi)
				return CairoGraphics.hitTest(this, px, py);
				#end
			}

			return true;
		}

		return false;
	}

	@:noCompletion private function __inflateBounds(x:Float, y:Float):Void
	{
		if (__bounds == null)
		{
			__bounds = new Rectangle(x, y, 0, 0);
			__transformDirty = true;
			return;
		}

		if (x < __bounds.x)
		{
			__bounds.width += __bounds.x - x;
			__bounds.x = x;
			__transformDirty = true;
		}

		if (y < __bounds.y)
		{
			__bounds.height += __bounds.y - y;
			__bounds.y = y;
			__transformDirty = true;
		}

		if (x > __bounds.x + __bounds.width)
		{
			__bounds.width = x - __bounds.x;
		}

		if (y > __bounds.y + __bounds.height)
		{
			__bounds.height = y - __bounds.y;
		}
	}

	@:noCompletion private function __readGraphicsData(graphicsData:Vector<IGraphicsData>):Void
	{
		var data = new DrawCommandReader(__commands);
		var path = null, stroke;

		for (type in __commands.types)
		{
			switch (type)
			{
				case CUBIC_CURVE_TO, CURVE_TO, LINE_TO, MOVE_TO, DRAW_CIRCLE, DRAW_ELLIPSE, DRAW_RECT, DRAW_ROUND_RECT:
					if (path == null)
					{
						path = new GraphicsPath();
					}

				default:
					if (path != null)
					{
						graphicsData.push(path);
						path = null;
					}
			}

			switch (type)
			{
				case CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					path.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);

				case CURVE_TO:
					var c = data.readCurveTo();
					path.curveTo(c.controlX, c.controlY, c.anchorX, c.anchorY);

				case LINE_TO:
					var c = data.readLineTo();
					path.lineTo(c.x, c.y);

				case MOVE_TO:
					var c = data.readMoveTo();
					path.moveTo(c.x, c.y);

				case DRAW_CIRCLE:
					var c = data.readDrawCircle();
					path.__drawCircle(c.x, c.y, c.radius);

				case DRAW_ELLIPSE:
					var c = data.readDrawEllipse();
					path.__drawEllipse(c.x, c.y, c.width, c.height);

				case DRAW_RECT:
					var c = data.readDrawRect();
					path.__drawRect(c.x, c.y, c.width, c.height);

				case DRAW_ROUND_RECT:
					var c = data.readDrawRoundRect();
					path.__drawRoundRect(c.x, c.y, c.width, c.height, c.ellipseWidth, c.ellipseHeight != null ? c.ellipseHeight : c.ellipseWidth);

				case LINE_GRADIENT_STYLE:
					// TODO

					var c = data.readLineGradientStyle();
				// stroke = new GraphicsStroke (c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				// stroke.fill = new GraphicsGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
				// graphicsData.push (stroke);

				case LINE_BITMAP_STYLE:
					// TODO

					var c = data.readLineBitmapStyle();
					path = null;
				// stroke = new GraphicsStroke (c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
				// stroke.fill = new GraphicsBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
				// graphicsData.push (stroke);

				case LINE_STYLE:
					var c = data.readLineStyle();
					stroke = new GraphicsStroke(c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
					stroke.fill = new GraphicsSolidFill(c.color, c.alpha);
					graphicsData.push(stroke);

				case END_FILL:
					data.readEndFill();
					graphicsData.push(new GraphicsEndFill());

				case BEGIN_BITMAP_FILL:
					var c = data.readBeginBitmapFill();
					graphicsData.push(new GraphicsBitmapFill(c.bitmap, c.matrix, c.repeat, c.smooth));

				case BEGIN_FILL:
					var c = data.readBeginFill();
					graphicsData.push(new GraphicsSolidFill(c.color, 1));

				case BEGIN_GRADIENT_FILL:
					var c = data.readBeginGradientFill();
					graphicsData.push(new GraphicsGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod,
						c.focalPointRatio));

				case BEGIN_SHADER_FILL:

				default:
					data.skip(type);
			}
		}

		if (path != null)
		{
			graphicsData.push(path);
		}
	}

	@:noCompletion private function __update(displayMatrix:Matrix):Void
	{
		if (__bounds == null || __bounds.width <= 0 || __bounds.height <= 0) return;

		var parentTransform = __owner.__renderTransform;
		var scaleX = 1.0, scaleY = 1.0;

		if (parentTransform != null)
		{
			if (parentTransform.b == 0)
			{
				scaleX = Math.abs(parentTransform.a);
			}
			else
			{
				scaleX = Math.sqrt(parentTransform.a * parentTransform.a + parentTransform.b * parentTransform.b);
			}

			if (parentTransform.c == 0)
			{
				scaleY = Math.abs(parentTransform.d);
			}
			else
			{
				scaleY = Math.sqrt(parentTransform.c * parentTransform.c + parentTransform.d * parentTransform.d);
			}
		}
		else
		{
			return;
		}

		if (displayMatrix != null)
		{
			if (displayMatrix.b == 0)
			{
				scaleX *= displayMatrix.a;
			}
			else
			{
				scaleX *= Math.sqrt(displayMatrix.a * displayMatrix.a + displayMatrix.b * displayMatrix.b);
			}

			if (displayMatrix.c == 0)
			{
				scaleY *= displayMatrix.d;
			}
			else
			{
				scaleY *= Math.sqrt(displayMatrix.c * displayMatrix.c + displayMatrix.d * displayMatrix.d);
			}
		}

		#if openfl_disable_graphics_upscaling
		if (scaleX > 1) scaleX = 1;
		if (scaleY > 1) scaleY = 1;
		#end

		var width = __bounds.width * scaleX;
		var height = __bounds.height * scaleY;

		if (width < 1 || height < 1)
		{
			if (__width >= 1 || __height >= 1) __dirty = true;
			__width = 0;
			__height = 0;
			return;
		}

		if (maxTextureWidth != null && width > maxTextureWidth)
		{
			width = maxTextureWidth;
			scaleX = maxTextureWidth / __bounds.width;
		}

		if (maxTextureWidth != null && height > maxTextureHeight)
		{
			height = maxTextureHeight;
			scaleY = maxTextureHeight / __bounds.height;
		}

		__renderTransform.a = width / __bounds.width;
		__renderTransform.d = height / __bounds.height;
		var inverseA = (1 / __renderTransform.a);
		var inverseD = (1 / __renderTransform.d);

		// Inlined & simplified `__worldTransform.concat (parentTransform)` below:
		__worldTransform.a = inverseA * parentTransform.a;
		__worldTransform.b = inverseA * parentTransform.b;
		__worldTransform.c = inverseD * parentTransform.c;
		__worldTransform.d = inverseD * parentTransform.d;

		var x = __bounds.x;
		var y = __bounds.y;
		var tx = x * parentTransform.a + y * parentTransform.c + parentTransform.tx;
		var ty = x * parentTransform.b + y * parentTransform.d + parentTransform.ty;

		// round the world position for crisp graphics rendering
		__worldTransform.tx = Math.fround(tx);
		__worldTransform.ty = Math.fround(ty);

		// Offset the rendering with the subpixel offset removed by Math.round above
		__renderTransform.tx = __worldTransform.__transformInverseX(tx, ty);
		__renderTransform.ty = __worldTransform.__transformInverseY(tx, ty);

		// Calculate the size to contain the graphics and an extra subpixel
		// We used to add tx and ty from __renderTransform instead of 1.0
		// but it improves performance if we keep the size consistent when the
		// extra pixel isn't needed
		var newWidth = Math.ceil(width + 1.0);
		var newHeight = Math.ceil(height + 1.0);

		// Mark dirty if render size changed
		if (newWidth != __width || newHeight != __height)
		{
			#if !openfl_disable_graphics_upscaling
			__dirty = true;
			#end
		}

		__width = newWidth;
		__height = newHeight;
	}

	// Get & Set Methods
	@:noCompletion private function set___dirty(value:Bool):Bool
	{
		if (value && __owner != null)
		{
			@:privateAccess __owner.__setRenderDirty();
		}

		if (value)
		{
			__softwareDirty = true;
			__hardwareDirty = true;
		}

		return __dirty = value;
	}
}
#else
typedef Graphics = flash.display.Graphics;
#end
