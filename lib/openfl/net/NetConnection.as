package openfl.net {
	
	
	import openfl.events.EventDispatcher;
	// import openfl.utils.Object;
	
	
	/**
	 * @externs
	 */
	public class NetConnection extends EventDispatcher {
		
		
		//public static inline var CONNECT_SUCCESS:String = "connectSuccess";
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var defaultObjectEncoding:ObjectEncoding;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var client:Dynamic;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var connected (default, null):Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var connectedProxyType (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var maxPeerConnections:UInt;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var nearID (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var objectEncoding:ObjectEncoding;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var protocol (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var proxyType:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var unconnectedPeerStreams (default, null):Array<Dynamic>;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var uri (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var usingTLS (default, null):Bool;
		// #end
		
		
		public function NetConnection () {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function addHeader (operation:String, mustUnderstand:Bool = false, ?param:Object):Void;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public function call (command:String, responder:flash.net.Responder, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public function close ():Void;
		// #end
		
		public function connect (command:String, p1:* = null, p2:* = null, p3:* = null, p4:* = null, p5:* = null):void {}
		
		
	}
	
	
}