package openfl.display._internal;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract IBitmapDrawableType(Int) from Int to Int

{
	public var BITMAP_DATA = 0;
	public var DISPLAY_OBJECT = 1;
	public var BITMAP = 2;
	public var SHAPE = 3;
	public var SPRITE = 4;
	public var STAGE = 5;
	public var SIMPLE_BUTTON = 6;
	public var TEXT_FIELD = 7;
	public var VIDEO = 8;
	public var TILEMAP = 9;
	public var DOM_ELEMENT = 10;
}
