package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;

class DOMFolderItem
{
	public var itemID:String;
	public var name:String;

	public function new() {}

	public static function parse(xml:Fast):DOMFolderItem
	{
		var folderItem = new DOMFolderItem();
		folderItem.name = xml.att.name;
		folderItem.itemID = xml.att.itemID;
		return folderItem;
	}
}
