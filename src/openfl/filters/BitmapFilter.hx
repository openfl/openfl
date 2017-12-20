package openfl.filters;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class BitmapFilter {
	
	
	private var __bottomExtension:Int;
	private var __leftExtension:Int;
	private var __needSecondBitmapData:Bool;
	private var __numShaderPasses:Int;
	private var __preserveObject:Bool;
	private var __renderDirty:Bool;
	private var __rightExtension:Int;
	private var __topExtension:Int;
	
	
	public function new () {
		
		__bottomExtension = 0;
		__leftExtension = 0;
		__needSecondBitmapData = true;
		__numShaderPasses = 0;
		__preserveObject = false;
		__rightExtension = 0;
		__topExtension = 0;
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	private function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		return sourceBitmapData;
		
	}
	
	
	private function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		return renderSession.shaderManager.defaultShader;
		
	}
	
	
}