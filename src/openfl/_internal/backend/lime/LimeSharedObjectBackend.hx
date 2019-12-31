package openfl._internal.backend.lime;

#if lime
import lime.system.System;
import openfl._internal.backend.sys.SysSharedObjectBackend;
import openfl.net.SharedObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.net.SharedObject)
class LimeSharedObjectBackend extends SysSharedObjectBackend
{
	public function new(parent:SharedObject)
	{
		super(parent);
	}

	public override function getLocal(name:String, localPath:String = null, secure:Bool = false /* note: unsupported**/):Void
	{
		if (SharedObject.__sharedObjects == null)
		{
			if (Application.current != null)
			{
				Application.current.onExit.add(application_onExit);
			}
		}

		super.getLocal(name, localPath, secure);
	}

	private override function getPath(localPath:String, name:String):String
	{
		return super.getPath(System.applicationStorageDirectory + "/" + localPath, name);
	}

	// Event Handlers
	private static function application_onExit(_):Void
	{
		for (sharedObject in SharedObject.__sharedObjects)
		{
			sharedObject.flush();
		}
	}
}
#end
