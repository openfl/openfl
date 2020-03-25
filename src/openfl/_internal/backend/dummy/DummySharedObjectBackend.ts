namespace openfl._internal.backend.dummy;

import openfl.net.SharedObject;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummySharedObjectBackend
{
	public new(parent: SharedObject) { }

	publicgetLocal(name: string, localPath: string = null, secure: boolean = false /* note: unsupported**/): void { }
}
