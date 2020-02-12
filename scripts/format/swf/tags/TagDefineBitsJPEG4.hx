package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.BitmapType;
import flash.utils.ByteArray;

class TagDefineBitsJPEG4 extends TagDefineBitsJPEG3 implements IDefinitionTag
{
	public static inline var TYPE:Int = 90;

	public var deblockParam:Float;

	public function new()
	{
		super();

		type = TYPE;
		name = "DefineBitsJPEG4";
		version = 10;
		level = 4;
	}

	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void
	{
		characterId = data.readUI16();
		var alphaDataOffset:Int = data.readUI32();
		deblockParam = data.readFIXED8();
		data.readBytes(bitmapData, 0, alphaDataOffset);
		if (bitmapData[0] == 0xff && (bitmapData[1] == 0xd8 || bitmapData[1] == 0xd9))
		{
			bitmapType = BitmapType.JPEG;
		}
		else if (bitmapData[0] == 0x89 && bitmapData[1] == 0x50 && bitmapData[2] == 0x4e && bitmapData[3] == 0x47 && bitmapData[4] == 0x0d
			&& bitmapData[5] == 0x0a && bitmapData[6] == 0x1a && bitmapData[7] == 0x0a)
		{
			bitmapType = BitmapType.PNG;
		}
		else if (bitmapData[0] == 0x47 && bitmapData[1] == 0x49 && bitmapData[2] == 0x46 && bitmapData[3] == 0x38 && bitmapData[4] == 0x39
			&& bitmapData[5] == 0x61)
		{
			bitmapType = BitmapType.GIF89A;
		}
		var alphaDataSize:Int = length - alphaDataOffset - 6;
		if (alphaDataSize > 0)
		{
			data.readBytes(bitmapAlphaData, 0, alphaDataSize);
		}
	}

	override public function publish(data:SWFData, version:Int):Void
	{
		data.writeTagHeader(type, bitmapData.length + bitmapAlphaData.length + 6, true);
		data.writeUI16(characterId);
		data.writeUI32(bitmapData.length);
		data.writeFIXED8(deblockParam);
		if (bitmapData.length > 0)
		{
			data.writeBytes(bitmapData);
		}
		if (bitmapAlphaData.length > 0)
		{
			data.writeBytes(bitmapAlphaData);
		}
	}

	override public function clone():IDefinitionTag
	{
		var tag:TagDefineBitsJPEG4 = new TagDefineBitsJPEG4();
		tag.characterId = characterId;
		tag.bitmapType = bitmapType;
		tag.deblockParam = deblockParam;
		if (bitmapData.length > 0)
		{
			tag.bitmapData.writeBytes(bitmapData);
		}
		if (bitmapAlphaData.length > 0)
		{
			tag.bitmapAlphaData.writeBytes(bitmapAlphaData);
		}
		return tag;
	}

	override public function toString(indent:Int = 0):String
	{
		var str:String = Tag.toStringCommon(type, name, indent)
			+ "ID: "
			+ characterId
			+ ", "
			+ "Type: "
			+ BitmapType.toString(bitmapType)
			+ ", "
			+ "DeblockParam: "
			+ deblockParam
			+ ", "
			+ "HasAlphaData: "
			+ (bitmapAlphaData.length > 0)
			+ ", "
			+ ((bitmapAlphaData.length > 0) ? "BitmapAlphaLength: " + bitmapAlphaData.length + ", " : "")
			+ "BitmapLength: "
			+ bitmapData.length;
		return str;
	}
}
