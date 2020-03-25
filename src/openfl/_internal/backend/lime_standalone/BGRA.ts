namespace openfl._internal.backend.lime_standalone; #if openfl_html5

import openfl._internal.bindings.typedarray.UInt8Array;

abstract BGRA(UInt) from Int to Int from UInt to UInt
{
	private static a16: number;
	private static unmult: number;

	public a(get, set) : number;
	public b(get, set) : number;
	public g(get, set) : number;
	public r(get, set) : number;

	public inline new (bgra : number = 0)
	{
		this = bgra;
	}

	public static readonly create(b : number, g : number, r : number, a : number): BGRA
	{
		var bgra = new BGRA();
		bgra.set(b, g, r, a);
		return bgra;
	}

	public inline multiplyAlpha()
	{
		if (a == 0)
		{
			this = 0;
		}
		else if (a != 0xFF)
		{
			a16 = RGBA.__alpha16[a];
			set((b * a16) >> 16, (g * a16) >> 16, (r * a16) >> 16, a);
		}
	}

	public inline readUInt8(data: UInt8Array, offset : number, format: PixelFormat = RGBA32, premultiplied : boolean = false): void
		{
			switch(format)
			{
			case BGRA32:
			set(data[offset], data[offset + 1], data[offset + 2], data[offset + 3]);

			case RGBA32:
	set(data[offset + 2], data[offset + 1], data[offset], data[offset + 3]);

			case ARGB32:
	set(data[offset + 3], data[offset + 2], data[offset + 1], data[offset]);
}

if (premultiplied)
{
	unmultiplyAlpha();
}
	}

	public inline set(b : number, g : number, r : number, a : number): void
	{
		this = ((b & 0xFF) << 24) | ((g & 0xFF) << 16) | ((r & 0xFF) << 8) | (a & 0xFF);
	}

	public inline unmultiplyAlpha()
{
	if (a != 0 && a != 0xFF)
	{
		unmult = 255.0 / a;
		set(RGBA.__clamp[Math.floor(b * unmult)], RGBA.__clamp[Math.floor(g * unmult)], RGBA.__clamp[Math.floor(r * unmult)], a);
	}
}

	public inline writeUInt8(data: UInt8Array, offset : number, format: PixelFormat = RGBA32, premultiplied : boolean = false): void
	{
		if(premultiplied)
		{
			multiplyAlpha();
		}

		switch(format)
		{
			case BGRA32:
		data[offset] = b;
		data[offset + 1] = g;
		data[offset + 2] = r;
		data[offset + 3] = a;

		case RGBA32:
		data[offset] = r;
		data[offset + 1] = g;
		data[offset + 2] = b;
		data[offset + 3] = a;

		case ARGB32:
		data[offset] = a;
		data[offset + 1] = r;
		data[offset + 2] = g;
		data[offset + 3] = b;
	}
	}

@: from private static readonly __fromARGB(argb: ARGB): BGRA
{
	return BGRA.create(argb.b, argb.g, argb.r, argb.a);
}

@: from private static readonly __fromRGBA(rgba: RGBA): BGRA
{
	return BGRA.create(rgba.b, rgba.g, rgba.r, rgba.a);
}

	// Get & Set Methods
	protected inline get_a() : number
{
	return this & 0xFF;
}

	protected inline set_a(value : number) : number
{
	set(b, g, r, value);
	return value;
}

	protected inline get_b() : number
{
	return (this >> 24) & 0xFF;
}

	protected inline set_b(value : number) : number
{
	set(value, g, r, a);
	return value;
}

	protected inline get_g() : number
{
	return (this >> 16) & 0xFF;
}

	protected inline set_g(value : number) : number
{
	set(b, value, r, a);
	return value;
}

	protected inline get_r() : number
{
	return (this >> 8) & 0xFF;
}

	protected inline set_r(value : number) : number
{
	set(b, g, value, a);
	return value;
}
}
#end
