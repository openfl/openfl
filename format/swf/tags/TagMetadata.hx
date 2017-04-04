package format.swf.tags;

import format.swf.SWFData;
import flash.errors.Error;

class TagMetadata implements ITag
{
	public static inline var TYPE:Int = 77;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var xmlString:String;
	
	public function new() {
		
		type = TYPE;
		name = "Metadata";
		version = 1;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		xmlString = data.readSTRING();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeSTRING(xmlString);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent);
		var xml:Xml;
		try {
			xml = Xml.parse(xmlString);
			str += " " + xml.toString();
		} catch(error:Error) {
			str += " " + xmlString;
		}
		return str;
	}
}