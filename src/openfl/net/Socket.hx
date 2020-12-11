package openfl.net;

#if !flash
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Eof;
import haxe.io.Error;
import haxe.Serializer;
import haxe.Timer;
import haxe.Unserializer;
import openfl.utils._internal.Lib;
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
#if (js && html5)
#if haxe4
import js.lib.ArrayBuffer;
#else
import js.html.ArrayBuffer;
#end
import js.html.WebSocket;
import js.Browser;
#end
#if sys
import sys.net.Host;
import sys.net.Socket as SysSocket;
#end

/**
	The Socket class enables code to establish Transport Control Protocol
	(TCP) socket connections for sending and receiving binary data.
	The Socket class is useful for working with servers that use binary
	protocols.

	To use the methods of the Socket class, first use the constructor, `new
	Socket`, to create a Socket object.

	A socket transmits and receives data asynchronously.

	On some operating systems, flush() is called automatically between
	execution frames, but on other operating systems, such as Windows, the
	data is never sent unless you call `flush()` explicitly. To ensure your
	application behaves reliably across all operating systems, it is a good
	practice to call the `flush()` method after writing each message (or
	related group of data) to the socket.

	In Adobe AIR, Socket objects are also created when a listening
	ServerSocket receives a connection from an external process. The Socket
	representing the connection is dispatched in a ServerSocketConnectEvent.
	Your application is responsible for maintaining a reference to this Socket
	object. If you don't, the Socket object is eligible for garbage collection
	and may be destroyed by the runtime without warning.

	SWF content running in the local-with-filesystem security sandbox cannot
	use sockets.

	_Socket policy files_ on the target host specify the hosts from which SWF
	files can make socket connections, and the ports to which those
	connections can be made. The security requirements with regard to socket
	policy files have become more stringent in the last several releases of
	Flash Player. In all versions of Flash Player, Adobe recommends the use of
	a socket policy file; in some circumstances, a socket policy file is
	required. Therefore, if you are using Socket objects, make sure that the
	target host provides a socket policy file if necessary.

	The following list summarizes the requirements for socket policy files in
	different versions of Flash Player:

	*  In Flash Player 9.0.124.0 and later, a socket policy file is required
	for any socket connection. That is, a socket policy file on the target
	host is required no matter what port you are connecting to, and is
	required even if you are connecting to a port on the same host that is
	serving the SWF file.
	*  In Flash Player versions 9.0.115.0 and earlier, if you want to connect
	to a port number below 1024, or if you want to connect to a host other
	than the one serving the SWF file, a socket policy file on the target host
	is required.
	*  In Flash Player 9.0.115.0, even if a socket policy file isn't required,
	a warning is displayed when using the Flash Debug Player if the target
	host doesn't serve a socket policy file.
	* In AIR, a socket policy file is not required for content running in the
	application security sandbox. Socket policy files are required for any
	socket connection established by content running outside the AIR
	application security sandbox.

	For more information related to security, see the Flash Player Developer
	Center Topic: <a href="http://www.adobe.com/go/devnet_security_en"
	scope="external">Security</a>

	@event close         Dispatched when the server closes the socket
						 connection.
						 The `close` event is dispatched only when the server
						 closes the connection; it is not dispatched when you
						 call the `Socket.close()` method.
	@event connect       Dispatched when a network connection has been
						 established.
	@event ioError       Dispatched when an input/output error occurs that
						 causes a send or load operation to fail.
	@event securityError Dispatched if a call to `Socket.connect()` attempts
						 to connect to a server prohibited by the caller's
						 security sandbox or to a port lower than 1024 and no
						 socket policy file exists to permit such a
						 connection.
						 **Note:** In an AIR application, content running in
						 the application security sandbox is permitted to
						 connect to any server and port number without a
						 socket policy file.
	@event socketData    Dispatched when a socket has received data.
						 The data received by the socket remains in the socket
						 until it is read. You do not have to read all the
						 available data during the handler for this event.

						 Events of type `socketData` do not use the
						 `ProgressEvent.bytesTotal` property.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Socket extends EventDispatcher implements IDataInput implements IDataOutput
{
	/**
		The number of bytes of data available for reading in the input buffer.

		Your code must access `bytesAvailable` to ensure that sufficient data
		is available before trying to read it with one of the `read` methods.
	**/
	public var bytesAvailable(get, never):Int;

	/**
		Indicates the number of bytes remaining in the write buffer.

		Use this property in combination with with the OutputProgressEvent. An
		OutputProgressEvent is thrown whenever data is written from the write buffer to
		the network. In the event handler, you can check bytesPending to see how much data
		is still left in the buffer waiting to be written. When bytesPending returns 0, it
		means that all the data has been transferred from the write buffer to the network,
		and it is safe to do things like remove event handlers, null out socket
		references, start the next upload in a queue, etc.
	**/
	public var bytesPending(get, never):Int;

	/**
		Indicates whether this Socket object is currently connected. A call to
		this property returns a value of `true` if the socket is currently
		connected, or `false` otherwise.
	**/
	public var connected(get, never):Bool;

	/**
		Indicates the byte order for the data. Possible values are constants
		from the openfl.utils.Endian class, `Endian.BIG_ENDIAN` or
		`Endian.LITTLE_ENDIAN`.

		@default Endian.BIG_ENDIAN
	**/
	public var endian(get, set):Endian;

	/**
		Controls the version of AMF used when writing or reading an object.
	**/
	public var objectEncoding:ObjectEncoding;

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:noCompletion @:dox(hide) public var secure:Bool;

	/**
		Indicates the number of milliseconds to wait for a connection.
		If the connection doesn't succeed within the specified time, the
		connection fails. The default value is 20,000 (twenty seconds).
	**/
	public var timeout:Int;

	@:noCompletion private var __buffer:Bytes;
	@:noCompletion private var __connected:Bool;
	@:noCompletion private var __endian:Endian;
	@:noCompletion private var __host:String;
	@:noCompletion private var __input:ByteArray;
	@:noCompletion private var __output:ByteArray;
	@:noCompletion private var __port:Int;
	@:noCompletion private var __socket:#if sys SysSocket #else Dynamic #end;
	@:noCompletion private var __timestamp:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Socket.prototype, {
			"bytesAvailable": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bytesAvailable (); }")},
			"bytesPending": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bytesPending (); }")},
			"connected": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_connected (); }")},
			"endian": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_endian (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_endian (v); }")
			},
		});
	}
	#end

	/**
		Creates a new Socket object. If no parameters are specified, an
		initially disconnected socket is created. If parameters are specified,
		a connection is attempted to the specified host and port.
		**Note:** It is strongly advised to use the constructor form **without
		parameters**, then add any event listeners, then call the `connect`
		method with `host` and `port` parameters. This sequence guarantees
		that all event listeners will work properly.

		@param host A fully qualified DNS domain name or an IP address. IPv4
					addresses are specified in dot-decimal notation, such as
					_192.0.2.0_. In Flash Player 9.0.115.0 and AIR 1.0 and
					later, you can specify IPv6 addresses using
					hexadecimal-colon notation, such as
					_2001:db8:ccc3:ffff:0:444d:555e:666f_. You can also
					specify `null` to connect to the host server on which the
					SWF file resides. If the SWF file issuing this call is
					running in a web browser, `host` must be in the domain
					from which the SWF file originated.
		@param port The TCP port number on the target host used to establish a
					connection. In Flash Player 9.0.124.0 and later, the
					target host must serve a socket policy file specifying
					that socket connections are permitted from the host
					serving the SWF file to the specified port. In earlier
					versions of Flash Player, a socket policy file is required
					only if you want to connect to a port number below 1024,
					or if you want to connect to a host other than the one
					serving the SWF file.
		@throws SecurityError This error occurs in SWF content for the
							  following reasons:
							  * Local-with-filesystem files cannot communicate
							  with the Internet. You can work around this
							  problem by reclassifying this SWF file as
							  local-with-networking or trusted. This
							  limitation is not set for AIR application
							  content in the application security sandbox.
							  * You cannot specify a socket port higher than
							  65535.
		@event connect       Dispatched when a network connection has been
							 established.
		@event ioError       Dispatched when an input/output error occurs that
							 causes the connection to fail.
		@event securityError Dispatched if a call to `Socket.connect()`
							 attempts to connect either to a server that
							 doesn't serve a socket policy file, or to a
							 server whose policy file doesn't grant the
							 calling host access to the specified port. For
							 more information on policy files, see "Website
							 controls (policy files)" in the _ActionScript 3.0
							 Developer's Guide_ and the Flash Player Developer
							 Center Topic: <a
							 href="http://www.adobe.com/go/devnet_security_en"
							 scope="external">Security</a>.
	**/
	public function new(host:String = null, port:Int = 0)
	{
		super();

		endian = Endian.BIG_ENDIAN;
		timeout = 20000;

		__buffer = Bytes.alloc(4096);

		if (port > 0 && port < 65535)
		{
			connect(host, port);
		}
	}

	/**
		Closes the socket. You cannot read or write any data after the
		`close()` method has been called.
		The `close` event is dispatched only when the server closes the
		connection; it is not dispatched when you call the `close()` method.

		You can reuse the Socket object by calling the `connect()` method on
		it again.

		@throws IOError The socket could not be closed, or the socket was not
						open.
	**/
	public function close():Void
	{
		if (__socket != null)
		{
			__cleanSocket();
		}
		else
		{
			throw new IOError("Operation attempted on invalid socket.");
		}
	}

	/**
		Connects the socket to the specified host and port.
		If the connection fails immediately, either an event is dispatched or
		an exception is thrown: an error event is dispatched if a host was
		specified, and an exception is thrown if no host was specified.
		Otherwise, the status of the connection is reported by an event. If
		the socket is already connected, the existing connection is closed
		first.

		@param host The name or IP address of the host to connect to. If no
					host is specified, the host that is contacted is the host
					where the calling file resides. If you do not specify a
					host, use an event listener to determine whether the
					connection was successful.
		@param port The port number to connect to.
		@throws IOError       No host was specified and the connection failed.
		@throws SecurityError This error occurs in SWF content for the
							  following reasons:
							  * Local untrusted SWF files may not communicate
							  with the Internet. You can work around this
							  limitation by reclassifying the file as
							  local-with-networking or as trusted.
							  * You cannot specify a socket port higher than
							  65535.
							  * In the HTML page that contains the SWF
							  content, the `allowNetworking` parameter of the
							  `object` and `embed` tags is set to `"none"`.
		@event connect       Dispatched when a network connection has been
							 established.
		@event ioError       Dispatched if a host is specified and an
							 input/output error occurs that causes the
							 connection to fail.
		@event securityError Dispatched if a call to `Socket.connect()`
							 attempts to connect either to a server that
							 doesn't serve a socket policy file, or to a
							 server whose policy file doesn't grant the
							 calling host access to the specified port. For
							 more information on policy files, see "Website
							 controls (policy files)" in the _ActionScript 3.0
							 Developer's Guide_ and the Flash Player Developer
							 Center Topic: <a
							 href="http://www.adobe.com/go/devnet_security_en"
							 scope="external">Security</a>.
	**/
	public function connect(host:String = null, port:Int = 0):Void
	{
		if (__socket != null)
		{
			close();
		}

		if (port < 0 || port > 65535)
		{
			throw new SecurityError("Invalid socket port number specified.");
		}

		#if (js && html5)
		__timestamp = Timer.stamp();
		#else
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

		__timestamp = Sys.time();
		#end

		__host = host;
		__port = port;

		__output = new ByteArray();
		__output.endian = __endian;

		__input = new ByteArray();
		__input.endian = __endian;

		#if (js && html5)
		if (Browser.location.protocol == "https:")
		{
			secure = true;
		}

		var schema = secure ? "wss" : "ws";
		var urlReg = ~/^(.*:\/\/)?([A-Za-z0-9\-\.]+)\/?(.*)/g;
		urlReg.match(host);
		var __webHost = urlReg.matched(2);
		var __webPath = urlReg.matched(3);

		__socket = new WebSocket(schema + "://" + __webHost + ":" + port + "/" + __webPath);
		__socket.binaryType = "arraybuffer";
		__socket.onopen = socket_onOpen;
		__socket.onmessage = socket_onMessage;
		__socket.onclose = socket_onClose;
		__socket.onerror = socket_onError;
		#else
		__socket = new SysSocket();

		try
		{
			__socket.setBlocking(false);
			__socket.connect(h, port);
			__socket.setFastSend(true);
		}
		catch (e:Dynamic) {}
		#end

		Lib.current.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	/**
		Flushes any accumulated data in the socket's output buffer.
		On some operating systems, flush() is called automatically between
		execution frames, but on other operating systems, such as Windows, the
		data is never sent unless you call `flush()` explicitly. To ensure
		your application behaves reliably across all operating systems, it is
		a good practice to call the `flush()` method after writing each
		message (or related group of data) to the socket.

		@throws IOError An I/O error occurred on the socket, or the socket is
						not open.
	**/
	public function flush():Void
	{
		if (__socket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		if (__output.length > 0)
		{
			try
			{
				#if (js && html5)
				var buffer:ArrayBuffer = __output;
				if (buffer.byteLength > __output.length) buffer = buffer.slice(0, __output.length);
				__socket.send(buffer);
				#else
				__socket.output.writeBytes(__output, 0, __output.length);
				#end
				__output = new ByteArray();
				__output.endian = __endian;
			}
			catch (e:Dynamic)
			{
				throw new IOError("Operation attempted on invalid socket.");
			}
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
	public function readBoolean():Bool
	{
		if (__socket == null)
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
	public function readByte():Int
	{
		if (__socket == null)
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
	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (__socket == null)
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
	public function readDouble():Float
	{
		if (__socket == null)
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
	public function readFloat():Float
	{
		if (__socket == null)
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
	public function readInt():Int
	{
		if (__socket == null)
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
	public function readMultiByte(length:Int, charSet:String):String
	{
		if (__socket == null)
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

	/**
		Reads a signed 16-bit integer from the socket.

		@return A value from -32768 to 32767.
		@throws EOFError There is insufficient data available to read.
		@throws IOError  An I/O error occurred on the socket, or the socket is
						 not open.
	**/
	public function readShort():Int
	{
		if (__socket == null)
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
	public function readUnsignedByte():Int
	{
		if (__socket == null)
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
	public function readUnsignedInt():Int
	{
		if (__socket == null)
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
	public function readUnsignedShort():Int
	{
		if (__socket == null)
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
	public function readUTF():String
	{
		if (__socket == null)
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
	public function readUTFBytes(length:Int):String
	{
		if (__socket == null)
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
	public function writeBoolean(value:Bool):Void
	{
		if (__socket == null)
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
	public function writeByte(value:Int):Void
	{
		if (__socket == null)
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
	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (__socket == null)
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
	public function writeDouble(value:Float):Void
	{
		if (__socket == null)
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
	public function writeFloat(value:Float):Void
	{
		if (__socket == null)
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
	public function writeInt(value:Int):Void
	{
		if (__socket == null)
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
	public function writeMultiByte(value:String, charSet:String):Void
	{
		if (__socket == null)
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
	public function writeObject(object:Dynamic):Void
	{
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
	public function writeShort(value:Int):Void
	{
		if (__socket == null)
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
	public function writeUnsignedInt(value:Int):Void
	{
		if (__socket == null)
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
	public function writeUTF(value:String):Void
	{
		if (__socket == null)
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
	public function writeUTFBytes(value:String):Void
	{
		if (__socket == null)
		{
			throw new IOError("Operation attempted on invalid socket.");
		}

		__output.writeUTFBytes(value);
	}

	@:noCompletion private function __cleanSocket():Void
	{
		try
		{
			__socket.close();
		}
		catch (e:Dynamic) {}

		__socket = null;
		__connected = false;
		Lib.current.removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	// Event Handlers
	@:noCompletion private function socket_onClose(_):Void
	{
		dispatchEvent(new Event(Event.CLOSE));
	}

	@:noCompletion private function socket_onError(e):Void
	{
		dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
	}

	@:noCompletion private function socket_onMessage(msg:Dynamic):Void
	{
		#if (js && html5)
		if (__input.position == __input.length)
		{
			__input.clear();
		}

		if ((msg.data is String))
		{
			__input.position = __input.length;
			var cachePosition = __input.position;
			__input.writeUTFBytes(msg.data);
			__input.position = cachePosition;
		}
		else
		{
			var newData:ByteArray = (msg.data : ArrayBuffer);
			newData.readBytes(__input, __input.length);
		}

		if (__input.bytesAvailable > 0)
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, __input.bytesAvailable, 0));
		}
		#end
	}

	@:noCompletion private function socket_onOpen(_):Void
	{
		__connected = true;
		dispatchEvent(new Event(Event.CONNECT));
	}

	@:noCompletion private function this_onEnterFrame(event:Event):Void
	{
		#if (js && html5)
		if (__socket != null)
		{
			flush();
		}
		#else
		var doConnect = false;
		var doClose = false;

		if (!connected)
		{
			var r = SysSocket.select(null, [__socket], null, 0);

			if (r.write[0] == __socket)
			{
				doConnect = true;
			}
			else if (Sys.time() - __timestamp > timeout / 1000)
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
					l = __socket.input.readBytes(__buffer, 0, __buffer.length);

					if (l > 0)
					{
						b.addBytes(__buffer, 0, l);
						bLength += l;
					}
				}
				while (l == __buffer.length);
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
			__cleanSocket();

			dispatchEvent(new Event(Event.CLOSE));
		}
		else if (doClose)
		{
			__cleanSocket();

			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, "Connection failed"));
		}
		else if (doConnect)
		{
			__connected = true;
			dispatchEvent(new Event(Event.CONNECT));
		}

		if (bLength > 0)
		{
			var newData = b.getBytes();

			var rl = __input.length - __input.position;
			if (rl < 0) rl = 0;

			var newInput = Bytes.alloc(rl + newData.length);
			if (rl > 0) newInput.blit(0, __input, __input.position, rl);
			newInput.blit(rl, newData, 0, newData.length);
			__input = newInput;
			__input.endian = __endian;

			dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, newData.length, 0));
		}

		if (__socket != null)
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
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_bytesAvailable():Int
	{
		return __input.bytesAvailable;
	}

	@:noCompletion private function get_bytesPending():Int
	{
		return __output.length;
	}

	@:noCompletion private function get_connected():Bool
	{
		return __connected;
	}

	@:noCompletion private function get_endian():Endian
	{
		return __endian;
	}

	@:noCompletion private function set_endian(value:Endian):Endian
	{
		__endian = value;

		if (__input != null) __input.endian = value;
		if (__output != null) __output.endian = value;

		return __endian;
	}
}
#else
typedef Socket = flash.net.Socket;
#end
