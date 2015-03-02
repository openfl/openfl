package openfl._v2.net; #if lime_legacy
#if cpp


import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;
import openfl.net.Socket;


class XMLSocket extends EventDispatcher {
	
	
	public var connected(default, null):Bool;
	public var timeout:Int;
	
	private var _socket:Socket;
	
	
	public function new(host:String = null, port:Int = 80):Void {
		
		super();
		
		if (host != null) {
			
			connect(host, port);
			
		}
		
	}
	
	
	public function close():Void {
		
		_socket.removeEventListener(Event.CONNECT, onOpenHandler);
		_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onMessageHandler);
		
		_socket.close();
		
	}
	
	
	public function connect(host: String, port:Int):Void {
		_socket = new Socket();
		_socket.connect(host, port);
		_socket.addEventListener(Event.CONNECT, onOpenHandler);
		_socket.addEventListener(ProgressEvent.SOCKET_DATA, onMessageHandler);
		
	}
	
	
	public function send(object:Dynamic):Void {
		_socket.writeUTFBytes(object);
		_socket.writeByte(0);

	}

	// Event Handlers
	private function onMessageHandler(e: ProgressEvent):Void {
		
		dispatchEvent(new DataEvent(DataEvent.DATA, false, false, _socket.readUTFBytes(_socket.bytesAvailable)));
		
	}
	
	
	private function onOpenHandler(_):Void {
		connected = true;
		dispatchEvent(new Event(Event.CONNECT));
		
	}
	
	
}


#end
#end