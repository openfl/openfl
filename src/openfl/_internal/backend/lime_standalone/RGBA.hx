package openfl._internal.backend.lime_standalone; #if openfl_html5

import openfl._internal.bindings.typedarray.UInt8Array;
#if haxe4
import js.lib.Uint32Array as UInt32Array;
#else
import js.html5.Uint32Array as UInt32Array;
#end

@:allow(openfl._internal.backend.lime_standalone)
abstract RGBA(UInt) from Int to Int from UInt to UInt
{
	private static var __alpha16:UInt32Array;
	private static var __clamp:UInt8Array;
	private static var a16:Int;
	private static var unmult:Float;

	public var a(get, set):Int;
	public var b(get, set):Int;
	public var g(get, set):Int;
	public var r(get, set):Int;

	private static function __init__():Void
	{
		#if (js && modular)
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

	#if (js && modular)
	private static function __initColors()
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

	public inline function new(rgba:Int = 0)
	{
		this = rgba;
	}

	public static inline function create(r:Int, g:Int, b:Int, a:Int):RGBA
	{
		var rgba = new RGBA();
		rgba.set(r, g, b, a);
		return rgba;
	}

	public inline function multiplyAlpha()
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

	public inline function readUInt8(data:UInt8Array, offset:Int, format:PixelFormat = RGBA32, premultiplied:Bool = false):Void
	{
		switch (format)
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

	public inline function set(r:Int, g:Int, b:Int, a:Int):Void
	{
		this = ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | (a & 0xFF);
	}

	public inline function unmultiplyAlpha()
	{
		if (a != 0 && a != 0xFF)
		{
			unmult = 255.0 / a;
			set(__clamp[Math.round(r * unmult)], __clamp[Math.round(g * unmult)], __clamp[Math.round(b * unmult)], a);
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

	@:from private static inline function __fromARGB(argb:ARGB):RGBA
	{
		return RGBA.create(argb.r, argb.g, argb.b, argb.a);
	}

	@:from private static inline function __fromBGRA(bgra:BGRA):RGBA
	{
		return RGBA.create(bgra.r, bgra.g, bgra.b, bgra.a);
	}

	// Get & Set Methods
	@:noCompletion private inline function get_a():Int
	{
		return this & 0xFF;
	}

	@:noCompletion private inline function set_a(value:Int):Int
	{
		set(r, g, b, value);
		return value;
	}

	@:noCompletion private inline function get_b():Int
	{
		return (this >> 8) & 0xFF;
	}

	@:noCompletion private inline function set_b(value:Int):Int
	{
		set(r, g, value, a);
		return value;
	}

	@:noCompletion private inline function get_g():Int
	{
		return (this >> 16) & 0xFF;
	}

	@:noCompletion private inline function set_g(value:Int):Int
	{
		set(r, value, b, a);
		return value;
	}

	@:noCompletion private inline function get_r():Int
	{
		return (this >> 24) & 0xFF;
	}

	@:noCompletion private inline function set_r(value:Int):Int
	{
		set(value, g, b, a);
		return value;
	}
}
#end
