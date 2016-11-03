package format.swf.tags;

import format.swf.data.consts.BitmapFormat;

class TagDefineBitsLossless2 extends TagDefineBitsLossless
{
	public static inline var TYPE:Int = 36;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineBitsLossless2";
		version = 3;
		level = 2;
		
	}
	
	override public function clone():IDefinitionTag {
		var tag:TagDefineBitsLossless2 = new TagDefineBitsLossless2();
		tag.characterId = characterId;
		tag.bitmapFormat = bitmapFormat;
		tag.bitmapWidth = bitmapWidth;
		tag.bitmapHeight = bitmapHeight;
		if (zlibBitmapData.length > 0) {
			tag.zlibBitmapData.writeBytes(zlibBitmapData);
		}
		return tag;
	}

	override public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Format: " + BitmapFormat.toString(bitmapFormat) + ", " +
			"Size: (" + bitmapWidth + "," + bitmapHeight + ")";
	}
}