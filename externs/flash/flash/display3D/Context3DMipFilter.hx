package flash.display3D;

#if flash
@:enum abstract Context3DMipFilter(String) from String to String
{
	public var MIPLINEAR = "miplinear";
	public var MIPNEAREST = "mipnearest";
	public var MIPNONE = "mipnone";
}
#else
typedef Context3DMipFilter = openfl.display3D.Context3DMipFilter;
#end
