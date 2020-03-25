namespace openfl._internal.backend.dummy;

import openfl.net.URLLoader;
import openfl.net.URLRequest;

class DummyURLLoaderBackend
{
	public new(parent: URLLoader) { }

	public close(): void { }

	public load(request: URLRequest): void { }
}
