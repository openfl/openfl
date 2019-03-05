package;

import openfl.display.Sprite;
import openfl.display.Stage;

class FunctionalTest
{
	public var content:Sprite;
	public var name:String;
	public var stage:Stage;

	private var contentHeight:Float;
	private var contentWidth:Float;

	public function new()
	{
		content = new Sprite();

		var className = Type.getClassName(Type.getClass(this));
		var index = className.lastIndexOf(".");
		name = (index > -1 ? className.substr(index + 1) : className);
	}

	public function resize(width:Float, height:Float):Void
	{
		contentWidth = width;
		contentHeight = height;
	}

	public function start():Void {}

	public function stop():Void {}
}
