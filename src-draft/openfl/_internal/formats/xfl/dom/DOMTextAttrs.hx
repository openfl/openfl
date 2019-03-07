package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;

class DOMTextAttrs
{
	public var aliasText:Bool;
	public var alignment:String;
	public var alpha:Float;
	public var face:String;
	public var fillColor:Int;
	public var size:Null<Float>;

	public function new() {}

	public static function parse(xml:Fast):DOMTextAttrs
	{
		var textAttrs = new DOMTextAttrs();
		if (xml.has.alignment) textAttrs.alignment = xml.att.alignment;
		if (xml.has.aliasText) textAttrs.aliasText = (xml.att.aliasText == "true");
		if (xml.has.alpha) textAttrs.alpha = Std.parseFloat(xml.att.alpha);
		if (xml.has.size) textAttrs.size = Std.parseFloat(xml.att.size);
		if (xml.has.face) textAttrs.face = xml.att.face;
		if (xml.has.fillColor) textAttrs.fillColor = Std.parseInt("0x" + xml.att.fillColor.substr(1));
		return textAttrs;
	}
}
