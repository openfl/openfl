package format.swf.data.filters;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;
import format.swf.utils.StringUtils;

import flash.filters.BitmapFilter;
#if flash
import flash.filters.ConvolutionFilter; // Not supported on native yet
#end

class FilterConvolution extends Filter implements IFilter
{
	public var matrixX:Int;
	public var matrixY:Int;
	public var divisor:Float;
	public var bias:Float;
	public var defaultColor:Int;
	public var clamp:Bool;
	public var preserveAlpha:Bool;
	
	public var matrix (default, null):Array<Float>;
	
	public function new(id:Int) {
		super(id);
		matrix = new Array<Float>();
	}
	
	override private function get_filter():BitmapFilter {
		var convolutionMatrix:Array<Float> = [];
		for (i in 0...matrix.length) {
			convolutionMatrix.push(matrix[i]);
		}
		#if flash
		return new ConvolutionFilter(
			matrixX,
			matrixY,
			convolutionMatrix,
			divisor,
			bias,
			preserveAlpha,
			clamp,
			ColorUtils.rgb(defaultColor),
			ColorUtils.alpha(defaultColor)
		);
		#else
		#if ((cpp || neko) && openfl_legacy)
		return new BitmapFilter ("");
		#else
		return new BitmapFilter ();
		#end
		#end
	}
	
	override public function parse(data:SWFData):Void {
		matrixX = data.readUI8();
		matrixY = data.readUI8();
		divisor = data.readFLOAT();
		bias = data.readFLOAT();
		var len:Int = matrixX * matrixY;
		for (i in 0...len) {
			matrix.push(data.readFLOAT());
		}
		defaultColor = data.readRGBA();
		var flags:Int = data.readUI8();
		clamp = ((flags & 0x02) != 0);
		preserveAlpha = ((flags & 0x01) != 0);
	}
	
	override public function publish(data:SWFData):Void {
		data.writeUI8(matrixX);
		data.writeUI8(matrixY);
		data.writeFLOAT(divisor);
		data.writeFLOAT(bias);
		var len:Int = matrixX * matrixY;
		for (i in 0...len) {
			data.writeFLOAT(matrix[i]);
		}
		data.writeRGBA(defaultColor);
		var flags:Int = 0;
		if(clamp) { flags |= 0x02; }
		if(preserveAlpha) { flags |= 0x01; }
		data.writeUI8(flags);
	}
	
	override public function clone():IFilter {
		var filter:FilterConvolution = new FilterConvolution(id);
		filter.matrixX = matrixX;
		filter.matrixY = matrixY;
		filter.divisor = divisor;
		filter.bias = bias;
		var len:Int = matrixX * matrixY;
		for (i in 0...len) {
			filter.matrix.push(matrix[i]);
		}
		filter.defaultColor = defaultColor;
		filter.clamp = clamp;
		filter.preserveAlpha = preserveAlpha;
		return filter;
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = "[ConvolutionFilter] " +
			"DefaultColor: " + ColorUtils.rgbToString(defaultColor) + ", " +
			"Divisor: " + divisor + ", " +
			"Bias: " + bias;
		var flags:Array<String> = [];
		if(clamp) { flags.push("Clamp"); }
		if(preserveAlpha) { flags.push("PreserveAlpha"); }
		if(flags.length > 0) {
			str += ", Flags: " + flags.join(", ");
		}
		if(matrix.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Matrix:";
			for(y in 0...matrixY) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + y + "]";
				for(x in 0...matrixX) {
					str += ((x > 0) ? ", " : " ") + matrix[matrixX * y + x];
				}
			}
		}
		return str;
	}
}