package openfl._internal.formats.animate;

@:enum abstract AnimateFrameObjectType(Int) from Int to Int
{
	public var CREATE = 0;
	public var UPDATE = 1;
	public var DESTROY = 2;
}
