package openfl._internal.backend.sys;

#if sys
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Eof;
import haxe.io.Error;
import openfl._internal.Lib;
import openfl.errors.IOError;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.Socket;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import sys.net.Host;
import sys.net.Socket as SysSocket;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.net.Socket)
class SysSocketBackend
{
	private var buffer:Bytes;
	private var endian:Endian;
	private var input:ByteArray;
	private var output:ByteArray;
	private var parent:Socket;
	private var socket:SysSocket;
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
		parent.connected = false;
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

		var h:Host = null;

		try
		{
			h = new Host(host);
		}
		catch (e:Dynamic)
		{
			parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Invalid host"));
			return;
		}

		timestamp = Sys.time();

		output = new ByteArray();
		output.endian = endian;

		input = new ByteArray();
		input.endian = endian;

		socket = new SysSocket();

		try
		{
			socket.setBlocking(false);
			socket.connect(h, port);
			socket.setFastSend(true);
		}
		catch (e:Dynamic) {}

		Lib.current.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public function flush():Void
	{
		if (output.length > 0)
		{
			try
			{
				socket.output.writeBytes(output, 0, output.length);
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

	private function socket_onOpen(_):Void
	{
		parent.connected = true;
		parent.dispatchEvent(new Event(Event.CONNECT));
	}

	private function this_onEnterFrame(event:Event):Void
	{
		var doConnect = false;
		var doClose = false;

		if (!parent.connected)
		{
			var r = SysSocket.select(null, [socket], null, 0);

			if (r.write[0] == socket)
			{
				doConnect = true;
			}
			else if (Sys.time() - timestamp > parent.timeout / 1000)
			{
				doClose = true;
			}
		}

		var b = new BytesBuffer();
		var bLength = 0;

		if (parent.connected || doConnect)
		{
			try
			{
				var l:Int;

				do
				{
					l = socket.input.readBytes(buffer, 0, buffer.length);

					if (l > 0)
					{
						b.addBytes(buffer, 0, l);
						bLength += l;
					}
				}
				while (l == buffer.length);
			}
			catch (e:Eof)
			{
				// ignore
			}
			catch (e:Error)
			{
				if (e != Error.Blocked)
				{
					doClose = true;
				}
			}
			catch (e:Dynamic)
			{
				doClose = true;
			}
		}

		if (doClose && parent.connected)
		{
			cleanSocket();

			parent.dispatchEvent(new Event(Event.CLOSE));
		}
		else if (doClose)
		{
			cleanSocket();

			parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Connection failed"));
		}
		else if (doConnect)
		{
			parent.connected = true;
			parent.dispatchEvent(new Event(Event.CONNECT));
		}

		if (bLength > 0)
		{
			var newData = b.getBytes();

			var rl = input.length - input.position;
			if (rl < 0) rl = 0;

			var newInput = Bytes.alloc(rl + newData.length);
			if (rl > 0) newInput.blit(0, input, input.position, rl);
			newInput.blit(rl, newData, 0, newData.length);
			input = newInput;
			input.endian = endian;

			parent.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, newData.length, 0));
		}

		if (socket != null)
		{
			try
			{
				flush();
			}
			catch (e:IOError)
			{
				parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, e.message));
			}
		}
	}
}
#end
