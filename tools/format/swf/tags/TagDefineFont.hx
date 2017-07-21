package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFShape;
import format.swf.exporters.core.IShapeExporter;
import format.swf.utils.StringUtils;
import flash.errors.Error;
	
class TagDefineFont implements IDefinitionTag
{
	public static inline var TYPE:Int = 10;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var characterId:Int;
	
	public var glyphShapeTable (default, null):Array<SWFShape>;
	private static var unitDivisor:Int = 1;
	
	public function new() {
		type = TYPE;
		name = "DefineFont";
		version = 1;
		level = 1;
		glyphShapeTable = new Array<SWFShape>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		// Because the glyph shape table immediately follows the offset table,
		// the number of entries in each table (the number of glyphs in the font) can be inferred by
		// dividing the first entry in the offset table by two.
		var numGlyphs:Int = data.readUI16() >> 1;
		// Skip offsets. We don't need them here.
		data.skipBytes((numGlyphs - 1) << 1);
		// Read glyph shape table
		for (i in 0...numGlyphs) {
			glyphShapeTable.push(data.readSHAPE(unitDivisor));
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		var i:Int;
		var prevPtr:Int = 0;
		var len:Int = glyphShapeTable.length;
		var shapeTable:SWFData = new SWFData();
		body.writeUI16(characterId);
		var offsetTableLength:Int = (len << 1);
		for (i in 0...len) {
			// Write out the offset table for the current glyph
			body.writeUI16(shapeTable.position + offsetTableLength);
			// Serialize the glyph's shape to a separate bytearray
			shapeTable.writeSHAPE(glyphShapeTable[i]);
		}
		// Now concatenate the glyph shape table to the end (after
		// the offset table that we were previously writing inside
		// the for loop above).
		body.writeBytes(shapeTable);
		// Now write the tag with the known body length, and the
		// actual contents out to the provided SWFData instance.
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineFont = new TagDefineFont();
		throw(new Error("Not implemented yet."));
		return tag;
	}
	
	public function export(handler:IShapeExporter, glyphIndex:Int):Void {
		glyphShapeTable[glyphIndex].export(handler);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Glyphs: " + glyphShapeTable.length;
		return str + toStringCommon(indent);
	}
	
	private function toStringCommon(indent:Int):String {
		var str:String = "";
		for (i in 0...glyphShapeTable.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] GlyphShapes:";
			str += glyphShapeTable[i].toString(indent + 4);
		}
		return str;
	}
}