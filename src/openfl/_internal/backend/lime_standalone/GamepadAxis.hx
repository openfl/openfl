package openfl._internal.backend.lime_standalone;

#if openfl_html5
@:enum abstract GamepadAxis(Int) from Int to Int from UInt to UInt
{
	var LEFT_X = 0;
	var LEFT_Y = 1;
	var RIGHT_X = 2;
	var RIGHT_Y = 3;
	var TRIGGER_LEFT = 4;
	var TRIGGER_RIGHT = 5;

	public inline function toString():String
	{
		return switch (this)
		{
			case LEFT_X: "LEFT_X";
			case LEFT_Y: "LEFT_Y";
			case RIGHT_X: "RIGHT_X";
			case RIGHT_Y: "RIGHT_Y";
			case TRIGGER_LEFT: "TRIGGER_LEFT";
			case TRIGGER_RIGHT: "TRIGGER_RIGHT";
			default: "UNKNOWN (" + this + ")";
		}
	}
}
#end
