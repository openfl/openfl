package format.swf.data.filters;

import openfl._internal.swf.FilterType;
import format.swf.SWFData;
import format.swf.utils.ColorUtils;

import flash.filters.BitmapFilter;
import flash.filters.GlowFilter;

class FilterGlow extends Filter implements IFilter
{
	public var glowColor:Int;
	public var blurX:Float;
	public var blurY:Float;
	public var strength:Float;
	public var innerGlow:Bool;
	public var knockout:Bool;
	public var compositeSource:Bool;
	public var passes:Int;
	
	public function new(id:Int) {
		super(id);
	}
	
	override private function get_filter():BitmapFilter {
		return new GlowFilter(
			ColorUtils.rgb(glowColor),
			ColorUtils.alpha(glowColor),
			blurX,
			blurY,
			strength,
			passes,
			innerGlow,
			knockout
		);
	}
	
	override private function get_type():FilterType {
		return GlowFilter(
			ColorUtils.rgb(glowColor),
			ColorUtils.alpha(glowColor),
			blurX,
			blurY,
			strength,
			passes,
			innerGlow,
			knockout
		);
	}
	
	override public function parse(data:SWFData):Void {
		glowColor = data.readRGBA();
		blurX = data.readFIXED();
		blurY = data.readFIXED();
		strength = data.readFIXED8();
		var flags:Int = data.readUI8();
		innerGlow = ((flags & 0x80) != 0);
		knockout = ((flags & 0x40) != 0);
		compositeSource = ((flags & 0x20) != 0);
		passes = flags & 0x1f;
	}
	
	override public function publish(data:SWFData):Void {
		data.writeRGBA(glowColor);
		data.writeFIXED(blurX);
		data.writeFIXED(blurY);
		data.writeFIXED8(strength);
		var flags:Int = (passes & 0x1f);
		if(innerGlow) { flags |= 0x80; }
		if(knockout) { flags |= 0x40; }
		if(compositeSource) { flags |= 0x20; }
		data.writeUI8(flags);
	}
	
	override public function clone():IFilter {
		var filter:FilterGlow = new FilterGlow(id);
		filter.glowColor = glowColor;
		filter.blurX = blurX;
		filter.blurY = blurY;
		filter.strength = strength;
		filter.passes = passes;
		filter.innerGlow = innerGlow;
		filter.knockout = knockout;
		filter.compositeSource = compositeSource;
		return filter;
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = "[GlowFilter] " +
			"GlowColor: " + ColorUtils.rgbToString(glowColor) + ", " +
			"BlurX: " + blurX + ", " +
			"BlurY: " + blurY + ", " +
			"Strength: " + strength + ", " +
			"Passes: " + passes;
		var flags:Array<String> = [];
		if(innerGlow) { flags.push("InnerGlow"); }
		if(knockout) { flags.push("Knockout"); }
		if(compositeSource) { flags.push("CompositeSource"); }
		if(flags.length > 0) {
			str += ", Flags: " + flags.join(", ");
		}
		return str;
	}
}