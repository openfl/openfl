package openfl.text;

#if !flash
import openfl.display.DisplayObject;

/**
	This class represents StaticText objects on the display list. You cannot
	create a StaticText object using ActionScript. Only the authoring tool can
	create a StaticText object. An attempt to create a new StaticText object
	generates an `ArgumentError`.
	To create a reference to an existing static text field in ActionScript
	3.0, you can iterate over the items in the display list. For example, the
	following snippet checks to see if the display list contains a static text
	field and assigns the field to a variable:

	```haxe
	for (i in 0...numChildren) {
		var displayitem = getChildAt(i);
		if (Std.is(displayitem, StaticText)) {
			trace("a static text field is item " + i + " on the display list");
			var myFieldLabel:StaticText = cast displayitem;
			trace("and contains the text: " + myFieldLabel.text);
		}
	}
	```
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class StaticText extends DisplayObject
{
	/**
		Returns the current text of the static text field. The authoring tool
		may export multiple text field objects comprising the complete text.
		For example, for vertical text, the authoring tool will create one
		text field per character.
	**/
	public var text(get, never):String;

	@:allow(openfl) @:noCompletion private function new()
	{
		if (_ == null)
		{
			_ = new _StaticText(this);
		}

		super();
	}

	// Get & Set Methods

	@:noCompletion private function get_text():String
	{
		return _.text;
	}
}
#else
typedef StaticText = flash.text.StaticText;
#end
