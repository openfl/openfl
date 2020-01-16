package openfl._internal.backend.lime_standalone; #if openfl_html5

import openfl._internal.bindings.typedarray.UInt8Array;

abstract BGRA(UInt) from Int to Int from UInt to UInt
{
	private static var a16:Int;
	private static var unmult:Float;

	public var a(get, set):Int;
	public var b(get, set):Int;
	public var g(get, set):Int;
	public var r(get, set):Int;

	public inline function new(bgra:Int = 0)
	{
		this = bgra;
	}

	public static inline function create(b:Int, g:Int, r:Int, a:Int):BGRA
	{
		var bgra = new BGRA();
		bgra.set(b, g, r, a);
		return bgra;
	}

	public inline function multiplyAlpha()
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

	public inline function readUInt8(data:UInt8Array, offset:Int, format:PixelFormat = RGBA32, premultiplied:Bool = false):Void
	{
		switch (format)
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

	public inline function set(b:Int, g:Int, r:Int, a:Int):Void
	{
		this = ((b & 0xFF) << 24) | ((g & 0xFF) << 16) | ((r & 0xFF) << 8) | (a & 0xFF);
	}

	public inline function unmultiplyAlpha()
	{
		if (a != 0 && a != 0xFF)
		{
			unmult = 255.0 / a;
			set(RGBA.__clamp[Math.floor(b * unmult)], RGBA.__clamp[Math.floor(g * unmult)], RGBA.__clamp[Math.floor(r * unmult)], a);
		}
	}

	public inline function writeUInt8(data:UInt8Array, offset:Int, format:PixelFormat = RGBA32, premultiplied:Bool = false):Void
	{
		if (premultiplied)
		{
			multiplyAlpha();
		}

		switch (format)
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

	@:from private static inline function __fromARGB(argb:ARGB):BGRA
	{
		return BGRA.create(argb.b, argb.g, argb.r, argb.a);
	}

	@:from private static inline function __fromRGBA(rgba:RGBA):BGRA
	{
		return BGRA.create(rgba.b, rgba.g, rgba.r, rgba.a);
	}

	// Get & Set Methods
	@:noCompletion private inline function get_a():Int
	{
		return this & 0xFF;
	}

	@:noCompletion private inline function set_a(value:Int):Int
	{
		set(b, g, r, value);
		return value;
	}

	@:noCompletion private inline function get_b():Int
	{
		return (this >> 24) & 0xFF;
	}

	@:noCompletion private inline function set_b(value:Int):Int
	{
		set(value, g, r, a);
		return value;
	}

	@:noCompletion private inline function get_g():Int
	{
		return (this >> 16) & 0xFF;
	}

	@:noCompletion private inline function set_g(value:Int):Int
	{
		set(b, value, r, a);
		return value;
	}

	@:noCompletion private inline function get_r():Int
	{
		return (this >> 8) & 0xFF;
	}

	@:noCompletion private inline function set_r(value:Int):Int
	{
		set(b, g, value, a);
		return value;
	}
}
#end
