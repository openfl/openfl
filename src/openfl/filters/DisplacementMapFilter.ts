import BitmapData from "../display/BitmapData";
import BitmapDataChannel from "../display/BitmapDataChannel";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Shader from "../display/Shader";
import BitmapFilter from "../filters/BitmapFilter";
import BitmapFilterShader from "../filters/BitmapFilterShader";
import DisplacementMapFilterMode from "../filters/DisplacementMapFilterMode";
import Rectangle from "../geom/Rectangle";
import Point from "../geom/Point";

class DisplacementMapShader extends BitmapFilterShader
{
	glFragmentSource = `
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
	`;

	glVertexSource = `
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
	`;

	public constructor()
	{
		super();
	}
}

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
export default class DisplacementMapFilter extends BitmapFilter
{
	protected static __displacementMapShader: DisplacementMapShader = new DisplacementMapShader();
	private static __matrixData: Array<number> = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	private static __offset: Array<number> = [0.5, 0.5, 0.0, 0.0];

	protected __alpha: number;
	protected __color: number;
	protected __componentX: number;
	protected __componentY: number;
	protected __mapBitmap: BitmapData;
	protected __mapPoint: Point;
	protected __mode: string;
	protected __scaleX: number;
	protected __scaleY: number;

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
	public constructor(mapBitmap: BitmapData = null, mapPoint: Point = null, componentX: number = 0, componentY: number = 0, scaleX: number = 0.0, scaleY: number = 0.0,
		mode: DisplacementMapFilterMode = DisplacementMapFilterMode.WRAP, color: number = 0, alpha: number = 0.0)
	{
		super();

		this.__mapBitmap = mapBitmap;
		this.__mapPoint = (mapPoint != null) ? mapPoint : new Point();
		this.__componentX = componentX;
		this.__componentY = componentY;
		this.__scaleX = scaleX;
		this.__scaleY = scaleY;
		this.__mode = mode; // TODO: not used
		this.__color = color;
		this.__alpha = alpha;

		this.__needSecondBitmapData = true;
		this.__preserveObject = false;
		this.__renderDirty = true;

		this.__numShaderPasses = 1;
	}

	publicclone(): BitmapFilter
	{
		return new DisplacementMapFilter(this.__mapBitmap, this.__mapPoint.clone(), this.__componentX, this.__componentY, this.__scaleX, this.__scaleY, this.__mode, this.__color, this.__alpha);
	}

	protected __applyFilter(bitmapData: BitmapData, sourceBitmapData: BitmapData, sourceRect: Rectangle,
		destPoint: Point): BitmapData
	{
		this.__updateMapMatrix();

		ImageCanvasUtil.convertToData(bitmapData.limeImage);
		ImageCanvasUtil.convertToData(sourceBitmapData.limeImage);
		ImageCanvasUtil.convertToData(this.__mapBitmap.limeImage);

		ImageDataUtil.displaceMap(bitmapData.limeImage, sourceBitmapData.limeImage, this.__mapBitmap.limeImage,

			new Vector2(this.__mapPoint.x / this.__mapBitmap.width, this.__mapPoint.y / this.__mapBitmap.height),

			new Vector4(this.__matrixData[0], this.__matrixData[4], this.__matrixData[8], this.__matrixData[12]),
			new Vector4(this.__matrixData[1], this.__matrixData[5], this.__matrixData[9], this.__matrixData[13]), this.__smooth);

		return bitmapData;
	}

	protected __initShader(renderer: DisplayObjectRenderer, pass: number, sourceBitmapData: BitmapData): Shader
	{
		// TODO: mapX/mapY/mapU/mapV + offsets

		this.__updateMapMatrix();

		DisplacementMapFilter.__displacementMapShader.data.uOffsets.value = DisplacementMapFilter.__offset;
		DisplacementMapFilter.__displacementMapShader.data.uDisplacements.value = DisplacementMapFilter.__matrixData;

		DisplacementMapFilter.__displacementMapShader.data.mapTextureCoordsOffset.value = [mapPoint.x / this.__mapBitmap.width, mapPoint.y / this.__mapBitmap.height];

		DisplacementMapFilter.__displacementMapShader.data.mapTexture.input = this.__mapBitmap;

		return DisplacementMapFilter.__displacementMapShader;
	}

	protected __updateMapMatrix(): void
	{
		var columnX: number, columnY: number;
		var scale: number = 1.0; // TODO: Stage's scale ?
		var textureWidth: number = this.__mapBitmap.width;
		var textureHeight: number = this.__mapBitmap.height;

		for (let i = 0; i < 16; i++)
		{
			DisplacementMapFilter.__matrixData[i] = 0;
		}

		if (this.__componentX == BitmapDataChannel.RED) columnX = 0;
		else if (this.__componentX == BitmapDataChannel.GREEN) columnX = 1;
		else if (this.__componentX == BitmapDataChannel.BLUE) columnX = 2;
		else
			columnX = 3;

		if (this.__componentY == BitmapDataChannel.RED) columnY = 0;
		else if (this.__componentY == BitmapDataChannel.GREEN) columnY = 1;
		else if (this.__componentY == BitmapDataChannel.BLUE) columnY = 2;
		else
			columnY = 3;

		DisplacementMapFilter.__matrixData[columnX * 4] = this.__scaleX * scale / textureWidth;
		DisplacementMapFilter.__matrixData[columnY * 4 + 1] = this.__scaleY * scale / textureHeight;
	}

	// Get & Set Methods

	/**
		Specifies the alpha transparency value to use for out-of-bounds
		displacements. It is specified as a normalized value from 0.0 to 1.0.
		For example, .25 sets a transparency value of 25%. The default value
		is 0. Use this property if the `mode` property is set to
		`DisplacementMapFilterMode.COLOR`.
	**/
	public get alpha(): number
	{
		return this.__alpha;
	}

	public set alpha(value: number)
	{
		if (value != this.__alpha) this.__renderDirty = true;
		this.__alpha = value;
	}

	/**
		Specifies what color to use for out-of-bounds displacements. The valid
		range of displacements is 0.0 to 1.0. Values are in hexadecimal
		format. The default value for `color` is 0. Use this property if the
		`mode` property is set to `DisplacementMapFilterMode.COLOR`.
	**/
	public get color(): number
	{
		return this.__color;
	}

	public set color(value: number)
	{
		if (value != this.__color) this.__renderDirty = true;
		this.__color = value;
	}

	/**
		Describes which color channel to use in the map image to displace the
		_x_ result. Possible values are BitmapDataChannel constants:
		* `BitmapDataChannel.ALPHA`
		* `BitmapDataChannel.BLUE`
		* `BitmapDataChannel.GREEN`
		* `BitmapDataChannel.RED`
	**/
	public get componentX(): number
	{
		return this.__componentX;
	}

	public set componentX(value: number)
	{
		if (value != this.__componentX) this.__renderDirty = true;
		this.__componentX = value;
	}

	/**
		Describes which color channel to use in the map image to displace the
		_y_ result. Possible values are BitmapDataChannel constants:
		* `BitmapDataChannel.ALPHA`
		* `BitmapDataChannel.BLUE`
		* `BitmapDataChannel.GREEN`
		* `BitmapDataChannel.RED`
	**/
	public get componentY(): number
	{
		return this.__componentY;
	}

	public set componentY(value: number)
	{
		if (value != this.__componentY) this.__renderDirty = true;
		this.__componentY = value;
	}

	/**
		A BitmapData object containing the displacement map data.

		@throws TypeError The BitmapData is null when being set
	**/
	public get mapBitmap(): BitmapData
	{
		return this.__mapBitmap;
	}

	public set mapBitmap(value: BitmapData)
	{
		if (value != this.__mapBitmap) this.__renderDirty = true;
		this.__mapBitmap = value;
	}

	/**
		A value that contains the offset of the upper-left corner of the
		target display object from the upper-left corner of the map image.

		@throws TypeError The Point is null when being set
	**/
	public get mapPoint(): Point
	{
		return this.__mapPoint;
	}

	public set mapPoint(value: Point)
	{
		if (value != this.__mapPoint) this.__renderDirty = true;
		this.__mapPoint = value;
	}

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
	public get mode(): string
	{
		return this.__mode;
	}

	public set mode(value: string)
	{
		if (value != this.__mode) this.__renderDirty = true;
		this.__mode = value;
	}

	/**
		The multiplier to use to scale the _x_ displacement result from the
		map calculation.
	**/
	public get scaleX(): number
	{
		return this.__scaleX;
	}

	public set scaleX(value: number)
	{
		if (value != this.__scaleX) this.__renderDirty = true;
		this.__scaleX = value;
	}

	/**
		The multiplier to use to scale the _y_ displacement result from the
		map calculation.
	**/
	public get scaleY(): number
	{
		return this.__scaleY;
	}

	public set scaleY(value: number)
	{
		if (value != this.__scaleY) this.__renderDirty = true;
		this.__scaleY = value;
	}
}
