package openfl._internal.backend.lime_standalone;

#if openfl_html5
abstract KeyModifier(Int) from Int to Int from UInt to UInt
{
	public static inline var NONE:KeyModifier = 0x0000;
	public static inline var LEFT_SHIFT:KeyModifier = 0x0001;
	public static inline var RIGHT_SHIFT:KeyModifier = 0x0002;
	public static inline var LEFT_CTRL:KeyModifier = 0x0040;
	public static inline var RIGHT_CTRL:KeyModifier = 0x0080;
	public static inline var LEFT_ALT:KeyModifier = 0x0100;
	public static inline var RIGHT_ALT:KeyModifier = 0x0200;
	public static inline var LEFT_META:KeyModifier = 0x0400;
	public static inline var RIGHT_META:KeyModifier = 0x0800;
	public static inline var NUM_LOCK:KeyModifier = 0x1000;
	public static inline var CAPS_LOCK:KeyModifier = 0x2000;
	public static inline var MODE:KeyModifier = 0x4000;
	public static inline var CTRL:KeyModifier = (0x0040 | 0x0080);
	public static inline var SHIFT:KeyModifier = (0x001 | 0x0002);
	public static inline var ALT:KeyModifier = (0x0100 | 0x0200);
	public static inline var META:KeyModifier = (0x0400 | 0x0800);

	public var altKey(get, set):Bool;
	public var capsLock(get, set):Bool;
	public var ctrlKey(get, set):Bool;
	public var metaKey(get, set):Bool;
	public var numLock(get, set):Bool;
	public var shiftKey(get, set):Bool;

	@:noCompletion private function get_altKey():Bool
	{
		return (this & LEFT_ALT > 0) || (this & RIGHT_ALT > 0);
	}

	@:noCompletion private inline function set_altKey(value:Bool):Bool
	{
		if (value)
		{
			this |= ALT;
		}
		else
		{
			this &= 0xFFFFFFF - ALT;
		}

		return value;
	}

	@:noCompletion private function get_capsLock():Bool
	{
		return (this & CAPS_LOCK > 0) || (this & CAPS_LOCK > 0);
	}

	@:noCompletion private inline function set_capsLock(value:Bool):Bool
	{
		if (value)
		{
			this |= CAPS_LOCK;
		}
		else
		{
			this &= 0xFFFFFFF - CAPS_LOCK;
		}

		return value;
	}

	@:noCompletion private function get_ctrlKey():Bool
	{
		return (this & LEFT_CTRL > 0) || (this & RIGHT_CTRL > 0);
	}

	@:noCompletion private inline function set_ctrlKey(value:Bool):Bool
	{
		if (value)
		{
			this |= CTRL;
		}
		else
		{
			this &= 0xFFFFFFF - CTRL;
		}

		return value;
	}

	@:noCompletion private function get_metaKey():Bool
	{
		return (this & LEFT_META > 0) || (this & RIGHT_META > 0);
	}

	@:noCompletion private inline function set_metaKey(value:Bool):Bool
	{
		if (value)
		{
			this |= META;
		}
		else
		{
			this &= 0xFFFFFFF - META;
		}

		return value;
	}

	@:noCompletion private function get_numLock():Bool
	{
		return (this & NUM_LOCK > 0) || (this & NUM_LOCK > 0);
	}

	@:noCompletion private inline function set_numLock(value:Bool):Bool
	{
		if (value)
		{
			this |= NUM_LOCK;
		}
		else
		{
			this &= 0xFFFFFFF - NUM_LOCK;
		}

		return value;
	}

	@:noCompletion private function get_shiftKey():Bool
	{
		return (this & LEFT_SHIFT > 0) || (this & RIGHT_SHIFT > 0);
	}

	@:noCompletion private inline function set_shiftKey(value:Bool):Bool
	{
		if (value)
		{
			this |= SHIFT;
		}
		else
		{
			this &= 0xFFFFFFF - SHIFT;
		}

		return value;
	}
}
#end
