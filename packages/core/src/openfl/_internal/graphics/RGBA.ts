import ARGB from "./ARGB";
import BGRA from "./BGRA";
import PixelFormat from "./PixelFormat";

export default class RGBA
{
	public static __alpha16: Uint32Array = new Uint32Array(256);
	public static __clamp: Uint8Array = new Uint8Array(0xFF + 0xFF + 1);
	private static a16: number;
	private static unmult: number;

	public a: number;
	public b: number;
	public g: number;
	public r: number;

	public constructor(rgba: number = 0)
	{
		this.r = (rgba >> 24) & 0xFF;
		this.g = (rgba >> 16) & 0xFF;
		this.b = (rgba >> 8) & 0xFF;
		this.a = rgba & 0xFF;
	}

	public static create(r: number, g: number, b: number, a: number): RGBA
	{
		var rgba = new RGBA();
		rgba.set(r, g, b, a);
		return rgba;
	}

	public get(): number
	{
		return ((this.r & 0xFF) << 24) | ((this.g & 0xFF) << 16) | ((this.b & 0xFF) << 8) | (this.a & 0xFF);
	}

	public multiplyAlpha()
	{
		if (this.a == 0)
		{
			this.set(0, 0, 0, 0);
		}
		else if (this.a != 0xFF)
		{
			RGBA.a16 = RGBA.__alpha16[this.a];
			this.set((this.r * RGBA.a16) >> 16, (this.g * RGBA.a16) >> 16, (this.b * RGBA.a16) >> 16, this.a);
		}
	}

	public readUInt8(data: Uint8Array, offset: number, format: PixelFormat = PixelFormat.RGBA32, premultiplied: boolean = false): void
	{
		switch (format)
		{
			case PixelFormat.BGRA32:
				this.set(data[offset + 2], data[offset + 1], data[offset], data[offset + 3]);
				break;

			case PixelFormat.RGBA32:
				this.set(data[offset], data[offset + 1], data[offset + 2], data[offset + 3]);
				break;

			case PixelFormat.ARGB32:
				this.set(data[offset + 1], data[offset + 2], data[offset + 3], data[offset]);
				break;
		}

		if (premultiplied)
		{
			this.unmultiplyAlpha();
		}
	}

	public set(r: number, g: number, b: number, a: number): void
	{
		this.r = r & 0xFF;
		this.g = g & 0xFF;
		this.b = b & 0xFF;
		this.a = a & 0xFF;
	}

	public unmultiplyAlpha()
	{
		if (this.a != 0 && this.a != 0xFF)
		{
			RGBA.unmult = 255.0 / this.a;
			this.set(RGBA.__clamp[Math.round(this.r * RGBA.unmult)], RGBA.__clamp[Math.round(this.g * RGBA.unmult)], RGBA.__clamp[Math.round(this.b * RGBA.unmult)], this.a);
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

	private static __fromARGB(argb: ARGB): RGBA
	{
		return RGBA.create(argb.r, argb.g, argb.b, argb.a);
	}

	private static __fromBGRA(bgra: BGRA): RGBA
	{
		return RGBA.create(bgra.r, bgra.g, bgra.b, bgra.a);
	}
}

for (let i = 0; i < 256; i++)
{
	(<any>RGBA).__alpha16[i] = Math.ceil((i) * ((1 << 16) / 0xFF));
}

for (let i = 0; i < 0xFF;)
{
	(<any>RGBA).__clamp[i] = i;
}

for (let i = 0xFF; i < (0xFF + 0xFF + 1); i++)
{
	(<any>RGBA).__clamp[i] = 0xFF;
}
