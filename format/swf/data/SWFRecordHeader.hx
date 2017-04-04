package format.swf.data;

class SWFRecordHeader
{
	public var type:Int;
	public var contentLength:Int;
	public var headerLength:Int;
	
	public var tagLength (get_tagLength, null):Int;
	
	public function new(type:Int, contentLength:Int, headerLength:Int)
	{
		this.type = type;
		this.contentLength = contentLength;
		this.headerLength = headerLength;
	}
	
	private function get_tagLength():Int {
		return headerLength + contentLength;
	}
	
	public function toString():String {
		return "[SWFRecordHeader] type: " + type + ", headerLength: " + headerLength + ", contentlength: " + contentLength;
	}
}