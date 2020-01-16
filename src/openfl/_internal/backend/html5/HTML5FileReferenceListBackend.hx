package openfl._internal.backend.html5;

#if openfl_html5
import openfl.net.FileFilter;
import openfl.net.FileReferenceList;

class HTML5FileReferenceListBackend
{
	private var parent:FileReferenceList;

	public function new(parent:FileReferenceList)
	{
		this.parent = parent;
	}

	public function browse(typeFilter:Array<FileFilter> = null):Bool
	{
		return false;
	}
}
#end
