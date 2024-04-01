package openfl.display3D;

#if !flash
/**
	Defines the values to use for specifying Context3D clear masks.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DClearMask(UInt) from UInt to UInt from Int to Int

{
	/**
		Clear all buffers.
	**/
	public var ALL = 0x07;

	/**
		Clear only the color buffer.
	**/
	public var COLOR = 0x01;

	/**
		Clear only the depth buffer.
	**/
	public var DEPTH = 0x02;

	/**
		Clear only the stencil buffer.
	**/
	public var STENCIL = 0x04;
}
#else
typedef Context3DClearMask = flash.display3D.Context3DClearMask;
#end
