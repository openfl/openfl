package format.swf.data;

import format.swf.SWFData;

class SWFMorphFocalGradient extends SWFMorphGradient
{
	public function new(data:SWFData = null, level:Int = 1) {
		super(data, level);
	}
	
	override public function parse(data:SWFData, level:Int):Void {
		super.parse(data, level);
		startFocalPoint = data.readFIXED8();
		endFocalPoint = data.readFIXED8();
	}
	
	override public function publish(data:SWFData, level:Int):Void {
		super.publish(data, level);
		data.writeFIXED8(startFocalPoint);
		data.writeFIXED8(endFocalPoint);
	}
	
	override public function getMorphedGradient(ratio:Float = 0):SWFGradient {
		var gradient:SWFGradient = new SWFGradient();
		// TODO: focalPoint
		for(i in 0...records.length) {
			gradient.records.push(records[i].getMorphedGradientRecord(ratio)); 
		}
		return gradient;
	}
	
	override public function toString():String {
		return "FocalPoint: " + startFocalPoint + "," + endFocalPoint + " (" + records.join(",") + ")";
	}
}