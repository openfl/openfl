package openfl.net;

#if !flash
import openfl.errors.ArgumentError;
import openfl.errors.IllegalOperationError;
import openfl.errors.IOError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.events.WebSocketEvent;
import openfl.utils.ByteArray;
import openfl.utils.ByteArray.ByteArrayData;
import openfl.utils.Endian;
import openfl.Vector;
#if (js && html5)
#if haxe4
import js.lib.ArrayBuffer;
#else
import js.html.ArrayBuffer;
#end
import js.html.BinaryType;
import js.html.CloseEvent;
import js.html.MessageEvent;
import js.html.WebSocket as JSWebSocket;
#else
import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.io.Bytes;
import openfl.events.ProgressEvent;
import openfl.security.CertificateStatus;
#end

/**
	The WebSocket class implements the client side of the WebSocket protocol
	(RFC 6455), as Adobe AIR's `air.net.WebSocket` does: connect to a `ws://`
	or `wss://` URL, send text or binary messages with `sendMessage()`, and
	receive them as `WebSocketEvent.DATA` events.

	On native targets, a `wss://` connection validates the server certificate
	against the system's trusted certificates. When the validation fails, a
	cancelable `SecurityErrorEvent.CERTIFICATE_ERROR` event is dispatched:
	calling `preventDefault()` on it connects anyway, without validation;
	otherwise an `IOErrorEvent.IO_ERROR` event follows. In a web browser, the
	browser validates the certificate, and `fmtPING` / `fmtPONG` messages
	cannot be sent.

	Code written for AIR that imports `air.net.WebSocket` compiles against this
	class, as OpenFL remaps the `air` package to `openfl` like `flash`.

	@event certificateError Dispatched when the server certificate of a
							`wss://` connection cannot be validated.
	@event close            Dispatched when the server closes the connection,
							or the connection is lost. Not dispatched when
							`close()` is called.
	@event connect          Dispatched when the WebSocket handshake succeeds.
	@event ioError          Dispatched when the connection cannot be made or
							fails.
	@event websocketData    Dispatched when a message is received.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class WebSocket extends EventDispatcher
{
	/**
		The format of a binary message.
	**/
	public static inline var fmtBINARY:UInt = 2;

	/**
		The format of a close message.
	**/
	public static inline var fmtCLOSE:UInt = 8;

	/**
		The format of a ping message.
	**/
	public static inline var fmtPING:UInt = 9;

	/**
		The format of a pong message.
	**/
	public static inline var fmtPONG:UInt = 10;

	/**
		The format of a text message.
	**/
	public static inline var fmtTEXT:UInt = 1;

	/**
		The status code the connection was closed with: the one the server sent
		in its close message, `1005` when it sent none, or `1006` when the
		connection was lost without one.
	**/
	public var closeReason(default, null):Int = 0;

	/**
		The subprotocol the server selected during the handshake, or an empty
		string when it selected none.
	**/
	public var protocol:String = "";

	#if (js && html5)
	@:noCompletion private var __socket:JSWebSocket;
	#else
	@:noCompletion private static inline var GUID:String = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
	@:noCompletion private static inline var MAX_HANDSHAKE_LENGTH:Int = 16384;

	@:noCompletion private var __socket:Socket;
	@:noCompletion private var __host:String;
	@:noCompletion private var __port:Int;
	@:noCompletion private var __path:String;
	@:noCompletion private var __secure:Bool;
	@:noCompletion private var __protocols:Array<String>;
	@:noCompletion private var __key:String;
	@:noCompletion private var __verifyCertificate:Bool;
	@:noCompletion private var __handshakeDone:Bool;
	@:noCompletion private var __input:ByteArray;
	@:noCompletion private var __message:ByteArray;
	@:noCompletion private var __messageFormat:UInt;
	#end

	@:noCompletion private var __closing:Bool;

	/**
		Creates a WebSocket object. Call `connect()` to open a connection.
	**/
	public function new()
	{
		super();
	}

	/**
		Closes the connection, sending the server a close message with
		`reasonCode`. No `close` event is dispatched.

		@param reasonCode The status code of the close message.
	**/
	public function close(reasonCode:UInt = 1000):Void
	{
		if (__socket == null) return;

		__closing = true;
		closeReason = reasonCode;

		#if (js && html5)
		var socket = __socket;
		__socket = null;
		try
		{
			socket.close(reasonCode);
		}
		catch (e:Dynamic)
		{
			socket.close();
		}
		#else
		if (__handshakeDone)
		{
			try
			{
				__sendFrame(fmtCLOSE, __closePayload(reasonCode));
			}
			catch (e:Dynamic) {}
		}
		__cleanup();
		#end
	}

	/**
		Connects to a WebSocket server.

		@param url       A `ws://` or `wss://` URL.
		@param protocols The subprotocols to offer the server, if any.
		@throws ArgumentError When `url` is not a `ws://` or `wss://` URL.
	**/
	public function connect(url:String, protocols:Vector<String> = null):Void
	{
		var regex = ~/^(wss?):\/\/(\[[^\]]+\]|[^\/:?#]+)(?::(\d+))?([^#]*)/i;
		if (url == null || !regex.match(url))
		{
			throw new ArgumentError("Invalid WebSocket URL: " + url);
		}

		if (__socket != null) close();
		__closing = false;
		closeReason = 0;
		protocol = "";

		#if (js && html5)
		var list:Array<String> = protocols != null ? [for (p in protocols) p] : [];
		__socket = list.length > 0 ? new JSWebSocket(url, list) : new JSWebSocket(url);
		__socket.binaryType = BinaryType.ARRAYBUFFER;
		var socket = __socket;
		socket.onopen = function(_)
		{
			if (__socket != socket) return;
			protocol = socket.protocol;
			dispatchEvent(new Event(Event.CONNECT));
		};
		socket.onmessage = function(event:MessageEvent)
		{
			if (__socket != socket) return;
			if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end(event.data, String))
			{
				var bytes = new ByteArray();
				bytes.writeUTFBytes(event.data);
				bytes.position = 0;
				dispatchEvent(new WebSocketEvent(WebSocketEvent.DATA, fmtTEXT, bytes));
			}
			else
			{
				dispatchEvent(new WebSocketEvent(WebSocketEvent.DATA, fmtBINARY, ByteArray.fromArrayBuffer(event.data)));
			}
		};
		socket.onclose = function(event:CloseEvent)
		{
			if (__socket != socket) return;
			__socket = null;
			closeReason = event.code;
			dispatchEvent(new Event(Event.CLOSE));
		};
		socket.onerror = function(_)
		{
			if (__socket != socket) return;
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "WebSocket error"));
		};
		#else
		__secure = regex.matched(1).toLowerCase() == "wss";
		__host = regex.matched(2);
		if (StringTools.startsWith(__host, "[")) __host = __host.substr(1, __host.length - 2);
		var port = regex.matched(3);
		__port = port != null ? Std.parseInt(port) : (__secure ? 443 : 80);
		var path = regex.matched(4);
		__path = path == "" ? "/" : (StringTools.startsWith(path, "/") ? path : "/" + path);
		__protocols = protocols != null ? [for (p in protocols) p] : [];
		__verifyCertificate = true;
		__open();
		#end
	}

	/**
		Sends a message.

		@param opcode The format of the message: `fmtTEXT`, `fmtBINARY`,
					  `fmtPING`, `fmtPONG` or `fmtCLOSE`.
		@param data   A String or a ByteArray. A text message sends a String's
					  UTF-8 bytes; a close message reads its status code from
					  the first two bytes, if any.
		@throws IOError When the connection is not open.
	**/
	public function sendMessage(opcode:UInt, data:Dynamic):Void
	{
		#if (js && html5)
		if (__socket == null || __socket.readyState != JSWebSocket.OPEN)
		{
			throw new IOError("Operation attempted on a WebSocket that is not connected.");
		}
		switch (opcode)
		{
			case fmtTEXT:
				__socket.send(#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end(data, ByteArrayData) ? (data : ByteArray).toString() : Std.string(data));
			case fmtBINARY:
				var bytes = __payload(data);
				var buffer:ArrayBuffer = bytes;
				__socket.send(buffer.byteLength > bytes.length ? buffer.slice(0, bytes.length) : buffer);
			case fmtCLOSE:
				var bytes = __payload(data);
				close(bytes.length >= 2 ? (bytes[0] << 8) | bytes[1] : 1000);
			default:
				// a browser sends its own pings and pongs
		}
		#else
		if (__socket == null || !__handshakeDone)
		{
			throw new IOError("Operation attempted on a WebSocket that is not connected.");
		}
		if (opcode == fmtCLOSE)
		{
			var bytes = __payload(data);
			close(bytes.length >= 2 ? (bytes[0] << 8) | bytes[1] : 1000);
			return;
		}
		__sendFrame(opcode, __payload(data));
		#end
	}

	/**
		Not supported: OpenFL implements the client side of the protocol only.

		@throws IllegalOperationError Always.
	**/
	public function startServer(s:Socket):Void
	{
		throw new IllegalOperationError("WebSocket.startServer() is not supported.");
	}

	@:noCompletion private static function __payload(data:Dynamic):ByteArray
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end(data, ByteArrayData)) return data;
		var bytes = new ByteArray();
		if (data != null) bytes.writeUTFBytes(Std.string(data));
		return bytes;
	}

	#if !(js && html5)
	@:noCompletion private function __open():Void
	{
		__handshakeDone = false;
		__input = new ByteArray();
		__input.endian = Endian.BIG_ENDIAN;
		__message = null;

		var keyBytes = Bytes.alloc(16);
		for (i in 0...16)
			keyBytes.set(i, Std.random(256));
		__key = Base64.encode(keyBytes);

		var socket:Socket;
		if (__secure)
		{
			var secureSocket = new SecureSocket();
			@:privateAccess secureSocket.__verifyCert = __verifyCertificate;
			socket = secureSocket;
		}
		else
		{
			socket = new Socket();
		}
		socket.endian = Endian.BIG_ENDIAN;
		socket.addEventListener(Event.CONNECT, __onSocketConnect);
		socket.addEventListener(ProgressEvent.SOCKET_DATA, __onSocketData);
		socket.addEventListener(Event.CLOSE, __onSocketClose);
		socket.addEventListener(IOErrorEvent.IO_ERROR, __onSocketError);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __onSocketError);
		__socket = socket;
		socket.connect(__host, __port);
	}

	@:noCompletion private function __cleanup():Void
	{
		var socket = __socket;
		__socket = null;
		__handshakeDone = false;
		if (socket == null) return;
		socket.removeEventListener(Event.CONNECT, __onSocketConnect);
		socket.removeEventListener(ProgressEvent.SOCKET_DATA, __onSocketData);
		socket.removeEventListener(Event.CLOSE, __onSocketClose);
		socket.removeEventListener(IOErrorEvent.IO_ERROR, __onSocketError);
		socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __onSocketError);
		try
		{
			socket.close();
		}
		catch (e:Dynamic) {}
	}

	@:noCompletion private static function __closePayload(code:Int):ByteArray
	{
		var bytes = new ByteArray();
		bytes.endian = Endian.BIG_ENDIAN;
		if (code != 1005) bytes.writeShort(code);
		return bytes;
	}

	@:noCompletion private function __fail(text:String):Void
	{
		__cleanup();
		dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, text));
	}

	@:noCompletion private function __lost(code:Int):Void
	{
		closeReason = code;
		__cleanup();
		if (!__closing) dispatchEvent(new Event(Event.CLOSE));
	}

	@:noCompletion private function __sendFrame(opcode:Int, payload:ByteArray):Void
	{
		var length = payload.length;
		var frame = new ByteArray();
		frame.endian = Endian.BIG_ENDIAN;
		frame.writeByte(0x80 | opcode);
		if (length < 126)
		{
			frame.writeByte(0x80 | length);
		}
		else if (length < 65536)
		{
			frame.writeByte(0x80 | 126);
			frame.writeShort(length);
		}
		else
		{
			frame.writeByte(0x80 | 127);
			frame.writeUnsignedInt(0);
			frame.writeUnsignedInt(length);
		}
		var mask = [for (i in 0...4) Std.random(256)];
		for (m in mask)
			frame.writeByte(m);
		for (i in 0...length)
			frame.writeByte(payload[i] ^ mask[i & 3]);
		__socket.writeBytes(frame);
		__socket.flush();
	}

	@:noCompletion private function __onSocketConnect(event:Event):Void
	{
		var lines = [
			'GET $__path HTTP/1.1',
			'Host: ' + (__host.indexOf(":") >= 0 ? '[$__host]' : __host) + (__port == (__secure ? 443 : 80) ? "" : ':$__port'),
			"Upgrade: websocket",
			"Connection: Upgrade",
			'Sec-WebSocket-Key: $__key',
			"Sec-WebSocket-Version: 13"
		];
		if (__protocols.length > 0) lines.push("Sec-WebSocket-Protocol: " + __protocols.join(", "));
		__socket.writeUTFBytes(lines.join("\r\n") + "\r\n\r\n");
		__socket.flush();
	}

	@:noCompletion private function __onSocketData(event:ProgressEvent):Void
	{
		if (__socket == null) return;
		__input.position = __input.length;
		__socket.readBytes(__input, __input.length, __socket.bytesAvailable);
		__input.position = 0;

		if (!__handshakeDone && !__readHandshake()) return;

		while (__socket != null && __readFrame()) {}

		if (__socket != null)
		{
			var rest = new ByteArray();
			rest.endian = Endian.BIG_ENDIAN;
			if (__input.bytesAvailable > 0) __input.readBytes(rest, 0, __input.bytesAvailable);
			__input = rest;
		}
	}

	@:noCompletion private function __readHandshake():Bool
	{
		var end = -1;
		for (i in 3...__input.length)
		{
			if (__input[i - 3] == 13 && __input[i - 2] == 10 && __input[i - 1] == 13 && __input[i] == 10)
			{
				end = i + 1;
				break;
			}
		}
		if (end < 0)
		{
			if (__input.length > MAX_HANDSHAKE_LENGTH) __fail("WebSocket handshake response too long");
			return false;
		}

		var lines = __input.readUTFBytes(end).split("\r\n");
		var status = ~/^HTTP\/1\.[01] (\d{3})/;
		if (!status.match(lines[0]) || status.matched(1) != "101")
		{
			__fail("WebSocket handshake failed: " + lines[0]);
			return false;
		}
		var headers = new Map<String, String>();
		for (i in 1...lines.length)
		{
			var colon = lines[i].indexOf(":");
			if (colon > 0) headers.set(StringTools.trim(lines[i].substr(0, colon)).toLowerCase(), StringTools.trim(lines[i].substr(colon + 1)));
		}
		var accept = Base64.encode(Sha1.make(Bytes.ofString(__key + GUID)));
		var upgrade = headers.get("upgrade");
		if (headers.get("sec-websocket-accept") != accept || upgrade == null || upgrade.toLowerCase() != "websocket")
		{
			__fail("WebSocket handshake failed: invalid upgrade response");
			return false;
		}
		protocol = headers.exists("sec-websocket-protocol") ? headers.get("sec-websocket-protocol") : "";
		__handshakeDone = true;
		dispatchEvent(new Event(Event.CONNECT));
		return __socket != null;
	}

	@:noCompletion private function __readFrame():Bool
	{
		var start = __input.position;
		if (__input.bytesAvailable < 2) return false;
		var b0 = __input.readUnsignedByte();
		var b1 = __input.readUnsignedByte();
		var length:Float = b1 & 0x7F;
		if (length == 126)
		{
			if (__input.bytesAvailable < 2)
			{
				__input.position = start;
				return false;
			}
			length = __input.readUnsignedShort();
		}
		else if (length == 127)
		{
			if (__input.bytesAvailable < 8)
			{
				__input.position = start;
				return false;
			}
			var high = __input.readUnsignedInt();
			length = high * 4294967296.0 + __input.readUnsignedInt();
		}
		var masked = (b1 & 0x80) != 0;
		if (__input.bytesAvailable < (masked ? 4 : 0) + length)
		{
			__input.position = start;
			return false;
		}
		var mask = masked ? [for (i in 0...4) __input.readUnsignedByte()] : null;
		var payload = new ByteArray();
		payload.endian = Endian.BIG_ENDIAN;
		if (length > 0) __input.readBytes(payload, 0, Std.int(length));
		if (mask != null)
		{
			for (i in 0...payload.length)
				payload[i] = payload[i] ^ mask[i & 3];
		}

		var fin = (b0 & 0x80) != 0;
		var opcode = b0 & 0x0F;
		switch (opcode)
		{
			case 0:
				if (__message == null)
				{
					__fail("WebSocket protocol error: unexpected continuation frame");
					return false;
				}
				__message.writeBytes(payload);
				if (fin) __deliver();
			case 1, 2:
				if (__message != null)
				{
					__fail("WebSocket protocol error: unfinished fragmented message");
					return false;
				}
				__message = payload;
				__message.position = payload.length;
				__messageFormat = opcode;
				if (fin) __deliver();
			case 8:
				var code = payload.length >= 2 ? (payload[0] << 8) | payload[1] : 1005;
				if (!__closing)
				{
					try
					{
						__sendFrame(fmtCLOSE, __closePayload(code));
					}
					catch (e:Dynamic) {}
				}
				__lost(code);
				return false;
			case 9:
				__sendFrame(fmtPONG, payload);
			case 10:
			default:
				__fail("WebSocket protocol error: unknown opcode " + opcode);
				return false;
		}
		return true;
	}

	@:noCompletion private function __deliver():Void
	{
		var message = __message;
		__message = null;
		message.position = 0;
		dispatchEvent(new WebSocketEvent(WebSocketEvent.DATA, __messageFormat, message));
	}

	@:noCompletion private function __onSocketClose(event:Event):Void
	{
		if (!__handshakeDone)
		{
			__fail("Connection closed during the WebSocket handshake");
			return;
		}
		__lost(1006);
	}

	@:noCompletion private function __onSocketError(event:Event):Void
	{
		var text = #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end(event, IOErrorEvent) ? (cast event : IOErrorEvent).text : (cast event : SecurityErrorEvent).text;
		var socket = __socket;
		if (__secure && !__handshakeDone && __verifyCertificate && #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end(socket, SecureSocket)
			&& (cast socket : SecureSocket).serverCertificateStatus == CertificateStatus.INVALID && __isCertificateError(text))
		{
			__cleanup();
			var certificateEvent = new SecurityErrorEvent(SecurityErrorEvent.CERTIFICATE_ERROR, false, true, text);
			dispatchEvent(certificateEvent);
			if (certificateEvent.isDefaultPrevented() && !__closing)
			{
				__verifyCertificate = false;
				__open();
				return;
			}
		}
		if (__handshakeDone)
		{
			__lost(1006);
		}
		else
		{
			__fail(text);
		}
	}

	@:noCompletion private static function __isCertificateError(text:String):Bool
	{
		var lower = text != null ? text.toLowerCase() : "";
		return lower.indexOf("x509") >= 0 || lower.indexOf("certificate") >= 0;
	}
	#end
}
#elseif air
typedef WebSocket = air.net.WebSocket;
#end
