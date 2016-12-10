package format.swf.data;

import format.swf.SWFData;

class SWFGlyphEntry
{
	public var index:Int;
	public var advance:Int;
	
	public function new(data:SWFData = null, glyphBits:Int = 0, advanceBits:Int = 0) {
		if (data != null) {
			parse(data, glyphBits, advanceBits);
		}
	}
	
	public function parse(data:SWFData, glyphBits:Int, advanceBits:Int):Void {
		// GLYPHENTRYs are not byte aligned
		index = data.readUB(glyphBits);
		advance = data.readSB(advanceBits);
	}
	
	public function publish(data:SWFData, glyphBits:Int, advanceBits:Int):Void {
		// GLYPHENTRYs are not byte aligned
		data.writeUB(glyphBits, index);
		data.writeSB(advanceBits, advance);
	}
	
	public function clone():SWFGlyphEntry {
		var entry:SWFGlyphEntry = new SWFGlyphEntry();
		entry.index = index;
		entry.advance = advance;
		return entry;
	}
	
	public function toString():String {
		return "[SWFGlyphEntry] Index: " + Std.string (index) + ", Advance: " + Std.string (advance);
	}
}
