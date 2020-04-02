import IllegalOperationError from "../../../errors/IllegalOperationError";
import ByteArray from "../../../utils/ByteArray";
import ATFFormat from "./ATFFormat";
import ATFGPUFormat from "./ATFGPUFormat";
import ATFType from "./ATFType";

type UploadCallback = (side: number, level: number, gpuFormat: ATFGPUFormat, width: number, height: number, blockLength: number, bytes: ByteArray) => void;

/**
	This class can read textures from Adobe Texture Format containers.
	Currently only ATF block compressed textures without JPEG-XR+LZMA are supported. You can create such files via:
	`png2atf -n 0,0 -c d -i texture.png -o compressed_texture.atf`

	To read a texture you need to perform these steps:
	- create a `new ATFReader()` instance
	- read the header with `readHeader()`
	- call `readTextures()` and a provide an upload callback

	The ATF specification can be found here:
	<https://www.adobe.com/devnet/archive/flashruntimes/articles/atf-file-format.html>
**/
export default class ATFReader
{
	private atfFormat: ATFFormat;
	private cubeMap: boolean;
	private data: ByteArray;
	private height: number;
	private mipCount: number;
	private version: number = 0;
	private width: number;

	public constructor(data: ByteArray, byteArrayOffset: number)
	{
		data.position = byteArrayOffset;
		var signature: string = data.readUTFBytes(3);
		data.position = byteArrayOffset;

		if (signature != "ATF")
		{
			throw new IllegalOperationError("ATF signature not found");
		}

		var length = 0;

		// When the 6th byte is 0xff, we have one of the new formats
		if (data[byteArrayOffset + 6] == 0xff)
		{
			this.version = data[byteArrayOffset + 7];
			data.position = byteArrayOffset + 8;
			length = this.__readUInt32(data);
		}
		else
		{
			this.version = 0;
			data.position = byteArrayOffset + 3;
			length = this.__readUInt24(data);
		}

		if ((byteArrayOffset + length) > data.length)
		{
			throw new IllegalOperationError("ATF length exceeds byte array length");
		}

		this.data = data;
	}

	public readHeader(__width: number, __height: number, cubeMap: boolean): boolean
	{
		var tdata = this.data.readUnsignedByte();
		var type: ATFType = (tdata >> 7);

		if (!cubeMap && (type != ATFType.NORMAL))
		{
			throw new IllegalOperationError("ATF Cube map not expected");
		}

		if (cubeMap && (type != ATFType.CUBE_MAP))
		{
			throw new IllegalOperationError("ATF Cube map expected");
		}

		this.cubeMap = cubeMap;

		this.atfFormat = (tdata & 0x7f);

		// Make sure it is one of the supported formats
		if (this.atfFormat != ATFFormat.RAW_COMPRESSED && this.atfFormat != ATFFormat.RAW_COMPRESSED_ALPHA)
		{
			console.warn("Only ATF block compressed textures without JPEG-XR+LZMA are supported");
		}

		this.width = (1 << this.data.readUnsignedByte());
		this.height = (1 << this.data.readUnsignedByte());

		if (this.width != __width || this.height != __height)
		{
			throw new IllegalOperationError("ATF width and height dont match");
		}

		this.mipCount = this.data.readUnsignedByte();

		return (this.atfFormat == ATFFormat.RAW_COMPRESSED_ALPHA);
	}

	public readTextures(uploadCallback: UploadCallback): void
	{
		// DXT1/5, ETC1, PVRTC4, ETC2
		// ETC2 is available with ATF version 3
		var gpuFormats = (this.version < 3) ? 3 : 4;
		var sideCount = this.cubeMap ? 6 : 1; // a cubemap has 6 sides

		for (let side = 0; side < sideCount; side++)
		{
			for (let level = 0; level < this.mipCount; level++)
			{
				for (let gpuFormat = 0; gpuFormat < gpuFormats; gpuFormat++)
				{
					var blockLength = (this.version == 0) ? this.__readUInt24(this.data) : this.__readUInt32(this.data);

					if ((this.data.position + blockLength) > this.data.length)
					{
						throw new IllegalOperationError("Block length exceeds ATF file length");
					}

					if (blockLength > 0)
					{
						var bytes = new ByteArray(blockLength);
						this.data.readBytes(bytes, 0, blockLength);

						uploadCallback(side, level, gpuFormat, this.width >> level, this.height >> level, blockLength, bytes);
					}
				}
			}
		}
	}

	private __readUInt24(data: ByteArray): number
	{
		var value: number;
		value = (data.readUnsignedByte() << 16);
		value |= (data.readUnsignedByte() << 8);
		value |= data.readUnsignedByte();
		return value;
	}

	private __readUInt32(data: ByteArray): number
	{
		var value: number;
		value = (data.readUnsignedByte() << 24);
		value |= (data.readUnsignedByte() << 16);
		value |= (data.readUnsignedByte() << 8);
		value |= data.readUnsignedByte();
		return value;
	}
}
