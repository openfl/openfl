package format.swf.data;

import format.swf.SWFData;

class SWFShapeRecordCurvedEdge extends SWFShapeRecord
{
	public var controlDeltaX:Int;
	public var controlDeltaY:Int;
	public var anchorDeltaX:Int;
	public var anchorDeltaY:Int;
	
	private var numBits:Int;

	public function new(data:SWFData = null, numBits:Int = 0, level:Int = 1) {
		this.numBits = numBits;
		super(data, level);
	}
	
	override public function parse(data:SWFData = null, level:Int = 1):Void {
		controlDeltaX = data.readSB(numBits);
		controlDeltaY = data.readSB(numBits);
		anchorDeltaX = data.readSB(numBits);
		anchorDeltaY = data.readSB(numBits);
	}
	
	override public function publish(data:SWFData = null, level:Int = 1):Void {
		numBits = data.calculateMaxBits(true, [controlDeltaX, controlDeltaY, anchorDeltaX, anchorDeltaY]);
		if(numBits < 2) { numBits = 2; }
		data.writeUB(4, numBits - 2);
		data.writeSB(numBits, controlDeltaX);
		data.writeSB(numBits, controlDeltaY);
		data.writeSB(numBits, anchorDeltaX);
		data.writeSB(numBits, anchorDeltaY);
	}
	
	override public function clone():SWFShapeRecord {
		var record:SWFShapeRecordCurvedEdge = new SWFShapeRecordCurvedEdge();
		record.anchorDeltaX = anchorDeltaX;
		record.anchorDeltaY = anchorDeltaY;
		record.controlDeltaX = controlDeltaX;
		record.controlDeltaY = controlDeltaY;
		record.numBits = numBits;
		return record;
	}
	
	override private function get_type():Int { return SWFShapeRecord.TYPE_CURVEDEDGE; }
	
	override public function toString(indent:Int = 0):String {
		return "[SWFShapeRecordCurvedEdge] " +
			"ControlDelta: " + controlDeltaX + "," + controlDeltaY + ", " +
			"AnchorDelta: " + anchorDeltaX + "," + anchorDeltaY;
	}
}