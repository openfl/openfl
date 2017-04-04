package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFGlyphEntry;
import format.swf.data.SWFMatrix;
import format.swf.data.SWFRectangle;
import format.swf.data.SWFTextRecord;
import format.swf.utils.StringUtils;

class TagDefineText implements IDefinitionTag
{
	public static inline var TYPE:Int = 11;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var textBounds:SWFRectangle;
	public var textMatrix:SWFMatrix;
	
	public var characterId:Int;
	
	public var records (default, null):Array<SWFTextRecord>;
	
	public function new() {
		type = TYPE;
		name = "DefineText";
		version = 1;
		level = 1;
		records = new Array<SWFTextRecord>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		textBounds = data.readRECT();
		textMatrix = data.readMATRIX();
		var glyphBits:Int = data.readUI8();
		var advanceBits:Int = data.readUI8();
		var record:SWFTextRecord = null;
		while ((record = data.readTEXTRECORD(glyphBits, advanceBits, record, level)) != null) {
			records.push(record);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		var i:Int;
		var j:Int;
		var record:SWFTextRecord;
		body.writeUI16(characterId);
		body.writeRECT(textBounds);
		body.writeMATRIX(textMatrix);
		// Calculate glyphBits and advanceBits values
		var glyphBitsValues:Array<Int> = [];
		var advanceBitsValues:Array<Int> = [];
		var recordsLen:Int = records.length;
		for(i in 0...recordsLen) {
			record = records[i];
			var glyphCount:Int = record.glyphEntries.length;
			for (j in 0...glyphCount) {
				var glyphEntry:SWFGlyphEntry = record.glyphEntries[j];
				glyphBitsValues.push(glyphEntry.index);
				advanceBitsValues.push(glyphEntry.advance);
			}
		}
		var glyphBits:Int = body.calculateMaxBits(false, glyphBitsValues);
		var advanceBits:Int = body.calculateMaxBits(true, advanceBitsValues);
		body.writeUI8(glyphBits);
		body.writeUI8(advanceBits);
		// Write text records
		record = null;
		for(i in 0...recordsLen) {
			body.writeTEXTRECORD(records[i], glyphBits, advanceBits, record, level);
			record = records[i];
		}
		body.writeUI8(0);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineText = new TagDefineText();
		tag.characterId = characterId;
		tag.textBounds = textBounds.clone();
		tag.textMatrix = textMatrix.clone();
		for(i in 0...records.length) {
			tag.records.push(records[i].clone());
		}
		return tag;
	}

	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Bounds: " + textBounds + ", " +
			"Matrix: " + textMatrix;
		if (records.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "TextRecords:";
			for (i in 0...records.length) {
				str += "\n" +
					StringUtils.repeat(indent + 4) +
					"[" + i + "] " +
					records[i].toString(indent + 4);
			}
		}
		return str;
	}
}