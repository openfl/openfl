package format.swf.data.filters;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;

#if flash
import flash.filters.BevelFilter;
#end
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterType;

class FilterBevel extends Filter implements IFilter
{
	public var shadowColor:Int;
	public var highlightColor:Int;
	public var blurX:Float;
	public var blurY:Float;
	public var angle:Float;
	public var distance:Float;
	public var strength:Float;
	public var innerShadow:Bool;
	public var knockout:Bool;
	public var compositeSource:Bool;
	public var onTop:Bool;
	public var passes:Int;
	
	public function new(id:Int) {
		super(id);
	}
	
	override private function get_filter():BitmapFilter {
		#if flash
		var filterType:BitmapFilterType;
		#else
		var filterType:String;
		#end
		if(onTop) {
			filterType = BitmapFilterType.FULL;
		} else {
			filterType = (innerShadow) ? BitmapFilterType.INNER : BitmapFilterType.OUTER;
		}
		#if flash
		return new BevelFilter(
			distance,
			angle * 180 / Math.PI,
			ColorUtils.rgb(highlightColor),
			ColorUtils.alpha(highlightColor),
			ColorUtils.rgb(shadowColor),
			ColorUtils.alpha(shadowColor),
			blurX,
			blurY,
			strength,
			passes,
			filterType,
			knockout
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
		shadowColor = data.readRGBA();
		highlightColor = data.readRGBA();
		blurX = data.readFIXED();
		blurY = data.readFIXED();
		angle = data.readFIXED();
		distance = data.readFIXED();
		strength = data.readFIXED8();
		var flags:Int = data.readUI8();
		innerShadow = ((flags & 0x80) != 0);
		knockout = ((flags & 0x40) != 0);
		compositeSource = ((flags & 0x20) != 0);
		onTop = ((flags & 0x10) != 0);
		passes = flags & 0x0f;
	}
	
	override public function publish(data:SWFData):Void {
		data.writeRGBA(shadowColor);
		data.writeRGBA(highlightColor);
		data.writeFIXED(blurX);
		data.writeFIXED(blurY);
		data.writeFIXED(angle);
		data.writeFIXED(distance);
		data.writeFIXED8(strength);
		var flags:Int = (passes & 0x0f);
		if(innerShadow) { flags |= 0x80; }
		if(knockout) { flags |= 0x40; }
		if(compositeSource) { flags |= 0x20; }
		if(onTop) { flags |= 0x10; }
		data.writeUI8(flags);
	}
	
	override public function clone():IFilter {
		var filter:FilterBevel = new FilterBevel(id);
		filter.shadowColor = shadowColor;
		filter.highlightColor = highlightColor;
		filter.blurX = blurX;
		filter.blurY = blurY;
		filter.angle = angle;
		filter.distance = distance;
		filter.strength = strength;
		filter.passes = passes;
		filter.innerShadow = innerShadow;
		filter.knockout = knockout;
		filter.compositeSource = compositeSource;
		filter.onTop = onTop;
		return filter;
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = "[BevelFilter] " +
			"ShadowColor: " + ColorUtils.rgbToString(shadowColor) + ", " +
			"HighlightColor: " + ColorUtils.rgbToString(highlightColor) + ", " +
			"BlurX: " + blurX + ", " +
			"BlurY: " + blurY + ", " +
			"Angle: " + angle + ", " +
			"Distance: " + distance + ", " +
			"Strength: " + strength + ", " +
			"Passes: " + passes;
		var flags:Array<String> = [];
		if(innerShadow) { flags.push("InnerShadow"); }
		if(knockout) { flags.push("Knockout"); }
		if(compositeSource) { flags.push("CompositeSource"); }
		if(onTop) { flags.push("OnTop"); }
		if(flags.length > 0) {
			str += ", Flags: " + flags.join(", ");
		}
		return str;
	}
}