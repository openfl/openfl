package openfl.filters;


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class BitmapFilter {
	
	private var __cacheObject:Bool;
	private var __filterDirty:Bool;
	private var __numPasses:Int;
	private var __preserveOriginal:Bool;
	private var __filterTransform:Matrix;
	
	
	public function new () {
		
		__filterDirty = true;
		__numPasses = 0;
		__preserveOriginal = false;

		__filterTransform = new Matrix();
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	private function __applyFilter (sourceBitmapData:BitmapData, destBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	

	private function __getFilterBounds( sourceBitmapData:BitmapData ) : Rectangle {

		return new Rectangle();

	}


	private function __renderFilter (sourceBitmapData:BitmapData, destBitmapData:BitmapData):Void {
		
		__filterDirty = false;
		
	}


    private function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		return renderSession.shaderManager.defaultShader;
		
	}
	
	
}
