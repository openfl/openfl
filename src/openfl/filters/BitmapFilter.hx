package openfl.filters;


import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class BitmapFilter {
	
	
	private var __bottomExtension:Int;
	private var __leftExtension:Int;
	private var __needSecondBitmapData:Bool;
	private var __numShaderPasses:Int;
	private var __preserveObject:Bool;
	private var __renderDirty:Bool;
	private var __rightExtension:Int;
	private var __shaderBlendMode:BlendMode;
	private var __topExtension:Int;
	
	
	public function new () {
		
		__bottomExtension = 0;
		__leftExtension = 0;
		__needSecondBitmapData = true;
		__numShaderPasses = 0;
		__preserveObject = false;
		__rightExtension = 0;
		__shaderBlendMode = NORMAL;
		__topExtension = 0;
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	private function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		return sourceBitmapData;
		
	}
	
	
	private function __initShader (renderer:DisplayObjectRenderer, pass:Int):Shader {
		
		// return renderer.__defaultShader;
		return null;
		
	}
	
	
}