package format.swf.data.actions;

import format.swf.SWFData;

class ActionUnknown extends Action implements IAction
{
	public function new(code:Int, length:Int, pos:Int) {
		super(code, length, pos);
		//trace("Hello ActionUnknown");
	}
	
	override public function parse(data:SWFData):Void {
		if (length > 0) {
			data.skipBytes(length);
		}
	}
	
	override public function toString(indent:Int = 0):String {
		return "[????] Code: " + StringTools.hex (code) + ", Length: " + length;
	}
}