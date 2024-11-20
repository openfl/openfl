package openfl.net._internal.websocket;

#if sys
import haxe.crypto.Md5;
import haxe.Int64;
import openfl.display.Stage;
import openfl.utils.Function;
import openfl.Lib;
import openfl.events.Event;
import openfl.utils.ByteArray;
import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.ds.StringMap;
import haxe.io.Bytes;
import haxe.io.Error;
import haxe.io.Output;

/**
 * Internal Websocket implementation based on RFC4648 Specification.
 */
class WebSocket
{
	public static inline var CLOSED:Int = 3;
	public static inline var CLOSING:Int = 2;
	public static inline var CONNECTING:Int = 0;
	public static inline var OPEN:Int = 1;

	// Max payload size in bytes
	public static var MAX_PAYLOAD:Int = 65536;

	/*Websocket RFC4648 specification suggests that each message frame should have
		a 4 bit mask that is randomly generated. Due to the overhead of generating
		strong random numbers, we implement a pool to preallocate masks.

		The default value is 0, which disables mask pooling.
	 */
	public static var MASK_POOL_SIZE:Int = 0;

	// The default ping interval. Set to 0 to disable pings.
	public static var PING_INTERVAL:Int = 60000;

	private static var __maskTable:StringMap<Int> = new StringMap();
	private static var __maskPool:Array<ByteArray> = __constructMaskPool();

	private static inline var WS:String = "ws";
	private static inline var WSS:String = "wss";

	private static inline var CRLF:String = "\r\n";
	private static inline var CRLFCRLF:String = "\r\n\r\n";
	private static inline var GET:String = "GET";
	private static inline var HTTP:String = "HTTP";

	public var binaryType:BinaryType = ARRAYBUFFER;
	public var bufferdAmount(default, null):Int = 0;
	public var extensions(default, null):String = "";
	public var onclose:Function = (e:WebsocketEvent) -> {};
	public var onerror:Function = (e:WebsocketEvent) -> {};
	public var onmessage:Function = (e:WebsocketEvent) -> {};
	public var onopen:Function = (e:WebsocketEvent) -> {};
	public var protocol(default, null):String;
	public var readyState(default, null):Int = CONNECTING;
	public var url(default, null):String;

	private var __socket:FlexSocket;
	private var __buffer:Bytes;

	private var __inputPosition:Int = 0;
	private var __input:ByteArray;
	private var __incomingMessageBuffer:ByteArray;
	private var __output:ByteArray;
	private var __connected:Bool = false;
	private var __timestamp:Float;
	private var __timeout:Int = 10000;

	private var __origin:String;
	private var __protocols:Array<String> = [];
	private var __secure:Bool;
	private var __path:String;
	private var __scheme:String;
	private var __host:String;
	private var __port:Int;
	private var __key:String;

	private var __handshakeBuffer:String = "";

	private var __mask:ByteArray;
	private var __maskedPayload:ByteArray;
	private var __outgoingMessageBuffer:ByteArray;

	private var __heartbeatDelay:Int = 0;
	private var __hasTimeoutPotential:Bool = false;
	private var __heartbeatID:UInt = 0;

	private var __isClient:Null<Bool>;

	public function new(url:String, ?protocols:Array<String>, ?origin:String)
	{
		__key = Base64.encode(getRandomBytes(16));

		__mask = __getMask();

		if (__isClient == null)
		{
			this.url = url;
			// benchmark the two for the fastest regular expression
			// var regex:EReg = ~/^(\w+):\/\/([^\/:]+)(?::(\d+))?([^#]*)(?:#.*)?$/;

			var regex:EReg = ~/^(\w+):\/\/([^:\/]+)(?::(\d+))?\/?(.*)$/;

			if (regex.match(url))
			{
				// the URI is well-formed
				__scheme = regex.matched(1);
				__host = regex.matched(2);
				var port:Null<Int> = Std.parseInt(regex.matched(3));
				__port = port == null ? (__secure ? 443 : 80) : port;
				var path:Null<String> = regex.matched(4);
				__path = path == "" ? "/" : path;
			}
			else
			{
				throw "Uri is not a well-formed";
			}
			if (__scheme == WSS)
			{
				__secure = true;
			}
			else if (__scheme == WS)
			{
				__secure = false;
			}
			else
			{
				throw "Uri does not include a valid Web Socket Scheme";
			}

			if (protocols != null)
			{
				__protocols = protocols.copy();
			}

			if (origin == null)
			{
				origin = "http://127.0.0.1/";
			}
			__initSocket();
		}
		else
		{
			__heartbeatDelay = PING_INTERVAL;
		}
	}

	private function __initSocket(?socket:FlexSocket):Void
	{
		__buffer = Bytes.alloc(4096);
		__input = new ByteArray();
		__input.endian = BIG_ENDIAN;
		__output = new ByteArray();
		__output.endian = BIG_ENDIAN;

		__incomingMessageBuffer = new ByteArray();
		__incomingMessageBuffer.endian = BIG_ENDIAN;

		__outgoingMessageBuffer = new ByteArray();
		__outgoingMessageBuffer.endian = BIG_ENDIAN;

		__maskedPayload = new ByteArray();
		__maskedPayload.endian = BIG_ENDIAN;

		__timestamp = Sys.time();

		if (socket == null)
		{
			__socket = new FlexSocket(__secure);
			if (__secure)
			{
				__socket.verifyCert = false;
			}
			__socket.output.bigEndian = true;
			__connect();
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, __onTickConnect);
		}
		else
		{
			__socket = socket;
			__openConnection(null);
		}
	}

	private function __connect():Void
	{
		try
		{
			__socket.setBlocking(false);
			__socket.setFastSend(true);
			__socket.connect(__host, __port);
		}
		catch (e:Dynamic) {}
	}

	private function __onTickConnect(e:Event):Void
	{
		if (!__connected)
		{
			var sockets:Dynamic = FlexSocket.select(null, [__socket], null, 0);

			if (sockets.write[0] == __socket)
			{
				__onConnect();
			}
			else if (Sys.time() - __timestamp > __timeout / 1000)
			{
				__close(1006);
				__onError("Failed to connect to server");
			}
		}
	}

	private function __onTickProcess(e:Event):Void
	{
		var hasData:Bool = false;
		var doClose:Bool = false;
		var currentBytes:Int = 0;
		var totalBytes:Int = 0;
		__input.position = __input.length;
		while (__connected)
		{
			try
			{
				var nBytes:Int = __socket.input.readBytes(__buffer, currentBytes, 1024);
				currentBytes += nBytes;
				totalBytes += nBytes;

				if (currentBytes > 3072)
				{
					__input.writeBytes(__buffer, 0, currentBytes);
					currentBytes = 0;
				}
				/*	else if (totalBytes < 1024) {
					__input.writeBytes(__buffer, 0, currentBytes);
					__input.position = 0;

					hasData = true;
					break;
				}*/
			}
			catch (e:Error)
			{
				if (totalBytes > 0)
				{
					if (currentBytes > 0)
					{
						__input.writeBytes(__buffer, 0, currentBytes);
					}

					hasData = true;
				}
				if (e != Error.Blocked #if HXCPP_DEBUGGER && !e.match(Error.Custom(Blocked)) #end)
				{
					if (e.match(Error.Custom("ssl network error")))
					{
						// break;
					}
					doClose = true;
				}
				break;
			}
			catch (e:Dynamic)
			{
				// trace("Error Reason:", e);
				doClose = true;
				break;
			}
		}

		if (hasData)
		{
			__input.position = __inputPosition;
			__onData();
		}
		else if (doClose)
		{
			// trace('closed from remote host');
			__close(1006);
		}
	}

	private function __doHandshake():Void
	{
		var handshakeBytes:Bytes = Bytes.ofString([
			'GET ${url} HTTP/1.1',
			'Host: ${__host}:${__port}',
			'Pragma: no-cache',
			'Cache-Control: no-cache',
			'Upgrade: websocket',
			__protocols != null ? 'Sec-WebSocket-Protocol: ' + __protocols.join(', ') : '',
			'Sec-WebSocket-Version: 13',
			'Connection: Upgrade',
			"Sec-WebSocket-Key: " + __key,
			'Origin: ${__origin}',
			'User-Agent: Mozilla/5.0'
		].join(CRLF) + CRLFCRLF);

		__writeBytes(handshakeBytes);
	}

	private function __writeBytes(bytes:Bytes)
	{
		try
		{
			__socket.output.writeBytes(bytes, 0, bytes.length);
			__socket.output.flush();
		}
		catch (e)
		{
			// trace(e);
		}
	}

	private function __handleControlFrame(opcode:WebSocketOpcode):Void
	{
		switch (opcode)
		{
			case PING:
				__pong();
			case PONG:
				__hasTimeoutPotential = false;
			case CLOSE:
				__close(1000);
		}
	}

	private function __onData():Void
	{
		// trace("/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\", __input.length, __input.position, __input.bytesAvailable, __inputPosition);
		if (readyState == OPEN)
		{
			while (__input.bytesAvailable > 0)
			{
				// try {
				// keep track of our header bytes
				// maybe we can rewind our buffer position based on a some different method like comparing start position
				if (__input.bytesAvailable < 2)
				{
					break;
				}

				var lengthBytes:Int = 0;
				// Parse the first byte
				var firstByte:Int = __input.readUnsignedByte();
				var isFinal:Bool = (firstByte & 0x80) != 0;
				var opCode:Int = firstByte & 0x0F;
				lengthBytes = 1;
				// Parse the second byte
				var secondByte:Int = __input.readUnsignedByte();
				var isMasked:Bool = (secondByte & 0x80) != 0;
				var payloadLength:UInt = secondByte & 0x7F;
				lengthBytes = 2;

				if (opCode > 0x02)
				{
					__handleControlFrame(opCode);
					__validateInputPosition();
					break;
				}

				// Parse extended payload length if necessary
				if (payloadLength == 126)
				{
					if (__input.bytesAvailable < 2)
					{
						__input.position -= lengthBytes;
						break;
					}
					lengthBytes = 4;
					payloadLength = __input.readUnsignedShort();
				}
				else if (payloadLength == 127)
				{
					if (__input.bytesAvailable < 8)
					{
						__input.position -= lengthBytes;
						break;
					}
					lengthBytes = 10;

					// TODO:Implement 64 bit read and write to ByteArray
					var high:Int = 0;
					var low:Int = 0;

					if (__input.endian == LITTLE_ENDIAN)
					{
						low = __input.readUnsignedInt();
						high = __input.readUnsignedInt();
					}
					else
					{
						high = __input.readUnsignedInt();
						low = __input.readUnsignedInt();
					}

					var i64Val:Int64 = Int64.make(high, low);

					// var i64Val:Int64 = __input.readInt64();
					payloadLength = Int64.toInt(i64Val);
				}

				if (payloadLength > __input.bytesAvailable)
				{
					// If our frame is incomplete, we rewind the buffer position so the rest of
					// it can be written in order.				d
					__input.position -= lengthBytes;
					break;
				}

				// Parse masking key if necessary
				var maskingKey:ByteArray = new ByteArray(4);
				if (isMasked)
				{
					__input.readBytes(maskingKey, 0, 4);
				}

				// Parse the payload
				if (__incomingMessageBuffer.length == 0)
				{
					__incomingMessageBuffer.length = payloadLength;
					// var frameBytes:ByteArray = new ByteArray(PayloadLength)?
				}

				// if (payloadLength > 0) {
				__input.readBytes(__incomingMessageBuffer, __incomingMessageBuffer.position, payloadLength);
				if (isMasked)
				{
					for (i in 0...payloadLength)
					{
						// Is the arrayaccess slower than manually positioning and calling readByte()?
						// we can avoid using the position as an offset by adding an addition buffer potentially having less
						// overhead.
						// frameBytes[i] ^= maskingKey[i & 0x03];
						__incomingMessageBuffer[i + __incomingMessageBuffer.position] ^= maskingKey[i & 0x03]; // use bitwise AND instead of modulo
					}
				}
				// handle some error?
				// }

				if (isFinal)
				{
					var messageEvent:WebsocketEvent = new WebsocketEvent(WebsocketEvent.MESSAGE, this, __incomingMessageBuffer);
					onmessage(messageEvent);
					__incomingMessageBuffer.clear();

					__validateInputPosition();
				}
				// }
				// catch (e:Error)
				// {
				// Handle errors here
				// TODO: some kind of error handling here
				//	trace('error');
				// }
			}
		}
		else if (readyState == CONNECTING)
		{
			var headerData:String = __input.readUTFBytes(__input.length);
			var endIndex:Int = headerData.lastIndexOf(CRLFCRLF);
			var headerLength = endIndex + 4;
			if (endIndex > -1)
			{
				// received entire header
				if (__handshakeBuffer.length > 0)
				{
					headerData = __handshakeBuffer + headerData;
					__handshakeBuffer = "";
				}
				var lines:Array<String> = headerData.split(CRLF);
				var headers:StringMap<String>;

				if (lines[0].indexOf(GET) == 0)
				{
					headers = __parseHeaders(lines);
					var response:Bytes = __generateResponseHandshake(headers);
					__writeBytes(response);

					readyState = OPEN;
					onopen(new WebsocketEvent(WebsocketEvent.OPEN, this));
				}
				else if (lines[0].indexOf("HTTP") == 0)
				{
					headers = __parseHeaders(lines);
					if (lines[0].indexOf("101") > -1)
					{
						headers.set("Status", "101");
					}
					else
					{
						__close(1002);
					}

					if (__validateResponseHandshake(headers))
					{
						// handshake complete, is ready
						readyState = OPEN;
						onopen(new WebsocketEvent(WebsocketEvent.OPEN, this));

						if (__input.length > headerLength)
						{
							__input.position = headerLength;
							__onData();
						}

						if (__heartbeatDelay > 0)
						{
							__initHeartbeat();
						}

						__validateInputPosition();
					}
					else
					{
						__close(1002);
					}
				}

				// is it the client handshake or server response?
			}
			else
			{
				// received partial header, buffer it and wait.
				__handshakeBuffer += headerData;
			}
		}
	}

	private inline function __validateInputPosition():Void
	{
		if (__input.bytesAvailable > 0)
		{
			__inputPosition = __input.position;
		}
		else
		{
			__input.clear();
			__inputPosition = 0;
		}
	}

	private function __generateResponseHandshake(headers:StringMap<String>):Bytes
	{
		var responseHeadersBytes:Bytes = Bytes.ofString([
			"HTTPS/1.1 101 Switching Protocols",
			"upgrade: websocket",
			"Connection: upgrade",
			"Sec-WebSocket-Accept: " + __generateWebSocketAccept(headers.get("Sec-WebSocket-Key")),
			"",
			""
		].join(CRLF));

		return responseHeadersBytes;
	}

	private function __generateWebSocketAccept(key:String):String
	{
		var magic:String = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
		return Base64.encode(Sha1.make(Bytes.ofString(key + magic)));
	}

	private function __parseHeaders(lines:Array<String>):StringMap<String>
	{
		var headers:StringMap<String> = new StringMap();

		// Skip the first line, since it contains the request method or status code
		for (i in 1...lines.length)
		{
			var line:String = lines[i];

			// Check if this is the end of the headers
			if (line == "")
			{
				break;
			}

			// Split the header into name and value
			var index:Int = line.indexOf(":");
			if (index != -1)
			{
				var name:String = line.substring(0, index);
				var value:String = StringTools.trim(line.substring(index + 1));

				// Store the header in the map
				headers.set(name, value);
			}
		}

		return headers;
	}

	private function __validateResponseHandshake(headers:StringMap<String>):Bool
	{
		// Check if the response status code is 101
		if (headers.get("Status") != "101")
		{
			// The server failed to switch protocols, close the connection with code 1002 (protocol error)
			return false;
		}

		// Check if the "Upgrade" header is set to "websocket"
		if (headers.get("upgrade") != "websocket")
		{
			// The server does not support WebSockets, close the connection with code 1002 (protocol error)
			return false;
		}

		// Check if the "Connection" header is set to "Upgrade"
		if (headers.get("Connection") != "upgrade")
		{
			// The server failed to switch protocols, close the connection with code 1002 (protocol error)
			return false;
		}

		// Check if the "Sec-WebSocket-Accept" header matches the expected value
		var expected:String = __generateWebSocketAccept(__key);
		if (headers.get("sec-websocket-accept") != expected)
		{
			// The server sent an invalid response, close the connection with code 1002 (protocol error)
			return false;
		}

		return true;
	}

	private function __onConnect():Void
	{
		if (__secure)
		{
			__initSSLHandshake();
		}
		else
		{
			__openConnection(__onTickConnect);
		}
	}

	private function __openConnection(tickListener:Event->Void):Void
	{
		__connected = true;
		var stage:Stage = Lib.current.stage;
		stage.addEventListener(Event.ENTER_FRAME, __onTickProcess);
		if (tickListener != null)
		{
			stage.removeEventListener(Event.ENTER_FRAME, tickListener);
			__doHandshake();
		}
	}

	private function __initSSLHandshake():Void
	{
		__timeout = 3000;
		__timestamp = Sys.time();

		var stage:Stage = Lib.current.stage;
		stage.removeEventListener(Event.ENTER_FRAME, __onTickConnect);
		stage.addEventListener(Event.ENTER_FRAME, __onTickSSLHandshake);
	}

	private function __onTickSSLHandshake(e:Event):Void
	{
		var doClose:Bool = false;
		try
		{
			__socket.handshake();
		}
		catch (e:Error)
		{
			if (e == Error.Blocked #if HXCPP_DEBUGGER || e.match(Error.Custom(Blocked)) #end)
			{
				doClose = true;
			}
		}
		catch (e:Dynamic)
		{
			doClose = true;
		}

		if (doClose)
		{
			if (Sys.time() - __timestamp > __timeout / 1000)
			{
				__close(1015);
			}
		}
		else
		{
			__openConnection(__onTickSSLHandshake);
		}
	}

	private function __onError(errorMessage:String):Void
	{
		onerror(new WebsocketEvent(WebsocketEvent.ERROR, this, errorMessage));
	}

	private function __onMessage(data:Dynamic):Void
	{
		onmessage(new WebsocketEvent(WebsocketEvent.MESSAGE, this, data));
	}

	public function close(?code:Int, ?reason:String):Void
	{
		if (__socket == null) return;

		if (readyState == OPEN)
		{
			__sendFrame(Bytes.alloc(0), WebSocketOpcode.CLOSE, true);
		}

		__close(code, reason);
	}

	private function __close(code:Int, ?reason:String):Void
	{
		if (__socket == null) return;

		if (__connected)
		{
			__socket.close();

			if (__heartbeatID > 0)
			{
				Lib.clearInterval(__heartbeatID);
			}

			readyState = CLOSED;
			__connected = false;
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, __onTickProcess);
		}
		else
		{
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, __onTickConnect);

			if (__secure)
			{
				Lib.current.stage.removeEventListener(Event.ENTER_FRAME, __onTickSSLHandshake);
			}
		}

		// trace(code, reason);
		onclose(new WebsocketEvent(WebsocketEvent.CLOSE, this, null, code, reason));

		__socket = null;
	}

	private function __initHeartbeat():Void
	{
		__heartbeatID = Lib.setInterval(__heartbeatInterval, __heartbeatDelay);
	}

	private function __heartbeatInterval()
	{
		if (__hasTimeoutPotential)
		{
			// trace("heartbeat close");
			__close(1006);
			return;
		}

		ping();
		__hasTimeoutPotential = true;
	}

	public function sendBytes(data:ByteArray):Void
	{
		__prepareMessage(data, WebSocketOpcode.BINARY);
	}

	public function sendString(data:String):Void
	{
		__prepareMessage(Bytes.ofString(data), WebSocketOpcode.TEXT);
	}

	private function __prepareMessage(data:ByteArray, opcode:Int):Void
	{
		// handles fragmentation of message into multiple frames
		if (data.length > MAX_PAYLOAD)
		{
			while (data.position != data.length)
			{
				var fin:Bool;
				var fragmentOpcode:Int;
				var length:Int;

				var remaining:Int = data.length - data.position;

				if (remaining > MAX_PAYLOAD)
				{
					fin = false;
					length = MAX_PAYLOAD;
					fragmentOpcode = WebSocketOpcode.CONTINUATION;
				}
				else
				{
					fin = true;
					length = remaining;
					fragmentOpcode = opcode;
				}

				__outgoingMessageBuffer.length = length;
				__outgoingMessageBuffer.position = 0;

				data.readBytes(__outgoingMessageBuffer, 0, length);

				__sendFrame(__outgoingMessageBuffer, fragmentOpcode, fin);
			}
		}
		else
		{
			__sendFrame(data, opcode, true);
		}
	}

	private static function __constructMaskPool():Array<ByteArray>
	{
		var pool:Array<ByteArray> = [];
		for (i in 0...MASK_POOL_SIZE)
		{
			pool.push(__generateMaskBytes());
		}

		return pool;
	}

	private static function __generateMaskBytes():ByteArray
	{
		var maskBytes:ByteArray = getRandomBytes(4);

		if (__maskTable.exists(maskBytes.toString()))
		{
			while (__maskTable.exists(maskBytes.toString()))
			{
				maskBytes = getRandomBytes(4);
			}
			__maskTable.set(maskBytes.toString(), 0);
		}

		return maskBytes;
	}

	private function __getMask():ByteArray
	{
		if (MASK_POOL_SIZE == 0)
		{
			return getRandomBytes(4);
		}

		var mask:ByteArray = __maskPool.length > 0 ? __maskPool.shift() : __generateMaskBytes();
		return __maskPool.shift();
	}

	private function __freeMask(maskBytes:ByteArray):Void
	{
		__maskPool.push(maskBytes);
	}

	private inline function __sendFrame(payload:ByteArray, opcode:Int, isFinal:Bool):Void
	{
		// Write the frame header
		var fin:Int = isFinal ? WebSocketHeaderMask.FIN : WebSocketOpcode.CONTINUATION;
		__output.writeByte(fin | opcode);
		var length:Int = payload.length;

		if (__isClient == false)
		{
			__writePayloadLength(length);
			__output.writeBytes(payload);
		}
		else
		{
			__writePayloadLength(length, WebSocketHeaderMask.MASK);

			// Reset the maskedPayload ByteArray
			__maskedPayload.length = payload.length;
			__maskedPayload.position = 0;
			// Mask the payload using a bulk XOR operation
			for (i in 0...length)
			{
				__maskedPayload.writeByte(payload[i] ^ __mask[i % 4]);
			}

			// Write the masked payload
			__output.writeBytes(__mask);
			__output.writeBytes(__maskedPayload);
		}
		// Write the frame to the socket
		if (isFinal)
		{
			try
			{
				__socket.output.writeBytes(__output, 0, __output.length);
				__socket.output.flush();

				__output.clear();
			}
			catch (e:Dynamic)
			{
				__close(1006, null);
			}
		}
	}

	private inline function __writePayloadLength(length:UInt, maskFlag:Int = 0x00):Void
	{
		if (length > 65535)
		{
			maskFlag |= 127;
			__output.writeByte(maskFlag);
			__output.writeUnsignedInt(length);
		}
		else if (length > 125)
		{
			maskFlag |= 126;
			__output.writeByte(maskFlag);
			__output.writeShort(length);
		}
		else
		{
			maskFlag |= length;
			__output.writeByte(maskFlag);
		}
	}

	private static var __pingPongBuffer:Bytes = Bytes.alloc(2);

	public function ping():Void
	{
		__pingPongBuffer.set(0, WebSocketOpcode.PING);
		__socket.output.writeBytes(__pingPongBuffer, 0, 2);
		__socket.output.flush();
	}

	private function __pong():Void
	{
		__pingPongBuffer.set(0, WebSocketOpcode.PONG);
		__socket.output.writeBytes(__pingPongBuffer, 0, 2);
		__socket.output.flush();
	}

	@:access(openfl.net._internal.websocket)
	inline function fromAcceptedSocket(socket:FlexSocket):WebSocket
	{
		var acceptedSocket:WebSocket = new AcceptedWebSocket();
		acceptedSocket.__initSocket(socket);

		return acceptedSocket;
	}

	/*We should replace this with cprng from the operating system. 
		Notably, the websocket specification doesn't
		actually mention using cryptographically secure randomness, so this may
		be suitable enough for now. Considering why we mask in websocket, the 
		security implications are such as that it be random enough to prevent
		certain attacks. The mask itself is sent with every websocket frame anyway,
		so I don't know if it's critically relevant. Instead we try to add a bit
		of extra entropy to elevate the factor of unpredictability.
	 */
	public static function getRandomBytes(length:Int):ByteArray
	{
		var rngBytes = Bytes.alloc(4);
		var seed = Date.now().getTime(); // Current time in milliseconds

		#if cpp
		// Add process ID to the seed for additional entropy
		seed += cpp.NativeSys.sys_get_pid();
		#elseif (hl || neko)
		seed += Sys.cpuTime();
		#end

		// Add some additional random seed
		seed += Std.random(1000000);

		// Generate an MD5 hash from the seed
		var seedBytes = Bytes.ofString(Std.string(seed));
		var hashBytes = Md5.make(seedBytes);

		for (i in 0...length)
		{
			@:privateAccess
			#if cpp
			var randomByte:Int = Std.random(256) ^ hashBytes.b[i % hashBytes.length];
			#else
			var randomByte = Std.random(256) ^ hashBytes.get(i % hashBytes.length);
			#end
			rngBytes.set(i, randomByte);
		}
		return rngBytes;
	}
}

enum abstract BinaryType(String) to String from String
{
	var ARRAYBUFFER = "arraybuffer";
	var BLOB = "blob";
}

enum abstract WebSocketHeaderMask(Int) from Int to Int
{
	public static inline var FIN:Int = 0x80;
	public static inline var RSV1:Int = 0x40;
	public static inline var RSV2:Int = 0x20;
	public static inline var RSV3:Int = 0x10;
	public static inline var MASK:Int = 0x80;
}

enum abstract WebSocketOpcode(Int) from Int to Int
{
	public static inline var CONTINUATION:Int = 0x00;
	public static inline var TEXT:Int = 0x01;
	public static inline var BINARY:Int = 0x02;
	public static inline var CLOSE:Int = 0x08;
	public static inline var PING:Int = 0x09;
	public static inline var PONG:Int = 0x0A;
}

@:noCompletion class AcceptedWebSocket extends WebSocket
{
	private function new()
	{
		__isClient = false;
		super(null, null, null);
	}
}

@:access(openfl.net._internal.websocket)
inline function fromAcceptedSocket(socket:FlexSocket):WebSocket
{
	var acceptedSocket:WebSocket = new AcceptedWebSocket();
	acceptedSocket.__initSocket(socket);

	return acceptedSocket;
}
#end
