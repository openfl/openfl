package openfl.filters;


import openfl.geom.Point;
import openfl.geom.Rectangle;

#if js
import js.html.ImageData;
#end


class BitmapFilter {
	
	
	public function new () {
		
		
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	#if js
	public function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	#end
	
	
}