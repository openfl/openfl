package openfl._internal.backend.dummy;

import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.URLRequest;

class DummyFileReferenceBackend
{
	public function new(parent:FileReference) {}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		return false;
	}

	public function cancel():Void {}

	public function download(request:URLRequest, defaultFileName:String = null):Void {}

	public function load():Void {}

	public function save(data:Dynamic, defaultFileName:String = null):Void {}
}
