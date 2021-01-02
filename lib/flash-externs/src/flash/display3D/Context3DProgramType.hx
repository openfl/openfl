package flash.display3D;

#if flash
@:enum abstract Context3DProgramType(String) from String to String
{
	public var FRAGMENT = "fragment";
	public var VERTEX = "vertex";
}
#else
typedef Context3DProgramType = openfl.display3D.Context3DProgramType;
#end
