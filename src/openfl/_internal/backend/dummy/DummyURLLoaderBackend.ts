namespace openfl._internal.backend.dummy;

import openfl.net.URLLoader;
import openfl.net.URLRequest;

class DummyURLLoaderBackend
{
	public constructor(parent: URLLoader) { }

	public close(): void { }

	public load(request: URLRequest): void { }
}
