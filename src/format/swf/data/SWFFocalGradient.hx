package format.swf.data;

import format.swf.SWFData;

class SWFFocalGradient extends SWFGradient
{
	public function new(data:SWFData = null, level:Int = 1) {
		super(data, level);
	}
	
	override public function parse(data:SWFData, level:Int):Void {
		super.parse(data, level);
		focalPoint = data.readFIXED8();
	}
	
	override public function publish(data:SWFData, level:Int = 1):Void {
		super.publish(data, level);
		data.writeFIXED8(focalPoint);
	}
	
	override public function toString():String {
		return "(" + records.join(",") + ")";
	}
}