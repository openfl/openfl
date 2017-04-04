package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.StringUtils;

class SWFClipActions
{
	public var eventFlags:SWFClipEventFlags;
	
	public var records (default, null):Array<SWFClipActionRecord>;
	
	public function new(data:SWFData = null, version:Int = 0) {
		records = new Array <SWFClipActionRecord>();
		if (data != null) {
			parse(data, version);
		}
		
		//trace("Hello SWFClipActions");
	}
	
	public function parse(data:SWFData, version:Int):Void {
		data.readUI16(); // reserved, always 0
		eventFlags = data.readCLIPEVENTFLAGS(version);
		var record:SWFClipActionRecord;
		while ((record = data.readCLIPACTIONRECORD(version)) != null) {
			records.push(record);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeUI16(0); // reserved, always 0
		data.writeCLIPEVENTFLAGS(eventFlags, version);
		for(i in 0...records.length) {
			data.writeCLIPACTIONRECORD(records[i], version);
		}
		if(version >= 6) {
			data.writeUI32(0);
		} else {
			data.writeUI16(0);
		}
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = "ClipActions (" + eventFlags.toString() + "):";
		for (i in 0...records.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + records[i].toString(indent + 2);
		}
		return str;
	}
}