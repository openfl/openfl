package flash.net;

#if flash
import openfl.events.EventDispatcher;
import openfl.net.Responder;
import openfl.utils.Object;

extern class NetConnection extends EventDispatcher
{
	// public static inline var CONNECT_SUCCESS:String = "connectSuccess";
	#if (haxe_ver < 4.3)
	public static var defaultObjectEncoding:ObjectEncoding;
	public var client:Dynamic;
	public var connected(default, never):Bool;
	public var connectedProxyType(default, never):String;
	@:require(flash10) public var farID(default, never):String;
	@:require(flash10) public var farNonce(default, never):String;
	@:require(flash10) public var maxPeerConnections:UInt;
	@:require(flash10) public var nearID(default, never):String;
	@:require(flash10) public var nearNonce(default, never):String;
	public var objectEncoding:ObjectEncoding;
	@:require(flash10) public var protocol(default, never):String;
	public var proxyType:String;
	@:require(flash10) public var unconnectedPeerStreams(default, never):Array<NetStream>;
	public var uri(default, never):String;
	public var usingTLS(default, never):Bool;
	#else
	@:flash.property static var defaultObjectEncoding(get, set):ObjectEncoding;
	@:flash.property var client(get, set):Dynamic;
	@:flash.property var connected(get, never):Bool;
	@:flash.property var connectedProxyType(get, never):String;
	@:flash.property @:require(flash10) var farID(get, never):String;
	@:flash.property @:require(flash10) var farNonce(get, never):String;
	@:flash.property @:require(flash10) var maxPeerConnections(get, set):UInt;
	@:flash.property @:require(flash10) var nearID(get, never):String;
	@:flash.property @:require(flash10) var nearNonce(get, never):String;
	@:flash.property var objectEncoding(get, set):ObjectEncoding;
	@:flash.property @:require(flash10) var protocol(get, never):String;
	@:flash.property var proxyType(get, set):String;
	@:flash.property @:require(flash10) var unconnectedPeerStreams(get, never):Array<NetStream>;
	@:flash.property var uri(get, never):String;
	@:flash.property var usingTLS(get, never):Bool;
	#end

	public function new();
	public function addHeader(operation:String, mustUnderstand:Bool = false, ?param:Object):Void;
	public function call(command:String, responder:Responder, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	public function close():Void;
	public function connect(command:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;

	#if (haxe_ver >= 4.3)
	private static function get_defaultObjectEncoding():ObjectEncoding;
	private function get_client():Dynamic;
	private function get_connected():Bool;
	private function get_connectedProxyType():String;
	private function get_farID():String;
	private function get_farNonce():String;
	private function get_maxPeerConnections():UInt;
	private function get_nearID():String;
	private function get_nearNonce():String;
	private function get_objectEncoding():ObjectEncoding;
	private function get_protocol():String;
	private function get_proxyType():String;
	private function get_unconnectedPeerStreams():Array<NetStream>;
	private function get_uri():String;
	private function get_usingTLS():Bool;
	private static function set_defaultObjectEncoding(value:ObjectEncoding):ObjectEncoding;
	private function set_client(value:Dynamic):Dynamic;
	private function set_maxPeerConnections(value:UInt):UInt;
	private function set_objectEncoding(value:UInt):UInt;
	private function set_proxyType(value:String):String;
	#end
}
#else
typedef NetConnection = openfl.net.NetConnection;
#end
