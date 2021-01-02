package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class FunctionalTestSuite
{
	public var content:Sprite;

	private var contentHeight:Float;
	private var contentWidth:Float;
	private var currentTest:FunctionalTest;
	private var currentTestID:Int;
	private var label:TextField;
	private var tests:Array<FunctionalTest>;

	public function new(createLabel:Bool = true)
	{
		content = new Sprite();
		contentHeight = 0;
		contentWidth = 0;
		tests = new Array();

		if (createLabel)
		{
			label = new TextField();
			var textFormat = new TextFormat("_sans", 24, 0x888888, true);
			textFormat.align = TextFormatAlign.RIGHT;
			label.defaultTextFormat = textFormat;
			label.height = 45;
			label.width = 1000;
			label.selectable = false;
			content.addChild(label);
		}
	}

	public function addTest(test:FunctionalTest):Void
	{
		tests.push(test);
	}

	public function hasTestWithName(name:String):Bool
	{
		for (test in tests)
		{
			if (test.name == name) return true;
		}
		return false;
	}

	public function nextTest():Void
	{
		if (tests.length <= 1) return;

		if (currentTestID < tests.length - 1)
		{
			startTest(currentTestID + 1);
		}
		else
		{
			startTest(0);
		}
	}

	public function previousTest():Void
	{
		if (tests.length <= 1) return;

		if (currentTestID > 0)
		{
			startTest(currentTestID - 1);
		}
		else
		{
			startTest(tests.length - 1);
		}
	}

	public function resize(width:Float, height:Float):Void
	{
		contentWidth = width;
		contentHeight = height;

		if (label != null)
		{
			label.x = width - label.width - 10;
			label.y = height - label.height;
		}

		if (currentTest != null)
		{
			currentTest.resize(width, height);
		}
	}

	public function startTest(id:Int):Void
	{
		if (id < 0 || id >= tests.length) return;

		if (currentTest != null)
		{
			if (currentTest.content != null && currentTest.content.parent == content)
			{
				content.removeChild(currentTest.content);
			}

			currentTest.stop();
			currentTest.stage = null;
		}

		currentTestID = id;
		currentTest = tests[id];

		currentTest.stage = content.stage;
		currentTest.resize(contentWidth, contentHeight);
		currentTest.start();

		if (currentTest.content != null)
		{
			content.addChildAt(currentTest.content, 0);
		}

		label.text = currentTest.name;
	}

	public function startTestWithName(name:String):Void
	{
		for (i in 0...tests.length)
		{
			if (tests[i].name == name)
			{
				startTest(i);
				break;
			}
		}
	}

	public function startTests():Void
	{
		startTest(0);
	}
}
