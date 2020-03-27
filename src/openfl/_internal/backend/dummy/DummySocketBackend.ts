namespace openfl._internal.backend.dummy;

import openfl.net.Socket;
import ByteArray from "../utils/ByteArray";
import openfl.utils.Endian;

class DummySocketBackend
{
	public constructor(parent: Socket) { }

	public close(): void { }

	public connect(host: string = null, port: number = 0): void { }

	public flush(): void { }

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
		return false;
	}

	public readByte(): number
	{
		return 0;
	}

	public readBytes(bytes: ByteArray, offset: number = 0, length: number = 0): void { }

	public readDouble(): number
	{
		return 0;
	}

	public readFloat(): number
	{
		return 0;
	}

	public readInt(): number
	{
		return 0;
	}

	public readMultiByte(length: number, charSet: string): string
	{
		return null;
	}

	public readShort(): number
	{
		return 0;
	}

	public readUnsignedByte(): number
	{
		return 0;
	}

	public readUnsignedInt(): number
	{
		return 0;
	}

	public readUnsignedShort(): number
	{
		return 0;
	}

	public readUTF(): string
	{
		return null;
	}

	public readUTFBytes(length: number): string
	{
		return null;
	}

	public setEndian(value: Endian): Endian
	{
		endian = value;

		if (input != null) input.endian = value;
		if (output != null) output.endian = value;

		return endian;
	}

	public writeBoolean(value: boolean): void { }

	public writeByte(value: number): void { }

	public writeBytes(bytes: ByteArray, offset: number = 0, length: number = 0): void { }

	public writeDouble(value: number): void { }

	public writeFloat(value: number): void { }

	public writeInt(value: number): void { }

	public writeMultiByte(value: string, charSet: string): void { }

	public writeShort(value: number): void { }

	public writeUnsignedInt(value: number): void { }

	public writeUTF(value: string): void { }

	public writeUTFBytes(value: string): void { }
}
