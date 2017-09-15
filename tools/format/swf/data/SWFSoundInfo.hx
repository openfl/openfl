package format.swf.data;

import format.swf.SWFData;

class SWFSoundInfo
{
	public var syncStop:Bool;
	public var syncNoMultiple:Bool;
	public var hasEnvelope:Bool;
	public var hasLoops:Bool;
	public var hasOutPoint:Bool;
	public var hasInPoint:Bool;
	
	public var outPoint:Int;
	public var inPoint:Int;
	public var loopCount:Int;
	
	public var envelopeRecords (default, null):Array<SWFSoundEnvelope>;
	
	public function new(data:SWFData = null) {
		envelopeRecords = new Array <SWFSoundEnvelope>();
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		var flags:Int = data.readUI8();
		syncStop = ((flags & 0x20) != 0);
		syncNoMultiple = ((flags & 0x10) != 0);
		hasEnvelope = ((flags & 0x08) != 0);
		hasLoops = ((flags & 0x04) != 0);
		hasOutPoint = ((flags & 0x02) != 0);
		hasInPoint = ((flags & 0x01) != 0);
		if (hasInPoint) {
			inPoint = data.readUI32();
		}
		if (hasOutPoint) {
			outPoint = data.readUI32();
		}
		if (hasLoops) {
			loopCount = data.readUI16();
		}
		if (hasEnvelope) {
			var envPoints:Int = data.readUI8();
			for (i in 0...envPoints) {
				envelopeRecords.push(data.readSOUNDENVELOPE());
			}
		}
	}
	
	public function publish(data:SWFData):Void {
		var flags:Int = 0;
		if(syncStop) { flags |= 0x20; }
		if(syncNoMultiple) { flags |= 0x10; }
		if(hasEnvelope) { flags |= 0x08; }
		if(hasLoops) { flags |= 0x04; }
		if(hasOutPoint) { flags |= 0x02; }
		if(hasInPoint) { flags |= 0x01; }
		data.writeUI8(flags);
		if (hasInPoint) {
			data.writeUI32(inPoint);
		}
		if (hasOutPoint) {
			data.writeUI32(outPoint);
		}
		if (hasLoops) {
			data.writeUI16(loopCount);
		}
		if (hasEnvelope) {
			var envPoints:Int = envelopeRecords.length;
			data.writeUI8(envPoints);
			for (i in 0...envPoints) {
				data.writeSOUNDENVELOPE(envelopeRecords[i]);
			}
		}
	}
	
	public function clone():SWFSoundInfo {
		var soundInfo:SWFSoundInfo = new SWFSoundInfo();
		soundInfo.syncStop = syncStop;
		soundInfo.syncNoMultiple = syncNoMultiple;
		soundInfo.hasEnvelope = hasEnvelope;
		soundInfo.hasLoops = hasLoops;
		soundInfo.hasOutPoint = hasOutPoint;
		soundInfo.hasInPoint = hasInPoint;
		soundInfo.outPoint = outPoint;
		soundInfo.inPoint = inPoint;
		soundInfo.loopCount = loopCount;
		for (i in 0...envelopeRecords.length) {
			soundInfo.envelopeRecords.push(envelopeRecords[i].clone());
		}
		return soundInfo;
	}
	
	public function toString():String {
		return "[SWFSoundInfo]";
	}
}