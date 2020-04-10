import BGRA from "./BGRA";
import PixelFormat from "./PixelFormat";
import RGBA from "./RGBA";

export default class ARGB
{
	private static a16: number;
	private static unmult: number;

	public a: number;
	public b: number;
	public g: number;
	public r: number;

	public constructor(argb: number = 0)
	{
		this.a = (argb >> 24) & 0xFF;
		this.r = (argb >> 16) & 0xFF;
		this.g = (argb >> 8) & 0xFF;
		this.b = argb & 0xFF;
	}

	public static create(a: number, r: number, g: number, b: number): ARGB
	{
		var argb = new ARGB();
		argb.set(a, r, g, b);
		return argb;
	}

	public get(): number
	{
		return ((this.a & 0xFF) << 24) | ((this.r & 0xFF) << 16) | ((this.g & 0xFF) << 8) | (this.b & 0xFF);
	}

	public multiplyAlpha(): void
	{
		if (this.a == 0)
		{
			this.set(0, 0, 0, 0);
		}
		else if (this.a != 0xFF)
		{
			ARGB.a16 = RGBA.__alpha16[this.a];
			this.set(this.a, (this.r * ARGB.a16) >> 16, (this.g * ARGB.a16) >> 16, (this.b * ARGB.a16) >> 16);
		}
	}

	public readUInt8(data: Uint8Array, offset: number, format: PixelFormat = PixelFormat.RGBA32, premultiplied: boolean = false): void
	{
		switch (format)
		{
			case PixelFormat.BGRA32:
				this.set(data[offset + 1], data[offset], data[offset + 3], data[offset + 2]);
				break;

			case PixelFormat.RGBA32:
				this.set(data[offset + 1], data[offset + 2], data[offset + 3], data[offset]);
				break;

			case PixelFormat.ARGB32:
				this.set(data[offset + 2], data[offset + 3], data[offset], data[offset + 1]);
				break;
		}

		if (premultiplied)
		{
			this.unmultiplyAlpha();
		}
	}

	public set(a: number, r: number, g: number, b: number): void
	{
		this.a = a & 0xFF;
		this.r = r & 0xFF;
		this.g = g & 0xFF;
		this.b = b & 0xFF;
	}

	public unmultiplyAlpha()
	{
		if (this.a != 0 && this.a != 0xFF)
		{
			ARGB.unmult = 255.0 / this.a;
			this.set(this.a, RGBA.__clamp[Math.floor(this.r * ARGB.unmult)], RGBA.__clamp[Math.floor(this.g * ARGB.unmult)], RGBA.__clamp[Math.floor(this.b * ARGB.unmult)]);
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

			case PixelFormat.ARGB32:
				data[offset] = this.a;
				data[offset + 1] = this.r;
				data[offset + 2] = this.g;
				data[offset + 3] = this.b;
		}
	}

	private static __fromBGRA(bgra: BGRA): ARGB
	{
		return ARGB.create(bgra.a, bgra.r, bgra.g, bgra.b);
	}

	private static __fromRGBA(rgba: RGBA): ARGB
	{
		return ARGB.create(rgba.a, rgba.r, rgba.g, rgba.b);
	}
}
