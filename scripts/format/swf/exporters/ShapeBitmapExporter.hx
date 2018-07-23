package format.swf.exporters;


import haxe.ds.Option;
import openfl._internal.swf.ShapeCommand;
import openfl.geom.Matrix;


/*
 * SWF tends to output bitmaps as a ShapeSymbol, but exporting as Bitmap instances can be more efficient at runtime.
 * This exporter attempts to detect simple bitmaps, and export as a MovieClip with Bitmap children instead
 * The exporter will return null if it seems like an incompatible list of commands
 */
class ShapeBitmapExporter {
	
	
	public static function process (exporter:ShapeCommandExporter):Array<BitmapFill> {
		
		var bitmaps = [];
		var commands = exporter.commands.copy ();
		var eligible = (commands != null && commands.length > 0 && commands.length % 9 == 0);
		
		if (!eligible) {
			
			return null;
			
		} 
		
		while (commands.length > 0) {
			
			switch (processNextBitmap (commands.splice (0, 9))) {
				
				case Some (bitmap): bitmaps.push (bitmap);
				case None: return null;
				
			}
			
		}
		
		return bitmaps;
		
	}
	
	
	private static function processNextBitmap (commands:Array<ShapeCommand>):Option<BitmapFill> {
		
		var index = 0;
		var bitmapID = 0;
		var positionX = 0.0;
		var positionY = 0.0;
		var transform = null;
		var smoothBitmap = true;
		
		// TODO: Handle cropped bitmaps?
		
		for (command in commands) {
			
			switch (command) {
				
				case LineStyle (null, null, null, null, null, null, null, null) if (index == 0): null;
				case EndFill if (index == 1): null;
				case BeginBitmapFill (bid, matrix, repeat, smooth) if (index == 2): 
					bitmapID = bid;
					transform = matrix;
					smoothBitmap = smooth;
				case MoveTo(x, y) if (index == 3): 
					positionX = x;
					positionY = y;
				case LineTo (x, y) if (index == 4): null;
				case LineTo (x, y) if (index == 5): null;
				case LineTo (x, y) if (index == 6): null;
				case LineTo (x, y) if (index == 7): null;
				case EndFill if (index == 8): null;
				default: return None;
				
			}
			
			index++;
			
		}
		
		if (transform == null) {
			
			transform = new Matrix ();
			transform.translate (positionX, positionY);
			
		}
		
		return Some ({ id: bitmapID, transform: transform, smooth: smoothBitmap });
		
	}
	
	
}


typedef BitmapFill = {
	
	id:Int, 
	transform:Matrix,
	smooth:Bool
	
}