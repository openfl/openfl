package flash.events;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SoftKeyboardTrigger(String) from String to String
{
	public var CONTENT_TRIGGERED = "contentTriggered";
	public var USER_TRIGGERED = "userTriggered";

	@:noCompletion public inline static function fromInt(value:Null<Int>):SoftKeyboardTrigger
	{
		return switch (value)
		{
			case 0: CONTENT_TRIGGERED;
			case 1: USER_TRIGGERED;
			default: null;
		}
	}
}
#else
typedef SoftKeyboardTrigger = openfl.events.SoftKeyboardTrigger;
#end
