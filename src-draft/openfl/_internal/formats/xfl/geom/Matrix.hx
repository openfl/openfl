package openfl._internal.formats.xfl.geom;

import haxe.xml.Fast;

class Matrix
{
	public static function parse(xml:Fast):openfl.geom.Matrix
	{
		return new openfl.geom.Matrix(xml.has.a == true ? Std.parseFloat(xml.att.a) : 1.0, xml.has.b == true ? Std.parseFloat(xml.att.b) : 0.0,
			xml.has.c == true ? Std.parseFloat(xml.att.c) : 0.0, xml.has.d == true ? Std.parseFloat(xml.att.d) : 1.0,
			xml.has.tx == true ? Std.parseFloat(xml.att.tx) : 0.0, xml.has.ty == true ? Std.parseFloat(xml.att.ty) : 0.0);
	}
}
