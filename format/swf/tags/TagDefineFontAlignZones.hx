package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFZoneRecord;
import format.swf.data.consts.CSMTableHint;
import format.swf.utils.StringUtils;

class TagDefineFontAlignZones implements ITag
{
	public static inline var TYPE:Int = 73;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var fontId:Int;
	public var csmTableHint:Int;
	
	public var zoneTable (default, null):Array<SWFZoneRecord>;
	
	public function new() {
		type = TYPE;
		name = "DefineFontAlignZones";
		version = 8;
		level = 1;
		zoneTable = new Array<SWFZoneRecord>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		fontId = data.readUI16();
		csmTableHint = (data.readUI8() >> 6);
		var recordsEndPos:Int = data.position + length - 3;
		while (Std.int (data.position) < recordsEndPos) {
			zoneTable.push(data.readZONERECORD());
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(fontId);
		body.writeUI8(csmTableHint << 6);
		for(i in 0...zoneTable.length) {
			body.writeZONERECORD(zoneTable[i]);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"FontID: " + fontId + ", " +
			"CSMTableHint: " + CSMTableHint.toString(csmTableHint) + ", " +
			"Records: " + zoneTable.length;
		for (i in 0...zoneTable.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + zoneTable[i].toString(indent + 2);
		}
		return str;
	}
}