package;

import haxe.macro.Compiler;
import lime.utils.Log;
import test.*;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.system.System;

class Main extends Sprite
{
	private var suite:FunctionalTestSuite;

	public function new()
	{
		super();

		suite = new FunctionalTestSuite();
		suite.addTest(new MaskTest1());
		suite.addTest(new ScrollRectTest1());
		suite.addTest(new WordWrapTest1());
		suite.addTest(new ClipTest1());
		suite.addTest(new CacheBitmapTest3());
		suite.addTest(new SurfaceAllocationTest1());
		suite.addTest(new BlendModeTest1());
		suite.addTest(new CacheBitmapTest1());
		suite.addTest(new CacheBitmapTest2());
		suite.addTest(new FillTest1());
		suite.addTest(new AlphaBlendTest1());
		suite.addTest(new UnicodeTest1());
		suite.addTest(new UnicodeTest2());
		suite.addTest(new ContextLossTest1());
		suite.addTest(new DropFileTest1());
		suite.addTest(new Scale9GridTest1());
		suite.addTest(new BlurTest1());
		addChild(suite.content);

		stage.addEventListener(Event.RESIZE, stage_onResize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_onKeyDown);

		suite.resize(stage.stageWidth, stage.stageHeight);

		var test = Compiler.getDefine("test");

		if (test != null)
		{
			if (suite.hasTestWithName(test))
			{
				suite.startTestWithName(test);
			}
			else
			{
				var number = Std.parseInt(test);

				if (number != null)
				{
					suite.startTest(number - 1);
				}
				else
				{
					Log.warn("Did not recognize test \"" + test + "\"");
					suite.startTests();
				}
			}
		}
		else
		{
			suite.startTests();
		}
	}

	// Event Handlers
	private function stage_onKeyDown(event:KeyboardEvent):Void
	{
		if (event.altKey || event.ctrlKey || event.commandKey || event.controlKey || event.shiftKey) return;

		switch (event.keyCode)
		{
			case Keyboard.LEFT, Keyboard.MINUS, Keyboard.NUMPAD_SUBTRACT:
				suite.previousTest();

			case Keyboard.RIGHT, Keyboard.ENTER, Keyboard.SPACE, Keyboard.EQUAL:
				suite.nextTest();

			case Keyboard.Q, Keyboard.ESCAPE:
				System.exit(0);

			case Keyboard.NUMBER_1, Keyboard.NUMPAD_1:
				suite.startTest(0);
			case Keyboard.NUMBER_2, Keyboard.NUMPAD_2:
				suite.startTest(1);
			case Keyboard.NUMBER_3, Keyboard.NUMPAD_3:
				suite.startTest(2);
			case Keyboard.NUMBER_4, Keyboard.NUMPAD_4:
				suite.startTest(3);
			case Keyboard.NUMBER_5, Keyboard.NUMPAD_5:
				suite.startTest(4);
			case Keyboard.NUMBER_6, Keyboard.NUMPAD_6:
				suite.startTest(5);
			case Keyboard.NUMBER_7, Keyboard.NUMPAD_7:
				suite.startTest(6);
			case Keyboard.NUMBER_8, Keyboard.NUMPAD_8:
				suite.startTest(7);
			case Keyboard.NUMBER_9, Keyboard.NUMPAD_9:
				suite.startTest(8);
			case Keyboard.NUMBER_0, Keyboard.NUMPAD_0:
				suite.startTest(9);

			default:
				return;
		}

		event.stopPropagation();
	}

	private function stage_onResize(event:Event):Void
	{
		suite.resize(stage.stageWidth, stage.stageHeight);
	}
}
