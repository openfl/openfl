package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFTextRecord;
import format.swf.utils.StringUtils;

class TagDefineText2 extends TagDefineText implements IDefinitionTag
{
	public static inline var TYPE:Int = 33;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineText2";
		version = 3;
		level = 2;
		
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Bounds: " + textBounds + ", " +
			"Matrix: " + textMatrix;
		if (records.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "TextRecords:";
			for (i in 0...records.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + records[i].toString();
			}
		}
		return str;
	}
}