namespace openfl._internal.backend.html5;

#if openfl_html5
import openfl.net.FileFilter;
import openfl.net.FileReferenceList;

class HTML5FileReferenceListBackend
{
	private parent: FileReferenceList;

	public constructor(parent: FileReferenceList)
	{
		this.parent = parent;
	}

	public browse(typeFilter: Array<FileFilter> = null): boolean
	{
		return false;
	}
}
#end
