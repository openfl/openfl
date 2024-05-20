package openfl.net;

import openfl.net._internal.websocket.FlexSocket;
import openfl.net._internal.websocket.WebSocket as InternalWS;
import openfl.net._internal.websocket.WebsocketEvent;
import openfl.errors.IOError;
import openfl.errors.SecurityError;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.ServerSocketConnectEvent;
import openfl.events.TickEvent;
import openfl.utils.ByteArray;
import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import haxe.io.Error;

/**
 * ...
 * @author Christopher Speciale
 */
class WebSocket extends Socket
{
	public static function toWebSocket(socket:FlexSocket, server:ServerWebSocket):WebSocket
	{
		var webSocket:WebSocket = new WebSocket();

		webSocket.__webSocket = openfl.net._internal.websocket.WebSocket.fromAcceptedSocket(socket);
		webSocket.__init();

		webSocket.__server = server;

		return webSocket;
	}

	private var __webSocket:openfl.net._internal.websocket.WebSocket;
	private var __server:ServerWebSocket;

	public function new(host:String = null, port:Int = 0)
	{
		super(host, port);
	}

	override public function close():Void
	{
		super.close();
	}

	override public function connect(host:String = null, port:Int = 0):Void
	{
		if (__socket != null)
		{
			close();
		}

		if (port < 0 || port > 65535)
		{
			throw new SecurityError("Invalid socket port number specified.");
		}

		__timestamp = Timer.stamp();

		__host = host;
		__port = port;

		__output = new ByteArray();
		__output.endian = __endian;

		__input = new ByteArray();
		__input.endian = __endian;

		var schema = secure ? "wss" : "ws";
		var urlReg = ~/^(.*:\/\/)?([A-Za-z0-9\-\.]+)\/?(.*)/g;
		urlReg.match(host);
		var __webHost = urlReg.matched(2);
		var __webPath = urlReg.matched(3);

		__webSocket = new crossbyte._internal.websocket.WebSocket(schema + "://" + __webHost + ":" + port + "/" + __webPath);
		__init();
	}

	override public function flush():Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		if (__output.length > 0)
		{
			// try
			// {
			__webSocket.sendBytes(__output);
			__output.clear();
			// }
			// catch (e:Dynamic)
			// {
			// switch (e)
			// {
			// case Error.Blocked:
			// case Error.Custom(Error.Blocked):
			// default:
			// throw new IOError("Operation attempted on invalid socket.");
			// }
			//
			// }
		}
	}

	/**
		Reads a Boolean value from the socket. After reading a single byte,
		the method returns `true` if the byte is nonzero, and `false`
		otherwise.
		@return A value of `true` if the byte read is nonzero, otherwise
				`false`.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readBoolean():Bool
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readBoolean();
	}

	/**
		Reads a signed byte from the socket.
		@return A value from -128 to 127.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readByte():Int
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readByte();
	}

	/**
		Reads the number of data bytes specified by the length parameter from
		the socket. The bytes are read into the specified byte array, starting
		at the position indicated by `offset`.
		@param bytes  The ByteArray object to read data into.
		@param offset The offset at which data reading should begin in the
					  byte array.
		@param length The number of bytes to read. The default value of 0
					  causes all available data to be read.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__input.readBytes(bytes, offset, length);
	}

	/**
		Reads an IEEE 754 double-precision floating-point number from the
		socket.
		@return An IEEE 754 double-precision floating-point number.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readDouble():Float
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readDouble();
	}

	/**
		Reads an IEEE 754 single-precision floating-point number from the
		socket.
		@return An IEEE 754 single-precision floating-point number.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readFloat():Float
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readFloat();
	}

	/**
		Reads a signed 32-bit integer from the socket.
		@return A value from -2147483648 to 2147483647.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readInt():Int
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readInt();
	}

	/**
		Reads a multibyte string from the byte stream, using the specified
		character set.
		@param length  The number of bytes from the byte stream to read.
		@param charSet The string denoting the character set to use to
					   interpret the bytes. Possible character set strings
					   include `"shift_jis"`, `"CN-GB"`, and `"iso-8859-1"`.
					   For a complete list, see <a
					   href="../../charset-codes.html">Supported Character
					   Sets</a>.
					   **Note:** If the value for the `charSet` parameter is
					   not recognized by the current system, then the
					   application uses the system's default code page as the
					   character set. For example, a value for the `charSet`
					   parameter, as in `myTest.readMultiByte(22,
					   "iso-8859-01")` that uses `01` instead of `1` might
					   work on your development machine, but not on another
					   machine. On the other machine, the application will use
					   the system's default code page.
		@return A UTF-8 encoded string.
		@throws EOFError There is insufficient data available to read.
	**/
	override public function readMultiByte(length:Int, charSet:String):String
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readMultiByte(length, charSet);
	}

	/**
		Reads an object from the socket, encoded in AMF serialized format.
		@return The deserialized object
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readObject():Dynamic
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

	/**
		Reads a signed 16-bit integer from the socket.
		@return A value from -32768 to 32767.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readShort():Int
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readShort();
	}

	/**
		Reads an unsigned byte from the socket.
		@return A value from 0 to 255.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readUnsignedByte():Int
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}
		return __input.readUnsignedByte();
	}

	/**
		Reads an unsigned 32-bit integer from the socket.
		@return A value from 0 to 4294967295.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readUnsignedInt():Int
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readUnsignedInt();
	}

	/**
		Reads an unsigned 16-bit integer from the socket.
		@return A value from 0 to 65535.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readUnsignedShort():Int
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readUnsignedShort();
	}

	/**
		Reads a UTF-8 string from the socket. The string is assumed to be
		prefixed with an unsigned short integer that indicates the length in
		bytes.
		@return A UTF-8 string.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readUTF():String
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readUTF();
	}

	/**
		Reads the number of UTF-8 data bytes specified by the `length`
		parameter from the socket, and returns a string.
		@param length The number of bytes to read.
		@return A UTF-8 string.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	override public function readUTFBytes(length:Int):String
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		return __input.readUTFBytes(length);
	}

	/**
		Writes a Boolean value to the socket. This method writes a single
		byte, with either a value of 1 (`true`) or 0 (`false`).
		@param value The value to write to the socket: 1 (`true`) or 0
					 (`false`).
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override function writeBoolean(value:Bool):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeBoolean(value);
	}

	/**
		Writes a byte to the socket.
		@param value The value to write to the socket. The low 8 bits of the
					 value are used; the high 24 bits are ignored.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeByte(value:Int):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeByte(value);
	}

	/**
		Writes a sequence of bytes from the specified byte array. The write
		operation starts at the position specified by `offset`.
		If you omit the `length` parameter the default length of 0 causes the
		method to write the entire buffer starting at `offset`.
		If you also omit the `offset` parameter, the entire buffer is written.
		@param bytes  The ByteArray object to write data from.
		@param offset The zero-based offset into the `bytes` ByteArray object
					  at which data writing should begin.
		@param length The number of bytes to write. The default value of 0
					  causes the entire buffer to be written, starting at the
					  value specified by the `offset` parameter.
		@throws IOError    An I/O error occurred on the socket, or the socket
						   is not open.
		@throws RangeError If `offset` is greater than the length of the
						   ByteArray specified in `bytes` or if the amount of
						   data specified to be written by `offset` plus
						   `length` exceeds the data available.
	**/
	override public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeBytes(bytes, offset, length);
	}

	/**
		Writes an IEEE 754 double-precision floating-point number to the
		socket.
		@param value The value to write to the socket.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeDouble(value:Float):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeDouble(value);
	}

	/**
		Writes an IEEE 754 single-precision floating-point number to the
		socket.
		@param value The value to write to the socket.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeFloat(value:Float):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeFloat(value);
	}

	/**
		Writes a 32-bit signed integer to the socket.
		@param value The value to write to the socket.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeInt(value:Int):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeInt(value);
	}

	/**
		Writes a multibyte string from the byte stream, using the specified
		character set.
		@param value   The string value to be written.
		@param charSet The string denoting the character set to use to
					   interpret the bytes. Possible character set strings
					   include `"shift_jis"`, `"CN-GB"`, and `"iso-8859-1"`.
					   For a complete list, see <a
					   href="../../charset-codes.html">Supported Character
					   Sets</a>.
	**/
	override public function writeMultiByte(value:String, charSet:String):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeUTFBytes(value);
	}

	/**
		Write an object to the socket in AMF serialized format.
		@param object The object to be serialized.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeObject(object:Dynamic):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		if (objectEncoding == HXSF)
		{
			__output.writeUTF(Serializer.run(object));
		}
		else
		{
			// TODO: Add support for AMF if haxelib "format" is included
		}
	}

	/**
		Writes a 16-bit integer to the socket. The bytes written are as
		follows:
		```
		(v >> 8) & 0xff v & 0xff
		```
		The low 16 bits of the parameter are used; the high 16 bits are
		ignored.
		@param value The value to write to the socket.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeShort(value:Int):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeShort(value);
	}

	/**
		Writes a 32-bit unsigned integer to the socket.
		@param value The value to write to the socket.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeUnsignedInt(value:Int):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeUnsignedInt(value);
	}

	/**
		Writes the following data to the socket: a 16-bit unsigned integer,
		which indicates the length of the specified UTF-8 string in bytes,
		followed by the string itself.
		Before writing the string, the method calculates the number of bytes
		that are needed to represent all characters of the string.
		@param value The string to write to the socket.
		@throws IOError    An I/O error occurred on the socket, or the socket
						   is not open.
		@throws RangeError The length is larger than 65535.
	**/
	override public function writeUTF(value:String):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeUTF(value);
	}

	/**
		Writes a UTF-8 string to the socket.
		@param value The string to write to the socket.
		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	override public function writeUTFBytes(value:String):Void
	{
		if (__webSocket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeUTFBytes(value);
	}

	@:noCompletion override private function __cleanSocket():Void
	{
		try
		{
			__webSocket.close();
		}
		catch (e:Dynamic) {}

		__webSocket = null;
		__connected = false;
	}

	@:noCompletion override private function socket_onMessage(msg:Dynamic):Void
	{
		if (__input.position == __input.length)
		{
			__input.clear();
		}

		/*if ((msg.data is String))
			{
				__input.position = __input.length;
				var cachePosition = __input.position;
				__input.writeUTFBytes(msg.data);
				__input.position = cachePosition;
			}
			else
			{ */
		var newData:ByteArray = msg.data;
		newData.readBytes(__input, __input.length);
		// }

		if (__input.bytesAvailable > 0)
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, __input.bytesAvailable, 0));
		}
	}

	@:noCompletion override private function socket_onOpen(_):Void
	{
		__connected = true;
		dispatchEvent(new Event(Event.CONNECT));

		if (__server != null)
		{
			__server.dispatchEvent(new ServerSocketConnectEvent(ServerSocketConnectEvent.CONNECT, this));
			__server = null;
		}
	}

	private function __init():Void
	{
		__output = new ByteArray();
		__output.endian = __endian;

		__input = new ByteArray();
		__input.endian = __endian;

		__webSocket.binaryType = "arraybuffer";
		__webSocket.onopen = socket_onOpen;
		__webSocket.onmessage = socket_onMessage;
		__webSocket.onclose = socket_onClose;
		__webSocket.onerror = socket_onError;
	}
}
