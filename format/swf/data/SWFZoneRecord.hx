package format.swf.data;

import format.swf.SWFData;

class SWFZoneRecord
{
	public var maskX:Bool;
	public var maskY:Bool;

	public var zoneData(default, null):Array<SWFZoneData>;
	
	public function new(data:SWFData = null) {
		zoneData = new Array<SWFZoneData>();
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		var numZoneData:Int = data.readUI8();
		for (i in 0...numZoneData) {
			zoneData.push(data.readZONEDATA());
		}
		var mask:Int = data.readUI8();
		maskX = ((mask & 0x01) != 0);
		maskY = ((mask & 0x02) != 0);
	}
	
	public function publish(data:SWFData):Void {
		var numZoneData:Int = zoneData.length;
		data.writeUI8(numZoneData);
		for (i in 0...numZoneData) {
			data.writeZONEDATA(zoneData[i]);
		}
		var mask:Int = 0;
		if(maskX) { mask |= 0x01; }
		if(maskY) { mask |= 0x02; }
		data.writeUI8(mask);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = "MaskY: " + maskY + ", MaskX: " + maskX;
		for (i in 0...zoneData.length) {
			str += ", " + i + ": " + zoneData[i].toString();
		}
		return str;
	}
}