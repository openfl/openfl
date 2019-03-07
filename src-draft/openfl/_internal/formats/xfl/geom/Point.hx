package openfl._internal.formats.xfl.geom;

import haxe.xml.Fast;

class Point
{
	public static function parse(xml:Fast):openfl.geom.Point
	{
		return new openfl.geom.Point(xml.has.x == true ? Std.parseFloat(xml.att.x) : 0.0, xml.has.y == true ? Std.parseFloat(xml.att.y) : 0.0);
	}
}
