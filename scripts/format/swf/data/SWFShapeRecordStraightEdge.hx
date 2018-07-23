package format.swf.data;

import format.swf.SWFData;

class SWFShapeRecordStraightEdge extends SWFShapeRecord
{
	public var generalLineFlag:Bool;
	public var vertLineFlag:Bool;
	public var deltaY:Int;
	public var deltaX:Int;
	
	private var numBits:Int;

	public function new(data:SWFData = null, numBits:Int = 0, level:Int = 1) {
		this.numBits = numBits;
		super(data, level);
	}
	
	override public function parse(data:SWFData = null, level:Int = 1):Void {
		generalLineFlag = (data.readUB(1) == 1);
		vertLineFlag = !generalLineFlag ? (data.readUB(1) == 1) : false;
		deltaX = (generalLineFlag || !vertLineFlag) ? data.readSB(numBits) : 0;
		deltaY = (generalLineFlag || vertLineFlag) ? data.readSB(numBits) : 0;
	}
	
	override public function publish(data:SWFData = null, level:Int = 1):Void {
		var deltas:Array<Int> = [];
		if(generalLineFlag || !vertLineFlag) { deltas.push(deltaX); }
		if(generalLineFlag || vertLineFlag) { deltas.push(deltaY); }
		numBits = data.calculateMaxBits(true, deltas);
		if(numBits < 2) { numBits = 2; }
		data.writeUB(4, numBits - 2);
		data.writeUB(1, generalLineFlag ? 1 : 0);
		if(!generalLineFlag) {
			data.writeUB(1, vertLineFlag ? 1 : 0);
		}
		for(i in 0...deltas.length) {
			data.writeSB(numBits, Std.int(deltas[i]));
		}
	}
	
	override public function clone():SWFShapeRecord {
		var record:SWFShapeRecordStraightEdge = new SWFShapeRecordStraightEdge();
		record.deltaX = deltaX;
		record.deltaY = deltaY;
		record.generalLineFlag = generalLineFlag;
		record.vertLineFlag = vertLineFlag;
		record.numBits = numBits;
		return record;
	}
	
	override private function get_type():Int { return SWFShapeRecord.TYPE_STRAIGHTEDGE; }
	
	override public function toString(indent:Int = 0):String {
		var str:String = "[SWFShapeRecordStraightEdge] ";
		if (generalLineFlag) {
			str += "General: " + deltaX + "," + deltaY;
		} else {
			if (vertLineFlag) {
				str += "Vertical: " + deltaY;
			} else {
				str += "Horizontal: " + deltaX;
			}
		}
		return str;
	}
}