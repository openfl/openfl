package format.swf.data;

import format.swf.SWFData;

class SWFRawTag
{
	public var header:SWFRecordHeader;
	public var bytes:SWFData;
	
	public function new(data:SWFData = null)
	{
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		var pos:Int = data.position;
		header = data.readTagHeader();
		bytes = new SWFData();
		var posContent:Int = data.position;
		data.position = pos;
		data.readBytes(bytes, 0, header.tagLength);
		data.position = posContent;
	}
	
	public function publish(data:SWFData):Void {
		// Header is part of the byte array
		data.writeBytes(bytes);
	}
}