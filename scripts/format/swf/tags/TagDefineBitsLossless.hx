package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.BitmapFormat;

import flash.display.BitmapData;
import flash.utils.ByteArray;

class TagDefineBitsLossless implements IDefinitionTag
{
	public static inline var TYPE:Int = 20;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var bitmapFormat:Int;
	public var bitmapWidth:Int;
	public var bitmapHeight:Int;
	public var bitmapColorTableSize:Int;
	
	public var characterId:Int;

	public var zlibBitmapData (default, null):ByteArray;
	public var instance:BitmapData;
		
	public function new() {
		
		type = TYPE;
		name = "DefineBitsLossless";
		version = 2;
		level = 1;
		zlibBitmapData = new ByteArray();
		zlibBitmapData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		bitmapFormat = data.readUI8();
		bitmapWidth = data.readUI16();
		bitmapHeight = data.readUI16();
		if (bitmapFormat == BitmapFormat.BIT_8) {
			bitmapColorTableSize = data.readUI8() + 1;
		}
		data.readBytes(zlibBitmapData, 0, length - ((bitmapFormat == BitmapFormat.BIT_8) ? 8 : 7));
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeUI8(bitmapFormat);
		body.writeUI16(bitmapWidth);
		body.writeUI16(bitmapHeight);
		if (bitmapFormat == BitmapFormat.BIT_8) {
			body.writeUI8(bitmapColorTableSize - 1);
		}
		if (zlibBitmapData.length > 0) {
			body.writeBytes(zlibBitmapData);
		}
		data.writeTagHeader(type, body.length, true);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineBitsLossless = new TagDefineBitsLossless();
		tag.characterId = characterId;
		tag.bitmapFormat = bitmapFormat;
		tag.bitmapWidth = bitmapWidth;
		tag.bitmapHeight = bitmapHeight;
		if (zlibBitmapData.length > 0) {
			tag.zlibBitmapData.writeBytes(zlibBitmapData);
		}
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Format: " + BitmapFormat.toString(bitmapFormat) + ", " +
			"Size: (" + bitmapWidth + "," + bitmapHeight + ")";
	}
}