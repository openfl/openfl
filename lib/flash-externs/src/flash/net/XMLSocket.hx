package flash.net;

#if flash
import openfl.events.EventDispatcher;

extern class XMLSocket extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var connected(default, never):Bool;
	@:require(flash10) public var timeout:Int;
	#else
	@:flash.property var connected(get, never):Bool;
	@:flash.property @:require(flash10) var timeout(get, set):Int;
	#end

	public function new(host:String = null, port:Int = 80);
	public function close():Void;
	public function connect(host:String, port:Int):Void;
	public function send(object:Dynamic):Void;

	#if (haxe_ver >= 4.3)
	private function get_connected():Bool;
	private function get_timeout():Int;
	private function set_timeout(value:Int):Int;
	#end
}
#else
typedef XMLSocket = openfl.net.XMLSocket;
#end
