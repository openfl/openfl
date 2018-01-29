package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.BitmapType;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.utils.ByteArray;

class TagDefineBitsJPEG3 extends TagDefineBitsJPEG2 implements IDefinitionTag
{
	public static inline var TYPE:Int = 35;
	
	public var bitmapAlphaData (default, null):ByteArray;
	
	public function new() {
		super();
		type = TYPE;
		name = "DefineBitsJPEG3";
		version = 3;
		level = 3;
		bitmapAlphaData = new ByteArray();
		bitmapAlphaData.endian = BIG_ENDIAN;
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		var alphaDataOffset:Int = data.readUI32();
		data.readBytes(bitmapData, 0, alphaDataOffset);
		if (bitmapData[0] == 0xff && (bitmapData[1] == 0xd8 || bitmapData[1] == 0xd9)) {
			bitmapType = BitmapType.JPEG;
		} else if (bitmapData[0] == 0x89 && bitmapData[1] == 0x50 && bitmapData[2] == 0x4e && bitmapData[3] == 0x47 && bitmapData[4] == 0x0d && bitmapData[5] == 0x0a && bitmapData[6] == 0x1a && bitmapData[7] == 0x0a) {
			bitmapType = BitmapType.PNG;
		} else if (bitmapData[0] == 0x47 && bitmapData[1] == 0x49 && bitmapData[2] == 0x46 && bitmapData[3] == 0x38 && bitmapData[4] == 0x39 && bitmapData[5] == 0x61) {
			bitmapType = BitmapType.GIF89A;
		}
		var alphaDataSize:Int = length - alphaDataOffset - 6;
		if (alphaDataSize > 0) {
			data.readBytes(bitmapAlphaData, 0, alphaDataSize);
		}
		if (bitmapType != BitmapType.JPEG) {
			version = 8;
		}
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, bitmapData.length + bitmapAlphaData.length + 6, true);
		data.writeUI16(characterId);
		data.writeUI32(bitmapData.length);
		if (bitmapData.length > 0) {
			data.writeBytes(bitmapData);
		}
		if (bitmapAlphaData.length > 0) {
			data.writeBytes(bitmapAlphaData);
		}
	}
	
	override public function clone():IDefinitionTag {
		var tag:TagDefineBitsJPEG3 = new TagDefineBitsJPEG3();
		tag.characterId = characterId;
		tag.bitmapType = bitmapType;
		if (bitmapData.length > 0) {
			tag.bitmapData.writeBytes(bitmapData);
		}
		if (bitmapAlphaData.length > 0) {
			tag.bitmapAlphaData.writeBytes(bitmapAlphaData);
		}
		return tag;
	}
	
	override private function exportCompleteHandler(event:Event):Void {
		var loader:Loader = (cast event.target).loader;
		var bitmapData:BitmapData = new BitmapData(Math.ceil (loader.content.width), Math.ceil (loader.content.height), true);
		bitmapData.draw(loader);
		try {
			bitmapAlphaData.uncompress ();
		} catch (e:Dynamic) {}
		bitmapAlphaData.position = 0;
		var constrain = function (value:Float):Int {
			if (value > 0xFF) return 0xFF;
			else if (value < 0) return 0;
			return Std.int (value);
		}
		for (y in 0...bitmapData.height) {
			for (x in 0...bitmapData.width) {
				var a = bitmapAlphaData.readUnsignedByte ();
				var unmultiply = 255.0 / a;
				var pixel = bitmapData.getPixel (x, y);
				var r = constrain (((pixel >> 16) & 0xFF) * unmultiply);
				var g = constrain (((pixel >> 8) & 0xFF) * unmultiply);
				var b = constrain (((pixel) & 0xFF) * unmultiply);
				bitmapData.setPixel32 (x, y, ((a << 24) + (r << 16) + (g << 8) + b));
			}
		}
		instance = bitmapData;
		onCompleteCallback(bitmapData);
	}

	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Type: " + BitmapType.toString(bitmapType) + ", " +
			"HasAlphaData: " + (bitmapAlphaData.length > 0) + ", " +
			((bitmapAlphaData.length > 0) ? "BitmapAlphaLength: " + bitmapAlphaData.length + ", " : "") +
			"BitmapLength: " + bitmapData.length;
		return str;
	}
}