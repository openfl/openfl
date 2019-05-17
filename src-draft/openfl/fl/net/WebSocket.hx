package openfl.fl.net;

import haxe.Timer;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.utils.ByteArray;
import sys.net.Host;
import sys.net.Socket;

/**
 * Web socket client for native openfl targets like macos, android, ios
 * @author Andreas Drewke, others
 * This is based on https://lib.haxe.org/p/WebSocket/2.0.2/files/sys/net/WebSocket.hx
 */
class WebSocket extends EventDispatcher
{
	public var bytesAvailable(get, null):UInt;

	private static inline var RECEIVESTATE_FRAME_INIT:Int = 0;
	private static inline var RECEIVESTATE_FRAME_LENGTH:Int = 1;
	private static inline var RECEIVESTATE_FRAME_LENGTH16:Int = 2;
	private static inline var RECEIVESTATE_FRAME_LENGTH32:Int = 3;
	private static inline var RECEIVESTATE_FRAME_DATA:Int = 4;
	private static inline var FRAME_OPCODE_TEXT = 0x01;
	private static inline var FRAME_OPCODE_BINARY = 0x02;
	private static inline var FRAME_OPCODE_CLOSE = 0x08;
	private static inline var FRAME_OPCODE_PING = 0x09;
	private static inline var FRAME_OPCODE_PONG = 0x0A;

	private var _socket:Socket;
	private var _receiveState:UInt;
	private var _receiveData:ByteArray;
	private var _receiveDataLength:Int;
	private var _receiveFrameOpcode:Int;
	private var _receiveFrameFin:Bool;
	private var _pendingReceiveDataComplete:Bool;
	private var _pendingReceiveData:ByteArray;
	private var _pendingSendData:ByteArray;
	private var _timer:Timer;
	private var _sendBuffer:ByteArray;
	private var _readSockets:Array<Socket>;
	private var _writeSockets:Array<Socket>;
	private var _emptySockets:Array<Socket>;

	public function new()
	{
		super();
		_socket = new Socket();
		_socket.setTimeout(30.0);
		_readSockets = [_socket];
		_writeSockets = [_socket];
		_emptySockets = [];
		// additional initialization
		initialize();
	}

	private function initialize():Void
	{
		_receiveState = RECEIVESTATE_FRAME_INIT;
		_receiveData = null;
		_receiveDataLength = 0;
		_receiveFrameOpcode = -1;
		_receiveFrameFin = false;
		_pendingReceiveDataComplete = false;
		_pendingReceiveData = null;
		_pendingSendData = null;
		_sendBuffer = new ByteArray();
	}

	static function encodeBase64(content:String):String
	{
		var suffix = switch (content.length % 3)
		{
			case 2: "=";
			case 1: "==";
			default: "";
		};
		return haxe.crypto.BaseCode.encode(content, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/") + suffix;
	}

	public function connect(host:String, port:Int, origin:String, url:String, key:String):Void
	{
		_socket.connect(new Host(host), port);
		_socket.output.writeString("GET " + url + " HTTP/1.1\r\n" + "Host: " + host + ":" + Std.string(port) + "\r\n" + "Upgrade: websocket\r\n"
			+ "Connection: Upgrade\r\n" + "Sec-WebSocket-Key: " + encodeBase64(key) + "\r\n" + "Origin: " + origin + "\r\n" + "Sec-WebSocket-Version: 13"
			+ "\r\n" + "\r\n");
		_socket.output.flush();

		var line:String;
		while ((line = _socket.input.readLine()) != "")
		{
			trace("connect(): Handshake from server: " + line);
		}

		_timer = new Timer(Math.ceil(1000.0 / 60.0));
		_timer.run = run;

		//
		dispatchEvent(new Event(Event.CONNECT));
	}

	public function close(?code:Int, reason = ""):Void
	{
		var reasonBytes:ByteArray = null;
		if (code != null)
		{
			reasonBytes = new ByteArray();
			reasonBytes.writeByte(code >> 8);
			reasonBytes.writeByte(code & 0x0F);
			for (i in 0...reason.length)
			{
				reasonBytes.writeByte(reason.charCodeAt(i));
			}
		}
		sendFrame(FRAME_OPCODE_CLOSE, true, reasonBytes);
		_socket.close();
	}

	private function sendFrame(code:Int, fin:Bool, data:ByteArray):Void
	{
		_sendBuffer.writeByte((fin ? 0x80 : 0x00) | code);

		var len = 0;
		if (data.length < 126) len = data.length;
		else if (data.length < 65536) len = 126;
		else
			len = 127;

		_sendBuffer.writeByte(len | 0x80);

		if (data.length >= 126)
		{
			if (data.length < 65536)
			{
				_sendBuffer.writeByte((data.length >> 8) & 0xFF);
				_sendBuffer.writeByte(data.length & 0xFF);
			}
			else
			{
				_sendBuffer.writeByte((data.length >> 24) & 0xFF);
				_sendBuffer.writeByte((data.length >> 16) & 0xFF);
				_sendBuffer.writeByte((data.length >> 8) & 0xFF);
				_sendBuffer.writeByte(data.length & 0xFF);
			}
		}

		var mask = [Std.random(256), Std.random(256), Std.random(256), Std.random(256)];
		_sendBuffer.writeByte(mask[0]);
		_sendBuffer.writeByte(mask[1]);
		_sendBuffer.writeByte(mask[2]);
		_sendBuffer.writeByte(mask[3]);
		if (data != null)
		{
			var maskedData = new ByteArray();
			data.position = 0;
			for (i in 0...data.length)
			{
				_sendBuffer.writeByte(data.readByte() ^ mask[i % 4]);
			}
		}
	}

	public function flush():Void
	{
		if (_pendingSendData == null || _pendingSendData.length == 0) return;
		sendFrame(FRAME_OPCODE_BINARY, true, _pendingSendData);
		_pendingSendData = null;
	}

	public function writeBytes(data:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		if (_pendingSendData == null) _pendingSendData = new ByteArray();
		_pendingSendData.writeBytes(data);
	}

	public function writeUTFBytes(data:ByteArray):Void
	{
		if (_pendingSendData == null) _pendingSendData = new ByteArray();
		_pendingSendData.writeBytes(data);
	}

	private function receiveByte(byte:Int):Bool
	{
		switch (_receiveState)
		{
			case RECEIVESTATE_FRAME_INIT:
				_receiveFrameOpcode = byte & 0xF;
				_receiveFrameFin = (byte >> 7) != 0;
				_receiveData = null;
				_receiveDataLength = 0;
				_receiveState = RECEIVESTATE_FRAME_LENGTH;
			case RECEIVESTATE_FRAME_LENGTH:
				if (byte & 0x80 != 0) throw "receiveByte(): invalid data";
				var frameLength:Int = byte & 0x7F;
				if (frameLength == 126)
				{
					_receiveData = new ByteArray();
					_receiveDataLength = 2;
					_receiveState = RECEIVESTATE_FRAME_LENGTH16;
				}
				else if (frameLength > 126)
				{
					_receiveData = new ByteArray();
					_receiveDataLength = 4;
					_receiveState = RECEIVESTATE_FRAME_LENGTH32;
				}
				else
				{
					_receiveData = new ByteArray();
					_receiveDataLength = frameLength;
					_receiveState = RECEIVESTATE_FRAME_DATA;
				}
			case RECEIVESTATE_FRAME_LENGTH16:
				_receiveData.writeByte(byte);
				if (_receiveData.position == _receiveDataLength)
				{
					_receiveData.position = 0;
					var frameLengthByte0:Int = _receiveData.readByte();
					var frameLengthByte1:Int = _receiveData.readByte();

					_receiveData = new ByteArray();
					_receiveDataLength = ((frameLengthByte0 & 0xff) << 8) + (frameLengthByte1 & 0xff);
					_receiveState = RECEIVESTATE_FRAME_DATA;
				}
			case RECEIVESTATE_FRAME_LENGTH32:
				_receiveData.writeByte(byte);
				if (_receiveData.position == _receiveDataLength)
				{
					_receiveData.position = 0;
					var frameLengthByte0:Int = _receiveData.readByte();
					var frameLengthByte1:Int = _receiveData.readByte();
					var frameLengthByte2:Int = _receiveData.readByte();
					var frameLengthByte3:Int = _receiveData.readByte();

					_receiveData = new ByteArray();
					_receiveDataLength = ((frameLengthByte0 & 0xff) << 24) + ((frameLengthByte1 & 0xff) << 16) + ((frameLengthByte2 & 0xff) << 8)
						+ (frameLengthByte3 & 0xff);
					_receiveState = RECEIVESTATE_FRAME_DATA;
				}
			case RECEIVESTATE_FRAME_DATA:
				_receiveData.writeByte(byte);
				if (_receiveData.position == _receiveDataLength)
				{
					if (_pendingReceiveData == null) _pendingReceiveData = new ByteArray();
					_pendingReceiveData.writeBytes(_receiveData, 0, _receiveData.position);

					_receiveData = null;
					_receiveDataLength = 0;
					_receiveState = RECEIVESTATE_FRAME_INIT;

					//
					switch (_receiveFrameOpcode)
					{
						case FRAME_OPCODE_PING:
							sendFrame(FRAME_OPCODE_PONG, true, null);
						case FRAME_OPCODE_CLOSE:
							dispatchEvent(new Event(Event.CLOSE));
						/*
							throw new CloseException
							(
								frame.data.length >= 2 ? (frame.data.readByte() << 8) | frame.data.readByte() : 0,
								frame.data.length > 2 ? frame.data.readUTFBytes(frame.data.length - 2) : "" // not sure here
							);
						 */
						default:
							if (_receiveFrameFin == true)
							{
								_receiveFrameFin = false;
								_pendingReceiveDataComplete = true;
								_pendingReceiveData.position = 0;
								return true;
							}
					}
				}
			default:
				throw "receiveByte(): unsupported state: " + _receiveState;
		}
		return false;
	}

	private function get_bytesAvailable():UInt
	{
		return _pendingReceiveDataComplete == true ? _pendingReceiveData.bytesAvailable : 0;
	}

	public function readBytes(data:ByteArray, offset:UInt = 0, length:UInt):Void
	{
		if (length > bytesAvailable)
		{
			throw "readBytes(): Not enough data available";
		}

		data.position = offset;
		for (i in 0...length)
			data.writeByte(_pendingReceiveData.readByte());

		if (_pendingReceiveData.position == _pendingReceiveData.length)
		{
			_pendingReceiveDataComplete = false;
			_pendingReceiveData = null;
		}
	}

	public function readUTFBytes(length:UInt):String
	{
		var data:ByteArray = new ByteArray(length);
		readBytes(data, 0, data.length);
		return data.toString();
	}

	private function run():Void
	{
		try
		{
			// query if to write or read if requested
			var result = Socket.select(_pendingReceiveDataComplete == true ? _emptySockets : _readSockets,
				_sendBuffer.position == 0 ? _emptySockets : _writeSockets, _emptySockets, 0.033);
			// read?
			if (result.read.length > 0)
			{
				// read exactly one web socket frame
				while (receiveByte(_socket.input.readByte()) == false) {}
				// we got new data
				dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
			}
			// write?
			if (result.write.length > 0)
			{
				// write and flush send buffer
				_socket.output.writeBytes(_sendBuffer, 0, _sendBuffer.position);
				_socket.output.flush();
				_sendBuffer = new ByteArray();
			}
		}
		catch (e:Dynamic)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			initialize();
		}
	}
}
