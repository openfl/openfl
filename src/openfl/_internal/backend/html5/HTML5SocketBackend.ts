namespace openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Bytes;
import haxe.Timer;
import js.html.WebSocket;
import js.Browser;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import Lib from "../_internal/Lib";
import openfl.errors.IOError;
import Event from "../events/Event";
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.Socket;
import ByteArray from "../utils/ByteArray";
import openfl.utils.Endian;

@: access(openfl.net.Socket)
class HTML5SocketBackend
{
	private buffer: Bytes;
	private endian: Endian;
	private input: ByteArray;
	private output: ByteArray;
	private parent: Socket;
	private socket: WebSocket;
	private timestamp: number;

	public constructor(parent: Socket)
	{
		this.parent = parent;

		buffer = Bytes.alloc(4096);
	}

	private cleanSocket(): void
	{
		try
		{
			socket.close();
		}
		catch (e: Dynamic) { }

		socket = null;
		@: privateAccess parent.connected = false;
		Lib.current.removeEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public close(): void
	{
		if (socket != null)
		{
			cleanSocket();
		}
	}

	public connect(host: string = null, port: number = 0): void
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

	public flush(): void
	{
		if (output.length > 0)
		{
			try
			{
				var buffer: ArrayBuffer = output;
				if (buffer.byteLength > output.length) buffer = buffer.slice(0, output.length);
				socket.send(buffer);
				output = new ByteArray();
				output.endian = endian;
			}
			catch (e: Dynamic)
			{
				throw new IOError("Operation attempted on invalid socket.");
			}
		}
	}

	public getBytesAvailable(): number
	{
		return input.bytesAvailable;
	}

	public getBytesPending(): number
	{
		return output.length;
	}

	public getEndian(): Endian
	{
		return endian;
	}

	public readBoolean(): boolean
	{
		return input.readBoolean();
	}

	public readByte(): number
	{
		return input.readByte();
	}

	public readBytes(bytes: ByteArray, offset: number = 0, length: number = 0): void
	{
		input.readBytes(bytes, offset, length);
	}

	public readDouble(): number
	{
		return input.readDouble();
	}

	public readFloat(): number
	{
		return input.readFloat();
	}

	public readInt(): number
	{
		return input.readInt();
	}

	public readMultiByte(length: number, charSet: string): string
	{
		return input.readMultiByte(length, charSet);
	}

	public readShort(): number
	{
		return input.readShort();
	}

	public readUnsignedByte(): number
	{
		return input.readUnsignedByte();
	}

	public readUnsignedInt(): number
	{
		return input.readUnsignedInt();
	}

	public readUnsignedShort(): number
	{
		return input.readUnsignedShort();
	}

	public readUTF(): string
	{
		return input.readUTF();
	}

	public readUTFBytes(length: number): string
	{
		return input.readUTFBytes(length);
	}

	public setEndian(value: Endian): Endian
	{
		endian = value;

		if (input != null) input.endian = value;
		if (output != null) output.endian = value;

		return endian;
	}

	public writeBoolean(value: boolean): void
	{
		output.writeBoolean(value);
	}

	public writeByte(value: number): void
	{
		output.writeByte(value);
	}

	public writeBytes(bytes: ByteArray, offset: number = 0, length: number = 0): void
	{
		output.writeBytes(bytes, offset, length);
	}

	public writeDouble(value: number): void
	{
		output.writeDouble(value);
	}

	public writeFloat(value: number): void
	{
		output.writeFloat(value);
	}

	public writeInt(value: number): void
	{
		output.writeInt(value);
	}

	public writeMultiByte(value: string, charSet: string): void
	{
		output.writeUTFBytes(value);
	}

	public writeShort(value: number): void
	{
		output.writeShort(value);
	}

	public writeUnsignedInt(value: number): void
	{
		output.writeUnsignedInt(value);
	}

	public writeUTF(value: string): void
	{
		output.writeUTF(value);
	}

	public writeUTFBytes(value: string): void
	{
		output.writeUTFBytes(value);
	}

	// Event Handlers
	private socket_onClose(_): void
	{
		parent.dispatchEvent(new Event(Event.CLOSE));
	}

	private socket_onError(e): void
	{
		parent.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
	}

	private socket_onMessage(msg: Dynamic): void
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
			var newData: ByteArray = (msg.data : ArrayBuffer);
			newData.readBytes(input, input.length);
		}

		if (input.bytesAvailable > 0)
		{
			parent.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA, false, false, input.bytesAvailable, 0));
		}
	}

	private socket_onOpen(_): void
	{
		@: privateAccess parent.connected = true;
		parent.dispatchEvent(new Event(Event.CONNECT));
	}

	private this_onEnterFrame(event: Event): void
	{
		if (socket != null)
		{
			flush();
		}
	}
}
#end
