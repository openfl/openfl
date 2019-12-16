package flash.display3D;

#if flash
import openfl.utils.ByteArray;

@:final extern class Program3D
{
	public function dispose():Void;
	public inline function getAttributeIndex(name:String):Int
	{
		if (StringTools.startsWith(name, "va"))
		{
			return Std.parseInt(name.substring(2));
		}
		else
		{
			return -1;
		}
	}
	public inline function getConstantIndex(name:String):Int
	{
		if (StringTools.startsWith(name, "vc"))
		{
			return Std.parseInt(name.substring(2));
		}
		else if (StringTools.startsWith(name, "fc"))
		{
			return Std.parseInt(name.substring(2));
		}
		else
		{
			return -1;
		}
	}
	public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray):Void;
	public inline function uploadSources(vertexSource:String, fragmentSource:String):Void {}
}
#else
typedef Program3D = openfl.display3D.Program3D;
#end
