package;

import openfl.display.StageQuality;
import openfl.display.StageScaleMode;
import openfl.display.StageDisplayState;
import openfl.display.StageAlign;
import openfl.display.Stage;
import openfl.events.EventPhase;
import openfl.events.MouseEvent;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class StageTest extends Test
{
	public function test_align()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping align test");
			return;
		}

		Assert.equals(StageAlign.TOP_LEFT, Lib.current.stage.align);
	}

	public function test_allowsFullScreen()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping allowsFullScreen test");
			return;
		}

		Assert.isTrue(Lib.current.stage.allowsFullScreen);
	}

	public function test_allowsFullScreenInteractive()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping allowsFullScreenInteractive test");
			return;
		}

		Assert.notNull(Lib.current.stage.allowsFullScreenInteractive);
	}

	public function test_application()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping application test");
			return;
		}

		Assert.notNull(Lib.current.stage.application);
	}

	public function test_color()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping color test");
			return;
		}

		var white:UInt = 0xffffffff;
		Assert.equals(white, Lib.current.stage.color);
	}

	public function test_displayState()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping stageHeight test");
			return;
		}

		Assert.equals(StageDisplayState.NORMAL, Lib.current.stage.displayState);
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

	public function test_frameRate()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping frameRate test");
			return;
		}

		Assert.isTrue(Lib.current.stage.frameRate > 0);
	}

	#if !flash
	public function test_quality()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping quality test");
			return;
		}

		Assert.equals(StageQuality.HIGH, Lib.current.stage.quality);
	}
	#end

	public function test_scaleMode()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping scaleMode test");
			return;
		}

		Assert.equals(StageScaleMode.NO_SCALE, Lib.current.stage.scaleMode);
	}

	public function test_stage3Ds()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping stage3Ds test");
			return;
		}

		Assert.notNull(Lib.current.stage.stage3Ds);
		Assert.isTrue(Lib.current.stage.stage3Ds.length > 0);
	}

	public function test_stageFocusRect()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping stageFocusRect test");
			return;
		}

		Assert.isTrue(Lib.current.stage.stageFocusRect);
	}

	public function test_stageHeight()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping stageHeight test");
			return;
		}

		Assert.isTrue(Lib.current.stage.stageHeight > 0.0);
	}

	public function test_stageWidth()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping stageWidth test");
			return;
		}

		Assert.isTrue(Lib.current.stage.stageWidth > 0.0);
	}

	public function test_window()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping window test");
			return;
		}

		Assert.notNull(Lib.current.stage.window);
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
