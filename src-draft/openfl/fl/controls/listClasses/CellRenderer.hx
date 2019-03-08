package openfl.fl.controls.listClasses;

import openfl.display.DisplayObject;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl.events.MouseEvent;

/**
 * Cell Renderer
 */
class CellRenderer extends LabelButton implements ICellRenderer
{
	public var listData(get, set):ListData;

	private var _listData:ListData;

	public var data(get, set):Dynamic;

	private var _data:Dynamic;

	/**
	 * Public constructor
	**/
	public function new()
	{
		super();
	}

	public function init()
	{
		drawLayout();
		drawBackground();
	}

	public static function createColorSkin(color:Int):XFLMovieClip
	{
		var skin:XFLMovieClip = new XFLMovieClip();
		skin.graphics.beginFill(color);
		skin.graphics.drawRect(0, 0, 500, 200);
		skin.graphics.endFill();
		return skin;
	}

	private function drawLayout():Void {}

	private function drawBackground():Void {}

	private function get_listData():ListData
	{
		return _listData;
	}

	private function set_listData(listData:ListData):ListData
	{
		_listData = listData;
		return _listData;
	}

	private function get_data():Dynamic
	{
		return _data;
	}

	private function set_data(data:Dynamic):Dynamic
	{
		_data = data;
		return _data;
	}

	public static function getStyleDefinition():Dynamic
	{
		return null;
	}
}
