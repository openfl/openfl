package openfl.events;

#if !flash
#if !openfljs
/**
	The SoftKeyboardTrigger class provides enumerator values for the
	`triggerType` property of the SoftKeyboardEvent class. These values indicate
	what type of action triggered a SoftKeyboard activation event.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SoftKeyboardTrigger(Null<Int>)
{
	/**
		Indicates that ActionScript invoked the event.
	**/
	public var CONTENT_TRIGGERED = 0;

	/**
		Indicates that user action invoked the event. Typical user actions that
		can trigger this event include explicitly closing the keyboard, or
		pressing the Back key.
	**/
	public var USER_TRIGGERED = 1;

	@:noCompletion private inline static function fromInt(value:Null<Int>):SoftKeyboardTrigger
	{
		return cast value;
	}

	@:from private static function fromString(value:String):SoftKeyboardTrigger
	{
		return switch (value)
		{
			case "contentTriggered": CONTENT_TRIGGERED;
			case "userTriggered": USER_TRIGGERED;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : SoftKeyboardTrigger)
		{
			case SoftKeyboardTrigger.CONTENT_TRIGGERED: "contentTriggered";
			case SoftKeyboardTrigger.USER_TRIGGERED: "userTriggered";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment") #if (haxe_ver >= 4.0) enum #else @:enum #end abstract SoftKeyboardTrigger(String) from String to String
{
	public var CONTENT_TRIGGERED = "contentTriggered";
	public var USER_TRIGGERED = "userTriggered";

	@:noCompletion private inline static function fromInt(value:Null<Int>):SoftKeyboardTrigger
	{
		return switch (value)
		{
			case 0: CONTENT_TRIGGERED;
			case 1: USER_TRIGGERED;
			default: null;
		}
	}
}
#end
#else
typedef SoftKeyboardTrigger = flash.events.SoftKeyboardTrigger;
#end
