package openfl._internal.backend.dummy;

import openfl.display3D.Program3D;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyProgram3DBackend
{
	public function new(parent:Program3D) {}

	public function dispose():Void {}

	public function markDirty(isVertex:Bool, index:Int, count:Int):Void {}

	public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray):Void {}

	public function uploadSources(vertexSource:String, fragmentSource:String):Void {}
}
