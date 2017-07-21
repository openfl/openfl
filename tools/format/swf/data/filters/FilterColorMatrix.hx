package format.swf.data.filters;

import openfl._internal.swf.FilterType;
import format.swf.SWFData;
import format.swf.utils.StringUtils;

import flash.filters.BitmapFilter;
import flash.filters.ColorMatrixFilter;

class FilterColorMatrix extends Filter implements IFilter
{
	public var colorMatrix (default, null):Array<Float>;
	
	public function new(id:Int) {
		super(id);
		colorMatrix = new Array<Float>();
	}
	
	override private function get_filter():BitmapFilter {
		return new ColorMatrixFilter([
			colorMatrix[0], colorMatrix[1], colorMatrix[2], colorMatrix[3], colorMatrix[4], 
			colorMatrix[5], colorMatrix[6], colorMatrix[7], colorMatrix[8], colorMatrix[9], 
			colorMatrix[10], colorMatrix[11], colorMatrix[12], colorMatrix[13], colorMatrix[14], 
			colorMatrix[15], colorMatrix[16], colorMatrix[17], colorMatrix[18], colorMatrix[19] 
		]);
	}
	
	override private function get_type():FilterType {
		return ColorMatrixFilter([
			colorMatrix[0], colorMatrix[1], colorMatrix[2], colorMatrix[3], colorMatrix[4], 
			colorMatrix[5], colorMatrix[6], colorMatrix[7], colorMatrix[8], colorMatrix[9], 
			colorMatrix[10], colorMatrix[11], colorMatrix[12], colorMatrix[13], colorMatrix[14], 
			colorMatrix[15], colorMatrix[16], colorMatrix[17], colorMatrix[18], colorMatrix[19] 
		]);
	}
	
	override public function parse(data:SWFData):Void {
		for (i in 0...20) {
			colorMatrix.push(data.readFLOAT());
		}
	}
	
	override public function publish(data:SWFData):Void {
		for (i in 0...20) {
			data.writeFLOAT(colorMatrix[i]);
		}
	}
	
	override public function clone():IFilter {
		var filter:FilterColorMatrix = new FilterColorMatrix(id);
		for (i in 0...20) {
			filter.colorMatrix.push(colorMatrix[i]);
		}
		return filter;
	}
	
	override public function toString(indent:Int = 0):String {
		var si:String = StringUtils.repeat(indent + 2);
		return "[ColorMatrixFilter]" + 
			"\n" + si + "[R] " + colorMatrix[0] + ", " + colorMatrix[1] + ", " + colorMatrix[2] + ", " + colorMatrix[3] + ", " + colorMatrix[4] +   
			"\n" + si + "[G] " + colorMatrix[5] + ", " + colorMatrix[6] + ", " + colorMatrix[7] + ", " + colorMatrix[8] + ", " + colorMatrix[9] + 
			"\n" + si + "[B] " + colorMatrix[10] + ", " + colorMatrix[11] + ", " + colorMatrix[12] + ", " + colorMatrix[13] + ", " + colorMatrix[14] + 
			"\n" + si + "[A] " + colorMatrix[15] + ", " + colorMatrix[16] + ", " + colorMatrix[17] + ", " + colorMatrix[18] + ", " + colorMatrix[19]; 
	}
}