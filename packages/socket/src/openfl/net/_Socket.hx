package openfl.net;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Eof;
import haxe.io.Error;
import haxe.Serializer;
import haxe.Unserializer;
import openfl._internal.Lib;
import openfl.errors.IOError;
import openfl.errors.SecurityError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;
import openfl.utils.IDataOutput;
#if sys
import sys.net.Host;
import sys.net.Socket as SysSocket;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Socket extends _EventDispatcher
{
	public var bytesAvailable(get, never):Int;
	public var bytesPending(get, never):Int;
	public var connected:Bool;
	public var endian(get, set):Endian;
	public var objectEncoding:ObjectEncoding;
	public var secure:Bool;
	public var timeout:Int;

	public var buffer:Bytes;
	public var _endian:Endian;
	public var input:ByteArray;
	public var output:ByteArray;
	public var parent:Socket;
	public var socket:SysSocket;
	public var timestamp:Float;

	public function new(host:String = null, port:Int = 0)
	{
		super();

		buffer = Bytes.alloc(4096);

		_endian = Endian.BIG_ENDIAN;
		timeout = 20000;

		if (port > 0 && port < 65535)
		{
			connect(host, port);
		}
	}

	public function cleanSocket():Void
	{
		try
		{
			socket.close();
		}
		catch (e:Dynamic) {}

		socket = null;
		connected = false;
		Lib.current.removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public function close():Void
	{
		__checkValid();
		if (socket != null)
		{
			cleanSocket();
		}
	}

	public function connect(host:String = null, port:Int = 0):Void
	{
		if (port < 0 || port > 65535)
		{
			throw new SecurityError("Invalid socket port number specified.");
		}

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
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Invalid host"));
			return;
		}

		timestamp = Sys.time();

		output = new ByteArray();
		output.endian = _endian;

		input = new ByteArray();
		input.endian = _endian;

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
		__checkValid();
		if (output.length > 0)
		{
			try
			{
				socket.output.writeBytes(output, 0, output.length);
				output = new ByteArray();
				output.endian = _endian;
			}
			catch (e:Dynamic)
			{
				throw new IOError("Operation attempted on invalid socket.");
			}
		}
	}

	public function readBoolean():Bool
	{
		__checkValid();
		return input.readBoolean();
	}

	public function readByte():Int
	{
		__checkValid();
		return input.readByte();
	}

	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		__checkValid();
		input.readBytes(bytes, offset, length);
	}

	public function readDouble():Float
	{
		__checkValid();
		return input.readDouble();
	}

	public function readFloat():Float
	{
		__checkValid();
		return input.readFloat();
	}

	public function readInt():Int
	{
		__checkValid();
		return input.readInt();
	}

	public function readMultiByte(length:Int, charSet:String):String
	{
		__checkValid();
		return input.readMultiByte(length, charSet);
	}

	public function readObject():Dynamic
	{
		if (objectEncoding == HXSF)
		{
			return Unserializer.run(readUTF());
		}
		else
		{
			// TODO: Add support for AMF if haxelib "format" is included
			return null;
		}
	}

	public function readShort():Int
	{
		__checkValid();
		return input.readShort();
	}

	public function readUnsignedByte():Int
	{
		__checkValid();
		return input.readUnsignedByte();
	}

	public function readUnsignedInt():Int
	{
		__checkValid();
		return input.readUnsignedInt();
	}

	public function readUnsignedShort():Int
	{
		__checkValid();
		return input.readUnsignedShort();
	}

	public function readUTF():String
	{
		__checkValid();
		return input.readUTF();
	}

	public function readUTFBytes(length:Int):String
	{
		__checkValid();
		return input.readUTFBytes(length);
	}

	public function writeBoolean(value:Bool):Void
	{
		__checkValid();
		output.writeBoolean(value);
	}

	public function writeByte(value:Int):Void
	{
		__checkValid();
		output.writeByte(value);
	}

	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		__checkValid();
		output.writeBytes(bytes, offset, length);
	}

	public function writeDouble(value:Float):Void
	{
		__checkValid();
		output.writeDouble(value);
	}

	public function writeFloat(value:Float):Void
	{
		__checkValid();
		output.writeFloat(value);
	}

	public function writeInt(value:Int):Void
	{
		__checkValid();
		output.writeInt(value);
	}

	public function writeMultiByte(value:String, charSet:String):Void
	{
		__checkValid();
		output.writeUTFBytes(value);
	}

	public function writeObject(object:Dynamic):Void
	{
		__checkValid();

		if (objectEncoding == HXSF)
		{
			output.writeUTF(Serializer.run(object));
		}
		else
		{
			// TODO: Add support for AMF if haxelib "format" is included
		}
	}

	public function writeShort(value:Int):Void
	{
		__checkValid();
		output.writeShort(value);
	}

	public function writeUnsignedInt(value:Int):Void
	{
		__checkValid();
		output.writeUnsignedInt(value);
	}

	public function writeUTF(value:String):Void
	{
		__checkValid();
		output.writeUTF(value);
	}

	public function writeUTFBytes(value:String):Void
	{
		__checkValid();
		output.writeUTFBytes(value);
	}

	public function __checkValid():Void
	{
		if (!connected)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}
	}

	// Event Handlers

	public function socket_onClose(_):Void
	{
		dispatchEvent(new Event(Event.CLOSE));
	}

	public function socket_onError(e):Void
	{
		dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
	}

	public function socket_onOpen(_):Void
	{
		connected = true;
		dispatchEvent(new Event(Event.CONNECT));
	}

	public function this_onEnterFrame(event:Event):Void
	{
		var doConnect = false;
		var doClose = false;

		if (!connected)
		{
			var r = SysSocket.select(null, [socket], null, 0);

			if (r.write[0] == socket)
			{
				doConnect = true;
			}
			else if (Sys.time() - timestamp > timeout / 1000)
			{
				doClose = true;
			}
		}

		var b = new BytesBuffer();
		var bLength = 0;

		if (connected || doConnect)
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

		if (doClose && connected)
		{
			cleanSocket();

			dispatchEvent(new Event(Event.CLOSE));
		}
		else if (doClose)
		{
			cleanSocket();

			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Connection failed"));
		}
		else if (doConnect)
		{
			connected = true;
			dispatchEvent(new Event(Event.CONNECT));
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
			input.endian = _endian;

			dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, newData.length, 0));
		}

		if (socket != null)
		{
			try
			{
				flush();
			}
			catch (e:IOError)
			{
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, e.message));
			}
		}
	}

	// Get & Set Methods

	private function get_bytesAvailable():Int
	{
		return input.bytesAvailable;
	}

	private function get_bytesPending():Int
	{
		return output.length;
	}

	private function get_endian():Endian
	{
		return _endian;
	}

	private function set_endian(value:Endian):Endian
	{
		_endian = value;
		if (input != null) input.endian = value;
		if (output != null) output.endian = value;
		return value;
	}
}
