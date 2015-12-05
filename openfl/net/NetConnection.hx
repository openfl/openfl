package openfl.net; #if (!display && !flash)


import openfl.events.EventDispatcher;
import openfl.events.NetStatusEvent;


class NetConnection extends EventDispatcher {
	
	
	public static inline var CONNECT_SUCCESS:String = "connectSuccess";
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public function connect (command:String, ?_, ?_, ?_, ?_, ?_):Void {
		
		if (command != null) {
			
			throw "Error: Can only connect in \"HTTP streaming\" mode";
			
		}
		
		this.dispatchEvent (new NetStatusEvent (NetStatusEvent.NET_STATUS, false, true, { code: NetConnection.CONNECT_SUCCESS }));
		
	}
	
	
}


#else


import openfl.events.EventDispatcher;
import openfl.utils.Object;

#if flash
@:native("flash.net.NetConnection")
#end


extern class NetConnection extends EventDispatcher {
	
	
	//public static inline var CONNECT_SUCCESS:String = "connectSuccess";
	
	#if flash
	@:noCompletion @:dox(hide) public static var defaultObjectEncoding:UInt;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var client:Dynamic;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var connected (default, null):Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var connectedProxyType (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var maxPeerConnections:UInt;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var nearID (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var objectEncoding:UInt;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var protocol (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var proxyType:String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var unconnectedPeerStreams (default, null):Array<Dynamic>;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var uri (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var usingTLS (default, null):Bool;
	#end
	
	
	public function new ();
	
	
	#if flash
	@:noCompletion @:dox(hide) public function addHeader (operation:String, mustUnderstand:Bool = false, ?param:Object):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function call (command:String, responder:flash.net.Responder, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function close ():Void;
	#end
	
	public function connect (command:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	
	
}


#end