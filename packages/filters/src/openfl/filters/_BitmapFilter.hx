package openfl.filters;

import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _BitmapFilter
{
	public var __bottomExtension:Int;
	public var __leftExtension:Int;
	public var __needSecondBitmapData:Bool;
	public var __numShaderPasses:Int;
	public var __preserveObject:Bool;
	public var __renderDirty:Bool;
	public var __rightExtension:Int;
	public var __shaderBlendMode:BlendMode;
	public var __smooth:Bool;
	public var __topExtension:Int;

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

	public function clone():BitmapFilter
	{
		return new BitmapFilter();
	}

	public function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		return sourceBitmapData;
	}

	public function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		// return renderer._.__defaultShader;
		return null;
	}
}
