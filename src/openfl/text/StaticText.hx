package openfl.text;

#if !flash
import openfl.display.DisplayObject;
import openfl.display.Graphics;

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
		if ((displayitem is StaticText)) {
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
@:access(openfl.display.Graphics)
class StaticText extends DisplayObject
{
	/**
		Returns the current text of the static text field. The authoring tool
		may export multiple text field objects comprising the complete text.
		For example, for vertical text, the authoring tool will create one
		text field per character.
	**/
	public var text(default, null):String;

	@:noCompletion private function new()
	{
		super();

		__drawableType = SHAPE;
		__graphics = new Graphics(this);
	}
}
#else
typedef StaticText = flash.text.StaticText;
typedef StaticText2 = flash.text.StaticText.StaticText2;
#end
