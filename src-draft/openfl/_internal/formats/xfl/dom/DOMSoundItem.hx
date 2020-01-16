package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;

class DOMSoundItem
{
	// public var soundDataHRef:String;
	public var href:String;

	// public var itemID:String;
	// public var linkageClassName:String;
	// public var linkageExportForAS:Bool;
	// public var name:String;
	// public var sourceExternalFilepath:String;
	// public var sourceLastImported:Int;
	// public var format: String;
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

	public static function parse(xml:Fast):DOMSoundItem
	{
		var soundItem = new DOMSoundItem();
		// soundItem.name = xml.att.name;
		// soundItem.itemID = xml.att.itemID;
		// if (xml.has.linkageClassName) soundItem.linkageClassName = xml.att.linkageClassName;
		// if (xml.has.linkageExportForAS) soundItem.linkageExportForAS = (xml.att.linkageExportForAS == "true");
		// soundItem.sourceExternalFilepath = xml.has.sourceExternalFilepath == true?xml.att.sourceExternalFilepath:null;
		// soundItem.sourceLastImported = Std.parseInt (xml.att.sourceLastImported);
		// soundItem.format = xml.att.format;
		soundItem.href = xml.att.href;
		// soundItem.soundDataHRef = xml.att.soundDataHRef;
		return soundItem;
	}
}
