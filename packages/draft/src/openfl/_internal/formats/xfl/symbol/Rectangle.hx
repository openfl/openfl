package openfl._internal.formats.xfl.symbol;

import openfl._internal.formats.xfl.dom.DOMRectangle;

class Rectangle extends ShapeBase
{
	public function new(domRectangle:DOMRectangle)
	{
		super();
		trace("DOMRectangle: " + domRectangle.x + ", " + domRectangle.y + ", " + domRectangle.width + ", " + domRectangle.height);
		graphics.beginFill(0xFF0000, 1.0);
		graphics.drawRect(domRectangle.x, domRectangle.y, domRectangle.width, domRectangle.height);
		graphics.endFill();
	}
}
