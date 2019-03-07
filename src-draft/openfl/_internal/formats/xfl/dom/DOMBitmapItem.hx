package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;

class DOMBitmapItem
{
	// public var bitmapDataHRef:String;
	public var href:String;
	// public var isJPEG:Bool;
	// public var itemID:String;
	// public var linkageClassName:String;
	// public var linkageExportForAS:Bool;
	public var name:String;

	// public var quality:Int;
	// public var sourceExternalFilepath:String;
	// public var sourceLastImported:Int;
	public function new() {}

	public static function parseIndex(xml:Fast):DOMItemIndex
	{
		var index:DOMItemIndex = new DOMItemIndex();
		index.name = xml.att.name;
		index.linkageClassName = xml.has.linkageClassName == true ? xml.att.linkageClassName : null;
		index.item = null;
		index.fileName = null;
		return index;
	}

	public static function parse(xml:Fast):DOMBitmapItem
	{
		var bitmapItem = new DOMBitmapItem();
		bitmapItem.name = xml.att.name;
		// bitmapItem.itemID = xml.att.itemID;
		// if (xml.has.linkageClassName) bitmapItem.linkageClassName = xml.att.linkageClassName;
		// if (xml.has.linkageExportForAS) bitmapItem.linkageExportForAS = (xml.att.linkageExportForAS == "true");
		// bitmapItem.sourceExternalFilepath = xml.has.sourceExternalFilepath == true?xml.att.sourceExternalFilepath:null;
		// bitmapItem.sourceLastImported = Std.parseInt (xml.att.sourceLastImported);
		// bitmapItem.quality = Std.parseInt (xml.att.quality);
		bitmapItem.href = xml.att.href;
		// bitmapItem.bitmapDataHRef = xml.att.bitmapDataHRef;
		// if (xml.has.isJPEG) bitmapItem.isJPEG = (xml.att.isJPEG == "true");
		return bitmapItem;
	}
}
