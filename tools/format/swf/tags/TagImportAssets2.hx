package format.swf.tags;

import format.swf.SWFData;

class TagImportAssets2 extends TagImportAssets implements ITag
{
	public static inline var TYPE:Int = 71;

	public function new() {
		
		super ();
		
		type = TYPE;
		name = "ImportAssets2";
		version = 8;
		level = 2;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		url = data.readSTRING();
		data.readUI8(); // reserved, always 1
		data.readUI8(); // reserved, always 0
		var numSymbols:Int = data.readUI16();
		for (i in 0...numSymbols) {
			symbols.push(data.readSYMBOL());
		}
	}

	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeSTRING(url);
		body.writeUI8(1);
		body.writeUI8(0);
		var numSymbols:Int = symbols.length;
		body.writeUI16(numSymbols);
		for (i in 0...numSymbols) {
			body.writeSYMBOL(symbols[i]);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
}