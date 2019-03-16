package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;
import haxe.ds.StringMap;
import openfl._internal.formats.xfl.XFLAssets;

class DOMDocument
{
	public var path:String;
	public var height:Int;
	public var media:StringMap<DOMItemIndex>;
	public var symbols:StringMap<DOMItemIndex>;
	// public var timelines: Array <DOMTimeline>;
	public var width:Int;
	public var xflVersion:Float;

	public function new(path:String)
	{
		this.path = path;
		media = new StringMap<DOMItemIndex>();
		symbols = new StringMap<DOMItemIndex>();
		// timelines = new Array<DOMTimeline>();
	}

	public static function load(path:String, file:String):DOMDocument
	{
		return parse(XFLAssets.getInstance().getXFLXMLAsset(path + "/" + file), path);
	}

	public static function parse(xml:Fast, path:String):DOMDocument
	{
		var document = new DOMDocument(path);
		if (xml.has.width) document.width = Std.parseInt(xml.att.width);
		if (xml.has.height) document.height = Std.parseInt(xml.att.height);
		document.xflVersion = Std.parseFloat(xml.att.xflVersion);
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "media":
					for (medium in element.elements)
					{
						switch (medium.name)
						{
							case "DOMBitmapItem":
								var bitmapItemIndex:DOMItemIndex = DOMBitmapItem.parseIndex(medium);
								bitmapItemIndex.item = DOMBitmapItem.parse(medium);
								if (document.media.exists(bitmapItemIndex.name))
								{
									trace("Media with key '" + bitmapItemIndex.name + "' already exists");
								}
								document.media.set(bitmapItemIndex.name, bitmapItemIndex);
							case "DOMSoundItem":
								var soundItemIndex:DOMItemIndex = DOMSoundItem.parseIndex(medium);
								soundItemIndex.item = DOMSoundItem.parse(medium);
								if (document.media.exists(soundItemIndex.name))
								{
									trace("Media with key '" + soundItemIndex.name + "' already exists");
								}
								document.media.set(soundItemIndex.name, soundItemIndex);
						}
					}
				case "symbols":
					for (symbol in element.elements)
					{
						var symbolItemIndex:DOMItemIndex = DOMSymbolItem.loadIndex(path + "/LIBRARY", symbol.att.href);
						if (document.symbols.exists(symbolItemIndex.name))
						{
							trace("Symbol with key '" + symbolItemIndex.name + "' already exists");
						}
						document.symbols.set(symbolItemIndex.name, symbolItemIndex);
					}
				case "timelines":
					/*
						for (timeline in element.elements) {
							document.timelines.push(DOMTimeline.parse(timeline));
						}
					 */
			}
		}
		return document;
	}
}
