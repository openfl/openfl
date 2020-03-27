namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
abstract KeyModifier(Int) from Int to Int from UInt to UInt
{
	public static readonly NONE: KeyModifier = 0x0000;
	public static readonly LEFT_SHIFT: KeyModifier = 0x0001;
	public static readonly RIGHT_SHIFT: KeyModifier = 0x0002;
	public static readonly LEFT_CTRL: KeyModifier = 0x0040;
	public static readonly RIGHT_CTRL: KeyModifier = 0x0080;
	public static readonly LEFT_ALT: KeyModifier = 0x0100;
	public static readonly RIGHT_ALT: KeyModifier = 0x0200;
	public static readonly LEFT_META: KeyModifier = 0x0400;
	public static readonly RIGHT_META: KeyModifier = 0x0800;
	public static readonly NUM_LOCK: KeyModifier = 0x1000;
	public static readonly CAPS_LOCK: KeyModifier = 0x2000;
	public static readonly MODE: KeyModifier = 0x4000;
	public static readonly CTRL: KeyModifier = (0x0040 | 0x0080);
	public static readonly SHIFT: KeyModifier = (0x001 | 0x0002);
	public static readonly ALT: KeyModifier = (0x0100 | 0x0200);
	public static readonly META: KeyModifier = (0x0400 | 0x0800);

	public altKey(get, set) : boolean;
	public capsLock(get, set) : boolean;
	public ctrlKey(get, set) : boolean;
	public metaKey(get, set) : boolean;
	public numLock(get, set) : boolean;
	public shiftKey(get, set) : boolean;

	public get altKey() : boolean
	{
		return (this & LEFT_ALT > 0) || (this & RIGHT_ALT > 0);
	}

	protected inline set_altKey(value : boolean) : boolean
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

	public get capsLock() : boolean
	{
		return (this & CAPS_LOCK > 0) || (this & CAPS_LOCK > 0);
	}

	protected inline set_capsLock(value : boolean) : boolean
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

	public get ctrlKey() : boolean
	{
		return (this & LEFT_CTRL > 0) || (this & RIGHT_CTRL > 0);
	}

	protected inline set_ctrlKey(value : boolean) : boolean
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

	public get metaKey() : boolean
	{
		return (this & LEFT_META > 0) || (this & RIGHT_META > 0);
	}

	protected inline set_metaKey(value : boolean) : boolean
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

	public get numLock() : boolean
	{
		return (this & NUM_LOCK > 0) || (this & NUM_LOCK > 0);
	}

	protected inline set_numLock(value : boolean) : boolean
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

	public get shiftKey() : boolean
	{
		return (this & LEFT_SHIFT > 0) || (this & RIGHT_SHIFT > 0);
	}

	protected inline set_shiftKey(value : boolean) : boolean
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
