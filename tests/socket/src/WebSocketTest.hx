package;

#if sys
import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.io.Bytes;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.ServerSocketConnectEvent;
import openfl.events.WebSocketEvent;
import openfl.net.ServerSocket;
import openfl.net.Socket;
import openfl.net.WebSocket;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
#end
import utest.Assert;
import utest.Async;
import utest.Test;

/**
	openfl.net.WebSocket against a minimal WebSocket server built on ServerSocket.
	The path of the URL picks what the server does. Requires a native target.
**/
class WebSocketTest extends Test
{
	#if sys
	var server:WebSocketTestServer;
	var socket:WebSocket;

	public function setup()
	{
		server = new WebSocketTestServer();
	}

	public function teardown()
	{
		if (socket != null) socket.close();
		socket = null;
		server.close();
		server = null;
	}

	function open(path:String, ?protocols:Array<String>):WebSocket
	{
		socket = new WebSocket();
		socket.connect("ws://127.0.0.1:" + server.port + path, protocols != null ? openfl.Vector.ofArray(protocols) : null);
		return socket;
	}

	@:timeout(4000)
	public function test_textEchoAndSubprotocol(async:Async)
	{
		var socket = open("/echo", ["chat"]);
		socket.addEventListener(Event.CONNECT, function(_)
		{
			Assert.equals("chat", socket.protocol);
			socket.sendMessage(WebSocket.fmtTEXT, "héllo");
		});
		socket.addEventListener(WebSocketEvent.DATA, function(event:WebSocketEvent)
		{
			Assert.equals(WebSocket.fmtTEXT, event.format);
			Assert.equals("echo:héllo", event.stringData);
			async.done();
		});
	}

	@:timeout(4000)
	public function test_binaryEcho(async:Async)
	{
		// 300 bytes take a 16-bit length, 70000 a 64-bit one
		var sizes = [300, 70000];
		var socket = open("/echo");
		function send()
		{
			var bytes = new ByteArray();
			for (i in 0...sizes[0])
				bytes.writeByte(i * 7);
			socket.sendMessage(WebSocket.fmtBINARY, bytes);
		}
		socket.addEventListener(Event.CONNECT, function(_) send());
		socket.addEventListener(WebSocketEvent.DATA, function(event:WebSocketEvent)
		{
			var size = sizes.shift();
			Assert.equals(WebSocket.fmtBINARY, event.format);
			Assert.isNull(event.stringData);
			Assert.equals(size, event.data.length);
			var same = true;
			for (i in 0...size)
				if (event.data[i] != (i * 7) & 0xFF) same = false;
			Assert.isTrue(same);
			if (sizes.length > 0) send() else async.done();
		});
	}

	@:timeout(4000)
	public function test_fragmentedMessage(async:Async)
	{
		var socket = open("/fragments");
		socket.addEventListener(WebSocketEvent.DATA, function(event:WebSocketEvent)
		{
			Assert.equals("fragmented", event.stringData);
			async.done();
		});
	}

	@:timeout(4000)
	public function test_answersPing(async:Async)
	{
		var socket = open("/ping");
		socket.addEventListener(WebSocketEvent.DATA, function(event:WebSocketEvent)
		{
			Assert.equals("pong:p", event.stringData);
			async.done();
		});
	}

	@:timeout(4000)
	public function test_serverClose(async:Async)
	{
		var socket = open("/close");
		socket.addEventListener(Event.CLOSE, function(_)
		{
			Assert.equals(4001, socket.closeReason);
			async.done();
		});
	}

	@:timeout(4000)
	public function test_clientClose(async:Async)
	{
		var socket = open("/echo");
		var closed = false;
		socket.addEventListener(Event.CLOSE, function(_) closed = true);
		socket.addEventListener(Event.CONNECT, function(_)
		{
			socket.close(1000);
			Assert.raises(function() socket.sendMessage(WebSocket.fmtTEXT, "late"));
			haxe.Timer.delay(function()
			{
				Assert.isFalse(closed);
				Assert.same([1000], server.closeCodes);
				async.done();
			}, 300);
		});
	}

	@:timeout(4000)
	public function test_handshakeRejected(async:Async)
	{
		var socket = open("/reject");
		socket.addEventListener(Event.CONNECT, function(_) Assert.fail("connected"));
		socket.addEventListener(IOErrorEvent.IO_ERROR, function(_)
		{
			Assert.pass();
			async.done();
		});
	}

	public function test_invalidUrl()
	{
		Assert.raises(function() new WebSocket().connect("http://127.0.0.1/"));
	}

	public function test_sendBeforeConnect()
	{
		Assert.raises(function() new WebSocket().sendMessage(WebSocket.fmtTEXT, "early"));
	}
	#end
}

#if sys
private class WebSocketTestServer
{
	public var port(default, null):Int;
	public var closeCodes(default, null):Array<Int> = [];

	var server:ServerSocket;
	var clients:Array<Socket> = [];

	public function new()
	{
		server = new ServerSocket();
		server.bind(0, "127.0.0.1");
		server.addEventListener(ServerSocketConnectEvent.CONNECT, function(event:ServerSocketConnectEvent) serve(event.socket));
		server.listen();
		port = server.localPort;
	}

	public function close():Void
	{
		for (client in clients)
			if (client.connected) client.close();
		if (server.bound) server.close();
	}

	function serve(client:Socket):Void
	{
		clients.push(client);
		client.endian = Endian.BIG_ENDIAN;
		var input = new ByteArray();
		input.endian = Endian.BIG_ENDIAN;
		var open = false;
		client.addEventListener(ProgressEvent.SOCKET_DATA, function(_)
		{
			input.position = input.length;
			client.readBytes(input, input.length, client.bytesAvailable);
			input.position = 0;
			if (!open)
			{
				var text = input.toString();
				var end = text.indexOf("\r\n\r\n");
				if (end < 0) return;
				open = true;
				input.position = end + 4;
				handshake(client, text.substr(0, end).split("\r\n"));
			}
			while (client.connected && readFrame(client, input)) {}
			var rest = new ByteArray();
			rest.endian = Endian.BIG_ENDIAN;
			if (input.bytesAvailable > 0) input.readBytes(rest, 0, input.bytesAvailable);
			input = rest;
		});
	}

	function handshake(client:Socket, lines:Array<String>):Void
	{
		var path = lines[0].split(" ")[1];
		var headers = new Map<String, String>();
		for (i in 1...lines.length)
		{
			var colon = lines[i].indexOf(":");
			headers.set(StringTools.trim(lines[i].substr(0, colon)).toLowerCase(), StringTools.trim(lines[i].substr(colon + 1)));
		}
		if (path == "/reject")
		{
			client.writeUTFBytes("HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\n\r\n");
			client.flush();
			return;
		}
		var accept = Base64.encode(Sha1.make(Bytes.ofString(headers.get("sec-websocket-key") + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")));
		var response = "HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: " + accept + "\r\n";
		var offered = headers.get("sec-websocket-protocol");
		if (offered != null && offered.split(",").map(StringTools.trim).indexOf("chat") >= 0) response += "Sec-WebSocket-Protocol: chat\r\n";
		client.writeUTFBytes(response + "\r\n");
		switch (path)
		{
			case "/close":
				sendFrame(client, 8, code(4001));
			case "/fragments":
				sendFrame(client, 1, text("frag"), false);
				sendFrame(client, 0, text("men"), false);
				sendFrame(client, 0, text("ted"));
			case "/ping":
				sendFrame(client, 9, text("p"));
			default:
		}
		client.flush();
	}

	function readFrame(client:Socket, input:ByteArray):Bool
	{
		var start = input.position;
		if (input.bytesAvailable < 2) return false;
		var b0 = input.readUnsignedByte();
		var b1 = input.readUnsignedByte();
		var length = b1 & 0x7F;
		if (length == 126)
		{
			if (input.bytesAvailable < 2)
			{
				input.position = start;
				return false;
			}
			length = input.readUnsignedShort();
		}
		else if (length == 127)
		{
			if (input.bytesAvailable < 8)
			{
				input.position = start;
				return false;
			}
			input.readUnsignedInt();
			length = input.readUnsignedInt();
		}
		if (input.bytesAvailable < 4 + length)
		{
			input.position = start;
			return false;
		}
		var mask = [for (i in 0...4) input.readUnsignedByte()];
		var payload = new ByteArray();
		payload.endian = Endian.BIG_ENDIAN;
		for (i in 0...length)
			payload.writeByte(input.readUnsignedByte() ^ mask[i & 3]);
		payload.position = 0;

		switch (b0 & 0x0F)
		{
			case 1:
				var message = payload.toString();
				sendFrame(client, 1, text("echo:" + message));
			case 2:
				sendFrame(client, 2, payload);
			case 8:
				closeCodes.push(payload.length >= 2 ? payload.readUnsignedShort() : 1005);
				client.close();
				return false;
			case 10:
				sendFrame(client, 1, text("pong:" + payload.toString()));
			default:
		}
		client.flush();
		return true;
	}

	static function sendFrame(client:Socket, opcode:Int, payload:ByteArray, fin:Bool = true):Void
	{
		client.writeByte((fin ? 0x80 : 0) | opcode);
		if (payload.length < 126)
		{
			client.writeByte(payload.length);
		}
		else if (payload.length < 65536)
		{
			client.writeByte(126);
			client.writeShort(payload.length);
		}
		else
		{
			client.writeByte(127);
			client.writeUnsignedInt(0);
			client.writeUnsignedInt(payload.length);
		}
		client.writeBytes(payload);
	}

	static function text(value:String):ByteArray
	{
		var bytes = new ByteArray();
		bytes.writeUTFBytes(value);
		return bytes;
	}

	static function code(value:Int):ByteArray
	{
		var bytes = new ByteArray();
		bytes.endian = Endian.BIG_ENDIAN;
		bytes.writeShort(value);
		return bytes;
	}
}
#end
