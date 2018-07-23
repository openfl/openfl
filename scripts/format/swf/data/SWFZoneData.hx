package format.swf.data;

import format.swf.SWFData;

class SWFZoneData
{
	public var alignmentCoordinate:Float;
	public var range:Float;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		alignmentCoordinate = data.readFLOAT16();
		range = data.readFLOAT16();
	}
	
	public function publish(data:SWFData):Void {
		data.writeFLOAT16(alignmentCoordinate);
		data.writeFLOAT16(range);
	}
	
	public function toString():String {
		return "(" + alignmentCoordinate + "," + range + ")";
	}
}