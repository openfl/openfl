package format.swf.data;

import format.swf.SWFData;

class SWFSoundEnvelope
{
	public var pos44:Int;
	public var leftLevel:Int;
	public var rightLevel:Int;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		pos44 = data.readUI32();
		leftLevel = data.readUI16();
		rightLevel = data.readUI16();
	}
	
	public function publish(data:SWFData):Void {
		data.writeUI32(pos44);
		data.writeUI16(leftLevel);
		data.writeUI16(rightLevel);
	}
	
	public function clone():SWFSoundEnvelope {
		var soundEnvelope:SWFSoundEnvelope = new SWFSoundEnvelope();
		soundEnvelope.pos44 = pos44;
		soundEnvelope.leftLevel = leftLevel;
		soundEnvelope.rightLevel = rightLevel;
		return soundEnvelope;
	}
	
	public function toString():String {
		return "[SWFSoundEnvelope]";
	}
}