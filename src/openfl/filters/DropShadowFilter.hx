package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime._internal.graphics.ImageDataUtil; // TODO

#end

/**
	The DropShadowFilter class lets you add a drop shadow to display objects.
	The shadow algorithm is based on the same box filter that the blur filter
	uses. You have several options for the style of the drop shadow, including
	inner or outer shadow and knockout mode. You can apply the filter to any
	display object(that is, objects that inherit from the DisplayObject
	class), such as MovieClip, SimpleButton, TextField, and Video objects, as
	well as to BitmapData objects.

	The use of filters depends on the object to which you apply the
	filter:


	* To apply filters to display objects use the `filters`
	property(inherited from DisplayObject). Setting the `filters`
	property of an object does not modify the object, and you can remove the
	filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling
	`applyFilter()` on a BitmapData object takes the source
	BitmapData object and the filter object and generates a filtered image as a
	result.


	If you apply a filter to a display object, the value of the
	`cacheAsBitmap` property of the display object is set to
	`true`. If you clear all filters, the original value of
	`cacheAsBitmap` is restored.

	This filter supports Stage scaling. However, it does not support general
	scaling, rotation, and skewing. If the object itself is scaled(if
	`scaleX` and `scaleY` are set to a value other than
	1.0), the filter is not scaled. It is scaled only when the user zooms in on
	the Stage.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. If, for
	example, you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image exceeds the maximum
	dimensions.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:final class DropShadowFilter extends BitmapFilter
{
	/**
		The alpha transparency value for the shadow color. Valid values are 0.0 to
		1.0. For example, .25 sets a transparency value of 25%. The default value
		is 1.0.
	**/
	public var alpha(get, set):Float;

	/**
		The angle of the shadow. Valid values are 0 to 360 degrees(floating
		point). The default value is 45.
	**/
	public var angle(get, set):Float;

	/**
		The amount of horizontal blur. Valid values are 0 to 255.0(floating
		point). The default value is 4.0.
	**/
	public var blurX(get, set):Float;

	/**
		The amount of vertical blur. Valid values are 0 to 255.0(floating point).
		The default value is 4.0.
	**/
	public var blurY(get, set):Float;

	/**
		The color of the shadow. Valid values are in hexadecimal format
		_0xRRGGBB_. The default value is 0x000000.
	**/
	public var color(get, set):Int;

	/**
		The offset distance for the shadow, in pixels. The default value is 4.0
		(floating point).
	**/
	public var distance(get, set):Float;

	/**
		Indicates whether or not the object is hidden. The value `true`
		indicates that the object itself is not drawn; only the shadow is visible.
		The default is `false`(the object is shown).
	**/
	public var hideObject(get, set):Bool;

	/**
		Indicates whether or not the shadow is an inner shadow. The value
		`true` indicates an inner shadow. The default is
		`false`, an outer shadow(a shadow around the outer edges of
		the object).
	**/
	public var inner(get, set):Bool;

	/**
		Applies a knockout effect(`true`), which effectively makes the
		object's fill transparent and reveals the background color of the
		document. The default is `false`(no knockout).
	**/
	public var knockout(get, set):Bool;

	/**
		The number of times to apply the filter. The default value is
		`BitmapFilterQuality.LOW`, which is equivalent to applying the
		filter once. The value `BitmapFilterQuality.MEDIUM` applies the
		filter twice; the value `BitmapFilterQuality.HIGH` applies it
		three times. Filters with lower values are rendered more quickly.

		For most applications, a quality value of low, medium, or high is
		sufficient. Although you can use additional numeric values up to 15 to
		achieve different effects, higher values are rendered more slowly. Instead
		of increasing the value of `quality`, you can often get a
		similar effect, and with faster rendering, by simply increasing the values
		of the `blurX` and `blurY` properties.
	**/
	public var quality(get, set):Int;

	/**
		The strength of the imprint or spread. The higher the value, the more
		color is imprinted and the stronger the contrast between the shadow and
		the background. Valid values are from 0 to 255.0. The default is 1.0.
	**/
	public var strength(get, set):Float;

	@:noCompletion private var __alpha:Float;
	@:noCompletion private var __angle:Float;
	@:noCompletion private var __blurX:Float;
	@:noCompletion private var __blurY:Float;
	@:noCompletion private var __color:Int;
	@:noCompletion private var __distance:Float;
	@:noCompletion private var __hideObject:Bool;
	@:noCompletion private var __inner:Bool;
	@:noCompletion private var __knockout:Bool;
	@:noCompletion private var __offsetX:Float;
	@:noCompletion private var __offsetY:Float;
	@:noCompletion private var __quality:Int;
	@:noCompletion private var __strength:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(DropShadowFilter.prototype, {
			"alpha": {get: untyped __js__("function () { return this.get_alpha (); }"), set: untyped __js__("function (v) { return this.set_alpha (v); }")},
			"angle": {get: untyped __js__("function () { return this.get_angle (); }"), set: untyped __js__("function (v) { return this.set_angle (v); }")},
			"blurX": {get: untyped __js__("function () { return this.get_blurX (); }"), set: untyped __js__("function (v) { return this.set_blurX (v); }")},
			"blurY": {get: untyped __js__("function () { return this.get_blurY (); }"), set: untyped __js__("function (v) { return this.set_blurY (v); }")},
			"color": {get: untyped __js__("function () { return this.get_color (); }"), set: untyped __js__("function (v) { return this.set_color (v); }")},
			"distance": {get: untyped __js__("function () { return this.get_distance (); }"),
				set: untyped __js__("function (v) { return this.set_distance (v); }")},
			"hideObject": {get: untyped __js__("function () { return this.get_hideObject (); }"),
				set: untyped __js__("function (v) { return this.set_hideObject (v); }")},
			"inner": {get: untyped __js__("function () { return this.get_inner (); }"), set: untyped __js__("function (v) { return this.set_inner (v); }")},
			"knockout": {get: untyped __js__("function () { return this.get_knockout (); }"),
				set: untyped __js__("function (v) { return this.set_knockout (v); }")},
			"quality": {get: untyped __js__("function () { return this.get_quality (); }"),
				set: untyped __js__("function (v) { return this.set_quality (v); }")},
			"strength": {get: untyped __js__("function () { return this.get_strength (); }"),
				set: untyped __js__("function (v) { return this.set_strength (v); }")},
		});
	}
	#end

	/**
		Creates a new DropShadowFilter instance with the specified parameters.

		@param distance   Offset distance for the shadow, in pixels.
		@param angle      Angle of the shadow, 0 to 360 degrees(floating point).
		@param color      Color of the shadow, in hexadecimal format
						  _0xRRGGBB_. The default value is 0x000000.
		@param alpha      Alpha transparency value for the shadow color. Valid
						  values are 0.0 to 1.0. For example, .25 sets a
						  transparency value of 25%.
		@param blurX      Amount of horizontal blur. Valid values are 0 to 255.0
						 (floating point).
		@param blurY      Amount of vertical blur. Valid values are 0 to 255.0
						 (floating point).
		@param strength   The strength of the imprint or spread. The higher the
						  value, the more color is imprinted and the stronger the
						  contrast between the shadow and the background. Valid
						  values are 0 to 255.0.
		@param quality    The number of times to apply the filter. Use the
						  BitmapFilterQuality constants:

						   * `BitmapFilterQuality.LOW`
						   * `BitmapFilterQuality.MEDIUM`
						   * `BitmapFilterQuality.HIGH`


						  For more information about these values, see the
						  `quality` property description.
		@param inner      Indicates whether or not the shadow is an inner shadow.
						  A value of `true` specifies an inner shadow.
						  A value of `false` specifies an outer shadow
						 (a shadow around the outer edges of the object).
		@param knockout   Applies a knockout effect(`true`), which
						  effectively makes the object's fill transparent and
						  reveals the background color of the document.
		@param hideObject Indicates whether or not the object is hidden. A value
						  of `true` indicates that the object itself is
						  not drawn; only the shadow is visible.
	**/
	public function new(distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1,
			quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false)
	{
		super();

		__offsetX = 0;
		__offsetY = 0;

		__distance = distance;
		__angle = angle;
		__color = color;
		__alpha = alpha;
		__blurX = blurX;
		__blurY = blurY;
		__strength = strength;
		__quality = quality;
		__inner = inner;
		__knockout = knockout;
		__hideObject = hideObject;

		__updateSize();

		__needSecondBitmapData = true;
		__preserveObject = !__hideObject;
		__renderDirty = true;
	}

	public override function clone():BitmapFilter
	{
		return new DropShadowFilter(__distance, __angle, __color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout, __hideObject);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle,
			destPoint:Point):BitmapData
	{
		// TODO: Support knockout, inner

		#if lime
		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;

		var point = new Point(destPoint.x + __offsetX, destPoint.y + __offsetY);

		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle(), point.__toLimeVector2(),
			__blurX, __blurY, __quality, __strength);
		finalImage.colorTransform(finalImage.rect, new ColorTransform(0, 0, 0, __alpha, r, g, b, 0).__toLimeColorMatrix());

		if (finalImage == bitmapData.image) return bitmapData;
		#end
		return sourceBitmapData;
	}

	@:noCompletion private function __updateSize():Void
	{
		__offsetX = Std.int(__distance * Math.cos(__angle * Math.PI / 180));
		__offsetY = Std.int(__distance * Math.sin(__angle * Math.PI / 180));
		__topExtension = Math.ceil((__offsetY < 0 ? -__offsetY : 0) + __blurY);
		__bottomExtension = Math.ceil((__offsetY > 0 ? __offsetY : 0) + __blurY);
		__leftExtension = Math.ceil((__offsetX < 0 ? -__offsetX : 0) + __blurX);
		__rightExtension = Math.ceil((__offsetX > 0 ? __offsetX : 0) + __blurX);
	}

	// Get & Set Methods
	@:noCompletion private function get_alpha():Float
	{
		return __alpha;
	}

	@:noCompletion private function set_alpha(value:Float):Float
	{
		if (value != __alpha) __renderDirty = true;
		return __alpha = value;
	}

	@:noCompletion private function get_angle():Float
	{
		return __angle;
	}

	@:noCompletion private function set_angle(value:Float):Float
	{
		if (value != __angle)
		{
			__angle = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	@:noCompletion private function get_blurX():Float
	{
		return __blurX;
	}

	@:noCompletion private function set_blurX(value:Float):Float
	{
		if (value != __blurX)
		{
			__blurX = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	@:noCompletion private function get_blurY():Float
	{
		return __blurY;
	}

	@:noCompletion private function set_blurY(value:Float):Float
	{
		if (value != __blurY)
		{
			__blurY = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	@:noCompletion private function get_color():Int
	{
		return __color;
	}

	@:noCompletion private function set_color(value:Int):Int
	{
		if (value != __color) __renderDirty = true;
		return __color = value;
	}

	@:noCompletion private function get_distance():Float
	{
		return __distance;
	}

	@:noCompletion private function set_distance(value:Float):Float
	{
		if (value != __distance)
		{
			__distance = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	@:noCompletion private function get_hideObject():Bool
	{
		return __hideObject;
	}

	@:noCompletion private function set_hideObject(value:Bool):Bool
	{
		if (value != __hideObject)
		{
			__renderDirty = true;
			__preserveObject = !value;
		}
		return __hideObject = value;
	}

	@:noCompletion private function get_inner():Bool
	{
		return __inner;
	}

	@:noCompletion private function set_inner(value:Bool):Bool
	{
		if (value != __inner) __renderDirty = true;
		return __inner = value;
	}

	@:noCompletion private function get_knockout():Bool
	{
		return __knockout;
	}

	@:noCompletion private function set_knockout(value:Bool):Bool
	{
		if (value != __knockout) __renderDirty = true;
		return __knockout = value;
	}

	@:noCompletion private function get_quality():Int
	{
		return __quality;
	}

	@:noCompletion private function set_quality(value:Int):Int
	{
		if (value != __quality) __renderDirty = true;
		return __quality = value;
	}

	@:noCompletion private function get_strength():Float
	{
		return __strength;
	}

	@:noCompletion private function set_strength(value:Float):Float
	{
		if (value != __strength) __renderDirty = true;
		return __strength = value;
	}
}
#else
typedef DropShadowFilter = flash.filters.DropShadowFilter;
#end
