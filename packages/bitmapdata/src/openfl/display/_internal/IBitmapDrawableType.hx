package openfl.display._internal;

@:enum abstract IBitmapDrawableType(Int) from Int to Int
{
	public var BITMAP_DATA = 0;
	public var STAGE = 1;
	public var BITMAP = 2;
	public var SHAPE = 3;
	public var SPRITE = 4;
	public var SIMPLE_BUTTON = 5;
	public var TEXT_FIELD = 6;
	public var VIDEO = 7;
	public var TILEMAP = 8;
	public var DOM_ELEMENT = 9;
}
