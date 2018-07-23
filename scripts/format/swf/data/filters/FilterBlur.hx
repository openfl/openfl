package format.swf.data.filters;

import openfl._internal.swf.FilterType;
import format.swf.SWFData;

import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;

class FilterBlur extends Filter implements IFilter
{
	public var blurX:Float;
	public var blurY:Float;
	public var passes:Int;
	
	public function new(id:Int) {
		super(id);
	}
	
	override private function get_filter():BitmapFilter {
		return new BlurFilter(
			blurX,
			blurY,
			passes
		);
	}
	
	override private function get_type():FilterType {
		return BlurFilter(blurX, blurY, passes);
	}
	
	override public function parse(data:SWFData):Void {
		blurX = data.readFIXED();
		blurY = data.readFIXED();
		passes = data.readUI8() >> 3;
	}
	
	override public function publish(data:SWFData):Void {
		data.writeFIXED(blurX);
		data.writeFIXED(blurY);
		data.writeUI8(passes << 3);
	}
	
	override public function clone():IFilter {
		var filter:FilterBlur = new FilterBlur(id);
		filter.blurX = blurX;
		filter.blurY = blurY;
		filter.passes = passes;
		return filter;
	}
	
	override public function toString(indent:Int = 0):String {
		return "[BlurFilter] " +
			"BlurX: " + blurX + ", " +
			"BlurY: " + blurY + ", " +
			"Passes: " + passes;
	}
}