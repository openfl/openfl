import * as internal from "../_internal/utils/InternalAccess";
import DisplayObject from "../display/DisplayObject";
import Graphics from "../display/Graphics";

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
export default class StaticText extends DisplayObject
{
	protected __text: string;

	protected constructor()
	{
		super();

		this.__graphics = new (<internal.Graphics><any>Graphics)(this);
	}

	// Get & Set Methods

	/**
		Returns the current text of the static text field. The authoring tool
		may export multiple text field objects comprising the complete text.
		For example, for vertical text, the authoring tool will create one
		text field per character.
	**/
	public get text(): string
	{
		return this.__text;
	}
}
