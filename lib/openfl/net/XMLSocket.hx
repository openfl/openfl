package openfl.net; #if (display || !flash)


import openfl.events.EventDispatcher;

@:jsRequire("openfl/net/XMLSocket", "default")


extern class XMLSocket extends EventDispatcher {
	
	
	public var connected (default, null):Bool;
	public var timeout:Int;
	
	public function new (host:String = null, port:Int = 80);
	public function close ():Void;
	public function connect (host:String, port:Int):Void;
	public function send (object:Dynamic):Void;
	
	
}


#else
typedef XMLSocket = flash.net.XMLSocket;
#end