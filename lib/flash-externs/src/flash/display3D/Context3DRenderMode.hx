package flash.display3D;

#if flash
@:enum abstract Context3DRenderMode(String) from String to String
{
	public var AUTO = "auto";
	public var SOFTWARE = "software";
}
#else
typedef Context3DRenderMode = openfl.display3D.Context3DRenderMode;
#end
