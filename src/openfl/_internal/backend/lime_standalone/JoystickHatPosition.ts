namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
abstract JoystickHatPosition(Int) from Int to Int from UInt to UInt
{
	public static readonly CENTER: JoystickHatPosition = 0x00;
	public static readonly DOWN: JoystickHatPosition = 0x04;
	public static readonly LEFT: JoystickHatPosition = 0x08;
	public static readonly RIGHT: JoystickHatPosition = 0x02;
	public static readonly UP: JoystickHatPosition = 0x01;
	public static readonly DOWN_LEFT: JoystickHatPosition = (0x04 | 0x08);
	public static readonly DOWN_RIGHT: JoystickHatPosition = (0x04 | 0x02);
	public static readonly UP_LEFT: JoystickHatPosition = (0x01 | 0x08);
	public static readonly UP_RIGHT: JoystickHatPosition = (0x01 | 0x02);

	public center(get, set) : boolean;
	public down(get, set) : boolean;
	public left(get, set) : boolean;
	public right(get, set) : boolean;
	public up(get, set) : boolean;

	public new (value : number)
	{
		this = value;
	}

	protected get_center() : boolean
	{
		return (this == 0);
	}

	protected inline set_center(value : boolean) : boolean
	{
		if (value)
		{
			this = 0;
		}

		return value;
	}

	protected get_down() : boolean
	{
		return (this & DOWN > 0);
	}

	protected inline set_down(value : boolean) : boolean
	{
		if (value)
		{
			this |= DOWN;
		}
		else
		{
			this &= 0xFFFFFFF - DOWN;
		}

		return value;
	}

	protected get_left() : boolean
	{
		return (this & LEFT > 0);
	}

	protected inline set_left(value : boolean) : boolean
	{
		if (value)
		{
			this |= LEFT;
		}
		else
		{
			this &= 0xFFFFFFF - LEFT;
		}

		return value;
	}

	protected get_right() : boolean
	{
		return (this & RIGHT > 0);
	}

	protected inline set_right(value : boolean) : boolean
	{
		if (value)
		{
			this |= RIGHT;
		}
		else
		{
			this &= 0xFFFFFFF - RIGHT;
		}

		return value;
	}

	protected get_up() : boolean
	{
		return (this & UP > 0);
	}

	protected inline set_up(value : boolean) : boolean
	{
		if (value)
		{
			this |= UP;
		}
		else
		{
			this &= 0xFFFFFFF - UP;
		}

		return value;
	}
}
#end
