package openfl._internal.formats.xfl.dom;

import openfl.Assets;
import openfl._internal.formats.xfl.XFLAssets;
import haxe.xml.Fast;

class DOMSymbolItem
{
	public var itemID:String;
	public var linkageBaseClass:String;
	public var linkageClassName:String;
	public var linkageExportForAS:Bool;
	public var parametersAreLocked:Bool;
	public var name:String;
	public var timeline:DOMTimeline;

	public function new() {}

	public static function load(path:String, file:String):DOMSymbolItem
	{
		return parse(XFLAssets.getInstance().getXFLXMLAsset(path + "/" + file));
	}

	public static function loadIndex(path:String, file:String):DOMItemIndex
	{
		var xml:Fast = XFLAssets.getInstance().getXFLXMLAsset(path + "/" + file);
		var index:DOMItemIndex = new DOMItemIndex();
		index.name = xml.att.name;
		index.linkageClassName = xml.has.linkageClassName == true ? xml.att.linkageClassName : null;
		index.item = null;
		index.fileName = file;
		return index;
	}

	public static function parse(xml:Fast):DOMSymbolItem
	{
		var symbolItem = new DOMSymbolItem();
		symbolItem.name = xml.att.name;
		symbolItem.itemID = xml.att.itemID;
		symbolItem.linkageBaseClass = xml.has.linkageBaseClass == true ? xml.att.linkageBaseClass : null;
		if (xml.has.linkageExportForAS) symbolItem.linkageExportForAS = (xml.att.linkageExportForAS == "true");
		if (xml.has.linkageClassName) symbolItem.linkageClassName = xml.att.linkageClassName;
		symbolItem.parametersAreLocked = xml.has.parametersAreLocked == true && xml.att.parametersAreLocked == "true";
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "timeline":
					symbolItem.timeline = DOMTimeline.parse(element.elements.next());
			}
		}
		return symbolItem;
	}
}
