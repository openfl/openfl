namespace openfl._internal.backend.sys;

#if sys
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.Eof;
import haxe.io.Error;
import Lib from "../_internal/Lib";
import openfl.errors.IOError;
import Event from "../events/Event";
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.Socket;
import ByteArray from "../utils/ByteArray";
import openfl.utils.Endian;
import sys.net.Host;
import sys.net.Socket as SysSocket;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl.net.Socket)
class SysSocketBackend
{
	private buffer: Bytes;
	private endian: Endian;
	private input: ByteArray;
	private output: ByteArray;
	private parent: Socket;
	private socket: SysSocket;
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
		parent.connected = false;
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

		var h: Host = null;

		try
		{
			h = new Host(host);
		}
		catch (e: Dynamic)
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
		catch (e: Dynamic) { }

		Lib.current.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
	}

	public flush(): void
	{
		if (output.length > 0)
		{
			try
			{
				socket.output.writeBytes(output, 0, output.length);
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

	private socket_onOpen(_): void
	{
		parent.connected = true;
		parent.dispatchEvent(new Event(Event.CONNECT));
	}

	private this_onEnterFrame(event: Event): void
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
				var l: number;

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
			catch (e: Eof)
			{
				// ignore
			}
			catch (e: Error)
			{
				if (e != Error.Blocked)
				{
					doClose = true;
				}
			}
			catch (e: Dynamic)
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
			catch (e: IOError)
			{
				parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, true, false, e.message));
			}
		}
	}
}
#end
