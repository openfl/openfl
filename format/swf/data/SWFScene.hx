package format.swf.data;

class SWFScene
{
	public var offset:Int;
	public var name:String;
	
	// TODO: parse() method?
	public function new(offset:Int, name:String)
	{
		this.offset = offset;
		this.name = name;
	}
	
	public function toString():String {
		return "Frame: " + offset + ", Name: " + name;
	}
}