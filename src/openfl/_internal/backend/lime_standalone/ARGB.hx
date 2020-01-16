package openfl._internal.backend.lime_standalone; #if openfl_html5

import openfl._internal.bindings.typedarray.UInt8Array;

abstract ARGB(UInt) from Int to Int from UInt to UInt
{
	private static var a16:Int;
	private static var unmult:Float;

	public var a(get, set):Int;
	public var b(get, set):Int;
	public var g(get, set):Int;
	public var r(get, set):Int;

	public inline function new(argb:Int = 0)
	{
		this = argb;
	}

	public static inline function create(a:Int, r:Int, g:Int, b:Int):ARGB
	{
		var argb = new ARGB();
		argb.set(a, r, g, b);
		return argb;
	}

	public inline function multiplyAlpha():Void
	{
		if (a == 0)
		{
			this = 0;
		}
		else if (a != 0xFF)
		{
			a16 = RGBA.__alpha16[a];
			set(a, (r * a16) >> 16, (g * a16) >> 16, (b * a16) >> 16);
		}
	}

	public inline function readUInt8(data:UInt8Array, offset:Int, format:PixelFormat = RGBA32, premultiplied:Bool = false):Void
	{
		switch (format)
		{
			case BGRA32:
				set(data[offset + 1], data[offset], data[offset + 3], data[offset + 2]);

			case RGBA32:
				set(data[offset + 1], data[offset + 2], data[offset + 3], data[offset]);

			case ARGB32:
				set(data[offset + 2], data[offset + 3], data[offset], data[offset + 1]);
		}

		if (premultiplied)
		{
			unmultiplyAlpha();
		}
	}

	public inline function set(a:Int, r:Int, g:Int, b:Int):Void
	{
		this = ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
	}

	public inline function unmultiplyAlpha()
	{
		if (a != 0 && a != 0xFF)
		{
			unmult = 255.0 / a;
			set(a, RGBA.__clamp[Math.floor(r * unmult)], RGBA.__clamp[Math.floor(g * unmult)], RGBA.__clamp[Math.floor(b * unmult)]);
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

	@:from private static inline function __fromBGRA(bgra:BGRA):ARGB
	{
		return ARGB.create(bgra.a, bgra.r, bgra.g, bgra.b);
	}

	@:from private static inline function __fromRGBA(rgba:RGBA):ARGB
	{
		return ARGB.create(rgba.a, rgba.r, rgba.g, rgba.b);
	}

	// Get & Set Methods
	@:noCompletion private inline function get_a():Int
	{
		return (this >> 24) & 0xFF;
	}

	@:noCompletion private inline function set_a(value:Int):Int
	{
		set(value, r, g, b);
		return value;
	}

	@:noCompletion private inline function get_b():Int
	{
		return this & 0xFF;
	}

	@:noCompletion private inline function set_b(value:Int):Int
	{
		set(a, r, g, value);
		return value;
	}

	@:noCompletion private inline function get_g():Int
	{
		return (this >> 8) & 0xFF;
	}

	@:noCompletion private inline function set_g(value:Int):Int
	{
		set(a, r, value, b);
		return value;
	}

	@:noCompletion private inline function get_r():Int
	{
		return (this >> 16) & 0xFF;
	}

	@:noCompletion private inline function set_r(value:Int):Int
	{
		set(a, value, g, b);
		return value;
	}
}
#end
