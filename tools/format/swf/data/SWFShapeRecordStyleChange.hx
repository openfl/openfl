package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.StringUtils;

class SWFShapeRecordStyleChange extends SWFShapeRecord
{
	public var stateNewStyles:Bool;
	public var stateLineStyle:Bool;
	public var stateFillStyle1:Bool;
	public var stateFillStyle0:Bool;
	public var stateMoveTo:Bool;
	
	public var moveDeltaX:Int;
	public var moveDeltaY:Int;
	public var fillStyle0:Int;
	public var fillStyle1:Int;
	public var lineStyle:Int;
	
	public var numFillBits:Int = 0;
	public var numLineBits:Int = 0;

	public var fillStyles(default, null):Array<SWFFillStyle>;
	public var lineStyles(default, null):Array<SWFLineStyle>;

	public function new(data:SWFData = null, states:Int = 0, fillBits:Int = 0, lineBits:Int = 0, level:Int = 1) {
		fillStyles = new Array<SWFFillStyle>();
		lineStyles = new Array<SWFLineStyle>();
		stateNewStyles = ((states & 0x10) != 0);
		stateLineStyle = ((states & 0x08) != 0);
		stateFillStyle1 = ((states & 0x04) != 0);
		stateFillStyle0 = ((states & 0x02) != 0);
		stateMoveTo = ((states & 0x01) != 0);
		numFillBits = fillBits;
		numLineBits = lineBits;
		super(data, level);
	}
	
	override private function get_type():Int { return SWFShapeRecord.TYPE_STYLECHANGE; }
	
	override public function parse(data:SWFData = null, level:Int = 1):Void {
		if (stateMoveTo) {
			var moveBits:Int = data.readUB(5);
			moveDeltaX = data.readSB(moveBits);
			moveDeltaY = data.readSB(moveBits);
		}
		fillStyle0 = stateFillStyle0 ? data.readUB(numFillBits) : 0;
		fillStyle1 = stateFillStyle1 ? data.readUB(numFillBits) : 0;
		lineStyle = stateLineStyle ? data.readUB(numLineBits) : 0;
		if (stateNewStyles) {
			data.resetBitsPending();
			var i:Int;
			var fillStylesLen:Int = readStyleArrayLength(data, level);
			for (i in 0...fillStylesLen) {
				fillStyles.push(data.readFILLSTYLE(level));
			}
			var lineStylesLen:Int = readStyleArrayLength(data, level);
			for (i in 0...lineStylesLen) {
				lineStyles.push(level <= 3 ? data.readLINESTYLE(level) : data.readLINESTYLE2(level));
			}
			data.resetBitsPending();
			numFillBits = data.readUB(4);
			numLineBits = data.readUB(4);
		}
	}

	override public function publish(data:SWFData = null, level:Int = 1):Void {
		if(stateMoveTo) {
			var moveBits:Int = data.calculateMaxBits(true, [moveDeltaX, moveDeltaY]);
			data.writeUB(5, moveBits);
			data.writeSB(moveBits, moveDeltaX);
			data.writeSB(moveBits, moveDeltaY);
		}
		if(stateFillStyle0) { data.writeUB(numFillBits, fillStyle0); }
		if(stateFillStyle1) { data.writeUB(numFillBits, fillStyle1); }
		if(stateLineStyle) { data.writeUB(numLineBits, lineStyle); }
		if (stateNewStyles) {
			data.resetBitsPending();
			var i:Int;
			var fillStylesLen:Int = fillStyles.length;
			writeStyleArrayLength(data, fillStylesLen, level);
			for (i in 0...fillStylesLen) {
				fillStyles[i].publish(data, level);
			}
			var lineStylesLen:Int = lineStyles.length;
			writeStyleArrayLength(data, lineStylesLen, level);
			for (i in 0...lineStylesLen) {
				lineStyles[i].publish(data, level);
			}
			numFillBits = data.calculateMaxBits(false, [fillStylesLen]);
			numLineBits = data.calculateMaxBits(false, [lineStylesLen]);
			data.resetBitsPending();
			data.writeUB(4, numFillBits);
			data.writeUB(4, numLineBits);
		}
	}

	private function readStyleArrayLength(data:SWFData, level:Int = 1):Int {
		var len:Int = data.readUI8();
		if (level >= 2 && len == 0xff) {
			len = data.readUI16();
		}
		return len;
	}
	
	private function writeStyleArrayLength(data:SWFData, length:Int, level:Int = 1):Void {
		if (level >= 2 && length > 0xfe) {
			data.writeUI8(0xff);
			data.writeUI16(length);
		} else {
			data.writeUI8(length);
		}
	}
	
	override public function clone():SWFShapeRecord {
		var record:SWFShapeRecordStyleChange = new SWFShapeRecordStyleChange();
		record.stateNewStyles = stateNewStyles;
		record.stateLineStyle = stateLineStyle;
		record.stateFillStyle1 = stateFillStyle1;
		record.stateFillStyle0 = stateFillStyle0;
		record.stateMoveTo = stateMoveTo;
		record.moveDeltaX = moveDeltaX;
		record.moveDeltaY = moveDeltaY;
		record.fillStyle0 = fillStyle0;
		record.fillStyle1 = fillStyle1;
		record.lineStyle = lineStyle;
		record.numFillBits = numFillBits;
		record.numLineBits = numLineBits;
		var i:Int;
		for(i in 0...fillStyles.length) {
			record.fillStyles.push(fillStyles[i].clone());
		}
		for(i in 0...lineStyles.length) {
			record.lineStyles.push(lineStyles[i].clone());
		}
		return record;
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = "[SWFShapeRecordStyleChange] ";
		var cmds:Array<String> = [];
		if (stateMoveTo) { cmds.push("MoveTo: " + moveDeltaX + "," + moveDeltaY); }
		if (stateFillStyle0) { cmds.push("FillStyle0: " + fillStyle0); }
		if (stateFillStyle1) { cmds.push("FillStyle1: " + fillStyle1); }
		if (stateLineStyle) { cmds.push("LineStyle: " + lineStyle); }
		if (cmds.length > 0) { str += cmds.join(", "); }
		if (stateNewStyles) {
			var i:Int;
			if (fillStyles.length > 0) {
				str += "\n" + StringUtils.repeat(indent + 2) + "New FillStyles:";
				for (i in 0...fillStyles.length) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + (i + 1) + "] " + fillStyles[i].toString();
				}
			}
			if (lineStyles.length > 0) {
				str += "\n" + StringUtils.repeat(indent + 2) + "New LineStyles:";
				for (i in 0...lineStyles.length) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + (i + 1) + "] " + lineStyles[i].toString();
				}
			}
		}
		return str;
	}
}