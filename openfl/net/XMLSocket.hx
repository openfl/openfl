package openfl.net;


import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;
import openfl.net.Socket;


class XMLSocket extends EventDispatcher {
	
	
	public var connected (default, null):Bool;
	public var timeout:Int;
	
	// TODO: Use openfl.net.Socket for all targets
	
	#if (js && html5)
	private var __socket:Dynamic;
	#else
	private var __socket:Socket;
	#end
	
	
	public function new (host:String = null, port:Int = 80) {
		
		super ();
		
		if (host != null) {
			
			connect (host, port);
			
		}
		
	}
	
	
	public function close ():Void {
		
		#if (!js || !html5)
		__socket.removeEventListener (Event.CONNECT, onOpenHandler);
		__socket.removeEventListener (ProgressEvent.SOCKET_DATA, onMessageHandler);
		#end
		
		__socket.close ();
		
	}
	
	
	public function connect (host:String, port:Int):Void {
		
		connectWithProto (host, port, null);
		
	}
	
	
	@:dox(hide) public function connectWithProto (host:String, port:Int, protocol:String):Void {
		
		// TODO: Remove this method
		
		connected = false;
		
		#if (js && html5)
		if (protocol == null) {
			
			__socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port)");
			
		} else {
			
			__socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port, protocol)");
			
		}
		
		__socket.onopen = onOpenHandler;
		__socket.onmessage = onMessageHandler;
		__socket.onclose = onCloseHandler;
		__socket.onerror = onErrorHandler;
		#else
		
		__socket = new Socket ();
		__socket.connect (host, port);
		
		__socket.addEventListener (Event.CONNECT, onOpenHandler);
		__socket.addEventListener (ProgressEvent.SOCKET_DATA, onMessageHandler);
		
		#end
		
	}
	
	
	public function send (object:Dynamic):Void {
		
		#if (js && html5)
		__socket.send (object);
		#else
		__socket.writeUTFBytes (object);
		__socket.writeByte (0);
		#end
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function onCloseHandler (_):Void {
		
		dispatchEvent (new Event (Event.CLOSE));
		
	}
	
	
	private function onErrorHandler (_):Void {
		
		dispatchEvent (new Event (IOErrorEvent.IO_ERROR));
		
	}
	
	
	private function onMessageHandler (e:#if (js && html5) Dynamic #else ProgressEvent #end):Void {
		
		#if (js && html5)
		dispatchEvent (new DataEvent (DataEvent.DATA, false, false, e.data));
		#else
		dispatchEvent (new DataEvent (DataEvent.DATA, false, false, __socket.readUTFBytes (__socket.bytesAvailable)));
		#end
		
	}
	
	
	private function onOpenHandler (_):Void {
		
		connected = true;
		dispatchEvent (new Event (Event.CONNECT));
		
	}
	
	
}