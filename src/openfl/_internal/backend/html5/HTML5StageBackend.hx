package openfl._internal.backend.html5;

#if openfl_html5
import js.html.DeviceMotionEvent in JSDeviceMotionEvent;
import js.html.Event in JSEvent;
import js.html.KeyboardEvent in JSKeyboardEvent;
import openfl._internal.backend.lime_standalone.KeyCode;
import openfl._internal.backend.lime_standalone.KeyModifier;
import openfl.display.DisplayObject;
import openfl.display.LoaderInfo;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)
class HTML5StageBackend
{
	private var currentUpdate:Float;
	private var framePeriod:Int;
	private var lastUpdate:Float;
	private var nextUpdate:Float;
	private var parent:Stage;

	public function new(parent:Stage, width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
			windowAttributes:Dynamic = null)
	{
		this.parent = parent;

		if (Lib.current == null)
		{
			Lib.current = new MovieClip();
		}

		if (Lib.current.__loaderInfo == null)
		{
			Lib.current.__loaderInfo = LoaderInfo.create(null);
			Lib.current.__loaderInfo.content = Lib.current;
		}

		var resizable = (width == 0 && width == 0);
		parent.element = Browser.document.createElement("div");

		if (resizable)
		{
			parent.element.style.width = "100%";
			parent.element.style.height = "100%";
		}

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
			DisplayObject.__initStage = parent;
			var sprite:Sprite = cast Type.createInstance(documentClass, []);
			// addChild (sprite); // done by init stage
			sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));
		}

		window_onRequestAnimationFrame();
	}

	private function convertKeyCode(keyCode:Int):KeyCode
	{
		if (keyCode >= 65 && keyCode <= 90)
		{
			return keyCode + 32;
		}

		switch (keyCode)
		{
			case 12:
				return KeyCode.CLEAR;
			case 16:
				return KeyCode.LEFT_SHIFT;
			case 17:
				return KeyCode.LEFT_CTRL;
			case 18:
				return KeyCode.LEFT_ALT;
			case 19:
				return KeyCode.PAUSE;
			case 20:
				return KeyCode.CAPS_LOCK;
			case 33:
				return KeyCode.PAGE_UP;
			case 34:
				return KeyCode.PAGE_DOWN;
			case 35:
				return KeyCode.END;
			case 36:
				return KeyCode.HOME;
			case 37:
				return KeyCode.LEFT;
			case 38:
				return KeyCode.UP;
			case 39:
				return KeyCode.RIGHT;
			case 40:
				return KeyCode.DOWN;
			case 41:
				return KeyCode.SELECT;
			case 43:
				return KeyCode.EXECUTE;
			case 44:
				return KeyCode.PRINT_SCREEN;
			case 45:
				return KeyCode.INSERT;
			case 46:
				return KeyCode.DELETE;
			case 91:
				return KeyCode.LEFT_META;
			case 92:
				return KeyCode.RIGHT_META;
			case 93:
				return KeyCode.RIGHT_META; // this maybe should be APPLICATION if on Windows
			case 95:
				return KeyCode.SLEEP;
			case 96:
				return KeyCode.NUMPAD_0;
			case 97:
				return KeyCode.NUMPAD_1;
			case 98:
				return KeyCode.NUMPAD_2;
			case 99:
				return KeyCode.NUMPAD_3;
			case 100:
				return KeyCode.NUMPAD_4;
			case 101:
				return KeyCode.NUMPAD_5;
			case 102:
				return KeyCode.NUMPAD_6;
			case 103:
				return KeyCode.NUMPAD_7;
			case 104:
				return KeyCode.NUMPAD_8;
			case 105:
				return KeyCode.NUMPAD_9;
			case 106:
				return KeyCode.NUMPAD_MULTIPLY;
			case 107:
				return KeyCode.NUMPAD_PLUS;
			case 108:
				return KeyCode.NUMPAD_PERIOD;
			case 109:
				return KeyCode.NUMPAD_MINUS;
			case 110:
				return KeyCode.NUMPAD_PERIOD;
			case 111:
				return KeyCode.NUMPAD_DIVIDE;
			case 112:
				return KeyCode.F1;
			case 113:
				return KeyCode.F2;
			case 114:
				return KeyCode.F3;
			case 115:
				return KeyCode.F4;
			case 116:
				return KeyCode.F5;
			case 117:
				return KeyCode.F6;
			case 118:
				return KeyCode.F7;
			case 119:
				return KeyCode.F8;
			case 120:
				return KeyCode.F9;
			case 121:
				return KeyCode.F10;
			case 122:
				return KeyCode.F11;
			case 123:
				return KeyCode.F12;
			case 124:
				return KeyCode.F13;
			case 125:
				return KeyCode.F14;
			case 126:
				return KeyCode.F15;
			case 127:
				return KeyCode.F16;
			case 128:
				return KeyCode.F17;
			case 129:
				return KeyCode.F18;
			case 130:
				return KeyCode.F19;
			case 131:
				return KeyCode.F20;
			case 132:
				return KeyCode.F21;
			case 133:
				return KeyCode.F22;
			case 134:
				return KeyCode.F23;
			case 135:
				return KeyCode.F24;
			case 144:
				return KeyCode.NUM_LOCK;
			case 145:
				return KeyCode.SCROLL_LOCK;
			case 160:
				return KeyCode.CARET;
			case 161:
				return KeyCode.EXCLAMATION;
			case 163:
				return KeyCode.HASH;
			case 164:
				return KeyCode.DOLLAR;
			case 166:
				return KeyCode.APP_CONTROL_BACK;
			case 167:
				return KeyCode.APP_CONTROL_FORWARD;
			case 168:
				return KeyCode.APP_CONTROL_REFRESH;
			case 169:
				return KeyCode.RIGHT_PARENTHESIS; // is this correct?
			case 170:
				return KeyCode.ASTERISK;
			case 171:
				return KeyCode.GRAVE;
			case 172:
				return KeyCode.HOME;
			case 173:
				return KeyCode.MINUS; // or mute/unmute?
			case 174:
				return KeyCode.VOLUME_DOWN;
			case 175:
				return KeyCode.VOLUME_UP;
			case 176:
				return KeyCode.AUDIO_NEXT;
			case 177:
				return KeyCode.AUDIO_PREVIOUS;
			case 178:
				return KeyCode.AUDIO_STOP;
			case 179:
				return KeyCode.AUDIO_PLAY;
			case 180:
				return KeyCode.MAIL;
			case 181:
				return KeyCode.AUDIO_MUTE;
			case 182:
				return KeyCode.VOLUME_DOWN;
			case 183:
				return KeyCode.VOLUME_UP;
			case 186:
				return KeyCode.SEMICOLON; // or ñ?
			case 187:
				return KeyCode.EQUALS;
			case 188:
				return KeyCode.COMMA;
			case 189:
				return KeyCode.MINUS;
			case 190:
				return KeyCode.PERIOD;
			case 191:
				return KeyCode.SLASH;
			case 192:
				return KeyCode.GRAVE;
			case 193:
				return KeyCode.QUESTION;
			case 194:
				return KeyCode.NUMPAD_PERIOD;
			case 219:
				return KeyCode.LEFT_BRACKET;
			case 220:
				return KeyCode.BACKSLASH;
			case 221:
				return KeyCode.RIGHT_BRACKET;
			case 222:
				return KeyCode.SINGLE_QUOTE;
			case 223:
				return KeyCode.GRAVE;
			case 224:
				return KeyCode.LEFT_META;
			case 226:
				return KeyCode.BACKSLASH;
		}

		return keyCode;
	}

	// Event Handlers
	private function window_onBeforeUnload(event:JSEvent):Void {}

	private function window_onBlur(event:JSEvent):Void {}

	private function window_onDeviceMotion(event:JSDeviceMotionEvent):Void {}

	private function window_onFocus(event:JSEvent):Void {}

	private function window_onKeyDown(event:JSKeyboardEvent):Void
	{
		// TODO: Remove intermediate KeyCode/KeyModifier type?
		var keyCode = convertKeyCode(event.keyCode != null ? event.keyCode : event.which);
		var modifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

		if (parent.__onKey(KeyboardEvent.KEY_DOWN, keyCode, modifier) && event.cancelable)
		{
			event.preventDefault();
		}
	}

	private function window_onKeyUp(event:JSKeyboardEvent):Void
	{
		// TODO: Remove intermediate KeyCode/KeyModifier type?
		var keyCode = convertKeyCode(event.keyCode != null ? event.keyCode : event.which);
		var modifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

		if (parent.__onKey(KeyboardEvent.KEY_UP, keyCode, modifier) && event.cancelable)
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

			parent.__deltaTime = Std.int(currentUpdate - lastUpdate);
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
