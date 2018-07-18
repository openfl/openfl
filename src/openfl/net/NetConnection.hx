package openfl.net; #if !flash


import openfl.events.EventDispatcher;
import openfl.events.NetStatusEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class NetConnection extends EventDispatcher {
	
	
	public static inline var CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
	
	// @:noCompletion @:dox(hide) public static var defaultObjectEncoding:ObjectEncoding;
	// @:noCompletion @:dox(hide) public var client:Dynamic;
	// @:noCompletion @:dox(hide) public var connected (default, null):Bool;
	// @:noCompletion @:dox(hide) public var connectedProxyType (default, null):String;
	// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
	// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
	// @:noCompletion @:dox(hide) @:require(flash10) public var maxPeerConnections:UInt;
	// @:noCompletion @:dox(hide) @:require(flash10) public var nearID (default, null):String;
	// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
	// @:noCompletion @:dox(hide) public var objectEncoding:ObjectEncoding;
	// @:noCompletion @:dox(hide) @:require(flash10) public var protocol (default, null):String;
	// @:noCompletion @:dox(hide) public var proxyType:String;
	// @:noCompletion @:dox(hide) @:require(flash10) public var unconnectedPeerStreams (default, null):Array<Dynamic>;
	// @:noCompletion @:dox(hide) public var uri (default, null):String;
	// @:noCompletion @:dox(hide) public var usingTLS (default, null):Bool;
	
	
	
	public function new () {
		
		super ();
		
	}
	
	
	// @:noCompletion @:dox(hide) public function addHeader (operation:String, mustUnderstand:Bool = false, ?param:Object):Void;
	// @:noCompletion @:dox(hide) public function call (command:String, responder:flash.net.Responder, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	// @:noCompletion @:dox(hide) public function close ():Void;
	
	
	public function connect (command:String, ?_, ?_, ?_, ?_, ?_):Void {
		
		if (command != null) {
			
			throw "Error: Can only connect in \"HTTP streaming\" mode";
			
		}
		
		this.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, true, { code: NetConnection.CONNECT_SUCCESS }));
		
	}
	
	
}


#else
typedef NetConnection = flash.net.NetConnection;
#end