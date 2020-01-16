package openfl._internal.backend.dummy;

import openfl.net.SharedObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummySharedObjectBackend
{
	public function new(parent:SharedObject) {}

	public override function getLocal(name:String, localPath:String = null, secure:Bool = false /* note: unsupported**/):Void {}
}
