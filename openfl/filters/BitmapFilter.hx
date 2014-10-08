package openfl.filters; #if !flash #if (display || openfl_next || js)


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
	@:noCompletion public function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	#end
	
	
}


#else
typedef BitmapFilter = openfl._v2.filters.BitmapFilter;
#end
#else
typedef BitmapFilter = flash.filters.BitmapFilter;
#end