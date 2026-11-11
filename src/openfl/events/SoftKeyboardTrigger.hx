package openfl.events;

#if !flash
#if !openfljs
/**

**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SoftKeyboardTrigger(Null<Int>)
{
	/**
	**/
	public var CONTENT_TRIGGERED = 0;

	/**
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
