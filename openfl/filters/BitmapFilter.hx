package openfl.filters;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class BitmapFilter {
	
	
	public function new () {
		
		
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	private function __applyFilter (sourceBitmapData:BitmapData, destBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	
	
	private function __initShader (renderSession:RenderSession):Shader {
		
		return renderSession.shaderManager.defaultShader;
		
	}
	
	
}