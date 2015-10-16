package openfl.filters; #if !flash #if !openfl_legacy


import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.ImageData;
#end



class ColorMatrixFilter extends BitmapFilter {
	
	
	public var matrix(default, set):Array<Float>;
	
	private var __colorMatrixShader:ColorMatrixShader;
	
	public function new (matrix:Array<Float> = null) {
		
		super ();
		
		__colorMatrixShader = new ColorMatrixShader();
		__passes = 1;
		
		this.matrix = matrix;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (matrix);
		
	}
	
	
	#if (js && html5)
	@:noCompletion @:dox(hide) public override function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
		
		var source = sourceData.data;
		var target = targetData.data;
		
		var offsetX = Std.int (destPoint.x - sourceRect.x);
		var offsetY = Std.int (destPoint.y - sourceRect.y);
		var sourceStride = sourceData.width * 4;
		var targetStride = targetData.width * 4;
		
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
		
	}
	#end
	
	override function __preparePass(pass:Int):Shader {
		return __colorMatrixShader;
	}
	
	function set_matrix(v:Array<Float>) {
		if (v == null) {
			v = [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ];
		}
		__colorMatrixShader.uMultipliers = [
											v[0], v[1], v[2], v[3],
											v[5], v[6], v[7], v[8],
											v[10], v[11], v[12], v[13],
											v[15], v[16], v[17], v[18],
											];
		__colorMatrixShader.uOffsets = [v[4] / 255., v[9] / 255., v[14] / 255., v[19] / 255.];
		
		return matrix = v;
	}
}

private class ColorMatrixShader extends Shader {
	
	@fragment var fragment = [
		'uniform mat4 uMultipliers;',
		'uniform vec4 uOffsets;',
		'void main(void) {',
		'	vec4 color = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
		'	color = vec4(color.rgb / color.a, color.a);',
		'	color = uOffsets + color * uMultipliers;',
		'	color = vec4(color.rgb * color.a, color.a);',
		'	gl_FragColor = color;',
		'}',
	];
	
	public function new() {
		super();
	}
}


#else
typedef ColorMatrixFilter = openfl._legacy.filters.ColorMatrixFilter;
#end
#else
typedef ColorMatrixFilter = flash.filters.ColorMatrixFilter;
#end