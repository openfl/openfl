package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;

class DOMLayer
{
	public var index:Int;
	public var name:String;
	public var animationType:String;
	public var frames:Array<DOMFrame>;
	public var type:String;
	public var parentLayerIndex:Int;

	public function new()
	{
		frames = new Array<DOMFrame>();
	}

	public static function parse(index:Int, xml:Fast):DOMLayer
	{
		var layer = new DOMLayer();
		layer.index = index;
		layer.name = xml.has.name == true ? xml.att.name : null;
		if (xml.has.animationType) layer.animationType = xml.att.animationType;
		if (xml.has.layerType) layer.type = xml.att.layerType;
		layer.parentLayerIndex = xml.has.parentLayerIndex == true ? Std.parseInt(xml.att.parentLayerIndex) : -1;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "frames":
					for (frame in element.elements)
					{
						layer.frames.push(DOMFrame.parse(frame));
					}
			}
		}
		return layer;
	}
}
