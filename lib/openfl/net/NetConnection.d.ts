import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.net {
	
	
	export class NetConnection extends EventDispatcher {
	
	
		//public static inline var CONNECT_SUCCESS:string = "connectSuccess";
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var defaultObjectEncoding:UInt;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var client:Dynamic;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var connected (default, null):boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var connectedProxyType (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var maxPeerConnections:UInt;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var nearID (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var objectEncoding:UInt;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var protocol (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var proxyType:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var unconnectedPeerStreams (default, null):Array<Dynamic>;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var uri (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public var usingTLS (default, null):boolean;
		// #end
		
		
		public constructor ();
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function addHeader (operation:string, mustUnderstand:boolean = false, ?param:Object):Void;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public function call (command:string, responder:flash.net.Responder, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public function close ():Void;
		// #end
		
		public connect (command:string, ...args:any[]):void;
		
		
	}
	
	
}


export default openfl.net.NetConnection;