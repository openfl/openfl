package openfl.filters;


import lime.graphics.utils.ImageCanvasUtil;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;


@:final class ColorMatrixFilter extends BitmapFilter {
	
	
	public var matrix (default, set):Array<Float>;
	
	
	public function new (matrix:Array<Float> = null) {
		
		super ();
		
		this.matrix = matrix;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (matrix);
		
	}
	
	
	public override function __applyFilter (sourceBitmapData:BitmapData, destBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):Void {
		
		#if (js && html5)
		ImageCanvasUtil.convertToCanvas (sourceBitmapData.image);
		ImageCanvasUtil.createImageData (sourceBitmapData.image);
		ImageCanvasUtil.convertToCanvas (destBitmapData.image);
		ImageCanvasUtil.createImageData (destBitmapData.image);
		#end
		
		var source = sourceBitmapData.image.data;
		var target = destBitmapData.image.data;
		
		var offsetX = Std.int (destPoint.x - sourceRect.x);
		var offsetY = Std.int (destPoint.y - sourceRect.y);
		var sourceStride = sourceBitmapData.width * 4;
		var targetStride = destBitmapData.width * 4;
		
		var sourceOffset:Int;
		var targetOffset:Int;
		
		for (row in Std.int (sourceRect.y)...Std.int (sourceRect.height)) {
			
			for (column in Std.int (sourceRect.x)...Std.int (sourceRect.width)) {
				
				sourceOffset = (row * sourceStride) + (column * 4);
				targetOffset = ((row + offsetX) * targetStride) + ((column + offsetY) * 4);
				
				var srcR = source[sourceOffset];
				var srcG = source[sourceOffset + 1];
				var srcB = source[sourceOffset + 2];
				var srcA = source[sourceOffset + 3];
				
				target[targetOffset] = Std.int ((matrix[0]  * srcR) + (matrix[1]  * srcG) + (matrix[2]  * srcB) + (matrix[3]  * srcA) + matrix[4]);
				target[targetOffset + 1] = Std.int ((matrix[5]  * srcR) + (matrix[6]  * srcG) + (matrix[7]  * srcB) + (matrix[8]  * srcA) + matrix[9]);
				target[targetOffset + 2] = Std.int ((matrix[10] * srcR) + (matrix[11] * srcG) + (matrix[12] * srcB) + (matrix[13] * srcA) + matrix[14]);
				target[targetOffset + 3] = Std.int ((matrix[15] * srcR) + (matrix[16] * srcG) + (matrix[17] * srcB) + (matrix[18] * srcA) + matrix[19]);
				
			}
			
		}
		
		destBitmapData.image.dirty = true;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_matrix (value:Array<Float>):Array<Float> {
		
		if (value == null) {
			
			value = [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ];
			
		}
		
		return matrix = value;
		
	}
	
	
}