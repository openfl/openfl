package openfl._internal.backend.dummy;

import openfl.net.URLLoader;
import openfl.net.URLRequest;

class DummyURLLoaderBackend
{
	public function new(parent:URLLoader) {}

	public function close():Void {}

	public function load(request:URLRequest):Void {}
}
