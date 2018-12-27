package;


import test.*;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.system.System;


class Main extends Sprite {
	
	
	private var suite:FunctionalTestSuite;
	
	
	public function new () {
		
		super ();
		
		suite = new FunctionalTestSuite ();
		suite.addTest (new MaskTest1 ());
		suite.addTest (new ScrollRectTest1 ());
		suite.addTest (new WordWrapTest1 ());
		suite.addTest (new ClipTest1 ());
		suite.addTest (new CacheBitmapTest3 ());
		suite.addTest (new SurfaceAllocationTest1 ());
		suite.addTest (new BlendModeTest1 ());
		suite.addTest (new CacheBitmapTest1 ());
		suite.addTest (new CacheBitmapTest2 ());
		suite.addTest (new FillTest1 ());
		suite.addTest (new AlphaBlendTest1 ());
		suite.addTest (new UnicodeTest1 ());
		suite.addTest (new UnicodeTest2 ());
		addChild (suite.content);
		
		stage.addEventListener (Event.RESIZE, stage_onResize);
		stage.addEventListener (KeyboardEvent.KEY_DOWN, stage_onKeyDown);
		
		suite.resize (stage.stageWidth, stage.stageHeight);
		suite.startTests ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage_onKeyDown (event:KeyboardEvent):Void {
		
		switch (event.keyCode) {
			
			case Keyboard.LEFT:
				
				suite.previousTest ();
			
			case Keyboard.RIGHT, Keyboard.ENTER, Keyboard.SPACE:
				
				suite.nextTest ();
			
			case Keyboard.Q, Keyboard.NUMBER_0, Keyboard.ESCAPE:
				
				System.exit (0);
			
			default:
				
				return;
			
		}
		
		event.stopPropagation ();
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		suite.resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}