namespace openfl.filters;

#if!flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";

/**
	The BitmapFilter class is the base class for all image filter effects.

	The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
	DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
	and GradientGlowFilter classes all extend the BitmapFilter class. You can
	apply these filter effects to any display object.

	You can neither directly instantiate nor extend BitmapFilter.
**/
#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class BitmapFilter
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

	public new()
	{
		__bottomExtension = 0;
		__leftExtension = 0;
		__needSecondBitmapData = true;
		__numShaderPasses = 0;
		__preserveObject = false;
		__rightExtension = 0;
		__shaderBlendMode = NORMAL;
		__topExtension = 0;
		__smooth = true;
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
#else
typedef BitmapFilter = flash.filters.BitmapFilter;
#end
