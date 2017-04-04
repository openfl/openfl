package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.BitmapType;

class TagDefineBitsJPEG2 extends TagDefineBits implements IDefinitionTag
{
	public static inline var TYPE:Int = 21;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineBitsJPEG2";
		version = 2;
		level = 2;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		super.parse(data, length, version);
		if (bitmapData[0] == 0xff && (bitmapData[1] == 0xd8 || bitmapData[1] == 0xd9)) {
			bitmapType = BitmapType.JPEG;
		} else if (bitmapData[0] == 0x89 && bitmapData[1] == 0x50 && bitmapData[2] == 0x4e && bitmapData[3] == 0x47 && bitmapData[4] == 0x0d && bitmapData[5] == 0x0a && bitmapData[6] == 0x1a && bitmapData[7] == 0x0a) {
			bitmapType = BitmapType.PNG;
		} else if (bitmapData[0] == 0x47 && bitmapData[1] == 0x49 && bitmapData[2] == 0x46 && bitmapData[3] == 0x38 && bitmapData[4] == 0x39 && bitmapData[5] == 0x61) {
			bitmapType = BitmapType.GIF89A;
		}
		if (bitmapType != BitmapType.JPEG) {
			version = 8;
		}
	}
	
	override public function clone():IDefinitionTag {
		var tag:TagDefineBitsJPEG2 = new TagDefineBitsJPEG2();
		tag.characterId = characterId;
		tag.bitmapType = bitmapType;
		if (bitmapData.length > 0) {
			tag.bitmapData.writeBytes(bitmapData);
		}
		return tag;
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Type: " + BitmapType.toString(bitmapType) + ", " +
			"BitmapLength: " + bitmapData.length;
		return str;
	}
}