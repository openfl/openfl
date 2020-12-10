package flash.net;

#if flash
import openfl.events.EventDispatcher;

extern class URLLoader extends EventDispatcher
{
	public var bytesLoaded:Int;
	public var bytesTotal:Int;
	public var data:Dynamic;
	public var dataFormat:URLLoaderDataFormat;
	public function new(request:URLRequest = null);
	public function close():Void;
	public function load(request:URLRequest):Void;
}
#else
typedef URLLoader = openfl.net.URLLoader;
#end
