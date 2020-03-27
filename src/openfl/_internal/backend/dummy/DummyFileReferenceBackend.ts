namespace openfl._internal.backend.dummy;

import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.URLRequest;

class DummyFileReferenceBackend
{
	public constructor(parent: FileReference) { }

	public browse(typeFilter: Array<FileFilter> = null): boolean
	{
		return false;
	}

	public cancel(): void { }

	public download(request: URLRequest, defaultFileName: string = null): void { }

	public load(): void { }

	public save(data: Dynamic, defaultFileName: string = null): void { }
}
