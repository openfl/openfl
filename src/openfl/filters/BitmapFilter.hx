package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	The BitmapFilter class is the base class for all image filter effects.

	The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
	DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
	and GradientGlowFilter classes all extend the BitmapFilter class. You can
	apply these filter effects to any display object.

	You can neither directly instantiate nor extend BitmapFilter.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class BitmapFilter
{
	@:noCompletion private var __bottomExtension:Int;
	@:noCompletion private var __leftExtension:Int;
	@:noCompletion private var __needSecondBitmapData:Bool;
	@:noCompletion private var __numShaderPasses:Int;
	@:noCompletion private var __preserveObject:Bool;
	@:noCompletion private var __renderDirty:Bool;
	@:noCompletion private var __rightExtension:Int;
	@:noCompletion private var __shaderBlendMode:BlendMode;
	@:noCompletion private var __smooth:Bool;
	@:noCompletion private var __topExtension:Int;

	public function new()
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
	public function clone():BitmapFilter
	{
		return new BitmapFilter();
	}

	@:noCompletion private function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		return sourceBitmapData;
	}

	@:noCompletion private function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		// return renderer.__defaultShader;
		return null;
	}
}
#else
typedef BitmapFilter = flash.filters.BitmapFilter;
#end
