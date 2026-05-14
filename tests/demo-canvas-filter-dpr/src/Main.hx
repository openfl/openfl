package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filters.GlowFilter;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Main extends Sprite
{
	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}

	private function onAdded(_):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		buildRow(20, "plain", false, false);
		buildRow(70, "cacheAsBitmap", true, false);
		buildRow(120, "filter", false, true);
		buildRow(170, "filter + cacheAsBitmap", true, true);

		var ref = new Sprite();
		ref.graphics.beginFill(0x55ffaa);
		ref.graphics.drawRect(0, 0, 24, 24);
		ref.graphics.endFill();
		ref.x = 10;
		ref.y = 240;
		addChild(ref);

		var label = mkText("24px reference square ↑");
		label.x = 40;
		label.y = 240;
		addChild(label);
	}

	private function buildRow(y:Float, name:String, cab:Bool, withFilter:Bool):Void
	{
		var tf = mkText("TEST " + name);
		tf.x = 10;
		tf.y = y;
		if (withFilter) tf.filters = [new GlowFilter(0xff5566, 1, 4, 4, 1)];
		tf.cacheAsBitmap = cab;
		addChild(tf);
	}

	private function mkText(s:String):TextField
	{
		var tf = new TextField();
		tf.defaultTextFormat = new TextFormat("_sans", 24, 0xffffff);
		tf.autoSize = LEFT;
		tf.selectable = false;
		tf.text = s;
		return tf;
	}
}
