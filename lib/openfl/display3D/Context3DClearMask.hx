package openfl.display3D;

@:enum abstract Context3DClearMask(UInt) from UInt to UInt from Int to Int
{
	public var ALL = 0x07;
	public var COLOR = 0x01;
	public var DEPTH = 0x02;
	public var STENCIL = 0x04;
}
