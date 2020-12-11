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
	@:noCompletion private static var __displacementMapShader:DisplacementMapShader = new DisplacementMapShader();
	private static var __matrixData:Array<Float> = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	private static var __offset:Array<Float> = [0.5, 0.5, 0.0, 0.0];

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
		* `DisplacementMapFilterMode.WRAP` � Wraps the displacement value to
		the other side of the source image.
		* `DisplacementMapFilterMode.CLAMP` � Clamps the displacement value
		to the edge of the source image.
		* `DisplacementMapFilterMode.IGNORE` � If the displacement value is
		out of range, ignores the displacement and uses the source pixel.
		* `DisplacementMapFilterMode.COLOR` � If the displacement value is
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

	@:noCompletion private var __alpha:Float;
	@:noCompletion private var __color:Int;
	@:noCompletion private var __componentX:Int;
	@:noCompletion private var __componentY:Int;
	@:noCompletion private var __mapBitmap:BitmapData;
	@:noCompletion private var __mapPoint:Point;
	@:noCompletion private var __mode:String;
	@:noCompletion private var __scaleX:Float;
	@:noCompletion private var __scaleY:Float;

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
		super();

		__mapBitmap = mapBitmap;
		__mapPoint = (mapPoint != null) ? mapPoint : new Point();
		__componentX = componentX;
		__componentY = componentY;
		__scaleX = scaleX;
		__scaleY = scaleY;
		__mode = mode; // TODO: not used
		__color = color;
		__alpha = alpha;

		__needSecondBitmapData = true;
		__preserveObject = false;
		__renderDirty = true;

		__numShaderPasses = 1;
	}

	public override function clone():BitmapFilter
	{
		return new DisplacementMapFilter(__mapBitmap, __mapPoint.clone(), __componentX, __componentY, __scaleX, __scaleY, __mode, __color, __alpha);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle,
			destPoint:Point):BitmapData
	{
		#if lime
		__updateMapMatrix();

		#if (js && html5)
		ImageCanvasUtil.convertToData(bitmapData.image);
		ImageCanvasUtil.convertToData(sourceBitmapData.image);
		ImageCanvasUtil.convertToData(__mapBitmap.image);
		#end

		ImageDataUtil.displaceMap(bitmapData.image, sourceBitmapData.image, __mapBitmap.image,

			new Vector2(__mapPoint.x / __mapBitmap.width, __mapPoint.y / __mapBitmap.height),

			new Vector4(__matrixData[0], __matrixData[4], __matrixData[8], __matrixData[12]),
			new Vector4(__matrixData[1], __matrixData[5], __matrixData[9], __matrixData[13]), __smooth);
		#end

		return bitmapData;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		// TODO: mapX/mapY/mapU/mapV + offsets

		__updateMapMatrix();

		__displacementMapShader.uOffsets.value = __offset;
		__displacementMapShader.uDisplacements.value = __matrixData;

		__displacementMapShader.mapTextureCoordsOffset.value = [mapPoint.x / __mapBitmap.width, mapPoint.y / __mapBitmap.height];

		__displacementMapShader.mapTexture.input = __mapBitmap;
		#end

		return __displacementMapShader;
	}

	@:noCompletion private function __updateMapMatrix():Void
	{
		var columnX:Int, columnY:Int;
		var scale:Float = 1.0; // TODO: Stage's scale ?
		var textureWidth:Float = __mapBitmap.width;
		var textureHeight:Float = __mapBitmap.height;

		for (i in 0...16)
		{
			__matrixData[i] = 0;
		}

		if (__componentX == BitmapDataChannel.RED) columnX = 0;
		else if (__componentX == BitmapDataChannel.GREEN) columnX = 1;
		else if (__componentX == BitmapDataChannel.BLUE) columnX = 2;
		else
			columnX = 3;

		if (__componentY == BitmapDataChannel.RED) columnY = 0;
		else if (__componentY == BitmapDataChannel.GREEN) columnY = 1;
		else if (__componentY == BitmapDataChannel.BLUE) columnY = 2;
		else
			columnY = 3;

		__matrixData[columnX * 4] = __scaleX * scale / textureWidth;
		__matrixData[columnY * 4 + 1] = __scaleY * scale / textureHeight;
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

	@:noCompletion private function get_componentX():Int
	{
		return __componentX;
	}

	@:noCompletion private function set_componentX(value:Int):Int
	{
		if (value != __componentX) __renderDirty = true;
		return __componentX = value;
	}

	@:noCompletion private function get_componentY():Int
	{
		return __componentY;
	}

	@:noCompletion private function set_componentY(value:Int):Int
	{
		if (value != __componentY) __renderDirty = true;
		return __componentY = value;
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

	@:noCompletion private function get_scaleX():Float
	{
		return __scaleX;
	}

	@:noCompletion private function set_scaleX(value:Float):Float
	{
		if (value != __scaleX) __renderDirty = true;
		return __scaleX = value;
	}

	@:noCompletion private function get_scaleY():Float
	{
		return __scaleY;
	}

	@:noCompletion private function set_scaleY(value:Float):Float
	{
		if (value != __scaleY) __renderDirty = true;
		return __scaleY = value;
	}

	@:noCompletion private function get_mapBitmap():BitmapData
	{
		return __mapBitmap;
	}

	@:noCompletion private function set_mapBitmap(value:BitmapData):BitmapData
	{
		if (value != __mapBitmap) __renderDirty = true;
		return __mapBitmap = value;
	}

	@:noCompletion private function get_mapPoint():Point
	{
		return __mapPoint;
	}

	@:noCompletion private function set_mapPoint(value:Point):Point
	{
		if (value != __mapPoint) __renderDirty = true;
		return __mapPoint = value;
	}

	@:noCompletion private function get_mode():String
	{
		return __mode;
	}

	@:noCompletion private function set_mode(value:String):String
	{
		if (value != __mode) __renderDirty = true;
		return __mode = value;
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
