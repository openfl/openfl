package openfl.net; #if !flash #if (!openfl_legacy || disable_legacy_networking)


import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;

import openfl.net.Socket;


class XMLSocket extends EventDispatcher {
	
	
	public var connected (default, null):Bool;
	public var timeout:Int;
	
	private var _socket:Socket;
	
	
	public function new (host:String = null, port:Int = 80):Void {
		
		super();
		
		if (host != null) {
			
			connect (host, port);
			
		}
		
	}
	
	
	public function close ():Void {

		_socket.removeEventListener(Event.CONNECT, onOpenHandler);
		_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onMessageHandler);
		
		_socket.close ();
		
	}
	
	
	public function connect (host: String, port:Int):Void {
		
		connectWithProto(host, port, null);
		
	}
	
	
	public function connectWithProto (host: String, port:Int, protocol:String):Void {
		
		connected = false;

		#if (js && html5)
		if (protocol == null) {
            _socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port)");
        }
        else {
            _socket = untyped __js__("new WebSocket(\"ws://\" + host + \":\" + port, protocol)");
        }

        _socket.onopen = onOpenHandler;
		_socket.onmessage = onMessageHandler;
		_socket.onclose = onCloseHandler;
		_socket.onerror = onErrorHandler;
        #else

        _socket = new Socket();
		_socket.connect(host, port);

		_socket.addEventListener(Event.CONNECT, onOpenHandler);
		_socket.addEventListener(ProgressEvent.SOCKET_DATA, onMessageHandler);

		#end

		
		
	}
	
	
	public function send (object:Dynamic):Void {
		
		_socket.writeUTFBytes(object);
		_socket.writeByte(0);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function onMessageHandler (e:ProgressEvent):Void {

		dispatchEvent(new DataEvent(DataEvent.DATA, false, false, _socket.readUTFBytes(_socket.bytesAvailable)));
		
	}
	
	
	@:noCompletion private function onOpenHandler (_):Void {
		
		connected = true;
		dispatchEvent (new Event (Event.CONNECT));
		
	}
	
	
	@:noCompletion private function onCloseHandler (_):Void {
		
		dispatchEvent (new Event (Event.CLOSE));
		
	}
	
	
	@:noCompletion private function onErrorHandler (_):Void {
		
		dispatchEvent (new Event (IOErrorEvent.IO_ERROR));
		
	}
	
	
}


#else
typedef XMLSocket = openfl._legacy.net.XMLSocket;
#end
#else
typedef XMLSocket = flash.net.XMLSocket;
#end