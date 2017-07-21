package format.swf.data;

import format.swf.SWFData;

class SWFRegisterParam
{
	public var register:Int;
	public var name:String;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}

	public function parse(data:SWFData):Void {
		register = data.readUI8();
		name = data.readSTRING();
	}
	
	public function publish(data:SWFData):Void {
		data.writeUI8(register);
		data.writeSTRING(name);
	}
	
	public function toString():String {
		return register + ":" + name;
	}
}