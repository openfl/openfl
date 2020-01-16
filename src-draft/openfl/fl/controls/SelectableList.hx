package openfl.fl.controls;

import openfl.fl.core.UIComponent;
import openfl.fl.data.DataProvider;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;

/**
 * Selectable list
 */
class SelectableList extends UIComponent
{
	public var dataProvider(get, set):DataProvider;

	private var _dataProvider:DataProvider;
	private var displayObjects:Array<DisplayObject>;

	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments != null ? xflSymbolArguments : XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.SelectableList"));
		displayObjects = new Array<DisplayObject>();
		layoutChildren();
	}

	private function get_dataProvider():DataProvider
	{
		return _dataProvider;
	}

	private function set_dataProvider(dataProvider:DataProvider):DataProvider
	{
		_dataProvider = dataProvider;
		draw();
		return _dataProvider;
	}

	override private function draw()
	{
		for (displayObject in displayObjects)
		{
			removeChild(displayObject);
		}
	}

	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
		layoutChildren();
	}

	private function layoutChildren() {}

	private function onMouseEventMove(event:MouseEvent):Void
	{
		trace("onMouseEventMove(): " + event);
	}

	private function onMouseEventClick(event:MouseEvent):Void
	{
		trace("onMouseEventClick(): " + event);
	}
}
