package openfl._internal.backend.dummy;

import openfl.net.FileFilter;
import openfl.net.FileReferenceList;

class DummyFileReferenceListBackend
{
	public function new(parent:FileReferenceList) {}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		return false;
	}
}
