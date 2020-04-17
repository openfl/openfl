import ARGB from "./ARGB";
import PixelFormat from "./PixelFormat";
import RGBA from "./RGBA";

export default class BGRA
{
	private static a16: number;
	private static unmult: number;

	public a: number;
	public b: number;
	public g: number;
	public r: number;

	public constructor(bgra: number = 0)
	{
		this.b = (bgra >> 24) & 0xFF;
		this.g = (bgra >> 16) & 0xFF;
		this.r = (bgra >> 8) & 0xFF;
		this.a = bgra & 0xFF;
	}

	public static create(b: number, g: number, r: number, a: number): BGRA
	{
		var bgra = new BGRA();
		bgra.set(b, g, r, a);
		return bgra;
	}

	public get(): number
	{
		return ((this.b & 0xFF) << 24) | ((this.g & 0xFF) << 16) | ((this.r & 0xFF) << 8) | (this.a & 0xFF);
	}

	public multiplyAlpha(): void
	{
		if (this.a == 0)
		{
			this.set(0, 0, 0, 0);
		}
		else if (this.a != 0xFF)
		{
			BGRA.a16 = RGBA.__alpha16[this.a];
			this.set((this.b * BGRA.a16) >> 16, (this.g * BGRA.a16) >> 16, (this.r * BGRA.a16) >> 16, this.a);
		}
	}

	public readUInt8(data: Uint8Array, offset: number, format: PixelFormat = PixelFormat.RGBA32, premultiplied: boolean = false): void
	{
		switch (format)
		{
			case PixelFormat.BGRA32:
				this.set(data[offset], data[offset + 1], data[offset + 2], data[offset + 3]);
				break;

			case PixelFormat.RGBA32:
				this.set(data[offset + 2], data[offset + 1], data[offset], data[offset + 3]);
				break;

			case PixelFormat.ARGB32:
				this.set(data[offset + 3], data[offset + 2], data[offset + 1], data[offset]);
				break;
		}

		if (premultiplied)
		{
			this.unmultiplyAlpha();
		}
	}

	public set(b: number, g: number, r: number, a: number): void
	{
		this.b = b & 0xFF;
		this.g = g & 0xFF;
		this.r = r & 0xFF;
		this.a = a & 0xFF;
	}

	public unmultiplyAlpha()
	{
		if (this.a != 0 && this.a != 0xFF)
		{
			BGRA.unmult = 255.0 / this.a;
			this.set(RGBA.__clamp[Math.floor(this.b * BGRA.unmult)], RGBA.__clamp[Math.floor(this.g * BGRA.unmult)], RGBA.__clamp[Math.floor(this.r * BGRA.unmult)], this.a);
		}
	}

	public writeUInt8(data: Uint8Array, offset: number, format: PixelFormat = PixelFormat.RGBA32, premultiplied: boolean = false): void
	{
		if (premultiplied)
		{
			this.multiplyAlpha();
		}

		switch (format)
		{
			case PixelFormat.BGRA32:
				data[offset] = this.b;
				data[offset + 1] = this.g;
				data[offset + 2] = this.r;
				data[offset + 3] = this.a;
				break;

			case PixelFormat.RGBA32:
				data[offset] = this.r;
				data[offset + 1] = this.g;
				data[offset + 2] = this.b;
				data[offset + 3] = this.a;
				break;

			case PixelFormat.ARGB32:
				data[offset] = this.a;
				data[offset + 1] = this.r;
				data[offset + 2] = this.g;
				data[offset + 3] = this.b;
				break;
		}
	}

	private static __fromARGB(argb: BGRA): BGRA
	{
		return BGRA.create(argb.b, argb.g, argb.r, argb.a);
	}

	private static __fromRGBA(rgba: RGBA): BGRA
	{
		return BGRA.create(rgba.b, rgba.g, rgba.r, rgba.a);
	}
}
