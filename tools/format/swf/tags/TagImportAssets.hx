package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFSymbol;
import format.swf.utils.StringUtils;

class TagImportAssets implements ITag
{
	public static inline var TYPE:Int = 57;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;

	public var url:String;
	
	public var symbols (default, null):Array<SWFSymbol>;
	
	public function new() {
		type = TYPE;
		name = "ImportAssets";
		version = 5;
		level = 1;
		symbols = new Array<SWFSymbol>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		url = data.readSTRING();
		var numSymbols:Int = data.readUI16();
		for (i in 0...numSymbols) {
			symbols.push(data.readSYMBOL());
		}
	}

	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeSTRING(url);
		var numSymbols:Int = symbols.length;
		body.writeUI16(numSymbols);
		for (i in 0...numSymbols) {
			body.writeSYMBOL(symbols[i]);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent);
		if (symbols.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Assets:";
			for (i in 0...symbols.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + symbols[i].toString();
			}
		}
		return str;
	}
}