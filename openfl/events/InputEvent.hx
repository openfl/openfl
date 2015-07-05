package openfl.events;

class InputEvent extends Event
{
	public static var TEXT_INPUT = "textInput";

	public var text:String;

	public function new (type:String, text:String) {

		super (type, false, false);

		this.text = text;
	}


	public override function clone ():Event {

		return new InputEvent (type, text);

	}


	public override function toString ():String {

		return "[InputEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " text=" + text + "]";

	}


}
