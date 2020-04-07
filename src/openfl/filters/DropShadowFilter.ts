import * as internal from "../_internal/utils/InternalAccess";
import BitmapData from "../display/BitmapData";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Shader from "../display/Shader";
import ShaderInput from "../display/ShaderInput";
import ShaderParameter from "../display/ShaderParameter";
import BitmapFilter from "../filters/BitmapFilter";
import BitmapFilterShader from "../filters/BitmapFilterShader";
import GlowFilter from "../filters/GlowFilter";
import ColorTransform from "../geom/ColorTransform";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
// import openfl._internal.backend.lime_standalone.ImageDataUtil;

class HideShader extends BitmapFilterShader
{
	glFragmentSource = `
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			gl_FragColor = texture2D(openfl_Texture, textureCoords.zw);
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
		(this.data.offset as ShaderParameter).value = [0, 0];
	}
}

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
export default class DropShadowFilter extends BitmapFilter
{
	protected static __hideShader = new HideShader();

	protected __alpha: number;
	protected __angle: number;
	protected __blurX: number;
	protected __blurY: number;
	protected __color: number;
	protected __distance: number;
	protected __hideObject: boolean;
	protected __horizontalPasses: number;
	protected __inner: boolean;
	protected __knockout: boolean;
	protected __offsetX: number;
	protected __offsetY: number;
	protected __quality: number;
	protected __strength: number;
	protected __verticalPasses: number;

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
	public constructor(distance: number = 4, angle: number = 45, color: number = 0, alpha: number = 1, blurX: number = 4, blurY: number = 4, strength: number = 1,
		quality: number = 1, inner: boolean = false, knockout: boolean = false, hideObject: boolean = false)
	{
		super();

		this.__offsetX = 0;
		this.__offsetY = 0;

		this.__distance = distance;
		this.__angle = angle;
		this.__color = color;
		this.__alpha = alpha;
		this.__blurX = blurX;
		this.__blurY = blurY;
		this.__strength = strength;
		this.__quality = quality;
		this.__inner = inner;
		this.__knockout = knockout;
		this.__hideObject = hideObject;

		this.__updateSize();

		this.__needSecondBitmapData = true;
		this.__preserveObject = true;
		this.__renderDirty = true;
	}

	public clone(): BitmapFilter
	{
		return new DropShadowFilter(this.__distance, this.__angle, this.__color, this.__alpha, this.__blurX, this.__blurY, this.__strength, this.__quality, this.__inner, this.__knockout, this.__hideObject);
	}

	protected __applyFilter(bitmapData: BitmapData, sourceBitmapData: BitmapData, sourceRect: Rectangle,
		destPoint: Point): BitmapData
	{
		// TODO: Support knockout, inner

		// var r = (this.__color >> 16) & 0xFF;
		// var g = (this.__color >> 8) & 0xFF;
		// var b = this.__color & 0xFF;

		// var point = new Point(destPoint.x + this.__offsetX, destPoint.y + this.__offsetY);

		// var finalImage = ImageDataUtil.gaussianBlur(bitmapData.limeImage, sourceBitmapData.limeImage, sourceRect.__toLimeRectangle(), point.__toLimeVector2(),
		// 	this.__blurX, this.__blurY, this.__quality, this.__strength);
		// finalImage.colorTransform(finalImage.rect, new ColorTransform(0, 0, 0, this.__alpha, r, g, b, 0).__toLimeColorMatrix());

		// if (finalImage == bitmapData.limeImage) return bitmapData;
		return sourceBitmapData;
	}

	protected __initShader(renderer: DisplayObjectRenderer, pass: number, sourceBitmapData: BitmapData): Shader
	{
		// Drop shadow is glow with an offset
		if (this.__inner && pass == 0)
		{
			return (<internal.GlowFilter><any>GlowFilter).__invertAlphaShader;
		}

		var blurPass = pass - (this.__inner ? 1 : 0);
		var numBlurPasses = this.__horizontalPasses + this.__verticalPasses;
		var shader: Shader = null;

		if (blurPass < numBlurPasses)
		{
			var shader = (<internal.GlowFilter><any>GlowFilter).__blurAlphaShader;
			var uRadius = shader.data.uRadius as ShaderParameter;
			var uColor = shader.data.uColor as ShaderParameter;
			var uStrength = shader.data.uStrength as ShaderParameter;

			if (blurPass < this.__horizontalPasses)
			{
				var scale = Math.pow(0.5, blurPass >> 1) * 0.5;
				uRadius.value[0] = this.blurX * scale;
				uRadius.value[1] = 0;
			}
			else
			{
				var scale = Math.pow(0.5, (blurPass - this.__horizontalPasses) >> 1) * 0.5;
				uRadius.value[0] = 0;
				uRadius.value[1] = this.blurY * scale;
			}
			uColor.value[0] = ((this.color >> 16) & 0xFF) / 255;
			uColor.value[1] = ((this.color >> 8) & 0xFF) / 255;
			uColor.value[2] = (this.color & 0xFF) / 255;
			uColor.value[3] = this.alpha;
			uStrength.value[0] = blurPass == (numBlurPasses - 1) ? this.__strength : 1.0;
			return shader;
		}
		if (this.__inner)
		{
			if (this.__knockout || this.__hideObject)
			{
				var shader = (<internal.GlowFilter><any>GlowFilter).__innerCombineKnockoutShader;
				(shader.data.sourceBitmap as ShaderInput).input = sourceBitmapData;
				(shader.data.offset as ShaderParameter).value[0] = this.__offsetX;
				(shader.data.offset as ShaderParameter).value[1] = this.__offsetY;
				return shader;
			}
			var shader = (<internal.GlowFilter><any>GlowFilter).__innerCombineShader;
			(shader.data.sourceBitmap as ShaderInput).input = sourceBitmapData;
			(shader.data.offset as ShaderParameter).value[0] = this.__offsetX;
			(shader.data.offset as ShaderParameter).value[1] = this.__offsetY;
			return shader;
		}
		else
		{
			if (this.__knockout)
			{
				var shader = (<internal.GlowFilter><any>GlowFilter).__combineKnockoutShader;
				(shader.data.sourceBitmap as ShaderInput).input = sourceBitmapData;
				(shader.data.offset as ShaderParameter).value[0] = this.__offsetX;
				(shader.data.offset as ShaderParameter).value[1] = this.__offsetY;
				return shader;
			}
			else if (this.__hideObject)
			{
				var shader = DropShadowFilter.__hideShader as Shader;
				(shader.data.sourceBitmap as ShaderInput).input = sourceBitmapData;
				(shader.data.offset as ShaderParameter).value[0] = this.__offsetX;
				(shader.data.offset as ShaderParameter).value[1] = this.__offsetY;
				return shader;
			}
			var shader = (<internal.GlowFilter><any>GlowFilter).__combineShader;
			(shader.data.sourceBitmap as ShaderInput).input = sourceBitmapData;
			(shader.data.offset as ShaderParameter).value[0] = this.__offsetX;
			(shader.data.offset as ShaderParameter).value[1] = this.__offsetY;
			return shader;
		}
	}

	protected __updateSize(): void
	{
		this.__offsetX = Math.floor(this.__distance * Math.cos(this.__angle * Math.PI / 180));
		this.__offsetY = Math.floor(this.__distance * Math.sin(this.__angle * Math.PI / 180));
		this.__topExtension = Math.ceil((this.__offsetY < 0 ? -this.__offsetY : 0) + this.__blurY);
		this.__bottomExtension = Math.ceil((this.__offsetY > 0 ? this.__offsetY : 0) + this.__blurY);
		this.__leftExtension = Math.ceil((this.__offsetX < 0 ? -this.__offsetX : 0) + this.__blurX);
		this.__rightExtension = Math.ceil((this.__offsetX > 0 ? this.__offsetX : 0) + this.__blurX);
		this.__calculateNumShaderPasses();
	}

	protected __calculateNumShaderPasses(): void
	{
		this.__horizontalPasses = Math.round(this.__blurX * (this.__quality / 4)) + 1;
		this.__verticalPasses = Math.round(this.__blurY * (this.__quality / 4)) + 1;
		this.__numShaderPasses = this.__horizontalPasses + this.__verticalPasses + (this.__inner ? 2 : 1);
	}

	// Get & Set Methods

	/**
		The alpha transparency value for the shadow color. Valid values are 0.0 to
		1.0. For example, .25 sets a transparency value of 25%. The default value
		is 1.0.
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
		The angle of the shadow. Valid values are 0 to 360 degrees(floating
		point). The default value is 45.
	**/
	public get angle(): number
	{
		return this.__angle;
	}

	public set angle(value: number)
	{
		if (value != this.__angle)
		{
			this.__angle = value;
			this.__renderDirty = true;
			this.__updateSize();
		}
	}

	/**
		The amount of horizontal blur. Valid values are 0 to 255.0(floating
		point). The default value is 4.0.
	**/
	public get blurX(): number
	{
		return this.__blurX;
	}

	public set blurX(value: number)
	{
		if (value != this.__blurX)
		{
			this.__blurX = value;
			this.__renderDirty = true;
			this.__updateSize();
		}
	}

	/**
		The amount of vertical blur. Valid values are 0 to 255.0(floating point).
		The default value is 4.0.
	**/
	public get blurY(): number
	{
		return this.__blurY;
	}

	public set blurY(value: number)
	{
		if (value != this.__blurY)
		{
			this.__blurY = value;
			this.__renderDirty = true;
			this.__updateSize();
		}
	}

	/**
		The color of the shadow. Valid values are in hexadecimal format
		_0xRRGGBB_. The default value is 0x000000.
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
		The offset distance for the shadow, in pixels. The default value is 4.0
		(floating point).
	**/
	public get distance(): number
	{
		return this.__distance;
	}

	public set distance(value: number)
	{
		if (value != this.__distance)
		{
			this.__distance = value;
			this.__renderDirty = true;
			this.__updateSize();
		}
	}

	/**
		Indicates whether or not the object is hidden. The value `true`
		indicates that the object itself is not drawn; only the shadow is visible.
		The default is `false`(the object is shown).
	**/
	public get hideObject(): boolean
	{
		return this.__hideObject;
	}

	public set hideObject(value: boolean)
	{
		if (value != this.__hideObject)
		{
			this.__renderDirty = true;
		}
		this.__hideObject = value;
	}

	/**
		Indicates whether or not the shadow is an inner shadow. The value
		`true` indicates an inner shadow. The default is
		`false`, an outer shadow(a shadow around the outer edges of
		the object).
	**/
	public get inner(): boolean
	{
		return this.__inner;
	}

	public set inner(value: boolean)
	{
		if (value != this.__inner) this.__renderDirty = true;
		this.__inner = value;
	}

	/**
		Applies a knockout effect(`true`), which effectively makes the
		object's fill transparent and reveals the background color of the
		document. The default is `false`(no knockout).
	**/
	public get knockout(): boolean
	{
		return this.__knockout;
	}

	public set knockout(value: boolean)
	{
		if (value != this.__knockout) this.__renderDirty = true;
		this.__knockout = value;
	}

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
	public get quality(): number
	{
		return this.__quality;
	}

	public set quality(value: number)
	{
		if (value != this.__quality) this.__renderDirty = true;
		this.__quality = value;
	}

	/**
		The strength of the imprint or spread. The higher the value, the more
		color is imprinted and the stronger the contrast between the shadow and
		the background. Valid values are from 0 to 255.0. The default is 1.0.
	**/
	public get strength(): number
	{
		return this.__strength;
	}

	public set strength(value: number)
	{
		if (value != this.__strength) this.__renderDirty = true;
		this.__strength = value;
	}
}
