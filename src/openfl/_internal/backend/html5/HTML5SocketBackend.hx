package openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Bytes;
import haxe.Timer;
import js.html.WebSocket;
import js.Browser;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import openfl._internal.Lib;
import openfl.errors.IOError;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.Socket;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

@:access(openfl.net.Socket)
class HTML5SocketBackend
{
	private var buffer:Bytes;
	private var endian:Endian;
	private var input:ByteArray;
	private var output:ByteArray;
	private var parent:Socket;
	private var socket:WebSocket;
	private var timestamp:Float;

	public function new(parent:Socket)
	{
		this.parent = parent;

		buffer = Bytes.alloc(4096);
	}

	private function cleanSocket():Void
	{
		try
		{
			socket.close();
		}
		catch (e:Dynamic) {}

		socket = null;
		@:privateAccess parent.connected = false;
		Lib.current.removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public function close():Void
	{
		if (socket != null)
		{
			cleanSocket();
		}
	}

	public function connect(host:String = null, port:Int = 0):Void
	{
		if (socket != null)
		{
			close();
		}

		timestamp = Timer.stamp();

		output = new ByteArray();
		output.endian = endian;

		input = new ByteArray();
		input.endian = endian;

		if (Browser.location.protocol == "https:")
		{
			parent.secure = true;
		}

		var schema = parent.secure ? "wss" : "ws";
		var urlReg = ~/^(.*:\/\/)?([A-Za-z0-9\-\.]+)\/?(.*)/g;
		urlReg.match(host);
		var webHost = urlReg.matched(2);
		var webPath = urlReg.matched(3);

		socket = new WebSocket(schema + "://" + webHost + ":" + port + "/" + webPath);
		socket.binaryType = ARRAYBUFFER;
		socket.onopen = socket_onOpen;
		socket.onmessage = socket_onMessage;
		socket.onclose = socket_onClose;
		socket.onerror = socket_onError;

		Lib.current.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public function flush():Void
	{
		if (output.length > 0)
		{
			try
			{
				var buffer:ArrayBuffer = output;
				if (buffer.byteLength > output.length) buffer = buffer.slice(0, output.length);
				socket.send(buffer);
				output = new ByteArray();
				output.endian = endian;
			}
			catch (e:Dynamic)
			{
				throw new IOError("Operation attempted on invalid socket.");
			}
		}
	}

	public function getBytesAvailable():Int
	{
		return input.bytesAvailable;
	}

	public function getBytesPending():Int
	{
		return output.length;
	}

	public function getEndian():Endian
	{
		return endian;
	}

	public function readBoolean():Bool
	{
		return input.readBoolean();
	}

	public function readByte():Int
	{
		return input.readByte();
	}

	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		input.readBytes(bytes, offset, length);
	}

	public function readDouble():Float
	{
		return input.readDouble();
	}

	public function readFloat():Float
	{
		return input.readFloat();
	}

	public function readInt():Int
	{
		return input.readInt();
	}

	public function readMultiByte(length:Int, charSet:String):String
	{
		return input.readMultiByte(length, charSet);
	}

	public function readShort():Int
	{
		return input.readShort();
	}

	public function readUnsignedByte():Int
	{
		return input.readUnsignedByte();
	}

	public function readUnsignedInt():Int
	{
		return input.readUnsignedInt();
	}

	public function readUnsignedShort():Int
	{
		return input.readUnsignedShort();
	}

	public function readUTF():String
	{
		return input.readUTF();
	}

	public function readUTFBytes(length:Int):String
	{
		return input.readUTFBytes(length);
	}

	public function setEndian(value:Endian):Endian
	{
		endian = value;

		if (input != null) input.endian = value;
		if (output != null) output.endian = value;

		return endian;
	}

	public function writeBoolean(value:Bool):Void
	{
		output.writeBoolean(value);
	}

	public function writeByte(value:Int):Void
	{
		output.writeByte(value);
	}

	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		output.writeBytes(bytes, offset, length);
	}

	public function writeDouble(value:Float):Void
	{
		output.writeDouble(value);
	}

	public function writeFloat(value:Float):Void
	{
		output.writeFloat(value);
	}

	public function writeInt(value:Int):Void
	{
		output.writeInt(value);
	}

	public function writeMultiByte(value:String, charSet:String):Void
	{
		output.writeUTFBytes(value);
	}

	public function writeShort(value:Int):Void
	{
		output.writeShort(value);
	}

	public function writeUnsignedInt(value:Int):Void
	{
		output.writeUnsignedInt(value);
	}

	public function writeUTF(value:String):Void
	{
		output.writeUTF(value);
	}

	public function writeUTFBytes(value:String):Void
	{
		output.writeUTFBytes(value);
	}

	// Event Handlers
	private function socket_onClose(_):Void
	{
		parent.dispatchEvent(new Event(Event.CLOSE));
	}

	private function socket_onError(e):Void
	{
		parent.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
	}

	private function socket_onMessage(msg:Dynamic):Void
	{
		if (input.position == input.length)
		{
			input.clear();
		}

		if (Std.is(msg.data, String))
		{
			input.position = input.length;
			var cachePosition = input.position;
			input.writeUTFBytes(msg.data);
			input.position = cachePosition;
		}
		else
		{
			var newData:ByteArray = (msg.data : ArrayBuffer);
			newData.readBytes(input, input.length);
		}

		if (input.bytesAvailable > 0)
		{
			parent.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, input.bytesAvailable, 0));
		}
	}

	private function socket_onOpen(_):Void
	{
		@:privateAccess parent.connected = true;
		parent.dispatchEvent(new Event(Event.CONNECT));
	}

	private function this_onEnterFrame(event:Event):Void
	{
		if (socket != null)
		{
			flush();
		}
	}
}
#end
