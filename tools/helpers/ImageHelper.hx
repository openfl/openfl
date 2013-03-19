import format.SVG;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Shape;


class ImageHelper {
	
	
	public static function rasterizeSVG (svg:SVG, width:Int, height:Int, backgroundColor:Int = null):BitmapData {
		
		if (backgroundColor == null) {
			
			backgroundColor = 0x00FFFFFF;
			
		}
		
		var shape = new Shape ();
		svg.render (shape.graphics, 0, 0, width, height);
		
		var bitmapData = new BitmapData (width, height, true, backgroundColor);
		bitmapData.draw (shape);
		
		return bitmapData;
		
	}
	
	
	public static function resizeBitmapData (bitmapData:BitmapData, width:Int, height:Int):BitmapData {
		
		var bitmap = new Bitmap (bitmapData);
		
		bitmap.smoothing = true;
		bitmap.width = width;
		bitmap.height = height;
		
		var data = new BitmapData (width, height, true, 0x00FFFFFF);
		data.draw (bitmap);
		
		return data;
		
	}
	
	
}