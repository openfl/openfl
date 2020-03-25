namespace openfl._internal.backend.dummy;

import openfl.net.URLRequest;

class DummyLibBackend
{
	public static getTimer(): number
	{
		return 0;
	}

	public static navigateToURL(request: URLRequest, window: string = null): void { }
}
