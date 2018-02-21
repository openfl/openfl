package format.swf.data;

import format.swf.SWFData;
import format.swf.exporters.core.IShapeExporter;

import format.swf.utils.StringUtils;

class SWFShapeWithStyle extends SWFShape
{
	public var initialFillStyles:Array<SWFFillStyle>;
	public var initialLineStyles:Array<SWFLineStyle>;
	
	public function new(data:SWFData = null, level:Int = 1, unitDivisor:Float = 20) {
		initialFillStyles = new Array<SWFFillStyle>();
		initialLineStyles = new Array<SWFLineStyle>();
		super(data, level, unitDivisor);
	}
	
	override public function parse(data:SWFData, level:Int = 1):Void {
		data.resetBitsPending();
		var i:Int;
		var fillStylesLen:Int = readStyleArrayLength(data, level);
		for (i in 0...fillStylesLen) {
			initialFillStyles.push(data.readFILLSTYLE(level));
		}
		var lineStylesLen:Int = readStyleArrayLength(data, level);
		for (i in 0...lineStylesLen) {
			initialLineStyles.push(level <= 3 ? data.readLINESTYLE(level) : data.readLINESTYLE2(level));
		}
		data.resetBitsPending();
		var numFillBits:Int = data.readUB(4);
		var numLineBits:Int = data.readUB(4);
		readShapeRecords(data, numFillBits, numLineBits, level);
	}
	
	override public function publish(data:SWFData, level:Int = 1):Void {
		data.resetBitsPending();
		var i:Int;
		var fillStylesLen:Int = initialFillStyles.length;
		writeStyleArrayLength(data, fillStylesLen, level);
		for (i in 0...fillStylesLen) {
			initialFillStyles[i].publish(data, level);
		}
		var lineStylesLen:Int = initialLineStyles.length;
		writeStyleArrayLength(data, lineStylesLen, level);
		for (i in 0...lineStylesLen) {
			initialLineStyles[i].publish(data, level);
		}
		var fillBits:Int = data.calculateMaxBits(false, [getMaxFillStyleIndex()]);
		var lineBits:Int = data.calculateMaxBits(false, [getMaxLineStyleIndex()]);
		data.resetBitsPending();
		data.writeUB(4, fillBits);
		data.writeUB(4, lineBits);
		writeShapeRecords(data, fillBits, lineBits, level);
	}
	
	override public function export(handler:IShapeExporter = null):Void {
		fillStyles = initialFillStyles.copy();
		lineStyles = initialLineStyles.copy();
		super.export(handler);
	}

	override public function toString(indent:Int = 0):String {
		var i:Int;
		var str:String = "";
		if (initialFillStyles.length > 0) {
			str += "\n" + StringUtils.repeat(indent) + "FillStyles:";
			for (i in 0...initialFillStyles.length) {
				str += "\n" + StringUtils.repeat(indent + 2) + "[" + (i + 1) + "] " + initialFillStyles[i].toString();
			}
		}
		if (initialLineStyles.length > 0) {
			str += "\n" + StringUtils.repeat(indent) + "LineStyles:";
			for (i in 0...initialLineStyles.length) {
				str += "\n" + StringUtils.repeat(indent + 2) + "[" + (i + 1) + "] " + initialLineStyles[i].toString();
			}
		}
		return str + super.toString(indent);
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
}