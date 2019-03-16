package flash.display3D;

#if flash
@:enum abstract Context3DTriangleFace(String) from String to String
{
	public var BACK = "back";
	public var FRONT = "front";
	public var FRONT_AND_BACK = "frontAndBack";
	public var NONE = "none";
}
#else
typedef Context3DTriangleFace = openfl.display3D.Context3DTriangleFace;
#end
