package openfl.net; #if !flash #if (!openfl_legacy || disable_legacy_networking)


import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;
<<<<<<< HEAD

=======
>>>>>>> openfl/master
import openfl.net.Socket;


class XMLSocket extends EventDispatcher {
	
	
	public var connected (default, null):Bool;
	public var timeout:Int;
	
<<<<<<< HEAD
	private var _socket:Socket;
=======
	// TODO: Use openfl.net.Socket for all targets
	
	#if (js && html5)
	private var __socket:Dynamic;
	#else
	private var __socket:Socket;
	#end
>>>>>>> openfl/master
	
	
	public function new (host:String = null, port:Int = 80):Void {
		
		super ();
		
		if (host != null) {
			
			connect (host, port);
			
		}
		
	}
	
	
	public function close ():Void {

		_socket.removeEventListener(Event.CONNECT, onOpenHandler);
		_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onMessageHandler);
		
		#if (!js || !html5)
		__socket.removeEventListener (Event.CONNECT, onOpenHandler);
		__socket.removeEventListener (ProgressEvent.SOCKET_DATA, onMessageHandler);
		#end
		
		__socket.close ();
		
	}
	
	
	public function connect (host:String, port:Int):Void {
		
		connectWithProto (host, port, null);
		
	}
	
	
	@:noCompletion @:dox(hide) public function connectWithProto (host:String, port:Int, protocol:String):Void {
		
		// TODO: Remove this method
		
		connected = false;
		
		connected = false;

		#if (js && html5)
		if (protocol == null) {
<<<<<<< HEAD
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

=======
			
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
		
>>>>>>> openfl/master
		#end

		
		
	}
	
	
	public function send (object:Dynamic):Void {
		
<<<<<<< HEAD
		_socket.writeUTFBytes(object);
		_socket.writeByte(0);
=======
		#if (js && html5)
		__socket.send (object);
		#else
		__socket.writeUTFBytes (object);
		__socket.writeByte (0);
		#end
>>>>>>> openfl/master
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
<<<<<<< HEAD
	@:noCompletion private function onMessageHandler (e:ProgressEvent):Void {

		dispatchEvent(new DataEvent(DataEvent.DATA, false, false, _socket.readUTFBytes(_socket.bytesAvailable)));
=======
	@:noCompletion private function onCloseHandler (_):Void {
		
		dispatchEvent (new Event (Event.CLOSE));
>>>>>>> openfl/master
		
	}
	
	
	@:noCompletion private function onErrorHandler (_):Void {
		
		dispatchEvent (new Event (IOErrorEvent.IO_ERROR));
		
	}
	
	
	@:noCompletion private function onMessageHandler (e:#if (js && html5) Dynamic #else ProgressEvent #end):Void {
		
		#if (js && html5)
		dispatchEvent (new DataEvent (DataEvent.DATA, false, false, e.data));
		#else
		dispatchEvent (new DataEvent (DataEvent.DATA, false, false, __socket.readUTFBytes (__socket.bytesAvailable)));
		#end
		
	}
	
	
	@:noCompletion private function onOpenHandler (_):Void {
		
		connected = true;
		dispatchEvent (new Event (Event.CONNECT));
		
	}
	
	
}


#else
typedef XMLSocket = openfl._legacy.net.XMLSocket;
#end
#else
typedef XMLSocket = flash.net.XMLSocket;
#end