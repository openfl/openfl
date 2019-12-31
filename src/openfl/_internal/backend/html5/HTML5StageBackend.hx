package openfl._internal.backend.html5;

#if openfl_html5
import js.html.DeviceMotionEvent in JSDeviceMotionEvent;
import js.html.Event in JSEvent;
import js.html.KeyboardEvent in JSKeyboardEvent;
import openfl._internal.backend.lime_standalone.KeyModifier;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;

@:access(openfl.display.Stage)
class HTML5StageBackend
{
	private var currentUpdate:Float;
	private var framePeriod:Int;
	private var lastUpdate:Float;
	private var nextUpdate:Float;
	private var parent:Stage;

	public function new(stage:Stage, width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
			windowAttributes:Dynamic = null)
	{
		parent = stage;

		if (Lib.current.__loaderInfo == null)
		{
			Lib.current.__loaderInfo = LoaderInfo.create(null);
			Lib.current.__loaderInfo.content = Lib.current;
		}

		var resizable = (width == 0 && width == 0);
		element = Browser.document.createElement("div");

		if (resizable)
		{
			element.style.width = "100%";
			element.style.height = "100%";
		}

		// width, height, element, resizable

		currentUpdate = 0;
		lastUpdate = 0;
		nextUpdate = 0;
		framePeriod = -1;

		Browser.window.addEventListener("keydown", window_onKeyDown, false);
		Browser.window.addEventListener("keyup", window_onKeyUp, false);
		Browser.window.addEventListener("focus", window_onFocus, false);
		Browser.window.addEventListener("blur", window_onBlur, false);
		Browser.window.addEventListener("resize", window_onResize, false);
		Browser.window.addEventListener("beforeunload", window_onBeforeUnload, false);
		Browser.window.addEventListener("devicemotion", window_onDeviceMotion, false);

		// #if stats
		// __stats = untyped __js__("new Stats ()");
		// __stats.domElement.style.position = "absolute";
		// __stats.domElement.style.top = "0px";
		// Browser.document.body.appendChild(__stats.domElement);
		// #end

		untyped __js__("
			if (!CanvasRenderingContext2D.prototype.isPointInStroke) {
				CanvasRenderingContext2D.prototype.isPointInStroke = function (path, x, y) {
					return false;
				};
			}
			if (!CanvasRenderingContext2D.prototype.isPointInPath) {
				CanvasRenderingContext2D.prototype.isPointInPath = function (path, x, y) {
					return false;
				};
			}

			if ('performance' in window == false) {
				window.performance = {};
			}

			if ('now' in window.performance == false) {
				var offset = Date.now();
				if (performance.timing && performance.timing.navigationStart) {
					offset = performance.timing.navigationStart
				}
				window.performance.now = function now() {
					return Date.now() - offset;
				}
			}

			var lastTime = 0;
			var vendors = ['ms', 'moz', 'webkit', 'o'];
			for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
				window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
				window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
			}

			if (!window.requestAnimationFrame)
				window.requestAnimationFrame = function(callback, element) {
					var currTime = new Date().getTime();
					var timeToCall = Math.max(0, 16 - (currTime - lastTime));
					var id = window.setTimeout(function() { callback(currTime + timeToCall); },
					  timeToCall);
					lastTime = currTime + timeToCall;
					return id;
				};

			if (!window.cancelAnimationFrame)
				window.cancelAnimationFrame = function(id) {
					clearTimeout(id);
				};

			window.requestAnimFrame = window.requestAnimationFrame;
		");

		lastUpdate = Date.now().getTime();

		parent.color = color;

		parent.__contentsScaleFactor = 1;
		parent.__wasFullscreen = false;

		parent.__resize();

		if (Lib.current.stage == null)
		{
			parent.addChild(Lib.current);
		}

		if (documentClass != null)
		{
			DisplayObject.__initStage = this;
			var sprite:Sprite = cast Type.createInstance(documentClass, []);
			// addChild (sprite); // done by init stage
			sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));
		}

		window_onRequestAnimationFrame();
	}

	// Event Handlers
	private function window_onBeforeUnload(event:JSEvent):Void {}

	private function window_onBlur(event:JSEvent):Void {}

	private function window_onDeviceMotion(event:JSDeviceMotionEvent):Void {}

	private function window_onFocus(event:JSEvent):Void {}

	private function window_onKeyDown(event:JSKeyboardEvent):Void
	{
		// TODO: Remove intermediate KeyCode/KeyModifier type?
		var keyCode = cast parent.__convertKeyCode(event.keyCode != null ? event.keyCode : event.which);
		var modifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

		if (parent.window_onKey(KeyboardEvent.KEY_DOWN, keyCode, modifier) && event.cancelable)
		{
			event.preventDefault();
		}
	}

	private function window_onKeyUp(event:JSKeyboardEvent):Void
	{
		// TODO: Remove intermediate KeyCode/KeyModifier type?
		var keyCode = cast parent.__convertKeyCode(event.keyCode != null ? event.keyCode : event.which);
		var modifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

		if (parent.window_onKey(KeyboardEvent.KEY_UP, keyCode, modifier) && event.cancelable)
		{
			event.preventDefault();
		}
	}

	private function window_onRequestAnimationFrame(?__):Void
	{
		// for (window in parent.__windows)
		// {
		// 	window.__backend.updateSize();
		// }

		// updateGameDevices();

		currentUpdate = Date.now().getTime();

		if (currentUpdate >= nextUpdate)
		{
			// #if stats
			// stats.begin();
			// #end

			parent.__deltaTime = currentUpdate - lastUpdate;
			parent.__dispatchPendingMouseEvent();
			parent.__render();

			// #if stats
			// stats.end();
			// #end

			if (framePeriod < 0)
			{
				nextUpdate = currentUpdate;
			}
			else
			{
				nextUpdate = currentUpdate - (currentUpdate % framePeriod) + framePeriod;
			}

			lastUpdate = currentUpdate;
		}

		Browser.window.requestAnimationFrame(cast window_onRequestAnimationFrame);
	}

	private function window_onResize(event:JSEvent):Void {}
}
#end
