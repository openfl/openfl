package openfl.display3D;

#if (display || !flash)
import openfl.utils.ByteArray;

#if !openfl_global
@:jsRequire("openfl/display3D/Program3D", "default")
#end
@:final extern class Program3D
{
	public function dispose():Void;
	public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray):Void;
}
#else
typedef Program3D = flash.display3D.Program3D;
#end
