package openfl._internal.backend.lime_standalone;

#if openfl_html5
@:enum abstract GamepadButton(Int) from Int to Int from UInt to UInt
{
	var A = 0;
	var B = 1;
	var X = 2;
	var Y = 3;
	var BACK = 4;
	var GUIDE = 5;
	var START = 6;
	var LEFT_STICK = 7;
	var RIGHT_STICK = 8;
	var LEFT_SHOULDER = 9;
	var RIGHT_SHOULDER = 10;
	var DPAD_UP = 11;
	var DPAD_DOWN = 12;
	var DPAD_LEFT = 13;
	var DPAD_RIGHT = 14;

	public inline function toString():String
	{
		return switch (this)
		{
			case A: "A";
			case B: "B";
			case X: "X";
			case Y: "Y";
			case BACK: "BACK";
			case GUIDE: "GUIDE";
			case START: "START";
			case LEFT_STICK: "LEFT_STICK";
			case RIGHT_STICK: "RIGHT_STICK";
			case LEFT_SHOULDER: "LEFT_SHOULDER";
			case RIGHT_SHOULDER: "RIGHT_SHOULDER";
			case DPAD_UP: "DPAD_UP";
			case DPAD_DOWN: "DPAD_DOWN";
			case DPAD_LEFT: "DPAD_LEFT";
			case DPAD_RIGHT: "DPAD_RIGHT";
			default: "UNKNOWN (" + this + ")";
		}
	}
}
#end
