package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;

/**
	Defines a line style or stroke.

	Use a GraphicsStroke object with the
	`Graphics.drawGraphicsData()` method. Drawing a GraphicsStroke
	object is the equivalent of calling one of the methods of the Graphics
	class that sets the line style, such as the
	`Graphics.lineStyle()` method, the
	`Graphics.lineBitmapStyle()` method, or the
	`Graphics.lineGradientStyle()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsStroke implements IGraphicsData implements IGraphicsStroke
{
	/**
		Specifies the type of caps at the end of lines. Valid values are:
		`CapsStyle.NONE`, `CapsStyle.ROUND`, and
		`CapsStyle.SQUARE`. If a value is not indicated, Flash uses
		round caps.

		For example, the following illustrations show the different
		`capsStyle` settings. For each setting, the illustration shows
		a blue line with a thickness of 30(for which the `capsStyle`
		applies), and a superimposed black line with a thickness of 1(for which
		no `capsStyle` applies):
	**/
	public var caps:CapsStyle;

	/**
		Specifies the instance containing data for filling a stroke. An
		IGraphicsFill instance can represent a series of fill commands.
	**/
	public var fill:IGraphicsFill;

	/**
		Specifies the type of joint appearance used at angles. Valid values are:
		`JointStyle.BEVEL`, `JointStyle.MITER`, and
		`JointStyle.ROUND`. If a value is not indicated, Flash uses
		round joints.

		For example, the following illustrations show the different
		`joints` settings. For each setting, the illustration shows an
		angled blue line with a thickness of 30(for which the
		`jointStyle` applies), and a superimposed angled black line
		with a thickness of 1(for which no `jointStyle` applies):

		**Note:** For `joints` set to
		`JointStyle.MITER`, you can use the `miterLimit`
		parameter to limit the length of the miter.
	**/
	public var joints:JointStyle;

	/**
		Indicates the limit at which a miter is cut off. Valid values range from 1
		to 255(and values outside that range are rounded to 1 or 255). This value
		is only used if the `jointStyle` is set to
		`"miter"`. The `miterLimit` value represents the
		length that a miter can extend beyond the point at which the lines meet to
		form a joint. The value expresses a factor of the line
		`thickness`. For example, with a `miterLimit` factor
		of 2.5 and a `thickness` of 10 pixels, the miter is cut off at
		25 pixels.

		For example, consider the following angled lines, each drawn with a
		`thickness` of 20, but with `miterLimit` set to 1,
		2, and 4. Superimposed are black reference lines showing the meeting
		points of the joints:

		Notice that a given `miterLimit` value has a specific
		maximum angle for which the miter is cut off. The following table lists
		some examples:
	**/
	public var miterLimit:Float;

	/**
		Specifies whether to hint strokes to full pixels. This affects both the
		position of anchors of a curve and the line stroke size itself. With
		`pixelHinting` set to `true`, Flash Player hints
		line widths to full pixel widths. With `pixelHinting` set to
		`false`, disjoints can appear for curves and straight lines.
		For example, the following illustrations show how Flash Player renders two
		rounded rectangles that are identical, except that the
		`pixelHinting` parameter used in the `lineStyle()`
		method is set differently(the images are scaled by 200%, to emphasize the
		difference):
	**/
	public var pixelHinting:Bool;

	/**
		Specifies the stroke thickness scaling. Valid values are:

		* `LineScaleMode.NORMAL` - Always scale the line thickness
		when the object is scaled(the default).
		* `LineScaleMode.NONE` - Never scale the line thickness.

		* `LineScaleMode.VERTICAL` - Do not scale the line
		thickness if the object is scaled vertically _only_. For example,
		consider the following circles, drawn with a one-pixel line, and each with
		the `scaleMode` parameter set to
		`LineScaleMode.VERTICAL`. The circle on the left is scaled
		vertically only, and the circle on the right is scaled both vertically and
		horizontally:
		* `LineScaleMode.HORIZONTAL` - Do not scale the line
		thickness if the object is scaled horizontally _only_. For example,
		consider the following circles, drawn with a one-pixel line, and each with
		the `scaleMode` parameter set to
		`LineScaleMode.HORIZONTAL`. The circle on the left is scaled
		horizontally only, and the circle on the right is scaled both vertically
		and horizontally:

	**/
	public var scaleMode:LineScaleMode;

	/**
		Indicates the thickness of the line in points; valid values are 0-255. If
		a number is not specified, or if the parameter is undefined, a line is not
		drawn. If a value of less than 0 is passed, the default is 0. The value 0
		indicates hairline thickness; the maximum thickness is 255. If a value
		greater than 255 is passed, the default is 255.
	**/
	public var thickness:Float;

	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;

	/**
		Creates a new GraphicsStroke object.

		@param pixelHinting A Boolean value that specifies whether to hint strokes
							to full pixels. This affects both the position of
							anchors of a curve and the line stroke size itself.
							With `pixelHinting` set to
							`true`, Flash Player hints line widths to
							full pixel widths. With `pixelHinting` set
							to `false`, disjoints can appear for curves
							and straight lines. For example, the following
							illustrations show how Flash Player renders two
							rounded rectangles that are identical, except that the
							`pixelHinting` parameter used in the
							`lineStyle()` method is set differently
						   (the images are scaled by 200%, to emphasize the
							difference):

							If a value is not supplied, the line does not use
							pixel hinting.
		@param scaleMode    A value from the LineScaleMode class that specifies
							which scale mode to use:

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

							 *  `LineScaleMode.HORIZONTAL` - Do not
							scale the line thickness if the object is scaled
							horizontally _only_. For example, consider the
							following circles, drawn with a one-pixel line, and
							each with the `scaleMode` parameter set to
							`LineScaleMode.HORIZONTAL`. The circle on
							the left is scaled horizontally only, and the circle
							on the right is scaled both vertically and
							horizontally:

		@param caps         A value from the CapsStyle class that specifies the
							type of caps at the end of lines. Valid values are:
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
		@param joints       A value from the JointStyle class that specifies the
							type of joint appearance used at angles. Valid values
							are: `JointStyle.BEVEL`,
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

							**Note:** For `joints` set to
							`JointStyle.MITER`, you can use the
							`miterLimit` parameter to limit the length
							of the miter.
	**/
	public function new(thickness:Null<Float> = null, pixelHinting:Bool = false, scaleMode:LineScaleMode = LineScaleMode.NORMAL,
			caps:CapsStyle = CapsStyle.NONE, joints:JointStyle = JointStyle.ROUND, miterLimit:Float = 3, fill:IGraphicsFill = null)
	{
		if (thickness == null) thickness = Math.NaN;

		this.caps = caps;
		this.fill = fill;
		this.joints = joints;
		this.miterLimit = miterLimit;
		this.pixelHinting = pixelHinting;
		this.scaleMode = scaleMode;
		this.thickness = thickness;
		this.__graphicsDataType = STROKE;
	}
}
#else
typedef GraphicsStroke = flash.display.GraphicsStroke;
#end
