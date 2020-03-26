namespace openfl._internal.backend.lime_standalone; #if openfl_html5

import openfl._internal.bindings.typedarray.UInt8Array;
#if haxe4
import js.lib.Uint32Array as UInt32Array;
#else
import js.html5.Uint32Array as UInt32Array;
#end

@: allow(openfl._internal.backend.lime_standalone)
abstract RGBA(UInt) from Int to Int from UInt to UInt
{
	private static __alpha16: number32Array;
	private static __clamp: number8Array;
	private static a16: number;
	private static unmult: number;

	public a(get, set) : number;
	public b(get, set) : number;
	public g(get, set) : number;
	public r(get, set) : number;

	private static __init__(): void
		{
			#if(js && modular)
	__initColors();
		#else
	__alpha16 = new UInt32Array(256);

	for (i in 0...256)
	{
		__alpha16[i] = Math.ceil((i) * ((1 << 16) / 0xFF));
	}

	__clamp = new UInt8Array(0xFF + 0xFF + 1);

	for (i in 0...0xFF)
	{
		__clamp[i] = i;
	}

	for (i in 0xFF...(0xFF + 0xFF + 1))
	{
		__clamp[i] = 0xFF;
	}
		#end
}

	#if(js && modular)
	private static __initColors()
{
	__alpha16 = new UInt32Array(256);

	for (i in 0...256)
	{
		__alpha16[i] = Math.ceil((i) * ((1 << 16) / 0xFF));
	}

	__clamp = new UInt8Array(0xFF + 0xFF);

	for (i in 0...0xFF)
	{
		__clamp[i] = i;
	}

	for (i in 0xFF...(0xFF + 0xFF + 1))
	{
		__clamp[i] = 0xFF;
	}
}
	#end

	public inline new (rgba : number = 0)
{
	this = rgba;
}

	public static readonly create(r : number, g : number, b : number, a : number): RGBA
{
	var rgba = new RGBA();
	rgba.set(r, g, b, a);
	return rgba;
}

	public inline multiplyAlpha()
{
	if (a == 0)
	{
		if (this != 0)
		{
			this = 0;
		}
	}
	else if (a != 0xFF)
	{
		a16 = __alpha16[a];
		set((r * a16) >> 16, (g * a16) >> 16, (b * a16) >> 16, a);
	}
}

	public inline readUInt8(data: number8Array, offset : number, format: PixelFormat = RGBA32, premultiplied : boolean = false): void
	{
		switch(format)
		{
			case BGRA32:
		set(data[offset + 2], data[offset + 1], data[offset], data[offset + 3]);

			case RGBA32:
set(data[offset], data[offset + 1], data[offset + 2], data[offset + 3]);

			case ARGB32:
set(data[offset + 1], data[offset + 2], data[offset + 3], data[offset]);
		}

if (premultiplied)
{
	unmultiplyAlpha();
}
	}

	public inline set(r : number, g : number, b : number, a : number): void
	{
		this = ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | (a & 0xFF);
	}

	public inline unmultiplyAlpha()
{
	if (a != 0 && a != 0xFF)
	{
		unmult = 255.0 / a;
		set(__clamp[Math.round(r * unmult)], __clamp[Math.round(g * unmult)], __clamp[Math.round(b * unmult)], a);
	}
}

	public inline writeUInt8(data: number8Array, offset : number, format: PixelFormat = RGBA32, premultiplied : boolean = false): void
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

@: from private static readonly __fromARGB(argb: ARGB): RGBA
{
	return RGBA.create(argb.r, argb.g, argb.b, argb.a);
}

@: from private static readonly __fromBGRA(bgra: BGRA): RGBA
{
	return RGBA.create(bgra.r, bgra.g, bgra.b, bgra.a);
}

	// Get & Set Methods
	protected inline get_a() : number
{
	return this & 0xFF;
}

	protected inline set_a(value : number) : number
{
	set(r, g, b, value);
	return value;
}

	protected inline get_b() : number
{
	return (this >> 8) & 0xFF;
}

	protected inline set_b(value : number) : number
{
	set(r, g, value, a);
	return value;
}

	protected inline get_g() : number
{
	return (this >> 16) & 0xFF;
}

	protected inline set_g(value : number) : number
{
	set(r, value, b, a);
	return value;
}

	protected inline get_r() : number
{
	return (this >> 24) & 0xFF;
}

	protected inline set_r(value : number) : number
{
	set(value, g, b, a);
	return value;
}
}
#end
