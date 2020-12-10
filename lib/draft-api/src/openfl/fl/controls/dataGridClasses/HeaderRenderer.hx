package openfl.fl.controls.dataGridClasses;

import com.slipshift.engine.helpers.Utils;
import openfl.display.DisplayObject;
import openfl.events.MouseEvent;

/**
 *  Public constructor
 */
class HeaderRenderer extends LabelButton
{
	public var column:Int;

	/**
	 * Public constructor
	**/
	public function new()
	{
		super();
		column = -1;
		setMouseState("up");
	}

	public function init()
	{
		drawLayout();
		drawBackground();
	}

	override public function setStyle(key:String, style:Dynamic)
	{
		super.setStyle(key, style);
		draw();
	}

	private function drawLayout():Void {}

	private function drawBackground():Void {}

	public static function getStyleDefinition():Dynamic
	{
		return null;
	}
}
