package openfl._internal.backend.dummy;

class DummyExternalInterfaceBackend
{
	public static function addCallback(functionName:String, closure:Dynamic):Void {}

	public static function call(functionName:String, p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Dynamic
	{
		return null;
	}

	public static function getObjectID():String
	{
		return null;
	}
}