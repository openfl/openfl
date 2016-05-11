package openfl.filters; #if !openfl_legacy


import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class BitmapFilter {
	
	
	public function new () {
		
		
		
	}
	
	
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	public function __applyFilter (sourceBitmapData:BitmapData, destBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	
	
}


#else
typedef BitmapFilter = openfl._legacy.filters.BitmapFilter;
#end