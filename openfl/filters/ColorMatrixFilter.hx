package openfl.filters;


import lime.graphics.utils.ImageCanvasUtil;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


@:final class ColorMatrixFilter extends BitmapFilter {
	
	
	private static var __colorMatrixShader = new ColorMatrixShader ();
	
	public var matrix (default, set):Array<Float>;
	
	
	public function new (matrix:Array<Float> = null) {
		
		super ();
		
		this.matrix = matrix;
		
		// __numPasses = 1;
		__numShaderPasses = 0;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (matrix);
		
	}
	
	
	private override function __applyFilter (destBitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
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
		return destBitmapData;
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		__colorMatrixShader.init (matrix);
		return __colorMatrixShader;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_matrix (value:Array<Float>):Array<Float> {
		
		if (value == null) {
			
			value = [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ];
			
		}
		
		return matrix = value;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


private class ColorMatrixShader extends Shader {
	
	
	@:glFragmentSource( 
		
		"varying float vAlpha;
		varying vec2 vTexCoord;
		uniform sampler2D uImage0;
		
		uniform mat4 uMultipliers;
		uniform vec4 uOffsets;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else {
				
				color = vec4 (color.rgb / color.a, color.a);
				color = uOffsets + color * uMultipliers;
				
				gl_FragColor = vec4 (color.rgb * color.a * vAlpha, color.a * vAlpha);
				
			}
			
		}"
		
	)
	
	
	public function new () {
		
		super ();
		
		#if !macro
		data.uMultipliers.value = [ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ];
		data.uOffsets.value = [ 0, 0, 0, 0 ];
		#end
		
	}
	
	
	public function init (matrix:Array<Float>):Void {
		
		var multipliers = data.uMultipliers.value;
		var offsets = data.uOffsets.value;
		
		multipliers[0] = matrix[0];
		multipliers[1] = matrix[1];
		multipliers[2] = matrix[2];
		multipliers[3] = matrix[3];
		multipliers[4] = matrix[5];
		multipliers[5] = matrix[6];
		multipliers[6] = matrix[7];
		multipliers[7] = matrix[8];
		multipliers[8] = matrix[10];
		multipliers[9] = matrix[11];
		multipliers[10] = matrix[12];
		multipliers[11] = matrix[13];
		multipliers[12] = matrix[15];
		multipliers[13] = matrix[16];
		multipliers[14] = matrix[17];
		multipliers[15] = matrix[18];
		
		offsets[0] = matrix[4] / 255.0;
		offsets[1] = matrix[9] / 255.0;
		offsets[2] = matrix[14] / 255.0;
		offsets[3] = matrix[19] / 255.0;
		
	}
	
	
}