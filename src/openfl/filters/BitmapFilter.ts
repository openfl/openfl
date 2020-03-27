import BitmapData from "../display/BitmapData";
import BlendMode from "../display/BlendMode";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Shader from "../display/Shader";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";

/**
	The BitmapFilter class is the base class for all image filter effects.

	The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
	DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
	and GradientGlowFilter classes all extend the BitmapFilter class. You can
	apply these filter effects to any display object.

	You can neither directly instantiate nor extend BitmapFilter.
**/
export default class BitmapFilter
{
	protected __bottomExtension: number;
	protected __leftExtension: number;
	protected __needSecondBitmapData: boolean;
	protected __numShaderPasses: number;
	protected __preserveObject: boolean;
	protected __renderDirty: boolean;
	protected __rightExtension: number;
	protected __shaderBlendMode: BlendMode;
	protected __smooth: boolean;
	protected __topExtension: number;

	public constructor()
	{
		this.__bottomExtension = 0;
		this.__leftExtension = 0;
		this.__needSecondBitmapData = true;
		this.__numShaderPasses = 0;
		this.__preserveObject = false;
		this.__rightExtension = 0;
		this.__shaderBlendMode = BlendMode.NORMAL;
		this.__topExtension = 0;
		this.__smooth = true;
	}

	/**
		Returns a BitmapFilter object that is an exact copy of the original
		BitmapFilter object.

		@return A BitmapFilter object.
	**/
	public clone(): BitmapFilter
	{
		return new BitmapFilter();
	}

	protected __applyFilter(bitmapData: BitmapData, sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point): BitmapData
	{
		return sourceBitmapData;
	}

	protected __initShader(renderer: DisplayObjectRenderer, pass: number, sourceBitmapData: BitmapData): Shader
	{
		// return renderer.__defaultShader;
		return null;
	}
}
