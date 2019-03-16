package openfl.fl.controls;

import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;
import openfl._internal.formats.xfl.dom.DOMTimeline;
import openfl.fl.controls.LabelButton;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl.text.TextField;
import openfl.events.MouseEvent;

/**
 * Radio button
 */
class RadioButton extends LabelButton
{
	private static var groups:Map<String, Array<RadioButton>> = new Map<String, Array<RadioButton>>();

	public var groupName(get, set):String;

	private var _groupName:String;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		// TODO: clean up group and its radiobuttons if removed
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.RadioButton"));
		setStyle("upIcon", getXFLMovieClip("RadioButton_upIcon"));
		setStyle("overIcon", getXFLMovieClip("RadioButton_overIcon"));
		setStyle("downIcon", getXFLMovieClip("RadioButton_downIcon"));
		setStyle("disabledIcon", getXFLMovieClip("RadioButton_disabledIcon"));
		setStyle("selectedUpIcon", getXFLMovieClip("RadioButton_selectedUpIcon"));
		setStyle("selectedOverIcon", getXFLMovieClip("RadioButton_selectedOverIcon"));
		setStyle("selectedDownIcon", getXFLMovieClip("RadioButton_selectedDownIcon"));
		setStyle("selectedDisabledIcon", getXFLMovieClip("RadioButton_selectedDisabledIcon"));
		setMouseState("up");
		_selected = false;
		toggle = true;
	}

	private function get_groupName():String
	{
		return _groupName;
	}

	private function set_groupName(_groupName:String):String
	{
		var group:Array<RadioButton> = RadioButton.groups.get(this._groupName);
		if (group != null) group.remove(this);
		this._groupName = _groupName;
		var group:Array<RadioButton> = RadioButton.groups.get(this._groupName);
		if (group == null)
		{
			RadioButton.groups.set(this._groupName, [this]);
		}
		else
		{
			group.push(this);
		}
		return this._groupName;
	}

	override private function set_selected(selected:Bool):Bool
	{
		var group:Array<RadioButton> = RadioButton.groups.get(this._groupName);
		if (group != null)
		{
			for (radioButton in group)
			{
				if (radioButton == this) continue;
				radioButton.setLabelButtonSelected(false);
			}
		}
		setLabelButtonSelected(selected);
		return _selected;
	}

	private function setLabelButtonSelected(selected:Bool):Void
	{
		super.selected = selected;
	}

	override private function onMouseEvent(event:MouseEvent):Void
	{
		switch (event.type)
		{
			case MouseEvent.MOUSE_OVER:
				setMouseState("over");
			case MouseEvent.MOUSE_OUT:
				setMouseState("up");
			case MouseEvent.MOUSE_UP:
				var group:Array<RadioButton> = RadioButton.groups.get(this._groupName);
				if (group != null)
				{
					for (radioButton in group)
					{
						if (radioButton == this) continue;
						radioButton.selected = false;
					}
				}
				setLabelButtonSelected(true);
				setMouseState("up");
			case MouseEvent.MOUSE_DOWN:
				setMouseState("down");
			default:
				trace("onMouseEvent(): unsupported mouse event type '" + event.type + "'");
		}
	}

	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
	}
}
