package format.swf.data;

class SWFFrameLabel
{
	public var frameNumber:Int;
	public var name:String;
	
	// TODO: parse() method?
	public function new(frameNumber:Int, name:String)
	{
		this.frameNumber = frameNumber;
		this.name = name;
	}
	
	public function toString():String {
		return "Frame: " + frameNumber + ", Name: " + name;
	}
}
