import Context3DBuffer from "../_internal/renderer/context3D/Context3DBuffer";
import CanvasGraphics from "../_internal/renderer/canvas/CanvasGraphics";
import DisplayObjectRenderData from "../_internal/renderer/DisplayObjectRenderData";
import DrawCommandBuffer from "../_internal/renderer/DrawCommandBuffer";
import DrawCommandReader from "../_internal/renderer/DrawCommandReader";
import DrawCommandType from "../_internal/renderer/DrawCommandType";
import GraphicsDataType from "../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../_internal/renderer/GraphicsFillType";
import ShaderBuffer from "../_internal/renderer/ShaderBuffer";
import * as internal from "../_internal/utils/InternalAccess";
import ObjectPool from "../_internal/utils/ObjectPool";
import BitmapData from "../display/BitmapData";
import BlendMode from "../display/BlendMode";
import CapsStyle from "../display/CapsStyle";
import DisplayObject from "../display/DisplayObject";
import GraphicsBitmapFill from "../display/GraphicsBitmapFill";
import GraphicsEndFill from "../display/GraphicsEndFill";
import GraphicsGradientFill from "../display/GraphicsGradientFill";
import GraphicsPath from "../display/GraphicsPath";
import GraphicsPathCommand from "../display/GraphicsPathCommand";
import GraphicsPathWinding from "../display/GraphicsPathWinding";
import GraphicsQuadPath from "../display/GraphicsQuadPath";
import GraphicsShader from "../display/GraphicsShader";
import GraphicsShaderFill from "../display/GraphicsShaderFill";
import GraphicsSolidFill from "../display/GraphicsSolidFill";
import GraphicsStroke from "../display/GraphicsStroke";
import GraphicsTrianglePath from "../display/GraphicsTrianglePath";
import IGraphicsData from "../display/IGraphicsData";
import InterpolationMethod from "../display/InterpolationMethod";
import JointStyle from "../display/JointStyle";
import LineScaleMode from "../display/LineScaleMode";
import GradientType from "../display/GradientType";
import Shader from "../display/Shader";
import SpreadMethod from "../display/SpreadMethod";
import TriangleCulling from "../display/TriangleCulling";
import IndexBuffer3D from "../display3D/IndexBuffer3D";
import VertexBuffer3D from "../display3D/VertexBuffer3D";
import ArgumentError from "../errors/ArgumentError";
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";
import Vector from "../Vector";
// import openfl._internal.renderer.canvas.CanvasGraphics;

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
export default class Graphics
{
	protected static maxTextureHeight: null | number = null;
	protected static maxTextureWidth: null | number = null;

	protected __bitmap: BitmapData;
	protected __bounds: Rectangle;
	protected __commands: DrawCommandBuffer;
	protected __dirty: boolean;
	protected __hardwareDirty: boolean;
	protected __height: number;
	protected __managed: boolean;
	protected __positionX: number;
	protected __positionY: number;
	protected __renderData: DisplayObjectRenderData;
	protected __renderTransform: Matrix;
	protected __shaderBufferPool: ObjectPool<ShaderBuffer>;
	protected __softwareDirty: boolean;
	protected __strokePadding: number;
	protected __transformDirty: boolean;
	protected __usedShaderBuffers: Array<ShaderBuffer>;
	protected __visible: boolean;
	// private __cachedTexture:RenderTexture;
	protected __owner: DisplayObject;
	protected __width: number;
	protected __worldTransform: Matrix;

	protected constructor(owner: DisplayObject)
	{
		this.__owner = owner;

		this.__commands = new DrawCommandBuffer();
		this.__strokePadding = 0;
		this.__positionX = 0;
		this.__positionY = 0;
		this.__renderTransform = new Matrix();
		this.__usedShaderBuffers = new Array<ShaderBuffer>();
		this.__worldTransform = new Matrix();
		this.__width = 0;
		this.__height = 0;

		this.__renderData = new DisplayObjectRenderData();
		this.__shaderBufferPool = new ObjectPool<ShaderBuffer>(() => new ShaderBuffer());

		this.__setDirty();
		moveTo(0, 0);
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
	public beginBitmapFill(bitmap: BitmapData, matrix: Matrix = null, repeat: boolean = true, smooth: boolean = false): void
	{
		this.__commands.beginBitmapFill(bitmap, matrix != null ? matrix.clone() : null, repeat, smooth);

		this.__visible = true;
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
	public beginFill(color: number = 0, alpha: number = 1): void
	{
		this.__commands.beginFill(color & 0xFFFFFF, alpha);

		if (alpha > 0) this.__visible = true;
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
	public beginGradientFill(type: GradientType, colors: Array<number>, alphas: Array<number>, ratios: Array<number>, matrix: Matrix = null,
		spreadMethod: SpreadMethod = SpreadMethod.PAD, interpolationMethod: InterpolationMethod = InterpolationMethod.RGB, focalPointRatio: number = 0): void
	{
		if (colors == null || colors.length == 0) return;

		if (alphas == null)
		{
			alphas = [];

			for (let i = 0; i < colors.length; i++)
			{
				alphas.push(1);
			}
		}

		if (ratios == null)
		{
			ratios = [];

			for (let i = 0; i < colors.length; i++)
			{
				ratios.push(Math.ceil((i / colors.length) * 255));
			}
		}

		if (alphas.length < colors.length || ratios.length < colors.length) return;

		this.__commands.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

		for (let alpha of alphas)
		{
			if (alpha > 0)
			{
				this.__visible = true;
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
	public beginShaderFill(shader: Shader, matrix: Matrix = null): void
	{
		if (shader != null)
		{
			var shaderBuffer = this.__shaderBufferPool.get();
			this.__usedShaderBuffers.push(shaderBuffer);
			shaderBuffer.update(shader as GraphicsShader);

			this.__commands.beginShaderFill(shaderBuffer);
		}
	}

	/**
		Clears the graphics that were drawn to this Graphics object, and resets
		fill and line style settings.

	**/
	public clear(): void
	{
		for (let shaderBuffer of this.__usedShaderBuffers)
		{
			this.__shaderBufferPool.release(shaderBuffer);
		}

		this.__usedShaderBuffers.length = 0;
		this.__commands.clear();
		this.__strokePadding = 0;

		if (this.__bounds != null)
		{
			this.__setDirty();
			this.__transformDirty = true;
			this.__bounds = null;
			(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
		}

		this.__visible = false;
		this.__positionX = 0;
		this.__positionY = 0;

		moveTo(0, 0);
	}

	/**
		Copies all of drawing commands from the source Graphics object into
		the calling Graphics object.

		@param sourceGraphics The Graphics object from which to copy the
							  drawing commands.
	**/
	public copyFrom(sourceGraphics: Graphics): void
	{
		this.__bounds = sourceGraphics.__bounds != null ? sourceGraphics.__bounds.clone() : null;
		(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
		this.__commands = sourceGraphics.__commands.copy();
		this.__setDirty();
		this.__strokePadding = sourceGraphics.__strokePadding;
		this.__positionX = sourceGraphics.__positionX;
		this.__positionY = sourceGraphics.__positionY;
		this.__transformDirty = true;
		this.__visible = sourceGraphics.__visible;
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
	public cubicCurveTo(controlX1: number, controlY1: number, controlX2: number, controlY2: number, anchorX: number, anchorY: number): void
	{
		this.__inflateBounds(this.__positionX - this.__strokePadding, this.__positionY - this.__strokePadding);
		this.__inflateBounds(this.__positionX + this.__strokePadding, this.__positionY + this.__strokePadding);

		var ix1, iy1, ix2, iy2;

		ix1 = anchorX;
		ix2 = anchorX;

		if (!(((controlX1 < anchorX && controlX1 > this.__positionX) || (controlX1 > anchorX && controlX1 < this.__positionX))
			&& ((controlX2 < anchorX && controlX2 > this.__positionX) || (controlX2 > anchorX && controlX2 < this.__positionX))))
		{
			var u = (2 * this.__positionX - 4 * controlX1 + 2 * controlX2);
			var v = (controlX1 - this.__positionX);
			var w = (-this.__positionX + 3 * controlX1 + anchorX - 3 * controlX2);

			var t1 = (-u + Math.sqrt(u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt(u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1)
			{
				ix1 = this.__calculateBezierCubicPoint(t1, this.__positionX, controlX1, controlX2, anchorX);
			}

			if (t2 > 0 && t2 < 1)
			{
				ix2 = this.__calculateBezierCubicPoint(t2, this.__positionX, controlX1, controlX2, anchorX);
			}
		}

		iy1 = anchorY;
		iy2 = anchorY;

		if (!(((controlY1 < anchorY && controlY1 > this.__positionX) || (controlY1 > anchorY && controlY1 < this.__positionX))
			&& ((controlY2 < anchorY && controlY2 > this.__positionX) || (controlY2 > anchorY && controlY2 < this.__positionX))))
		{
			var u = (2 * this.__positionX - 4 * controlY1 + 2 * controlY2);
			var v = (controlY1 - this.__positionX);
			var w = (-this.__positionX + 3 * controlY1 + anchorY - 3 * controlY2);

			var t1 = (-u + Math.sqrt(u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt(u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1)
			{
				iy1 = this.__calculateBezierCubicPoint(t1, this.__positionX, controlY1, controlY2, anchorY);
			}

			if (t2 > 0 && t2 < 1)
			{
				iy2 = this.__calculateBezierCubicPoint(t2, this.__positionX, controlY1, controlY2, anchorY);
			}
		}

		this.__inflateBounds(ix1 - this.__strokePadding, iy1 - this.__strokePadding);
		this.__inflateBounds(ix1 + this.__strokePadding, iy1 + this.__strokePadding);
		this.__inflateBounds(ix2 - this.__strokePadding, iy2 - this.__strokePadding);
		this.__inflateBounds(ix2 + this.__strokePadding, iy2 + this.__strokePadding);

		this.__positionX = anchorX;
		this.__positionY = anchorY;

		this.__inflateBounds(this.__positionX - this.__strokePadding, this.__positionY - this.__strokePadding);
		this.__inflateBounds(this.__positionX + this.__strokePadding, this.__positionY + this.__strokePadding);

		this.__commands.cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);

		this.__setDirty();
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
	public curveTo(controlX: number, controlY: number, anchorX: number, anchorY: number): void
	{
		this.__inflateBounds(this.__positionX - this.__strokePadding, this.__positionY - this.__strokePadding);
		this.__inflateBounds(this.__positionX + this.__strokePadding, this.__positionY + this.__strokePadding);

		var ix, iy;

		if ((controlX < anchorX && controlX > this.__positionX) || (controlX > anchorX && controlX < this.__positionX))
		{
			ix = anchorX;
		}
		else
		{
			var tx = ((this.__positionX - controlX) / (this.__positionX - 2 * controlX + anchorX));
			ix = this.__calculateBezierQuadPoint(tx, this.__positionX, controlX, anchorX);
		}

		if ((controlY < anchorY && controlY > this.__positionY) || (controlY > anchorY && controlY < this.__positionY))
		{
			iy = anchorY;
		}
		else
		{
			var ty = ((this.__positionY - controlY) / (this.__positionY - (2 * controlY) + anchorY));
			iy = this.__calculateBezierQuadPoint(ty, this.__positionY, controlY, anchorY);
		}

		this.__inflateBounds(ix - this.__strokePadding, iy - this.__strokePadding);
		this.__inflateBounds(ix + this.__strokePadding, iy + this.__strokePadding);

		this.__positionX = anchorX;
		this.__positionY = anchorY;

		this.__commands.curveTo(controlX, controlY, anchorX, anchorY);

		this.__setDirty();
	}

	/**
		Draws a circle. Set the line style, fill, or both before you call the
		`drawCircle()` method, by calling the `linestyle()`,
		`lineGradientStyle()`, `beginFill()`,
		`beginGradientFill()`, or `beginBitmapFill()`
		method.

		@param x      The _x_ location of the center of the circle relative
					  to the registration point of the parent display object(in
					  pixels).
		@param y      The _y_ location of the center of the circle relative
					  to the registration point of the parent display object(in
					  pixels).
		@param radius The radius of the circle(in pixels).
	**/
	public drawCircle(x: number, y: number, radius: number): void
	{
		if (radius <= 0) return;

		this.__inflateBounds(x - radius - this.__strokePadding, y - radius - this.__strokePadding);
		this.__inflateBounds(x + radius + this.__strokePadding, y + radius + this.__strokePadding);

		this.__commands.drawCircle(x, y, radius);

		this.__setDirty();
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
	public drawEllipse(x: number, y: number, width: number, height: number): void
	{
		if (width <= 0 || height <= 0) return;

		this.__inflateBounds(x - this.__strokePadding, y - this.__strokePadding);
		this.__inflateBounds(x + width + this.__strokePadding, y + height + this.__strokePadding);

		this.__commands.drawEllipse(x, y, width, height);

		this.__setDirty();
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
	public drawGraphicsData(graphicsData: Vector<IGraphicsData>): void
	{
		var fill: GraphicsSolidFill;
		var bitmapFill: GraphicsBitmapFill;
		var gradientFill: GraphicsGradientFill;
		var shaderFill: GraphicsShaderFill;
		var stroke: GraphicsStroke;
		var path: GraphicsPath;
		var trianglePath: GraphicsTrianglePath;
		var quadPath: GraphicsQuadPath;

		for (let graphics of graphicsData)
		{
			switch ((<internal.IGraphicsData>graphics).__graphicsDataType)
			{
				case GraphicsDataType.SOLID:
					fill = graphics as GraphicsSolidFill;
					this.beginFill(fill.color, fill.alpha);
					break;

				case GraphicsDataType.BITMAP:
					bitmapFill = graphics as GraphicsBitmapFill;
					this.beginBitmapFill(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);
					break;

				case GraphicsDataType.GRADIENT:
					gradientFill = graphics as GraphicsGradientFill;
					this.beginGradientFill(gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix,
						gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);
					break;

				case GraphicsDataType.SHADER:
					shaderFill = graphics as GraphicsShaderFill;
					this.beginShaderFill(shaderFill.shader, shaderFill.matrix);
					break;

				case GraphicsDataType.STROKE:
					stroke = graphics as GraphicsStroke;

					if (stroke.fill != null)
					{
						var thickness: null | number = stroke.thickness;

						if (Number.isNaN(thickness))
						{
							thickness = null;
						}

						switch ((<internal.IGraphicsFill><any>stroke.fill).__graphicsFillType)
						{
							case GraphicsFillType.SOLID_FILL:
								fill = stroke.fill as GraphicsSolidFill;
								this.lineStyle(thickness, fill.color, fill.alpha, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints,
									stroke.miterLimit);
								break;

							case GraphicsFillType.BITMAP_FILL:
								bitmapFill = stroke.fill as GraphicsBitmapFill;
								this.lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
								this.lineBitmapStyle(bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);
								break;

							case GraphicsFillType.GRADIENT_FILL:
								gradientFill = stroke.fill as GraphicsGradientFill;
								this.lineStyle(thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);
								this.lineGradientStyle(gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix,
									gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);
								break;

							default:
						}
					}
					else
					{
						this.lineStyle();
					}
					break;

				case GraphicsDataType.PATH:
					path = graphics as GraphicsPath;
					this.drawPath(path.commands, path.data, path.winding);
					break;

				case GraphicsDataType.TRIANGLE_PATH:
					trianglePath = graphics as GraphicsTrianglePath;
					this.drawTriangles(trianglePath.vertices, trianglePath.indices, trianglePath.uvtData, trianglePath.culling);
					break;

				case GraphicsDataType.END:
					this.endFill();
					break;

				case GraphicsDataType.QUAD_PATH:
					quadPath = graphics as GraphicsQuadPath;
					this.drawQuads(quadPath.rects, quadPath.indices, quadPath.transforms);
					break;
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
	public drawPath(commands: Vector<number>, data: Vector<number>, winding: GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD): void
	{
		var dataIndex = 0;

		if (winding == GraphicsPathWinding.NON_ZERO) this.__commands.windingNonZero();

		for (let command of commands)
		{
			switch (command)
			{
				case GraphicsPathCommand.MOVE_TO:
					this.moveTo(data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;
					break;

				case GraphicsPathCommand.LINE_TO:
					this.lineTo(data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;
					break;

				case GraphicsPathCommand.WIDE_MOVE_TO:
					this.moveTo(data[dataIndex + 2], data[dataIndex + 3]);
					break;
					dataIndex += 4;
					break;

				case GraphicsPathCommand.WIDE_LINE_TO:
					this.lineTo(data[dataIndex + 2], data[dataIndex + 3]);
					break;
					dataIndex += 4;
					break;

				case GraphicsPathCommand.CURVE_TO:
					this.curveTo(data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3]);
					dataIndex += 4;
					break;

				case GraphicsPathCommand.CUBIC_CURVE_TO:
					this.cubicCurveTo(data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3], data[dataIndex + 4], data[dataIndex + 5]);
					dataIndex += 6;
					break;

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
	public drawQuads(rects: Vector<number>, indices: Vector<number> = null, transforms: Vector<number> = null): void
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

		var tileRect = (<internal.Rectangle><any>Rectangle).__pool.get();
		var tileTransform = (<internal.Matrix><any>Matrix).__pool.get();

		var minX = Number.POSITIVE_INFINITY;
		var minY = Number.POSITIVE_INFINITY;
		var maxX = Number.NEGATIVE_INFINITY;
		var maxY = Number.NEGATIVE_INFINITY;

		var ri, ti;

		for (let i = 0; i < length; i++)
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

			(<internal.Rectangle><any>tileRect).__transform(tileRect, tileTransform);

			if (minX > tileRect.x) minX = tileRect.x;
			if (minY > tileRect.y) minY = tileRect.y;
			if (maxX < tileRect.right) maxX = tileRect.right;
			if (maxY < tileRect.bottom) maxY = tileRect.bottom;
		}

		this.__inflateBounds(minX, minY);
		this.__inflateBounds(maxX, maxY);

		this.__commands.drawQuads(rects, indices, transforms);

		this.__setDirty();
		this.__visible = true;

		(<internal.Rectangle><any>Rectangle).__pool.release(tileRect);
		(<internal.Matrix><any>Matrix).__pool.release(tileTransform);
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
	public drawRect(x: number, y: number, width: number, height: number): void
	{
		if (width == 0 && height == 0) return;

		var xSign = width < 0 ? -1 : 1;
		var ySign = height < 0 ? -1 : 1;

		this.__inflateBounds(x - this.__strokePadding * xSign, y - this.__strokePadding * ySign);
		this.__inflateBounds(x + width + this.__strokePadding * xSign, y + height + this.__strokePadding * ySign);

		this.__commands.drawRect(x, y, width, height);

		this.__setDirty();
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
	public drawRoundRect(x: number, y: number, width: number, height: number, ellipseWidth: number, ellipseHeight: null | number = null): void
	{
		if (width == 0 && height == 0) return;

		var xSign = width < 0 ? -1 : 1;
		var ySign = height < 0 ? -1 : 1;

		this.__inflateBounds(x - this.__strokePadding * xSign, y - this.__strokePadding * ySign);
		this.__inflateBounds(x + width + this.__strokePadding * xSign, y + height + this.__strokePadding * ySign);

		this.__commands.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);

		this.__setDirty();
	}

	/**
		Undocumented method
	**/
	public drawRoundRectComplex(x: number, y: number, width: number, height: number, topLeftRadius: number, topRightRadius: number, bottomLeftRadius: number,
		bottomRightRadius: number): void
	{
		if (width <= 0 || height <= 0) return;

		this.__inflateBounds(x - this.__strokePadding, y - this.__strokePadding);
		this.__inflateBounds(x + width + this.__strokePadding, y + height + this.__strokePadding);

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
		this.moveTo(xw, yh - bottomRightRadius);
		this.curveTo(xw, yh - s, xw - a, yh - a);
		this.curveTo(xw - s, yh, xw - bottomRightRadius, yh);

		a = bottomLeftRadius * anchor;
		s = bottomLeftRadius * control;
		this.lineTo(x + bottomLeftRadius, yh);
		this.curveTo(x + s, yh, x + a, yh - a);
		this.curveTo(x, yh - s, x, yh - bottomLeftRadius);

		a = topLeftRadius * anchor;
		s = topLeftRadius * control;
		this.lineTo(x, y + topLeftRadius);
		this.curveTo(x, y + s, x + a, y + a);
		this.curveTo(x + s, y, x + topLeftRadius, y);

		a = topRightRadius * anchor;
		s = topRightRadius * control;
		this.lineTo(xw - topRightRadius, y);
		this.curveTo(xw - s, y, xw - a, y + a);
		this.curveTo(xw, y + s, xw, y + topRightRadius);
		this.lineTo(xw, yh - bottomRightRadius);

		this.__setDirty();
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
	public drawTriangles(vertices: Vector<number>, indices: Vector<number> = null, uvtData: Vector<number> = null,
		culling: TriangleCulling = TriangleCulling.NONE): void
	{
		if (vertices == null || vertices.length == 0) return;

		var vertLength = Math.floor(vertices.length / 2);

		if (indices == null)
		{
			// TODO: Allow null indices

			if (vertLength % 3 != 0)
			{
				throw new ArgumentError("Not enough vertices to close a triangle.");
			}

			indices = new Vector<number>();

			for (let i = 0; i < vertLength; i++)
			{
				indices.push(i);
			}
		}

		if (culling == null)
		{
			culling = TriangleCulling.NONE;
		}

		var x, y;
		var minX = Number.POSITIVE_INFINITY;
		var minY = Number.POSITIVE_INFINITY;
		var maxX = Number.NEGATIVE_INFINITY;
		var maxY = Number.NEGATIVE_INFINITY;

		for (let i = 0; i < vertLength; i++)
		{
			x = vertices[i * 2];
			y = vertices[i * 2 + 1];

			if (minX > x) minX = x;
			if (minY > y) minY = y;
			if (maxX < x) maxX = x;
			if (maxY < y) maxY = y;
		}

		this.__inflateBounds(minX, minY);
		this.__inflateBounds(maxX, maxY);

		this.__commands.drawTriangles(vertices, indices, uvtData, culling);

		this.__setDirty();
		this.__visible = true;
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
	public endFill(): void
	{
		this.__commands.endFill();
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
	public lineBitmapStyle(bitmap: BitmapData, matrix: Matrix = null, repeat: boolean = true, smooth: boolean = false): void
	{
		this.__commands.lineBitmapStyle(bitmap, matrix != null ? matrix.clone() : null, repeat, smooth);
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
	public lineGradientStyle(type: GradientType, colors: Array<number>, alphas: Array<number>, ratios: Array<number>, matrix: Matrix = null,
		spreadMethod: SpreadMethod = SpreadMethod.PAD, interpolationMethod: InterpolationMethod = InterpolationMethod.RGB, focalPointRatio: number = 0): void
	{
		this.__commands.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
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
	// @:require(flash10) public lineShaderStyle (shader:Shader, ?matrix:Matrix):Void;

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
	public lineStyle(thickness: null | number = null, color: number = 0, alpha: number = 1, pixelHinting: boolean = false,
		scaleMode: LineScaleMode = LineScaleMode.NORMAL, caps: CapsStyle = null, joints: JointStyle = null, miterLimit: number = 3): void
	{
		if (thickness != null)
		{
			if (joints == JointStyle.MITER)
			{
				if (thickness > this.__strokePadding) this.__strokePadding = thickness;
			}
			else
			{
				if (thickness / 2 > this.__strokePadding) this.__strokePadding = thickness / 2;
			}
		}

		this.__commands.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

		if (thickness != null) this.__visible = true;
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
	public lineTo(x: number, y: number): void
	{
		if (!Number.isFinite(x) || !Number.isFinite(y))
		{
			return;
		}

		// TODO: Should we consider the origin instead, instead of inflating in all directions?

		this.__inflateBounds(this.__positionX - this.__strokePadding, this.__positionY - this.__strokePadding);
		this.__inflateBounds(this.__positionX + this.__strokePadding, this.__positionY + this.__strokePadding);

		this.__positionX = x;
		this.__positionY = y;

		this.__inflateBounds(this.__positionX - this.__strokePadding, this.__positionY - this.__strokePadding);
		this.__inflateBounds(this.__positionX + this.__strokePadding * 2, this.__positionY + this.__strokePadding);

		this.__commands.lineTo(x, y);

		this.__setDirty();
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
	public moveTo(x: number, y: number): void
	{
		this.__positionX = x;
		this.__positionY = y;

		this.__commands.moveTo(x, y);
	}

	protected overrideBlendMode(blendMode: BlendMode): void
	{
		if (blendMode == null) blendMode = BlendMode.NORMAL;
		this.__commands.overrideBlendMode(blendMode);
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
	public readGraphicsData(recurse: boolean = true): Vector<IGraphicsData>
	{
		var graphicsData = new Vector<IGraphicsData>();
		(<internal.DisplayObject><any>this.__owner).__readGraphicsData(graphicsData, recurse);
		return graphicsData;
	}

	protected __calculateBezierCubicPoint(t: number, p1: number, p2: number, p3: number, p4: number): number
	{
		var iT = 1 - t;
		return p1 * (iT * iT * iT) + 3 * p2 * t * (iT * iT) + 3 * p3 * iT * (t * t) + p4 * (t * t * t);
	}

	protected __calculateBezierQuadPoint(t: number, p1: number, p2: number, p3: number): number
	{
		var iT = 1 - t;
		return iT * iT * p1 + 2 * iT * t * p2 + t * t * p3;
	}

	protected __cleanup(): void
	{
		if (this.__bounds != null && this.__renderData.canvas != null)
		{
			this.__setDirty();
			this.__transformDirty = true;
		}

		this.__bitmap = null;
		this.__renderData.dispose();
	}

	protected __getBounds(rect: Rectangle, matrix: Matrix): void
	{
		if (this.__bounds == null) return;

		var bounds = (<internal.Rectangle><any>Rectangle).__pool.get();
		(<internal.Rectangle><any>this.__bounds).__transform(bounds, matrix);
		(<internal.Rectangle><any>rect).__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		(<internal.Rectangle><any>Rectangle).__pool.release(bounds);
	}

	protected __hitTest(x: number, y: number, shapeFlag: boolean, matrix: Matrix): boolean
	{
		if (this.__bounds == null) return false;

		var px = (<internal.Matrix><any>matrix).__transformInverseX(x, y);
		var py = (<internal.Matrix><any>matrix).__transformInverseY(x, y);

		if (px > this.__bounds.x && py > this.__bounds.y && this.__bounds.contains(px, py))
		{
			if (shapeFlag)
			{
				return CanvasGraphics.hitTest(this, px, py);
			}

			return true;
		}

		return false;
	}

	protected __inflateBounds(x: number, y: number): void
	{
		if (this.__bounds == null)
		{
			this.__bounds = new Rectangle(x, y, 0, 0);
			(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
			this.__transformDirty = true;
		}
		else
		{
			if (x < this.__bounds.x)
			{
				this.__bounds.width += this.__bounds.x - x;
				this.__bounds.x = x;
				(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
				this.__transformDirty = true;
			}

			if (y < this.__bounds.y)
			{
				this.__bounds.height += this.__bounds.y - y;
				this.__bounds.y = y;
				(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
				this.__transformDirty = true;
			}

			if (x > this.__bounds.x + this.__bounds.width)
			{
				(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
				this.__bounds.width = x - this.__bounds.x;
			}

			if (y > this.__bounds.y + this.__bounds.height)
			{
				(<internal.DisplayObject><any>this.__owner).__localBoundsDirty = true;
				this.__bounds.height = y - this.__bounds.y;
			}
		}
	}

	protected __readGraphicsData(graphicsData: Vector<IGraphicsData>): void
	{
		var data = new DrawCommandReader(this.__commands);
		var path = null, stroke;

		for (let type of this.__commands.types)
		{
			switch (type)
			{
				case DrawCommandType.CUBIC_CURVE_TO:
				case DrawCommandType.CURVE_TO:
				case DrawCommandType.LINE_TO:
				case DrawCommandType.MOVE_TO:
				case DrawCommandType.DRAW_CIRCLE:
				case DrawCommandType.DRAW_ELLIPSE:
				case DrawCommandType.DRAW_RECT:
				case DrawCommandType.DRAW_ROUND_RECT:
					if (path == null)
					{
						path = new GraphicsPath();
					}
					break;

				default:
					if (path != null)
					{
						graphicsData.push(path);
						path = null;
					}
			}

			switch (type)
			{
				case DrawCommandType.CUBIC_CURVE_TO:
					var c = data.readCubicCurveTo();
					path.cubicCurveTo(c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.anchorX, c.anchorY);
					break;

				case DrawCommandType.CURVE_TO:
					var c2 = data.readCurveTo();
					path.curveTo(c2.controlX, c2.controlY, c2.anchorX, c2.anchorY);
					break;

				case DrawCommandType.LINE_TO:
					var c3 = data.readLineTo();
					path.lineTo(c3.x, c3.y);
					break;

				case DrawCommandType.MOVE_TO:
					var c4 = data.readMoveTo();
					path.moveTo(c4.x, c4.y);
					break;

				case DrawCommandType.DRAW_CIRCLE:
					var c5 = data.readDrawCircle();
					path.__drawCircle(c5.x, c5.y, c5.radius);
					break;

				case DrawCommandType.DRAW_ELLIPSE:
					var c6 = data.readDrawEllipse();
					path.__drawEllipse(c6.x, c6.y, c6.width, c6.height);
					break;

				case DrawCommandType.DRAW_RECT:
					var c7 = data.readDrawRect();
					path.__drawRect(c7.x, c7.y, c7.width, c7.height);
					break;

				case DrawCommandType.DRAW_ROUND_RECT:
					var c8 = data.readDrawRoundRect();
					path.__drawRoundRect(c8.x, c8.y, c8.width, c8.height, c8.ellipseWidth, c8.ellipseHeight != null ? c8.ellipseHeight : c8.ellipseWidth);
					break;

				case DrawCommandType.LINE_GRADIENT_STYLE:
					// TODO

					var c9 = data.readLineGradientStyle();
					// stroke = new GraphicsStroke (c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
					// stroke.fill = new GraphicsGradientFill (c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spreadMethod, c.interpolationMethod, c.focalPointRatio);
					// graphicsData.push (stroke);
					break;

				case DrawCommandType.LINE_BITMAP_STYLE:
					// TODO

					var c10 = data.readLineBitmapStyle();
					path = null;
					// stroke = new GraphicsStroke (c.thickness, c.pixelHinting, c.scaleMode, c.caps, c.joints, c.miterLimit);
					// stroke.fill = new GraphicsBitmapFill (c.bitmap, c.matrix, c.repeat, c.smooth);
					// graphicsData.push (stroke);
					break;

				case DrawCommandType.LINE_STYLE:
					var c11 = data.readLineStyle();
					stroke = new GraphicsStroke(c11.thickness, c11.pixelHinting, c11.scaleMode, c11.caps, c11.joints, c11.miterLimit);
					stroke.fill = new GraphicsSolidFill(c11.color, c11.alpha);
					graphicsData.push(stroke);
					break;

				case DrawCommandType.END_FILL:
					data.readEndFill();
					graphicsData.push(new GraphicsEndFill());
					break;

				case DrawCommandType.BEGIN_BITMAP_FILL:
					var c12 = data.readBeginBitmapFill();
					graphicsData.push(new GraphicsBitmapFill(c12.bitmap, c12.matrix, c12.repeat, c12.smooth));
					break;

				case DrawCommandType.BEGIN_FILL:
					var c13 = data.readBeginFill();
					graphicsData.push(new GraphicsSolidFill(c13.color, 1));
					break;

				case DrawCommandType.BEGIN_GRADIENT_FILL:
					var c14 = data.readBeginGradientFill();
					graphicsData.push(new GraphicsGradientFill(c14.type, c14.colors, c14.alphas, c14.ratios, c14.matrix, c14.spreadMethod, c14.interpolationMethod,
						c14.focalPointRatio));
					break;

				// case DrawCommandType.BEGIN_SHADER_FILL:
				// break;

				default:
					data.skip(type);
			}
		}

		if (path != null)
		{
			graphicsData.push(path);
		}
	}

	protected __setDirty(value: boolean = true): void
	{
		if (value && this.__owner != null)
		{
			(<internal.DisplayObject><any>this.__owner).__setRenderDirty();
		}

		if (value)
		{
			this.__softwareDirty = true;
			this.__hardwareDirty = true;
		}

		this.__dirty = true;
	}

	protected __update(displayMatrix: Matrix): void
	{
		if (this.__bounds == null || this.__bounds.width <= 0 || this.__bounds.height <= 0) return;

		var parentTransform = (<internal.DisplayObject><any>this.__owner).__renderTransform;
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

		// #if openfl_disable_graphics_upscaling
		// if (scaleX > 1) scaleX = 1;
		// if (scaleY > 1) scaleY = 1;
		// #end

		var width = this.__bounds.width * scaleX;
		var height = this.__bounds.height * scaleY;

		if (width < 1 || height < 1)
		{
			if (this.__width >= 1 || this.__height >= 1) this.__setDirty();
			this.__width = 0;
			this.__height = 0;
			return;
		}

		if (Graphics.maxTextureWidth != null && width > Graphics.maxTextureWidth)
		{
			width = Graphics.maxTextureWidth;
			scaleX = Graphics.maxTextureWidth / this.__bounds.width;
		}

		if (Graphics.maxTextureWidth != null && height > Graphics.maxTextureHeight)
		{
			height = Graphics.maxTextureHeight;
			scaleY = Graphics.maxTextureHeight / this.__bounds.height;
		}

		this.__renderTransform.a = width / this.__bounds.width;
		this.__renderTransform.d = height / this.__bounds.height;
		var inverseA = (1 / this.__renderTransform.a);
		var inverseD = (1 / this.__renderTransform.d);

		// Inlined & simplified `__worldTransform.concat (parentTransform)` below:
		this.__worldTransform.a = inverseA * parentTransform.a;
		this.__worldTransform.b = inverseA * parentTransform.b;
		this.__worldTransform.c = inverseD * parentTransform.c;
		this.__worldTransform.d = inverseD * parentTransform.d;

		var x = this.__bounds.x;
		var y = this.__bounds.y;
		var tx = x * parentTransform.a + y * parentTransform.c + parentTransform.tx;
		var ty = x * parentTransform.b + y * parentTransform.d + parentTransform.ty;

		// Floor the world position for crisp graphics rendering
		this.__worldTransform.tx = Math.floor(tx);
		this.__worldTransform.ty = Math.floor(ty);

		// Offset the rendering with the subpixel offset removed by Math.floor above
		this.__renderTransform.tx = (<internal.Matrix><any>this.__worldTransform).__transformInverseX(tx, ty);
		this.__renderTransform.ty = (<internal.Matrix><any>this.__worldTransform).__transformInverseY(tx, ty);

		// Calculate the size to contain the graphics and an extra subpixel
		// We used to add tx and ty from __renderTransform instead of 1.0
		// but it improves performance if we keep the size consistent when the
		// extra pixel isn't needed
		var newWidth = Math.ceil(width + 1.0);
		var newHeight = Math.ceil(height + 1.0);

		// Mark dirty if render size changed
		if (newWidth != this.__width || newHeight != this.__height)
		{
			// #if!openfl_disable_graphics_upscaling
			this.__setDirty();
			// #end
		}

		this.__width = newWidth;
		this.__height = newHeight;
	}
}
