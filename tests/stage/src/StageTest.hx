package;

import openfl.display.Stage;
import openfl.events.EventPhase;
import openfl.events.MouseEvent;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class StageTest extends Test
{
	#if !integration
	@Ignored
	#end
	public function test_align()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.align;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_allowsFullScreen()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.allowsFullScreen;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_allowsFullScreenInteractive()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.allowsFullScreenInteractive;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_application()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.application;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_color()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.color;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_displayState()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.displayState;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_focus()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.focus;

		Assert.isNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_frameRate()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.frameRate;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_quality()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.quality;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_scaleMode()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.scaleMode;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stage3Ds()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stage3Ds;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stageFocusRect()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageFocusRect;

		Assert.isTrue(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stageHeight()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageHeight;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_stageWidth()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.stageWidth;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_window()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var exists = Lib.current.stage.window;

		Assert.notNull(exists);
		#end
	}

	#if (flash || !integration)
	@Ignored
	#end
	public function test_invalidate()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if (integration && !flash)
		var exists = Lib.current.stage.invalidate;

		Assert.notNull(exists);
		#end
	}

	#if !flash
	public function test_mouseDownEventStageTargetPhases()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseDown capture phase event test");
			return;
		}

		var stage = Lib.current.stage;

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var captured = false;
		var dispatchedToTarget = false;
		function stage_mouseDownHandler(event:MouseEvent):Void
		{
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.isTrue(captured);
			Assert.equals(stage, event.target);
			Assert.equals(stage, event.currentTarget);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		}
		stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
		function stage_mouseDownCaptureHandler(event:MouseEvent):Void
		{
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.equals(stage, event.target);
			Assert.equals(stage, event.currentTarget);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}
		stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownCaptureHandler, true);

		stage.window.onMouseDown.dispatch(25.0, 35.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatchedToTarget);
		Assert.isTrue(captured);

		stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownCaptureHandler, true);
	}
	#end
}
