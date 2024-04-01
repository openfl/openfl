package flash.display3D;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DBufferUsage(String) from String to String

{
	public var DYNAMIC_DRAW = "dynamicDraw";
	public var STATIC_DRAW = "staticDraw";
}
#else
typedef Context3DBufferUsage = openfl.display3D.Context3DBufferUsage;
#end
