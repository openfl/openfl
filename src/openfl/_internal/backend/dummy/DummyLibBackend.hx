package openfl._internal.backend.dummy;

import openfl.net.URLRequest;

class DummyLibBackend
{
	public static function getTimer():Int
	{
		return 0;
	}

	public static function navigateToURL(request:URLRequest, window:String = null):Void {}
}
