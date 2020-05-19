package openfl.display;

import openfl.containers.ScrollPane;
import openfl.controls.CheckBox;
import openfl.controls.ComboBox;
import openfl.controls.List;
import openfl.controls.ProgressBar;
import openfl.controls.RadioButton;
import openfl.controls.Slider;
import openfl.controls.ScrollBar;
import openfl.controls.UIScrollBar;
import openfl.controls.TextArea;
import openfl.controls.TextInput;
import openfl.core.UIComponent;
import openfl.events.Event;
import openfl.text.TextField;

class XFLImplementation
{
	private static var VERBOSE:Bool = false;

	private var container:Sprite;
	private var values:Map<String, Dynamic>;
	private var tweens:Array<Dynamic>;

	public function new(container:Sprite)
	{
		this.container = container;
		values = new Map<String, String>();
		tweens = new Array<Dynamic>();
	}

	public function getXFLElementUntyped(name:String):Dynamic
	{
		var fullName:String = "";
		var parentDisplayObjectContainer:DisplayObjectContainer = container.parent;
		while (parentDisplayObjectContainer != null)
		{
			fullName = parentDisplayObjectContainer.name + "." + fullName;
			parentDisplayObjectContainer = parentDisplayObjectContainer.parent;
		}
		var element:Dynamic = container.getChildByName(name);
		if (element == null)
		{
			if (VERBOSE == true) trace("Getting XFL element: '" + fullName + name + "', NOT found!");
		}
		return element;
	}

	public function getXFLElement(name:String):XFLElement
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, XFLElement);
		return null;
	}

	public function getXFLMovieClip(name:String):XFLMovieClip
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, XFLMovieClip);
		return null;
	}

	public function getXFLSprite(name:String):XFLSprite
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, XFLSprite);
		return null;
	}

	public function getXFLDisplayObject(name:String):DisplayObject
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, DisplayObject);
		return null;
	}

	public function getXFLDisplayObjectContainer(name:String):DisplayObjectContainer
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, DisplayObjectContainer);
		return null;
	}

	public function getXFLTextField(name:String):TextField
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, TextField);
		return null;
	}

	public function getXFLTextArea(name:String):TextArea
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, TextArea);
		return null;
	}

	public function getXFLTextInput(name:String):TextInput
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, TextInput);
		return null;
	}

	public function getXFLSlider(name:String):Slider
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, Slider);
		return null;
	}

	public function getXFLComboBox(name:String):ComboBox
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, ComboBox);
		return null;
	}

	public function getXFLCheckBox(name:String):CheckBox
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, CheckBox);
		return null;
	}

	public function getXFLRadioButton(name:String):RadioButton
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, RadioButton);
		return null;
	}

	public function getXFLList(name:String):List
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, List);
		return null;
	}

	public function getXFLScrollBar(name:String):ScrollBar
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, ScrollBar);
		return null;
	}

	public function getXFLUIScrollBar(name:String):UIScrollBar
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, UIScrollBar);
		return null;
	}

	public function getXFLUIComponent(name:String):UIComponent
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, UIComponent);
		return null;
	}

	public function getXFLScrollPane(name:String):ScrollPane
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, ScrollPane);
		return null;
	}

	public function getXFLProgressBar(name:String):ProgressBar
	{
		var element:Dynamic = getXFLElementUntyped(name);
		if (element != null) return cast(element, ProgressBar);
		return null;
	}

	public function removeValue(key:String):Void
	{
		values.remove(key);
	}

	public function addValue(key:String, value:Dynamic):Void
	{
		values[key] = value;
	}

	public function getValue(key:String):Dynamic
	{
		return values[key];
	}
}
