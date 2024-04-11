package flash.display3D;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DProgramType(String) from String to String

{
	public var FRAGMENT = "fragment";
	public var VERTEX = "vertex";
}
#else
typedef Context3DProgramType = openfl.display3D.Context3DProgramType;
#end
