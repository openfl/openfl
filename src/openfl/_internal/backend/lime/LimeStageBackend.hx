package openfl._internal.backend.lime;

#if lime
import lime.app.Application;
import lime.ui.Gamepad;
import lime.ui.Window;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.display.Window in OpenFLWindow;
import openfl.events.Event;
import openfl.events.FullScreenEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.events.TouchEvent;
import openfl.ui.GameInput;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.InteractiveObject)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.events.MouseEvent)
@:access(openfl.ui.GameInput)
class LimeStageBackend
{
	private var parent:Stage;

	public function new(stage:Stage, window:OpenFLWindow, color:Null<Int> = null)
	{
		parent = stage;

		parent.application = window.application;
		parent.window = window;
		parent.color = color;

		parent.__contentsScaleFactor = window.scale;
		parent.__wasFullscreen = window.fullscreen;

		parent.__resize();

		if (Lib.current.stage == null)
		{
			parent.addChild(Lib.current);
		}
	}

	public function registerLimeModule(application:Application):Void
	{
		application.onCreateWindow.add(application_onCreateWindow);
		application.onUpdate.add(application_onUpdate);
		application.onExit.add(application_onExit, false, 0);

		for (gamepad in Gamepad.devices)
		{
			gamepad_onConnect(gamepad);
		}

		Gamepad.onConnect.add(gamepad_onConnect);
		Touch.onStart.add(touch_onStart);
		Touch.onMove.add(touch_onMove);
		Touch.onEnd.add(touch_onEnd);
		Touch.onCancel.add(touch_onCancel);
	}

	public function unregisterLimeModule(application:Application):Void
	{
		application.onCreateWindow.remove(application_onCreateWindow);
		application.onUpdate.remove(application_onUpdate);
		application.onExit.remove(application_onExit);

		Gamepad.onConnect.remove(gamepad_onConnect);
		Touch.onStart.remove(touch_onStart);
		Touch.onMove.remove(touch_onMove);
		Touch.onEnd.remove(touch_onEnd);
		Touch.onCancel.remove(touch_onCancel);
	}

	// Event Handlers
	private function application_onCreateWindow(window:Window):Void
	{
		if (parent.window != window) return;

		window.onActivate.add(window_onActivate.bind(window));
		window.onClose.add(window_onClose.bind(window), false, -9000);
		window.onDeactivate.add(window_onDeactivate.bind(window));
		window.onDropFile.add(window_onDropFile.bind(window));
		window.onEnter.add(window_onEnter.bind(window));
		window.onExpose.add(window_onExpose.bind(window));
		window.onFocusIn.add(window_onFocusIn.bind(window));
		window.onFocusOut.add(window_onFocusOut.bind(window));
		window.onFullscreen.add(window_onFullscreen.bind(window));
		window.onKeyDown.add(window_onKeyDown.bind(window));
		window.onKeyUp.add(window_onKeyUp.bind(window));
		window.onLeave.add(window_onLeave.bind(window));
		window.onMinimize.add(window_onMinimize.bind(window));
		window.onMouseDown.add(window_onMouseDown.bind(window));
		window.onMouseMove.add(window_onMouseMove.bind(window));
		window.onMouseMoveRelative.add(window_onMouseMoveRelative.bind(window));
		window.onMouseUp.add(window_onMouseUp.bind(window));
		window.onMouseWheel.add(window_onMouseWheel.bind(window));
		window.onMove.add(window_onMove.bind(window));
		window.onRender.add(window_onRender);
		window.onRenderContextLost.add(window_onRenderContextLost);
		window.onRenderContextRestored.add(window_onRenderContextRestored);
		window.onResize.add(window_onResize.bind(window));
		window.onRestore.add(window_onRestore.bind(window));
		window.onTextEdit.add(window_onTextEdit.bind(window));
		window.onTextInput.add(window_onTextInput.bind(window));

		window_onCreate(window);
	}

	private function application_onExit(code:Int):Void
	{
		if (parent.window != null)
		{
			var event:Event = null;

			#if openfl_pool_events
			event = Event.__pool.get(Event.DEACTIVATE);
			#else
			event = new Event(Event.DEACTIVATE);
			#end

			parent.__broadcastEvent(event);

			#if openfl_pool_events
			Event.__pool.release(event);
			#end
		}
	}

	private function application_onUpdate(deltaTime:Int):Void
	{
		parent.__deltaTime = deltaTime;
		parent.__dispatchPendingMouseEvent();
	}

	private function gamepad_onAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void
	{
		#if !openfl_disable_handle_error
		try
		{
			GameInput.__onGamepadAxisMove(gamepad, axis, value);
		}
		catch (e:Dynamic)
		{
			parent.__handleError(e);
		}
		#else
		GameInput.__onGamepadAxisMove(gamepad, axis, value);
		#end
	}

	private function gamepad_onButtonDown(gamepad:Gamepad, button:GamepadButton):Void
	{
		#if !openfl_disable_handle_error
		try
		{
			GameInput.__onGamepadButtonDown(gamepad, button);
		}
		catch (e:Dynamic)
		{
			parent.__handleError(e);
		}
		#else
		GameInput.__onGamepadButtonDown(gamepad, button);
		#end
	}

	private function gamepad_onButtonUp(gamepad:Gamepad, button:GamepadButton):Void
	{
		#if !openfl_disable_handle_error
		try
		{
			GameInput.__onGamepadButtonUp(gamepad, button);
		}
		catch (e:Dynamic)
		{
			parent.__handleError(e);
		}
		#else
		GameInput.__onGamepadButtonUp(gamepad, button);
		#end
	}

	private function gamepad_onConnect(gamepad:Gamepad):Void
	{
		#if !openfl_disable_handle_error
		try
		{
			GameInput.__onGamepadConnect(gamepad);
		}
		catch (e:Dynamic)
		{
			parent.__handleError(e);
		}
		#else
		GameInput.__onGamepadConnect(gamepad);
		#end

		gamepad.onAxisMove.add(gamepad_onAxisMove.bind(gamepad));
		gamepad.onButtonDown.add(gamepad_onButtonDown.bind(gamepad));
		gamepad.onButtonUp.add(gamepad_onButtonUp.bind(gamepad));
		gamepad.onDisconnect.add(gamepad_onDisconnect.bind(gamepad));
	}

	private function gamepad_onDisconnect(gamepad:Gamepad):Void
	{
		#if !openfl_disable_handle_error
		try
		{
			GameInput.__onGamepadDisconnect(gamepad);
		}
		catch (e:Dynamic)
		{
			parent.__handleError(e);
		}
		#else
		GameInput.__onGamepadDisconnect(gamepad);
		#end
	}

	private function touch_onCancel(touch:Touch):Void
	{
		// TODO: Should we handle this differently?

		if (parent.__primaryTouch == touch)
		{
			parent.__primaryTouch = null;
		}

		parent.__onTouch(TouchEvent.TOUCH_END, touch);
	}

	private function touch_onMove(touch:Touch):Void
	{
		parent.__onTouch(TouchEvent.TOUCH_MOVE, touch);
	}

	private function touch_onEnd(touch:Touch):Void
	{
		if (parent.__primaryTouch == touch)
		{
			parent.__primaryTouch = null;
		}

		parent.__onTouch(TouchEvent.TOUCH_END, touch);
	}

	private function touch_onStart(touch:Touch):Void
	{
		if (parent.__primaryTouch == null)
		{
			parent.__primaryTouch = touch;
		}

		parent.__onTouch(TouchEvent.TOUCH_BEGIN, touch);
	}

	private function window_onActivate(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		// __broadcastEvent (new Event (Event.ACTIVATE));
	}

	private function window_onClose(window:Window):Void
	{
		if (parent.window == window)
		{
			parent.window = null;
		}

		parent.__primaryTouch = null;

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.DEACTIVATE);
		#else
		event = new Event(Event.DEACTIVATE);
		#end

		parent.__broadcastEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}

	private function window_onCreate(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		if (window.context != null)
		{
			parent.__createRenderer();
		}
	}

	private function window_onDeactivate(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		// __primaryTouch = null;
		// __broadcastEvent (new Event (Event.DEACTIVATE));
	}

	private function window_onDropFile(window:Window, file:String):Void {}

	private function window_onEnter(window:Window):Void
	{
		// if (parent.window == null || parent.window != window) return;
	}

	private function window_onExpose(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__renderDirty = true;
	}

	private function window_onFocusIn(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		#if !desktop
		// TODO: Is this needed?
		parent.__renderDirty = true;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.ACTIVATE);
		#else
		event = new Event(Event.ACTIVATE);
		#end

		parent.__broadcastEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end

		#if !desktop
		parent.focus = parent.__cacheFocus;
		#end
	}

	private function window_onFocusOut(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__primaryTouch = null;

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.DEACTIVATE);
		#else
		event = new Event(Event.DEACTIVATE);
		#end

		parent.__broadcastEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end

		var currentFocus = parent.focus;
		parent.focus = null;
		parent.__cacheFocus = currentFocus;

		MouseEvent.__altKey = false;
		MouseEvent.__commandKey = false;
		MouseEvent.__ctrlKey = false;
		MouseEvent.__shiftKey = false;
	}

	private function window_onFullscreen(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__resize();

		if (!parent.__wasFullscreen)
		{
			parent.__wasFullscreen = true;
			if (parent.__displayState == NORMAL) parent.__displayState = FULL_SCREEN_INTERACTIVE;
			parent.__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, true, true));
		}
	}

	private function window_onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void
	{
		if (parent.window == null || parent.window != window) return;

		if (parent.__onKey(KeyboardEvent.KEY_DOWN, keyCode, modifier))
		{
			window.onKeyDown.cancel();
		}
	}

	private function window_onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void
	{
		if (parent.window == null || parent.window != window) return;

		if (parent.__onKey(KeyboardEvent.KEY_UP, keyCode, modifier))
		{
			window.onKeyUp.cancel();
		}
	}

	private function window_onLeave(window:Window):Void
	{
		if (parent.window == null || parent.window != window || MouseEvent.__buttonDown) return;

		parent.__dispatchPendingMouseEvent();

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.MOUSE_LEAVE);
		#else
		event = new Event(Event.MOUSE_LEAVE);
		#end

		parent.__dispatchEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}

	private function window_onMinimize(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		// __primaryTouch = null;
		// __broadcastEvent (new Event (Event.DEACTIVATE));
	}

	private function window_onMouseDown(window:Window, x:Float, y:Float, button:Int):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__dispatchPendingMouseEvent();

		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
		}

		parent.__onMouse(type, Std.int(x * window.scale), Std.int(y * window.scale), button);

		if (!parent.showDefaultContextMenu && button == 2)
		{
			window.onMouseDown.cancel();
		}
	}

	private function window_onMouseMove(window:Window, x:Float, y:Float):Void
	{
		if (parent.window == null || parent.window != window) return;

		#if openfl_always_dispatch_mouse_events
		parent.__onMouse(MouseEvent.MOUSE_MOVE, Std.int(x * window.scale), Std.int(y * window.scale), 0);
		#else
		parent.__pendingMouseEvent = true;
		parent.__pendingMouseX = Std.int(x * window.scale);
		parent.__pendingMouseY = Std.int(y * window.scale);
		#end
	}

	private function window_onMouseMoveRelative(window:Window, x:Float, y:Float):Void
	{
		// if (parent.window == null || parent.window != window) return;
	}

	private function window_onMouseUp(window:Window, x:Float, y:Float, button:Int):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__dispatchPendingMouseEvent();

		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
		}

		parent.__onMouse(type, Std.int(x * window.scale), Std.int(y * window.scale), button);

		if (!parent.showDefaultContextMenu && button == 2)
		{
			window.onMouseUp.cancel();
		}
	}

	private function window_onMouseWheel(window:Window, deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__dispatchPendingMouseEvent();

		if (deltaMode == PIXELS)
		{
			parent.__onMouseWheel(Std.int(deltaX * window.scale), Std.int(deltaY * window.scale), deltaMode);
		}
		else
		{
			parent.__onMouseWheel(Std.int(deltaX), Std.int(deltaY), deltaMode);
		}
	}

	private function window_onMove(window:Window, x:Float, y:Float):Void
	{
		// if (parent.window == null || parent.window != window) return;
	}

	private function window_onRender(context:RenderContext):Void
	{
		#if openfl_cairo
		if (parent.__renderer != null && parent.__renderer.__type == CAIRO)
		{
			var renderer:CairoRenderer = cast parent.__renderer;
			renderer.cairo = context.cairo;
		}
		#end

		parent.__render();
	}

	private function window_onRenderContextLost():Void
	{
		parent.__renderer = null;
		parent.context3D = null;

		for (stage3D in parent.stage3Ds)
		{
			stage3D.__lostContext();
		}
	}

	private function window_onRenderContextRestored(context:RenderContext):Void
	{
		parent.__createRenderer();

		for (stage3D in parent.stage3Ds)
		{
			stage3D.__restoreContext();
		}
	}

	private function window_onResize(window:Window, width:Int, height:Int):Void
	{
		if (parent.window == null || parent.window != window) return;

		parent.__resize();

		#if android
		// workaround for newer behavior
		parent.__forceRender = true;
		Lib.setTimeout(function()
		{
			parent.__forceRender = false;
		}, 500);
		#end

		if (parent.__wasFullscreen && !window.fullscreen)
		{
			parent.__wasFullscreen = false;
			parent.__displayState = NORMAL;
			parent.__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
		}
	}

	private function window_onRestore(window:Window):Void
	{
		if (parent.window == null || parent.window != window) return;

		if (parent.__wasFullscreen && !window.fullscreen)
		{
			parent.__wasFullscreen = false;
			parent.__displayState = NORMAL;
			parent.__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
		}
	}

	private function window_onTextEdit(window:Window, text:String, start:Int, length:Int):Void
	{
		// if (parent.window == null || parent.window != window) return;
	}

	private function window_onTextInput(window:Window, text:String):Void
	{
		if (parent.window == null || parent.window != window) return;

		var stack = new Array<DisplayObject>();

		if (parent.__focus == null)
		{
			parent.__getInteractive(stack);
		}
		else
		{
			parent.__focus.__getInteractive(stack);
		}

		var event = new TextEvent(TextEvent.TEXT_INPUT, true, true, text);
		if (stack.length > 0)
		{
			stack.reverse();
			parent.__dispatchStack(event, stack);
		}
		else
		{
			parent.__dispatchEvent(event);
		}

		if (event.isDefaultPrevented())
		{
			window.onTextInput.cancel();
		}
	}
}
#end
