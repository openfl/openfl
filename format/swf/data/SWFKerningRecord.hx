package format.swf.data;

import format.swf.SWFData;

class SWFKerningRecord
{
	public var code1:Int;
	public var code2:Int;
	public var adjustment:Int;

	public function new(data:SWFData = null, wideCodes:Bool = false) {
		if (data != null) {
			parse(data, wideCodes);
		}
	}

	public function parse(data:SWFData, wideCodes:Bool):Void {
		code1 = wideCodes ? data.readUI16() : data.readUI8();
		code2 = wideCodes ? data.readUI16() : data.readUI8();
		adjustment = data.readSI16();
	}
	
	public function publish(data:SWFData, wideCodes:Bool):Void {
		if(wideCodes) { data.writeUI16(code1); } else { data.writeUI8(code1); }
		if(wideCodes) { data.writeUI16(code2); } else { data.writeUI8(code2); }
		data.writeSI16(adjustment);
	}
	
	public function toString(indent:Int = 0):String {
		return "Code1: " + code1 + ", " + "Code2: " + code2 + ", " + "Adjustment: " + adjustment;
	}
}