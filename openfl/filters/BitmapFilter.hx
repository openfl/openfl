package openfl.filters;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class BitmapFilter {
	
	
	private var __cacheObject:Bool;
	private var __filterRequiresCopy:Bool;
	private var __numShaderPasses:Int;
	
	
	public function new () {
		
		__filterRequiresCopy = true;
		__numShaderPasses = 0;
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	private function __applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		return bitmapData;
		
	}
	
	
	private function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		return renderSession.shaderManager.defaultShader;
		
	}
	
	
}