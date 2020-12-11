package openfl.ui;

#if !flash
/**
	The KeyLocation class contains constants that indicate the location of a
	key pressed on the keyboard or keyboard-like input device.
	The KeyLocation constants are used in the `KeyboardEvent.keyLocation`
	property.
**/
@:enum abstract KeyLocation(Int) from Int to Int from UInt to UInt
{
	/**
		Indicates the key activated is in the left key location (there is more
		than one possible location for this key). Example: The left Shift key
		on a PC 101 Key US keyboard.
	**/
	public var LEFT = 1;

	/**
		Indicates the key activation originated on the numeric keypad or with a virtual
		key corresponding to the numeric keypad. Example: The 1 key on a PC 101 Key US
		keyboard located on the numeric pad.
	**/
	public var NUM_PAD = 3;

	/**
		Indicates the key activated is in the right key location (there is
		more than one possible location for this key). Example: The right
		Shift key on a PC 101 Key US keyboard.
	**/
	public var RIGHT = 2;

	/**
		Indicates the key activation is not distinguished as the left or right
		version of the key, and did not originate on the numeric keypad (or
		did not originate with a virtual key corresponding to the numeric
		keypad). Example: The Q key on a PC 101 Key US keyboard.
	**/
	public var STANDARD = 0;
}
#else
typedef KeyLocation = flash.ui.KeyLocation;
#end
