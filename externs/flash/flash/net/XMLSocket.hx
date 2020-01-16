package flash.net;

#if flash
import openfl.events.EventDispatcher;

extern class XMLSocket extends EventDispatcher
{
	public var connected(default, never):Bool;
	@:require(flash10) public var timeout:Int;
	public function new(host:String = null, port:Int = 80);
	public function close():Void;
	public function connect(host:String, port:Int):Void;
	public function send(object:Dynamic):Void;
}
#else
typedef XMLSocket = openfl.net.XMLSocket;
#end
