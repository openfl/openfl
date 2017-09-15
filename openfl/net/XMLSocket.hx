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
	
	private var __socket:Socket;
	
	
	public function new (host:String = null, port:Int = 80) {
		
		super ();
		
		if (host != null) {
			
			connect (host, port);
			
		}
		
	}
	
	
	public function close ():Void {
		
		__socket.removeEventListener (Event.CLOSE, __onClose);
		__socket.removeEventListener (Event.CONNECT, __onConnect);
		__socket.removeEventListener (IOErrorEvent.IO_ERROR, __onError);
		__socket.removeEventListener (ProgressEvent.SOCKET_DATA, __onSocketData);
		
		__socket.close ();
		
	}
	
	
	public function connect (host:String, port:Int):Void {
		
		connected = false;
		
		__socket = new Socket ();
		
		__socket.addEventListener (Event.CLOSE, __onClose);
		__socket.addEventListener (Event.CONNECT, __onConnect);
		__socket.addEventListener (IOErrorEvent.IO_ERROR, __onError);
		__socket.addEventListener (ProgressEvent.SOCKET_DATA, __onSocketData);
		
		__socket.connect (host, port);
		
	}
	
	
	public function send (object:Dynamic):Void {
		
		__socket.writeUTFBytes (Std.string (object));
		__socket.writeByte (0);
		__socket.flush ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function __onClose (_):Void {
		
		connected = false;
		dispatchEvent (new Event (Event.CLOSE));
		
	}
	
	
	private function __onConnect (_):Void {
		
		connected = true;
		dispatchEvent (new Event (Event.CONNECT));
		
	}
	
	
	private function __onError (_):Void {
		
		dispatchEvent (new Event (IOErrorEvent.IO_ERROR));
		
	}
	
	
	private function __onSocketData (_):Void {
		
		dispatchEvent (new DataEvent (DataEvent.DATA, false, false, __socket.readUTFBytes (__socket.bytesAvailable)));
		
	}
	
	
}