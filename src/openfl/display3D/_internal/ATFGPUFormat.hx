package openfl.display3D._internal;

#if !flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ATFGPUFormat(Int) from Int to Int

{
	public var DXT = 0; // DXT1/DXT5 depending on alpha
	public var PVRTC = 1;
	public var ETC1 = 2;
	public var ETC2 = 3;
}
#end
