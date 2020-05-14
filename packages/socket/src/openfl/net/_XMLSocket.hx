package openfl.net;

import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.EventDispatcher;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _XMLSocket extends _EventDispatcher
{
	public var connected:Bool;
	public var timeout:Int;

	#if !js
	public var __inputBuffer:ByteArray;
	#end
	public var __socket:Socket;

	private var xmlSocket:XMLSocket;

	public function new(xmlSocket:XMLSocket, host:String = null, port:Int = 80)
	{
		this.xmlSocket = xmlSocket;

		super(xmlSocket);

		#if !js
		__inputBuffer = new ByteArray();
		#end

		if (host != null)
		{
			connect(host, port);
		}
	}

	public function close():Void
	{
		__socket.removeEventListener(Event.CLOSE, __onClose);
		__socket.removeEventListener(Event.CONNECT, __onConnect);
		__socket.removeEventListener(IOErrorEvent.IO_ERROR, __onError);
		__socket.removeEventListener(ProgressEvent.SOCKET_DATA, __onSocketData);

		__socket.close();
	}

	public function connect(host:String, port:Int):Void
	{
		connected = false;

		__socket = new Socket();

		__socket.addEventListener(Event.CLOSE, __onClose);
		__socket.addEventListener(Event.CONNECT, __onConnect);
		__socket.addEventListener(IOErrorEvent.IO_ERROR, __onError);
		__socket.addEventListener(ProgressEvent.SOCKET_DATA, __onSocketData);

		__socket.connect(host, port);
	}

	public function send(object:Dynamic):Void
	{
		__socket.writeUTFBytes(Std.string(object));
		__socket.writeByte(0);
		__socket.flush();
	}

	// Event Handlers

	public function __onClose(_):Void
	{
		connected = false;
		dispatchEvent(new Event(Event.CLOSE));
	}

	public function __onConnect(_):Void
	{
		connected = true;
		dispatchEvent(new Event(Event.CONNECT));
	}

	public function __onError(_):Void
	{
		dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
	}

	public function __onSocketData(_):Void
	{
		#if !js
		var bytesAvailable = __socket.bytesAvailable;
		var byte, data;

		for (i in 0...bytesAvailable)
		{
			byte = __socket.readByte();
			__inputBuffer.writeByte(byte);

			if (byte == 0)
			{
				__inputBuffer.endian = __socket.endian;
				__inputBuffer.position = 0;
				data = __inputBuffer.readUTFBytes(__inputBuffer.bytesAvailable);
				__inputBuffer.position = 0;
				__inputBuffer.length = 0;

				dispatchEvent(new DataEvent(DataEvent.DATA, false, false, data));
			}
		}
		#else
		dispatchEvent(new DataEvent(DataEvent.DATA, false, false, __socket.readUTFBytes(__socket.bytesAvailable)));
		#end
	}
}
