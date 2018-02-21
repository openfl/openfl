package openfl.filters;


import lime.graphics.utils.ImageCanvasUtil;
import lime.math.color.RGBA;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;


@:final class ColorMatrixFilter extends BitmapFilter {
	
	
	//private static var __colorMatrixShader = new ColorMatrixShader ();
	
	public var matrix (get, set):Array<Float>;
	
	private var __matrix:Array<Float>;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (ColorMatrixFilter.prototype, {
			"matrix": { get: untyped __js__ ("function () { return this.get_matrix (); }"), set: untyped __js__ ("function (v) { return this.set_matrix (v); }") },
		});
		
	}
	#end
	
	
	public function new (matrix:Array<Float> = null) {
		
		super ();
		
		this.matrix = matrix;
		
		// __numShaderPasses = 1;
		__numShaderPasses = 0;
		__needSecondBitmapData = false;
		
	}
	
	
	public override function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (__matrix);
		
	}
	
	
	private override function __applyFilter (destBitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData {
		
		var sourceImage = sourceBitmapData.image; 
		var image = destBitmapData.image;
		
		#if (js && html5)
		ImageCanvasUtil.convertToData (sourceImage);
		ImageCanvasUtil.convertToData (image);
		#end
		
		var sourceData = sourceImage.data;
		var destData = image.data;
		
		var offsetX = Std.int (destPoint.x - sourceRect.x);
		var offsetY = Std.int (destPoint.y - sourceRect.y);
		var sourceStride = sourceBitmapData.width * 4;
		var destStride = destBitmapData.width * 4;
		
		var sourceFormat = sourceImage.buffer.format;
		var destFormat = image.buffer.format;
		var sourcePremultiplied = sourceImage.buffer.premultiplied;
		var destPremultiplied = image.buffer.premultiplied;
		
		var sourcePixel:RGBA, destPixel:RGBA = 0;
		var sourceOffset:Int, destOffset:Int;
		
		for (row in Std.int (sourceRect.y)...Std.int (sourceRect.height)) {
			
			for (column in Std.int (sourceRect.x)...Std.int (sourceRect.width)) {
				
				sourceOffset = (row * sourceStride) + (column * 4);
				destOffset = ((row + offsetX) * destStride) + ((column + offsetY) * 4);
				
				sourcePixel.readUInt8 (sourceData, sourceOffset, sourceFormat, sourcePremultiplied);
				
				if (sourcePixel.a == 0) {
					
					destPixel = 0;
					
				} else {
					
					destPixel.r = Std.int (Math.max(0, Math.min ((__matrix[0] * sourcePixel.r) + (__matrix[1] * sourcePixel.g) + (__matrix[2] * sourcePixel.b) + (__matrix[3] * sourcePixel.a) + __matrix[4], 255)));
					destPixel.g = Std.int (Math.max(0, Math.min ((__matrix[5] * sourcePixel.r) + (__matrix[6] * sourcePixel.g) + (__matrix[7] * sourcePixel.b) + (__matrix[8] * sourcePixel.a) + __matrix[9], 255)));
					destPixel.b = Std.int (Math.max(0, Math.min ((__matrix[10] * sourcePixel.r) + (__matrix[11] * sourcePixel.g) + (__matrix[12] * sourcePixel.b) + (__matrix[13] * sourcePixel.a) + __matrix[14], 255)));
					destPixel.a = Std.int (Math.max(0, Math.min ((__matrix[15] * sourcePixel.r) + (__matrix[16] * sourcePixel.g) + (__matrix[17] * sourcePixel.b) + (__matrix[18] * sourcePixel.a) + __matrix[19], 255)));
					
				}
				
				destPixel.writeUInt8 (destData, destOffset, destFormat, destPremultiplied);
				
			}
			
		}
		
		destBitmapData.image.dirty = true;
		return destBitmapData;
		
	}
	
	
	private override function __initShader (renderSession:RenderSession, pass:Int):Shader {
		
		return null;
		//__colorMatrixShader.init (matrix);
		//return __colorMatrixShader;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_matrix ():Array<Float> {
		
		return __matrix;
		
	}
	
	
	private function set_matrix (value:Array<Float>):Array<Float> {
		
		if (value == null) {
			
			value = [ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 ];
			
		}
		
		return __matrix = value;
		
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