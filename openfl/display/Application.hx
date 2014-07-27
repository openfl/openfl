package openfl.display;


import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.ui.Keyboard;
import openfl.Lib;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)


class Application extends lime.app.Application {
	
	
	private var stage:Stage;
	
	
	public function new () {
		
		super ();
		
		Lib.application = this;
		
	}
	
	
	#if !flash
	
	
	private function convertKeyCode (keyCode:KeyCode):Int {
		
		return switch (keyCode) {
			
			case KEY_BACKSPACE: Keyboard.BACKSPACE;
			case KEY_TAB: Keyboard.TAB;
			case KEY_RETURN: Keyboard.ENTER;
			case KEY_ESCAPE: Keyboard.ESCAPE;
			case KEY_SPACE: Keyboard.SPACE;
			//case KEY_EXCLAMATION: 0x21;
			//case KEY_QUOTE: 0x22;
			//case KEY_HASH: 0x23;
			//case KEY_DOLLAR: 0x24;
			//case KEY_PERCENT: 0x25;
			//case KEY_AMPERSAND: 0x26;
			case KEY_SINGLE_QUOTE: Keyboard.QUOTE;
			//case KEY_LEFT_PARENTHESIS: 0x28;
			//case KEY_RIGHT_PARENTHESIS: 0x29;
			//case KEY_ASTERISK: 0x2A;
			//case KEY_PLUS: 0x2B;
			case KEY_COMMA: Keyboard.COMMA;
			case KEY_MINUS: Keyboard.MINUS;
			case KEY_PERIOD: Keyboard.PERIOD;
			case KEY_SLASH: Keyboard.SLASH;
			case KEY_0: Keyboard.NUMBER_0;
			case KEY_1: Keyboard.NUMBER_1;
			case KEY_2: Keyboard.NUMBER_2;
			case KEY_3: Keyboard.NUMBER_3;
			case KEY_4: Keyboard.NUMBER_4;
			case KEY_5: Keyboard.NUMBER_5;
			case KEY_6: Keyboard.NUMBER_6;
			case KEY_7: Keyboard.NUMBER_7;
			case KEY_8: Keyboard.NUMBER_8;
			case KEY_9: Keyboard.NUMBER_9;
			//case KEY_COLON: 0x3A;
			case KEY_SEMICOLON: Keyboard.SEMICOLON;
			//case KEY_LESS_THAN: 0x3C;
			case KEY_EQUALS: Keyboard.EQUAL;
			//case KEY_GREATER_THAN: 0x3E;
			//case KEY_QUESTION: 0x3F;
			//case KEY_AT: 0x40;
			case KEY_LEFT_BRACKET: Keyboard.LEFTBRACKET;
			case KEY_BACKSLASH: Keyboard.BACKSLASH;
			case KEY_RIGHT_BRACKET: Keyboard.RIGHTBRACKET;
			//case KEY_CARET: 0x5E;
			//case KEY_UNDERSCORE: 0x5F;
			case KEY_GRAVE: Keyboard.BACKQUOTE;
			case KEY_A: Keyboard.A;
			case KEY_B: Keyboard.B;
			case KEY_C: Keyboard.C;
			case KEY_D: Keyboard.D;
			case KEY_E: Keyboard.E;
			case KEY_F: Keyboard.F;
			case KEY_G: Keyboard.G;
			case KEY_H: Keyboard.H;
			case KEY_I: Keyboard.I;
			case KEY_J: Keyboard.J;
			case KEY_K: Keyboard.K;
			case KEY_L: Keyboard.L;
			case KEY_M: Keyboard.M;
			case KEY_N: Keyboard.N;
			case KEY_O: Keyboard.O;
			case KEY_P: Keyboard.P;
			case KEY_Q: Keyboard.Q;
			case KEY_R: Keyboard.R;
			case KEY_S: Keyboard.S;
			case KEY_T: Keyboard.T;
			case KEY_U: Keyboard.U;
			case KEY_V: Keyboard.V;
			case KEY_W: Keyboard.W;
			case KEY_X: Keyboard.X;
			case KEY_Y: Keyboard.Y;
			case KEY_Z: Keyboard.Z;
			case KEY_DELETE: Keyboard.DELETE;
			case KEY_CAPS_LOCK: Keyboard.CAPS_LOCK;
			case KEY_F1: Keyboard.F1;
			case KEY_F2: Keyboard.F2;
			case KEY_F3: Keyboard.F3;
			case KEY_F4: Keyboard.F4;
			case KEY_F5: Keyboard.F5;
			case KEY_F6: Keyboard.F6;
			case KEY_F7: Keyboard.F7;
			case KEY_F8: Keyboard.F8;
			case KEY_F9: Keyboard.F9;
			case KEY_F10: Keyboard.F10;
			case KEY_F11: Keyboard.F11;
			case KEY_F12: Keyboard.F12;
			//case KEY_PRINT_SCREEN: 0x40000046;
			//case KEY_SCROLL_LOCK: 0x40000047;
			//case KEY_PAUSE: 0x40000048;
			case KEY_INSERT: Keyboard.INSERT;
			case KEY_HOME: Keyboard.HOME;
			case KEY_PAGE_UP: Keyboard.PAGE_UP;
			case KEY_END: Keyboard.END;
			case KEY_PAGE_DOWN: Keyboard.PAGE_DOWN;
			case KEY_RIGHT: Keyboard.RIGHT;
			case KEY_LEFT: Keyboard.LEFT;
			case KEY_DOWN: Keyboard.DOWN;
			case KEY_UP: Keyboard.UP;
			//case KEY_NUM_LOCK_CLEAR: 0x40000053;
			case KEY_NUMPAD_DIVIDE: Keyboard.NUMPAD_DIVIDE;
			case KEY_NUMPAD_MULTIPLY: Keyboard.NUMPAD_MULTIPLY;
			case KEY_NUMPAD_MINUS: Keyboard.NUMPAD_SUBTRACT;
			case KEY_NUMPAD_PLUS: Keyboard.NUMPAD_ADD;
			case KEY_NUMPAD_ENTER: Keyboard.NUMPAD_ENTER;
			case KEY_NUMPAD_1: Keyboard.NUMPAD_1;
			case KEY_NUMPAD_2: Keyboard.NUMPAD_2;
			case KEY_NUMPAD_3: Keyboard.NUMPAD_3;
			case KEY_NUMPAD_4: Keyboard.NUMPAD_4;
			case KEY_NUMPAD_5: Keyboard.NUMPAD_5;
			case KEY_NUMPAD_6: Keyboard.NUMPAD_6;
			case KEY_NUMPAD_7: Keyboard.NUMPAD_7;
			case KEY_NUMPAD_8: Keyboard.NUMPAD_8;
			case KEY_NUMPAD_9: Keyboard.NUMPAD_9;
			case KEY_NUMPAD_0: Keyboard.NUMPAD_0;
			case KEY_NUMPAD_PERIOD: Keyboard.NUMPAD_DECIMAL;
			//case KEY_APPLICATION: 0x40000065;
			//case KEY_POWER: 0x40000066;
			//case KEY_NUMPAD_EQUALS: 0x40000067;
			case KEY_F13: Keyboard.F13;
			case KEY_F14: Keyboard.F14;
			case KEY_F15: Keyboard.F15;
			//case KEY_F16: 0x4000006B;
			//case KEY_F17: 0x4000006C;
			//case KEY_F18: 0x4000006D;
			//case KEY_F19: 0x4000006E;
			//case KEY_F20: 0x4000006F;
			//case KEY_F21: 0x40000070;
			//case KEY_F22: 0x40000071;
			//case KEY_F23: 0x40000072;
			//case KEY_F24: 0x40000073;
			//case KEY_EXECUTE: 0x40000074;
			//case KEY_HELP: 0x40000075;
			//case KEY_MENU: 0x40000076;
			//case KEY_SELECT: 0x40000077;
			//case KEY_STOP: 0x40000078;
			//case KEY_AGAIN: 0x40000079;
			//case KEY_UNDO: 0x4000007A;
			//case KEY_CUT: 0x4000007B;
			//case KEY_COPY: 0x4000007C;
			//case KEY_PASTE: 0x4000007D;
			//case KEY_FIND: 0x4000007E;
			//case KEY_MUTE: 0x4000007F;
			//case KEY_VOLUME_UP: 0x40000080;
			//case KEY_VOLUME_DOWN: 0x40000081;
			//case KEY_NUMPAD_COMMA: 0x40000085;
			////case KEY_NUMPAD_EQUALS_AS400: 0x40000086;
			//case KEY_ALT_ERASE: 0x40000099;
			//case KEY_SYSTEM_REQUEST: 0x4000009A;
			//case KEY_CANCEL: 0x4000009B;
			//case KEY_CLEAR: 0x4000009C;
			//case KEY_PRIOR: 0x4000009D;
			//case KEY_RETURN2: 0x4000009E;
			//case KEY_SEPARATOR: 0x4000009F;
			//case KEY_OUT: 0x400000A0;
			//case KEY_OPER: 0x400000A1;
			//case KEY_CLEAR_AGAIN: 0x400000A2;
			//case KEY_CRSEL: 0x400000A3;
			//case KEY_EXSEL: 0x400000A4;
			//case KEY_NUMPAD_00: 0x400000B0;
			//case KEY_NUMPAD_000: 0x400000B1;
			//case KEY_THOUSAND_SEPARATOR: 0x400000B2;
			//case KEY_DECIMAL_SEPARATOR: 0x400000B3;
			//case KEY_CURRENCY_UNIT: 0x400000B4;
			//case KEY_CURRENCY_SUBUNIT: 0x400000B5;
			//case KEY_NUMPAD_LEFT_PARENTHESIS: 0x400000B6;
			//case KEY_NUMPAD_RIGHT_PARENTHESIS: 0x400000B7;
			//case KEY_NUMPAD_LEFT_BRACE: 0x400000B8;
			//case KEY_NUMPAD_RIGHT_BRACE: 0x400000B9;
			//case KEY_NUMPAD_TAB: 0x400000BA;
			//case KEY_NUMPAD_BACKSPACE: 0x400000BB;
			//case KEY_NUMPAD_A: 0x400000BC;
			//case KEY_NUMPAD_B: 0x400000BD;
			//case KEY_NUMPAD_C: 0x400000BE;
			//case KEY_NUMPAD_D: 0x400000BF;
			//case KEY_NUMPAD_E: 0x400000C0;
			//case KEY_NUMPAD_F: 0x400000C1;
			//case KEY_NUMPAD_XOR: 0x400000C2;
			//case KEY_NUMPAD_POWER: 0x400000C3;
			//case KEY_NUMPAD_PERCENT: 0x400000C4;
			//case KEY_NUMPAD_LESS_THAN: 0x400000C5;
			//case KEY_NUMPAD_GREATER_THAN: 0x400000C6;
			//case KEY_NUMPAD_AMPERSAND: 0x400000C7;
			//case KEY_NUMPAD_DOUBLE_AMPERSAND: 0x400000C8;
			//case KEY_NUMPAD_VERTICAL_BAR: 0x400000C9;
			//case KEY_NUMPAD_DOUBLE_VERTICAL_BAR: 0x400000CA;
			//case KEY_NUMPAD_COLON: 0x400000CB;
			//case KEY_NUMPAD_HASH: 0x400000CC;
			//case KEY_NUMPAD_SPACE: 0x400000CD;
			//case KEY_NUMPAD_AT: 0x400000CE;
			//case KEY_NUMPAD_EXCLAMATION: 0x400000CF;
			//case KEY_NUMPAD_MEM_STORE: 0x400000D0;
			//case KEY_NUMPAD_MEM_RECALL: 0x400000D1;
			//case KEY_NUMPAD_MEM_CLEAR: 0x400000D2;
			//case KEY_NUMPAD_MEM_ADD: 0x400000D3;
			//case KEY_NUMPAD_MEM_SUBTRACT: 0x400000D4;
			//case KEY_NUMPAD_MEM_MULTIPLY: 0x400000D5;
			//case KEY_NUMPAD_MEM_DIVIDE: 0x400000D6;
			//case KEY_NUMPAD_PLUS_MINUS: 0x400000D7;
			//case KEY_NUMPAD_CLEAR: 0x400000D8;
			//case KEY_NUMPAD_CLEAR_ENTRY: 0x400000D9;
			//case KEY_NUMPAD_BINARY: 0x400000DA;
			//case KEY_NUMPAD_OCTAL: 0x400000DB;
			//case KEY_NUMPAD_DECIMAL: 0x400000DC;
			//case KEY_NUMPAD_HEXADECIMAL: 0x400000DD;
			case KEY_LEFT_CTRL: Keyboard.CONTROL;
			case KEY_LEFT_SHIFT: Keyboard.SHIFT;
			case KEY_LEFT_ALT: Keyboard.ALTERNATE;
			//case KEY_LEFT_META: 0x400000E3;
			case KEY_RIGHT_CTRL: Keyboard.CONTROL;
			case KEY_RIGHT_SHIFT: Keyboard.SHIFT;
			case KEY_RIGHT_ALT: Keyboard.ALTERNATE;
			//case KEY_RIGHT_META: 0x400000E7;
			//case KEY_MODE: 0x40000101;
			//case KEY_AUDIO_NEXT: 0x40000102;
			//case KEY_AUDIO_PREVIOUS: 0x40000103;
			//case KEY_AUDIO_STOP: 0x40000104;
			//case KEY_AUDIO_PLAY: 0x40000105;
			//case KEY_AUDIO_MUTE: 0x40000106;
			//case KEY_MEDIA_SELECT: 0x40000107;
			//case KEY_WWW: 0x40000108;
			//case KEY_MAIL: 0x40000109;
			//case KEY_CALCULATOR: 0x4000010A;
			//case KEY_COMPUTER: 0x4000010B;
			//case KEY_APP_CONTROL_SEARCH: 0x4000010C;
			//case KEY_APP_CONTROL_HOME: 0x4000010D;
			//case KEY_APP_CONTROL_BACK: 0x4000010E;
			//case KEY_APP_CONTROL_FORWARD: 0x4000010F;
			//case KEY_APP_CONTROL_STOP: 0x40000110;
			//case KEY_APP_CONTROL_REFRESH: 0x40000111;
			//case KEY_APP_CONTROL_BOOKMARKS: 0x40000112;
			//case KEY_BRIGHTNESS_DOWN: 0x40000113;
			//case KEY_BRIGHTNESS_UP: 0x40000114;
			//case KEY_DISPLAY_SWITCH: 0x40000115;
			//case KEY_BACKLIGHT_TOGGLE: 0x40000116;
			//case KEY_BACKLIGHT_DOWN: 0x40000117;
			//case KEY_BACKLIGHT_UP: 0x40000118;
			//case KEY_EJECT: 0x40000119;
			//case KEY_SLEEP: 0x4000011A;
			default: cast keyCode;
			
		}
		
	}
	
	
	public override function create (config:lime.app.Config):Void {
		
		super.create (config);
		
		stage = new Stage (window.width, window.height, config.background);
		stage.addChild (Lib.current);
		
	}
	
	
	private function onKey (event:KeyboardEvent):Void {
		
		var stack = new Array <DisplayObject> ();
		
		if (stage.__focus == null) {
			
			stage.__getInteractive (stack);
			
		} else {
			
			stage.__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {
			
			stack.reverse ();
			stage.__fireEvent (event, stack);
			
		}
		
	}
	
	
	public override function onKeyDown (keyCode:Int, modifier:Int):Void {
		
		var keyCode = convertKeyCode (cast keyCode);
		var charCode = keyCode;
		
		//var event = new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey)
		onKey (new KeyboardEvent (KeyboardEvent.KEY_DOWN, true, false, charCode, keyCode));
		
	}
	
	
	public override function onKeyUp (keyCode:Int, modifier:Int):Void {
		
		var keyCode = convertKeyCode (cast keyCode);
		var charCode = keyCode;
		
		//var event = new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey)
		onKey (new KeyboardEvent (KeyboardEvent.KEY_UP, true, false, charCode, keyCode));
		
	}
	
	
	private function onMouse (type:String, x:Float, y:Float):Void {
		
		/*var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			__mouseX = (event.clientX - rect.left) * (stageWidth / rect.width);
			__mouseY = (event.clientY - rect.top) * (stageHeight / rect.height);
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			//__mouseX = (event.clientX - rect.left) * (__div.style.width / rect.width);
			__mouseX = (event.clientX - rect.left);
			//__mouseY = (event.clientY - rect.top) * (__div.style.height / rect.height);
			__mouseY = (event.clientY - rect.top);
			
		}*/
		
		stage.__mouseX = x;
		stage.__mouseY = y;
		
		var __stack = [];
		
		if (stage.__hitTest (x, y, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			stage.__setCursor (untyped (target).buttonMode ? "pointer" : "default");
			stage.__fireEvent (MouseEvent.__create (type, /*event,*/ target.globalToLocal (new Point (x, y)), cast target), __stack);
			
			if (type == MouseEvent.MOUSE_UP) {
				
				stage.__fireEvent (MouseEvent.__create (MouseEvent.CLICK, /*event,*/ target.globalToLocal (new Point (x, y)), cast target), __stack);
				
			}
			
		} else {
			
			stage.__setCursor (stage.buttonMode ? "pointer" : "default");
			stage.__fireEvent (MouseEvent.__create (type, /*event,*/ new Point (x, y), stage), [ stage ]);
			
			if (type == MouseEvent.MOUSE_UP) {
				
				stage.__fireEvent (MouseEvent.__create (MouseEvent.CLICK, /*event,*/ new Point (x, y), stage), [ stage ]);
				
			}
			
		}
		
		if (stage.__dragObject != null) {
			
			stage.__drag (new Point (x, y));
			
		}
		
	}
	
	
	public override function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_DOWN, x, y);
		
	}
	
	
	public override function onMouseMove (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_MOVE, x, y);
		
	}
	
	
	public override function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_UP, x, y);
		
	}
	
	
	private function onTouch (type:String, x:Float, y:Float, id:Int):Void {
		
		/*event.preventDefault ();
		
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			
		}
		
		var touch = event.changedTouches[0];
		var point = new Point ((touch.pageX - rect.left) * (stageWidth / rect.width), (touch.pageY - rect.top) * (stageHeight / rect.height));
		*/
		var point = new Point (x, y);
		
		stage.__mouseX = point.x;
		stage.__mouseY = point.y;
		
		var __stack = [];
		
		var mouseType = switch (type) {
			
			case TouchEvent.TOUCH_BEGIN: MouseEvent.MOUSE_DOWN;
			case TouchEvent.TOUCH_MOVE: MouseEvent.MOUSE_MOVE;
			case TouchEvent.TOUCH_END: MouseEvent.MOUSE_UP;
			default: null;
			
		}
		
		if (stage.__hitTest (x, x, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, localPoint, cast target);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, /*cast event,*/ localPoint, cast target);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			stage.__fireEvent (touchEvent, __stack);
			stage.__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, point, stage);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, /*cast event,*/ point, stage);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			stage.__fireEvent (touchEvent, [ stage ]);
			stage.__fireEvent (mouseEvent, [ stage ]);
			
		}
		
		if (type == TouchEvent.TOUCH_MOVE && stage.__dragObject != null) {
			
			stage.__drag (point);
			
		}
		
	}
	
	
	public override function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		onTouch (TouchEvent.TOUCH_MOVE, x, y, id);
		
	}
	
	
	public override function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		onTouch (TouchEvent.TOUCH_END, x, y, id);
		
	}
	
	
	public override function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		onTouch (TouchEvent.TOUCH_BEGIN, x, y, id);
		
	}
	
	
	public override function onWindowActivate ():Void {
		
		var event = new openfl.events.Event (openfl.events.Event.ACTIVATE);
		stage.__broadcast (event, true);
		
	}
	
	
	public override function onWindowDeactivate ():Void {
		
		var event = new openfl.events.Event (openfl.events.Event.DEACTIVATE);
		stage.__broadcast (event, true);
		
	}
	
	
	public override function onWindowResize (width:Int, height:Int):Void {
		
		stage.stageWidth = width;
		stage.stageHeight = height;
		
		var event = new openfl.events.Event (openfl.events.Event.RESIZE);
		stage.__broadcast (event, false);
		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		stage.__render (context);
		
	}
	
	
	#end
	
	
}