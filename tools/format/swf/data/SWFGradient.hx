package format.swf.data;

import format.swf.SWFData;

class SWFGradient
{
	public var spreadMode:Int;
	public var interpolationMode:Int;

	// Forward declarations of properties in SWFFocalGradient
	public var focalPoint:Float;
	
	public var records(default, null):Array<SWFGradientRecord>;
	
	public function new(data:SWFData = null, level:Int = 1) {
		focalPoint = 0.0;
		records = new Array<SWFGradientRecord>();
		if (data != null) {
			parse(data, level);
		}
	}
	
	public function parse(data:SWFData, level:Int):Void {
		data.resetBitsPending();
		spreadMode = data.readUB(2);
		interpolationMode = data.readUB(2);
		var numGradients:Int = data.readUB(4);
		for (i in 0...numGradients) {
			records.push(data.readGRADIENTRECORD(level));
		}
	}

	public function publish(data:SWFData, level:Int = 1):Void {
		var numRecords:Int = records.length;
		data.resetBitsPending();
		data.writeUB(2, spreadMode);
		data.writeUB(2, interpolationMode);
		data.writeUB(4, numRecords);
		for(i in 0...numRecords) {
			data.writeGRADIENTRECORD(records[i], level);
		}
	}
	
	public function clone():SWFGradient {
		var gradient:SWFGradient = new SWFGradient();
		gradient.spreadMode = spreadMode;
		gradient.interpolationMode = interpolationMode;
		gradient.focalPoint = focalPoint;
		for (i in 0...records.length) {
			gradient.records.push(records[i].clone());
		}
		return gradient;
	}

	public function toString():String {
		return "(" + records.join(",") + "), SpreadMode: " + spreadMode + ", InterpolationMode: " + interpolationMode;
	}
}