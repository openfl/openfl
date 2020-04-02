import BitmapData from "../display/BitmapData";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Shader from "../display/Shader";
import BitmapFilter from "../filters/BitmapFilter";
import BitmapFilterShader from "../filters/BitmapFilterShader";
import ColorTransform from "../geom/ColorTransform";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";

class InvertAlphaShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		varying vec2 vTexCoord;

		void main(void) {
			vec4 texel = texture2D(openfl_Texture, vTexCoord);
			gl_FragColor = vec4(texel.rgb, 1.0 - texel.a);
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		varying vec2 vTexCoord;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			vTexCoord = openfl_TextureCoord;
		}
	`;

	public constructor()
	{
		super();
	}
}

class BlurAlphaShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		uniform vec4 uColor;
		uniform float uStrength;
		varying vec2 vTexCoord;
		varying vec2 vBlurCoords[6];

		void main(void)
		{
			vec4 texel = texture2D(openfl_Texture, vTexCoord);

			vec3 contributions = vec3(0.00443, 0.05399, 0.24197);
			vec3 top = vec3(
				texture2D(openfl_Texture, vBlurCoords[0]).a,
				texture2D(openfl_Texture, vBlurCoords[1]).a,
				texture2D(openfl_Texture, vBlurCoords[2]).a
			);
			vec3 bottom = vec3(
				texture2D(openfl_Texture, vBlurCoords[3]).a,
				texture2D(openfl_Texture, vBlurCoords[4]).a,
				texture2D(openfl_Texture, vBlurCoords[5]).a
			);

			float a = texel.a * 0.39894;
			a += dot(top, contributions.xyz);
			a += dot(bottom, contributions.zyx);

			gl_FragColor = uColor * clamp(a * uStrength, 0.0, 1.0);
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;

		uniform vec2 uRadius;
		varying vec2 vTexCoord;
		varying vec2 vBlurCoords[6];

		void main(void) {

			gl_Position = openfl_Matrix * openfl_Position;
			vTexCoord = openfl_TextureCoord;

			vec3 offset = vec3(0.5, 0.75, 1.0);
			vec2 r = uRadius / openfl_TextureSize;
			vBlurCoords[0] = openfl_TextureCoord - r * offset.z;
			vBlurCoords[1] = openfl_TextureCoord - r * offset.y;
			vBlurCoords[2] = openfl_TextureCoord - r * offset.x;
			vBlurCoords[3] = openfl_TextureCoord + r * offset.x;
			vBlurCoords[4] = openfl_TextureCoord + r * offset.y;
			vBlurCoords[5] = openfl_TextureCoord + r * offset.z;
		}
	`;

	public constructor()
	{
		super();
		this.data.uRadius.value = [0, 0];
		this.data.uColor.value = [0, 0, 0, 0];
		this.data.uStrength.value = [1];
	}
}

class CombineShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

			gl_FragColor = src + glow * (1.0 - src.a);
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	`;

	public constructor()
	{
		super();
		offset.value = [0, 0];
	}
}

class InnerCombineShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

			gl_FragColor = vec4((src.rgb * (1.0 - glow.a)) + (glow.rgb * src.a), src.a);
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	`;

	public constructor()
	{
		super();
		offset.value = [0, 0];
	}
}

class CombineKnockoutShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

			gl_FragColor = glow * (1.0 - src.a);
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	`;

	public constructor()
	{
		super();
		offset.value = [0, 0];
	}
}

class InnerCombineKnockoutShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

			gl_FragColor = glow * src.a;
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	`;

	public constructor()
	{
		super();
		offset.value = [0, 0];
	}
}

/**
	The GlowFilter class lets you apply a glow effect to display objects. You
	have several options for the style of the glow, including inner or outer
	glow and knockout mode. The glow filter is similar to the drop shadow
	filter with the `distance` and `angle` properties of
	the drop shadow filter set to 0. You can apply the filter to any display
	object(that is, objects that inherit from the DisplayObject class), such
	as MovieClip, SimpleButton, TextField, and Video objects, as well as to
	BitmapData objects.

	The use of filters depends on the object to which you apply the
	filter:


	* To apply filters to display objects, use the `filters`
	property(inherited from DisplayObject). Setting the `filters`
	property of an object does not modify the object, and you can remove the
	filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling
	`applyFilter()` on a BitmapData object takes the source
	BitmapData object and the filter object and generates a filtered image as a
	result.


	If you apply a filter to a display object, the
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
	limitation is 2,880 pixels in height and 2,880 pixels in width. For
	example, if you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image exceeds the maximum
	dimensions.
**/
export default class GlowFilter extends BitmapFilter
{
	protected static __invertAlphaShader = new InvertAlphaShader();
	protected static __blurAlphaShader = new BlurAlphaShader();
	protected static __combineShader = new CombineShader();
	protected static __innerCombineShader = new InnerCombineShader();
	protected static __combineKnockoutShader = new CombineKnockoutShader();
	protected static __innerCombineKnockoutShader = new InnerCombineKnockoutShader();

	/**
		The alpha transparency value for the color. Valid values are 0 to 1. For
		example, .25 sets a transparency value of 25%. The default value is 1.
	**/
	public alpha(get, set): number;

	/**
		The amount of horizontal blur. Valid values are 0 to 255(floating point).
		The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
		and 32) are optimized to render more quickly than other values.
	**/
	public blurX(get, set): number;

	/**
		The amount of vertical blur. Valid values are 0 to 255(floating point).
		The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
		and 32) are optimized to render more quickly than other values.
	**/
	public blurY(get, set): number;

	/**
		The color of the glow. Valid values are in the hexadecimal format
		0x_RRGGBB_. The default value is 0xFF0000.
	**/
	public color(get, set): number;

	/**
		Specifies whether the glow is an inner glow. The value `true`
		indicates an inner glow. The default is `false`, an outer glow
		(a glow around the outer edges of the object).
	**/
	public inner(get, set): boolean;

	/**
		Specifies whether the object has a knockout effect. A value of
		`true` makes the object's fill transparent and reveals the
		background color of the document. The default value is `false`
		(no knockout effect).
	**/
	public knockout(get, set): boolean;

	/**
		The number of times to apply the filter. The default value is
		`BitmapFilterQuality.LOW`, which is equivalent to applying the
		filter once. The value `BitmapFilterQuality.MEDIUM` applies the
		filter twice; the value `BitmapFilterQuality.HIGH` applies it
		three times. Filters with lower values are rendered more quickly.

		For most applications, a `quality` value of low, medium, or
		high is sufficient. Although you can use additional numeric values up to
		15 to achieve different effects, higher values are rendered more slowly.
		Instead of increasing the value of `quality`, you can often get
		a similar effect, and with faster rendering, by simply increasing the
		values of the `blurX` and `blurY` properties.
	**/
	public quality(get, set): number;

	/**
		The strength of the imprint or spread. The higher the value, the more
		color is imprinted and the stronger the contrast between the glow and the
		background. Valid values are 0 to 255. The default is 2.
	**/
	public strength(get, set): number;

	protected __alpha: number;
	protected __blurX: number;
	protected __blurY: number;
	protected __color: number;
	protected __horizontalPasses: number;
	protected __inner: boolean;
	protected __knockout: boolean;
	protected __quality: number;
	protected __strength: number;
	protected __verticalPasses: number;

	/**
		Initializes a new GlowFilter instance with the specified parameters.

		@param color    The color of the glow, in the hexadecimal format
						0x_RRGGBB_. The default value is 0xFF0000.
		@param alpha    The alpha transparency value for the color. Valid values
						are 0 to 1. For example, .25 sets a transparency value of
						25%.
		@param blurX    The amount of horizontal blur. Valid values are 0 to 255
					   (floating point). Values that are a power of 2(such as 2,
						4, 8, 16 and 32) are optimized to render more quickly than
						other values.
		@param blurY    The amount of vertical blur. Valid values are 0 to 255
					   (floating point). Values that are a power of 2(such as 2,
						4, 8, 16 and 32) are optimized to render more quickly than
						other values.
		@param strength The strength of the imprint or spread. The higher the
						value, the more color is imprinted and the stronger the
						contrast between the glow and the background. Valid values
						are 0 to 255.
		@param quality  The number of times to apply the filter. Use the
						BitmapFilterQuality constants:

						 * `BitmapFilterQuality.LOW`
						 * `BitmapFilterQuality.MEDIUM`
						 * `BitmapFilterQuality.HIGH`


						For more information, see the description of the
						`quality` property.
		@param inner    Specifies whether the glow is an inner glow. The value
						` true` specifies an inner glow. The value
						`false` specifies an outer glow(a glow around
						the outer edges of the object).
		@param knockout Specifies whether the object has a knockout effect. The
						value `true` makes the object's fill
						transparent and reveals the background color of the
						document.
	**/
	public constructor(color: number = 0xFF0000, alpha: number = 1, blurX: number = 6, blurY: number = 6, strength: number = 2, quality: number = 1, inner: boolean = false,
		knockout: boolean = false)
	{
		super();

		__color = color;
		__alpha = alpha;
		__blurX = blurX;
		__blurY = blurY;
		__strength = strength;
		__inner = inner;
		__knockout = knockout;
		__quality = quality;

		__updateSize();

		__needSecondBitmapData = true;
		__preserveObject = true;
		__renderDirty = true;
	}

	public clone(): BitmapFilter
	{
		return new GlowFilter(__color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout);
	}

	protected __applyFilter(bitmapData: BitmapData, sourceBitmapData: BitmapData, sourceRect: Rectangle,
		destPoint: Point): BitmapData
	{
		// TODO: Support knockout, inner

		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;

		if (__inner || __knockout)
		{
			sourceBitmapData.limeImage.colorTransform(sourceBitmapData.limeImage.rect, new ColorTransform(1, 1, 1, 0, 0, 0, 0, -255).__toLimeColorMatrix());
			sourceBitmapData.limeImage.dirty = true;
			sourceBitmapData.limeImage.version++;
			bitmapData = sourceBitmapData.clone();
			return bitmapData;
		}

		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.limeImage, sourceBitmapData.limeImage, sourceRect.__toLimeRectangle(),
			destPoint.__toLimeVector2(), __blurX, __blurY, __quality, __strength);
		finalImage.colorTransform(finalImage.rect, new ColorTransform(0, 0, 0, __alpha, r, g, b, 0).__toLimeColorMatrix());

		if (finalImage == bitmapData.limeImage) return bitmapData;
		return sourceBitmapData;
	}

	protected __initShader(renderer: DisplayObjectRenderer, pass: number, sourceBitmapData: BitmapData): Shader
	{
		// First pass of inner glow is invert alpha
		if (__inner && pass == 0)
		{
			return __invertAlphaShader;
		}

		var blurPass = pass - (__inner ? 1 : 0);
		var numBlurPasses = __horizontalPasses + __verticalPasses;

		if (blurPass < numBlurPasses)
		{
			var shader = __blurAlphaShader;
			if (blurPass < __horizontalPasses)
			{
				var scale = Math.pow(0.5, blurPass >> 1) * 0.5;
				shader.uRadius.value[0] = blurX * scale;
				shader.uRadius.value[1] = 0;
			}
			else
			{
				var scale = Math.pow(0.5, (blurPass - __horizontalPasses) >> 1) * 0.5;
				shader.uRadius.value[0] = 0;
				shader.uRadius.value[1] = blurY * scale;
			}
			shader.uColor.value[0] = ((color >> 16) & 0xFF) / 255;
			shader.uColor.value[1] = ((color >> 8) & 0xFF) / 255;
			shader.uColor.value[2] = (color & 0xFF) / 255;
			shader.uColor.value[3] = alpha;
			shader.uStrength.value[0] = blurPass == (numBlurPasses - 1) ? __strength : 1.0;
			return shader;
		}
		if (__inner)
		{
			if (__knockout)
			{
				var shader = __innerCombineKnockoutShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = 0.0;
				shader.offset.value[1] = 0.0;
				return shader;
			}
			var shader = __innerCombineShader;
			shader.sourceBitmap.input = sourceBitmapData;
			shader.offset.value[0] = 0.0;
			shader.offset.value[1] = 0.0;
			return shader;
		}
		else
		{
			if (__knockout)
			{
				var shader = __combineKnockoutShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = 0.0;
				shader.offset.value[1] = 0.0;
				return shader;
			}
			var shader = __combineShader;
			shader.sourceBitmap.input = sourceBitmapData;
			shader.offset.value[0] = 0.0;
			shader.offset.value[1] = 0.0;
			return shader;
		}
	}

	protected __updateSize(): void
	{
		__leftExtension = (__blurX > 0 ? Math.ceil(__blurX * 1.5) : 0);
		__rightExtension = __leftExtension;
		__topExtension = (__blurY > 0 ? Math.ceil(__blurY * 1.5) : 0);
		__bottomExtension = __topExtension;
		__calculateNumShaderPasses();
	}

	protected __calculateNumShaderPasses(): void
	{
		__horizontalPasses = (__blurX <= 0) ? 0 : Math.round(__blurX * (__quality / 4)) + 1;
		__verticalPasses = (__blurY <= 0) ? 0 : Math.round(__blurY * (__quality / 4)) + 1;
		__numShaderPasses = __horizontalPasses + __verticalPasses + (__inner ? 2 : 1);
	}

	// Get & Set Methods
	public get alpha(): number
	{
		return __alpha;
	}

	public set alpha(value: number): number
	{
		if (value != __alpha) __renderDirty = true;
		return __alpha = value;
	}

	public get blurX(): number
	{
		return __blurX;
	}

	public set blurX(value: number): number
	{
		if (value != __blurX)
		{
			__blurX = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	public get blurY(): number
	{
		return __blurY;
	}

	public set blurY(value: number): number
	{
		if (value != __blurY)
		{
			__blurY = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	public get color(): number
	{
		return __color;
	}

	public set color(value: number): number
	{
		if (value != __color) __renderDirty = true;
		return __color = value;
	}

	public get inner(): boolean
	{
		return __inner;
	}

	public set inner(value: boolean): boolean
	{
		if (value != __inner)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __inner = value;
	}

	public get knockout(): boolean
	{
		return __knockout;
	}

	public set knockout(value: boolean): boolean
	{
		if (value != __knockout)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __knockout = value;
	}

	public get quality(): number
	{
		return __quality;
	}

	public set quality(value: number): number
	{
		if (value != __quality)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __quality = value;
	}

	public get strength(): number
	{
		return __strength;
	}

	public set strength(value: number): number
	{
		if (value != __strength) __renderDirty = true;
		return __strength = value;
	}
}
