package openfl.filters;

#if !flash
import openfl.display.BitmapDataChannel;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
#if lime
import lime._internal.graphics.ImageCanvasUtil;
import lime._internal.graphics.ImageDataUtil;
import lime.math.Vector2;
import lime.math.Vector4;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
import openfl._internal.backend.lime_standalone.ImageDataUtil;
#end

/**
	The DisplacementMapFilter class uses the pixel values from the specified
	BitmapData object (called the _displacement map image_) to perform a
	displacement of an object. You can use this filter to apply a warped or
	mottled effect to any object that inherits from the DisplayObject class,
	such as MovieClip, SimpleButton, TextField, and Video objects, as well as
	to BitmapData objects.
	The use of filters depends on the object to which you apply the filter:

	* To apply filters to a display object, use the `filters` property of the
	display object. Setting the `filters` property of an object does not
	modify the object, and you can remove the filter by clearing the `filters`
	property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling `applyFilter()` on a BitmapData
	object takes the source BitmapData object and the filter object and
	generates a filtered image.

	If you apply a filter to a display object, the value of the
	`cacheAsBitmap` property of the display object is set to `true`. If you
	clear all filters, the original value of `cacheAsBitmap` is restored.

	The filter uses the following formula:

	```
	dstPixel[x, y] = srcPixel[x + ((componentX(x, y) - 128) * scaleX) / 256, y + ((componentY(x, y) - 128) * scaleY) / 256)
	```

	where `componentX(x, y)` gets the `componentX` property color value from
	the `mapBitmap` property at `(x - mapPoint.x ,y - mapPoint.y)`.

	The map image used by the filter is scaled to match the Stage scaling. It
	is not scaled when the object itself is scaled.

	This filter supports Stage scaling. However, general scaling, rotation,
	and skewing are not supported. If the object itself is scaled (if the
	`scaleX` and `scaleY` properties are set to a value other than 1.0), the
	filter effect is not scaled. It is scaled only when the user zooms in on
	the Stage.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:final class DisplacementMapFilter extends BitmapFilter
{
	/**
		Specifies the alpha transparency value to use for out-of-bounds
		displacements. It is specified as a normalized value from 0.0 to 1.0.
		For example, .25 sets a transparency value of 25%. The default value
		is 0. Use this property if the `mode` property is set to
		`DisplacementMapFilterMode.COLOR`.
	**/
	public var alpha(get, set):Float;

	/**
		Specifies what color to use for out-of-bounds displacements. The valid
		range of displacements is 0.0 to 1.0. Values are in hexadecimal
		format. The default value for `color` is 0. Use this property if the
		`mode` property is set to `DisplacementMapFilterMode.COLOR`.
	**/
	public var color(get, set):Int;

	/**
		Describes which color channel to use in the map image to displace the
		_x_ result. Possible values are BitmapDataChannel constants:
		* `BitmapDataChannel.ALPHA`
		* `BitmapDataChannel.BLUE`
		* `BitmapDataChannel.GREEN`
		* `BitmapDataChannel.RED`
	**/
	public var componentX(get, set):Int;

	/**
		Describes which color channel to use in the map image to displace the
		_y_ result. Possible values are BitmapDataChannel constants:
		* `BitmapDataChannel.ALPHA`
		* `BitmapDataChannel.BLUE`
		* `BitmapDataChannel.GREEN`
		* `BitmapDataChannel.RED`
	**/
	public var componentY(get, set):Int;

	/**
		A BitmapData object containing the displacement map data.

		@throws TypeError The BitmapData is null when being set
	**/
	public var mapBitmap(get, set):BitmapData;

	/**
		A value that contains the offset of the upper-left corner of the
		target display object from the upper-left corner of the map image.

		@throws TypeError The Point is null when being set
	**/
	public var mapPoint(get, set):Point;

	/**
		The mode for the filter. Possible values are DisplacementMapFilterMode
		constants:
		* `DisplacementMapFilterMode.WRAP` — Wraps the displacement value to
		the other side of the source image.
		* `DisplacementMapFilterMode.CLAMP` — Clamps the displacement value
		to the edge of the source image.
		* `DisplacementMapFilterMode.IGNORE` — If the displacement value is
		out of range, ignores the displacement and uses the source pixel.
		* `DisplacementMapFilterMode.COLOR` — If the displacement value is
		outside the image, substitutes the values in the `color` and `alpha`
		properties.

		@throws ArgumentError The mode string is not one of the valid types
		@throws TypeError     The String is null when being set
	**/
	public var mode(get, set):DisplacementMapFilterMode;

	/**
		The multiplier to use to scale the _x_ displacement result from the
		map calculation.
	**/
	public var scaleX(get, set):Float;

	/**
		The multiplier to use to scale the _y_ displacement result from the
		map calculation.
	**/
	public var scaleY(get, set):Float;

	/**
		Initializes a DisplacementMapFilter instance with the specified
		parameters.

		@param mapBitmap  A BitmapData object containing the displacement map
						  data.
		@param mapPoint   A value that contains the offset of the upper-left
						  corner of the target display object from the
						  upper-left corner of the map image.
		@param componentX Describes which color channel to use in the map
						  image to displace the _x_ result. Possible values
						  are the BitmapDataChannel constants.
		@param componentY Describes which color channel to use in the map
						  image to displace the _y_ result. Possible values
						  are the BitmapDataChannel constants.
		@param scaleX     The multiplier to use to scale the _x_ displacement
						  result from the map calculation.
		@param scaleY     The multiplier to use to scale the _y_ displacement
						  result from the map calculation.
		@param mode       The mode of the filter. Possible values are the
						  DisplacementMapFilterMode constants.
		@param color      Specifies the color to use for out-of-bounds
						  displacements. The valid range of displacements is
						  0.0 to 1.0. Use this parameter if `mode` is set to
						  `DisplacementMapFilterMode.COLOR`.
		@param alpha      Specifies what alpha value to use for out-of-bounds
						  displacements. It is specified as a normalized value
						  from 0.0 to 1.0. For example, .25 sets a
						  transparency value of 25%. Use this parameter if
						  `mode` is set to `DisplacementMapFilterMode.COLOR`.
	**/
	public function new(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:Int = 0, componentY:Int = 0, scaleX:Float = 0.0, scaleY:Float = 0.0,
			mode:DisplacementMapFilterMode = WRAP, color:Int = 0, alpha:Float = 0.0)
	{
		_ = new _DisplacementMapFilter(this, mapBitmap, mapPoint, componentX, componentY, scaleX, scaleY, mode, color, alpha);

		super();
	}

	public override function clone():DisplacementMapFilter
	{
		return (_ : _DisplacementMapFilter).clone();
	}

	// Get & Set Methods

	@:noCompletion private function get_alpha():Float
	{
		return (_ : _DisplacementMapFilter).alpha;
	}

	@:noCompletion private function set_alpha(value:Float):Float
	{
		return (_ : _DisplacementMapFilter).alpha = value;
	}

	@:noCompletion private function get_componentX():Int
	{
		return (_ : _DisplacementMapFilter).componentX;
	}

	@:noCompletion private function set_componentX(value:Int):Int
	{
		return (_ : _DisplacementMapFilter).componentX = value;
	}

	@:noCompletion private function get_componentY():Int
	{
		return (_ : _DisplacementMapFilter).componentY;
	}

	@:noCompletion private function set_componentY(value:Int):Int
	{
		return (_ : _DisplacementMapFilter).componentY = value;
	}

	@:noCompletion private function get_color():Int
	{
		return (_ : _DisplacementMapFilter).color;
	}

	@:noCompletion private function set_color(value:Int):Int
	{
		return (_ : _DisplacementMapFilter).color = value;
	}

	@:noCompletion private function get_scaleX():Float
	{
		return (_ : _DisplacementMapFilter).scaleX;
	}

	@:noCompletion private function set_scaleX(value:Float):Float
	{
		return (_ : _DisplacementMapFilter).scaleX = value;
	}

	@:noCompletion private function get_scaleY():Float
	{
		return (_ : _DisplacementMapFilter).scaleY;
	}

	@:noCompletion private function set_scaleY(value:Float):Float
	{
		return (_ : _DisplacementMapFilter).scaleY = value;
	}

	@:noCompletion private function get_mapBitmap():BitmapData
	{
		return (_ : _DisplacementMapFilter).mapBitmap;
	}

	@:noCompletion private function set_mapBitmap(value:BitmapData):BitmapData
	{
		return (_ : _DisplacementMapFilter).mapBitmap = value;
	}

	@:noCompletion private function get_mapPoint():Point
	{
		return (_ : _DisplacementMapFilter).mapPoint;
	}

	@:noCompletion private function set_mapPoint(value:Point):Point
	{
		return (_ : _DisplacementMapFilter).mapPoint = value;
	}

	@:noCompletion private function get_mode():String
	{
		return (_ : _DisplacementMapFilter).mode;
	}

	@:noCompletion private function set_mode(value:String):String
	{
		return (_ : _DisplacementMapFilter).mode = value;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class DisplacementMapShader extends BitmapFilterShader
{
	@:glFragmentSource("

		uniform sampler2D openfl_Texture;
		uniform sampler2D mapTexture;

		uniform mat4 openfl_Matrix;

		uniform vec4 uOffsets;
		uniform mat4 uDisplacements;

		varying vec2 openfl_TextureCoordV;
		varying vec2 mapTextureCoords;

		void main(void) {

			vec4 map_color = texture2D(mapTexture, mapTextureCoords);
			vec4 map_color_mod = map_color - uOffsets;

			map_color_mod = map_color_mod * vec4(map_color.w, map_color.w, 1.0, 1.0);

			vec4 displacements_multiplied = map_color_mod * uDisplacements;
			vec4 result = vec4(openfl_TextureCoordV.x, openfl_TextureCoordV.y, 0.0, 1.0) + displacements_multiplied;

			gl_FragColor = texture2D(openfl_Texture, vec2(result));

		}

	")
	@:glVertexSource("

		uniform mat4 openfl_Matrix;

		uniform vec2 mapTextureCoordsOffset;

		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying vec2 openfl_TextureCoordV;

		varying vec2 mapTextureCoords;

		void main(void) {

			gl_Position = openfl_Matrix * openfl_Position;

			openfl_TextureCoordV = openfl_TextureCoord;
			mapTextureCoords = openfl_TextureCoord - mapTextureCoordsOffset;

		}

	")
	public function new()
	{
		super();
	}
}
#else
typedef DisplacementMapFilter = flash.filters.DisplacementMapFilter;
#end
