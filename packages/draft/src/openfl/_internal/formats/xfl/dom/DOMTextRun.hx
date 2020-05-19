package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;

class DOMTextRun
{
	public var characters:String;
	public var textAttrs:DOMTextAttrs;

	public function new() {}

	public static function parse(xml:Fast):DOMTextRun
	{
		var textRun = new DOMTextRun();
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "characters":
					textRun.characters = element.innerData;
				case "textAttrs":
					textRun.textAttrs = DOMTextAttrs.parse(element.elements.next());
			}
		}
		return textRun;
	}
}
