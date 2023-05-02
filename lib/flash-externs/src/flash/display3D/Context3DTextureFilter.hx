package flash.display3D;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DTextureFilter(String) from String to String

{
	public var ANISOTROPIC16X = "anisotropic16x";
	public var ANISOTROPIC2X = "anisotropic2x";
	public var ANISOTROPIC4X = "anisotropic4x";
	public var ANISOTROPIC8X = "anisotropic8x";
	public var LINEAR = "linear";
	public var NEAREST = "nearest";
}
#else
typedef Context3DTextureFilter = openfl.display3D.Context3DTextureFilter;
#end
