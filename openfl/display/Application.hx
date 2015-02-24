package openfl.display;


import lime.app.Application in LimeApplication;
import lime.app.Config in LimeConfig;
import lime.graphics.RenderContext;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Mouse;
import openfl.display.InteractiveObject;
import openfl.display.Stage;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.ui.Keyboard;
import openfl.Lib;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)


class Application extends LimeApplication {
	
	
	private var stage:Stage;
	private var __lastClickTime:Int;
	private var __mouseOutStack = [];
	
	
	public function new () {
		
		super ();
		
		Lib.application = this;
		
	}
	
	
	#if !flash
	
	
	@:noCompletion private function convertKeyCode (keyCode:KeyCode):Int {
		
		return switch (keyCode) {
			
			case BACKSPACE: Keyboard.BACKSPACE;
			case TAB: Keyboard.TAB;
			case RETURN: Keyboard.ENTER;
			case ESCAPE: Keyboard.ESCAPE;
			case SPACE: Keyboard.SPACE;
			//case EXCLAMATION: 0x21;
			//case QUOTE: 0x22;
			//case HASH: 0x23;
			//case DOLLAR: 0x24;
			//case PERCENT: 0x25;
			//case AMPERSAND: 0x26;
			case SINGLE_QUOTE: Keyboard.QUOTE;
			//case LEFT_PARENTHESIS: 0x28;
			//case RIGHT_PARENTHESIS: 0x29;
			//case ASTERISK: 0x2A;
			//case PLUS: 0x2B;
			case COMMA: Keyboard.COMMA;
			case MINUS: Keyboard.MINUS;
			case PERIOD: Keyboard.PERIOD;
			case SLASH: Keyboard.SLASH;
			case NUMBER_0: Keyboard.NUMBER_0;
			case NUMBER_1: Keyboard.NUMBER_1;
			case NUMBER_2: Keyboard.NUMBER_2;
			case NUMBER_3: Keyboard.NUMBER_3;
			case NUMBER_4: Keyboard.NUMBER_4;
			case NUMBER_5: Keyboard.NUMBER_5;
			case NUMBER_6: Keyboard.NUMBER_6;
			case NUMBER_7: Keyboard.NUMBER_7;
			case NUMBER_8: Keyboard.NUMBER_8;
			case NUMBER_9: Keyboard.NUMBER_9;
			//case COLON: 0x3A;
			case SEMICOLON: Keyboard.SEMICOLON;
			//case LESS_THAN: 0x3C;
			case EQUALS: Keyboard.EQUAL;
			//case GREATER_THAN: 0x3E;
			//case QUESTION: 0x3F;
			//case AT: 0x40;
			case LEFT_BRACKET: Keyboard.LEFTBRACKET;
			case BACKSLASH: Keyboard.BACKSLASH;
			case RIGHT_BRACKET: Keyboard.RIGHTBRACKET;
			//case CARET: 0x5E;
			//case UNDERSCORE: 0x5F;
			case GRAVE: Keyboard.BACKQUOTE;
			case A: Keyboard.A;
			case B: Keyboard.B;
			case C: Keyboard.C;
			case D: Keyboard.D;
			case E: Keyboard.E;
			case F: Keyboard.F;
			case G: Keyboard.G;
			case H: Keyboard.H;
			case I: Keyboard.I;
			case J: Keyboard.J;
			case K: Keyboard.K;
			case L: Keyboard.L;
			case M: Keyboard.M;
			case N: Keyboard.N;
			case O: Keyboard.O;
			case P: Keyboard.P;
			case Q: Keyboard.Q;
			case R: Keyboard.R;
			case S: Keyboard.S;
			case T: Keyboard.T;
			case U: Keyboard.U;
			case V: Keyboard.V;
			case W: Keyboard.W;
			case X: Keyboard.X;
			case Y: Keyboard.Y;
			case Z: Keyboard.Z;
			case DELETE: Keyboard.DELETE;
			case CAPS_LOCK: Keyboard.CAPS_LOCK;
			case F1: Keyboard.F1;
			case F2: Keyboard.F2;
			case F3: Keyboard.F3;
			case F4: Keyboard.F4;
			case F5: Keyboard.F5;
			case F6: Keyboard.F6;
			case F7: Keyboard.F7;
			case F8: Keyboard.F8;
			case F9: Keyboard.F9;
			case F10: Keyboard.F10;
			case F11: Keyboard.F11;
			case F12: Keyboard.F12;
			//case PRINT_SCREEN: 0x40000046;
			//case SCROLL_LOCK: 0x40000047;
			//case PAUSE: 0x40000048;
			case INSERT: Keyboard.INSERT;
			case HOME: Keyboard.HOME;
			case PAGE_UP: Keyboard.PAGE_UP;
			case END: Keyboard.END;
			case PAGE_DOWN: Keyboard.PAGE_DOWN;
			case RIGHT: Keyboard.RIGHT;
			case LEFT: Keyboard.LEFT;
			case DOWN: Keyboard.DOWN;
			case UP: Keyboard.UP;
			//case NUM_LOCK_CLEAR: 0x40000053;
			case NUMPAD_DIVIDE: Keyboard.NUMPAD_DIVIDE;
			case NUMPAD_MULTIPLY: Keyboard.NUMPAD_MULTIPLY;
			case NUMPAD_MINUS: Keyboard.NUMPAD_SUBTRACT;
			case NUMPAD_PLUS: Keyboard.NUMPAD_ADD;
			case NUMPAD_ENTER: Keyboard.NUMPAD_ENTER;
			case NUMPAD_1: Keyboard.NUMPAD_1;
			case NUMPAD_2: Keyboard.NUMPAD_2;
			case NUMPAD_3: Keyboard.NUMPAD_3;
			case NUMPAD_4: Keyboard.NUMPAD_4;
			case NUMPAD_5: Keyboard.NUMPAD_5;
			case NUMPAD_6: Keyboard.NUMPAD_6;
			case NUMPAD_7: Keyboard.NUMPAD_7;
			case NUMPAD_8: Keyboard.NUMPAD_8;
			case NUMPAD_9: Keyboard.NUMPAD_9;
			case NUMPAD_0: Keyboard.NUMPAD_0;
			case NUMPAD_PERIOD: Keyboard.NUMPAD_DECIMAL;
			//case APPLICATION: 0x40000065;
			//case POWER: 0x40000066;
			//case NUMPAD_EQUALS: 0x40000067;
			case F13: Keyboard.F13;
			case F14: Keyboard.F14;
			case F15: Keyboard.F15;
			//case F16: 0x4000006B;
			//case F17: 0x4000006C;
			//case F18: 0x4000006D;
			//case F19: 0x4000006E;
			//case F20: 0x4000006F;
			//case F21: 0x40000070;
			//case F22: 0x40000071;
			//case F23: 0x40000072;
			//case F24: 0x40000073;
			//case EXECUTE: 0x40000074;
			//case HELP: 0x40000075;
			//case MENU: 0x40000076;
			//case SELECT: 0x40000077;
			//case STOP: 0x40000078;
			//case AGAIN: 0x40000079;
			//case UNDO: 0x4000007A;
			//case CUT: 0x4000007B;
			//case COPY: 0x4000007C;
			//case PASTE: 0x4000007D;
			//case FIND: 0x4000007E;
			//case MUTE: 0x4000007F;
			//case VOLUME_UP: 0x40000080;
			//case VOLUME_DOWN: 0x40000081;
			//case NUMPAD_COMMA: 0x40000085;
			////case NUMPAD_EQUALS_AS400: 0x40000086;
			//case ALT_ERASE: 0x40000099;
			//case SYSTEM_REQUEST: 0x4000009A;
			//case CANCEL: 0x4000009B;
			//case CLEAR: 0x4000009C;
			//case PRIOR: 0x4000009D;
			//case RETURN2: 0x4000009E;
			//case SEPARATOR: 0x4000009F;
			//case OUT: 0x400000A0;
			//case OPER: 0x400000A1;
			//case CLEAR_AGAIN: 0x400000A2;
			//case CRSEL: 0x400000A3;
			//case EXSEL: 0x400000A4;
			//case NUMPAD_00: 0x400000B0;
			//case NUMPAD_000: 0x400000B1;
			//case THOUSAND_SEPARATOR: 0x400000B2;
			//case DECIMAL_SEPARATOR: 0x400000B3;
			//case CURRENCY_UNIT: 0x400000B4;
			//case CURRENCY_SUBUNIT: 0x400000B5;
			//case NUMPAD_LEFT_PARENTHESIS: 0x400000B6;
			//case NUMPAD_RIGHT_PARENTHESIS: 0x400000B7;
			//case NUMPAD_LEFT_BRACE: 0x400000B8;
			//case NUMPAD_RIGHT_BRACE: 0x400000B9;
			//case NUMPAD_TAB: 0x400000BA;
			//case NUMPAD_BACKSPACE: 0x400000BB;
			//case NUMPAD_A: 0x400000BC;
			//case NUMPAD_B: 0x400000BD;
			//case NUMPAD_C: 0x400000BE;
			//case NUMPAD_D: 0x400000BF;
			//case NUMPAD_E: 0x400000C0;
			//case NUMPAD_F: 0x400000C1;
			//case NUMPAD_XOR: 0x400000C2;
			//case NUMPAD_POWER: 0x400000C3;
			//case NUMPAD_PERCENT: 0x400000C4;
			//case NUMPAD_LESS_THAN: 0x400000C5;
			//case NUMPAD_GREATER_THAN: 0x400000C6;
			//case NUMPAD_AMPERSAND: 0x400000C7;
			//case NUMPAD_DOUBLE_AMPERSAND: 0x400000C8;
			//case NUMPAD_VERTICAL_BAR: 0x400000C9;
			//case NUMPAD_DOUBLE_VERTICAL_BAR: 0x400000CA;
			//case NUMPAD_COLON: 0x400000CB;
			//case NUMPAD_HASH: 0x400000CC;
			//case NUMPAD_SPACE: 0x400000CD;
			//case NUMPAD_AT: 0x400000CE;
			//case NUMPAD_EXCLAMATION: 0x400000CF;
			//case NUMPAD_MEM_STORE: 0x400000D0;
			//case NUMPAD_MEM_RECALL: 0x400000D1;
			//case NUMPAD_MEM_CLEAR: 0x400000D2;
			//case NUMPAD_MEM_ADD: 0x400000D3;
			//case NUMPAD_MEM_SUBTRACT: 0x400000D4;
			//case NUMPAD_MEM_MULTIPLY: 0x400000D5;
			//case NUMPAD_MEM_DIVIDE: 0x400000D6;
			//case NUMPAD_PLUS_MINUS: 0x400000D7;
			//case NUMPAD_CLEAR: 0x400000D8;
			//case NUMPAD_CLEAR_ENTRY: 0x400000D9;
			//case NUMPAD_BINARY: 0x400000DA;
			//case NUMPAD_OCTAL: 0x400000DB;
			//case NUMPAD_DECIMAL: 0x400000DC;
			//case NUMPAD_HEXADECIMAL: 0x400000DD;
			case LEFT_CTRL: Keyboard.CONTROL;
			case LEFT_SHIFT: Keyboard.SHIFT;
			case LEFT_ALT: Keyboard.ALTERNATE;
			//case LEFT_META: 0x400000E3;
			case RIGHT_CTRL: Keyboard.CONTROL;
			case RIGHT_SHIFT: Keyboard.SHIFT;
			case RIGHT_ALT: Keyboard.ALTERNATE;
			//case RIGHT_META: 0x400000E7;
			//case MODE: 0x40000101;
			//case AUDIO_NEXT: 0x40000102;
			//case AUDIO_PREVIOUS: 0x40000103;
			//case AUDIO_STOP: 0x40000104;
			//case AUDIO_PLAY: 0x40000105;
			//case AUDIO_MUTE: 0x40000106;
			//case MEDIA_SELECT: 0x40000107;
			//case WWW: 0x40000108;
			//case MAIL: 0x40000109;
			//case CALCULATOR: 0x4000010A;
			//case COMPUTER: 0x4000010B;
			//case APP_CONTROL_SEARCH: 0x4000010C;
			//case APP_CONTROL_HOME: 0x4000010D;
			//case APP_CONTROL_BACK: 0x4000010E;
			//case APP_CONTROL_FORWARD: 0x4000010F;
			//case APP_CONTROL_STOP: 0x40000110;
			//case APP_CONTROL_REFRESH: 0x40000111;
			//case APP_CONTROL_BOOKMARKS: 0x40000112;
			//case BRIGHTNESS_DOWN: 0x40000113;
			//case BRIGHTNESS_UP: 0x40000114;
			//case DISPLAY_SWITCH: 0x40000115;
			//case BACKLIGHT_TOGGLE: 0x40000116;
			//case BACKLIGHT_DOWN: 0x40000117;
			//case BACKLIGHT_UP: 0x40000118;
			//case EJECT: 0x40000119;
			//case SLEEP: 0x4000011A;
			default: cast keyCode;
			
		}
		
	}
	
	
	public override function create (config:LimeConfig):Void {
		
		super.create (config);
		
		stage = new Stage (window.width, window.height, config.background);
		stage.addChild (Lib.current);
		
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
	}
	
	
	@:noCompletion private function onKey (event:KeyboardEvent):Void {
		
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
	
	
	public override function onKeyDown (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var keyCode = convertKeyCode (cast keyCode);
		var charCode = keyCode;
		
		//var event = new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey)
		onKey (new KeyboardEvent (KeyboardEvent.KEY_DOWN, true, false, charCode, keyCode, null, modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.metaKey));
		
	}
	
	
	public override function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var keyCode = convertKeyCode (cast keyCode);
		var charCode = keyCode;
		
		//var event = new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey)
		onKey (new KeyboardEvent (KeyboardEvent.KEY_UP, true, false, charCode, keyCode, null, modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.metaKey));
		
	}
	
	
	@:noCompletion private function onMouse (type:String, x:Float, y:Float, button:Int):Void {
		
		if (button > 2) return;
		
		stage.__mouseX = x;
		stage.__mouseY = y;
		
		var stack = [];
		var target:InteractiveObject = null;
		var targetPoint = new Point (x, y);
		
		if (stage.__hitTest (x, y, false, stack, true)) {
			
			target = cast stack[stack.length - 1];
			
		} else {
			
			target = stage;
			stack = [ stage ];
			
		}
		
		stage.__fireEvent (MouseEvent.__create (type, button, (target == stage ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
		
		var clickType = switch (type) {
			
			case MouseEvent.MOUSE_UP: MouseEvent.CLICK;
			case MouseEvent.MIDDLE_MOUSE_UP: MouseEvent.MIDDLE_CLICK;
			case MouseEvent.RIGHT_MOUSE_UP: MouseEvent.RIGHT_CLICK;
			default: null;
			
		}
		
		if (clickType != null) {
			
			stage.__fireEvent (MouseEvent.__create (clickType, button, (target == stage ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
			
			if (type == MouseEvent.MOUSE_UP && cast (target, openfl.display.InteractiveObject).doubleClickEnabled) {
				
				var currentTime = Lib.getTimer ();
				if (currentTime - __lastClickTime < 500) {
					
					stage.__fireEvent (MouseEvent.__create (MouseEvent.DOUBLE_CLICK, button, (target == stage ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
					__lastClickTime = 0;
					
				} else {
					
					__lastClickTime = currentTime;
					
				}
				
			}
			
		}
		
		if (Std.is (target, Sprite)) {
			
			var targetSprite:Sprite = cast target;
			
			if (targetSprite.buttonMode && targetSprite.useHandCursor) {
				
				Mouse.cursor = POINTER;
				
			} else {
				
				Mouse.cursor = ARROW;
				
			}
			
		} else if (Std.is (target, SimpleButton)) {
			
			var targetButton:SimpleButton = cast target;
			
			if (targetButton.useHandCursor) {
				
				Mouse.cursor = POINTER;
				
			} else {
				
				Mouse.cursor = ARROW;
				
			}
			
		} else if (Std.is (target, TextField)) {
			
			var targetTextField:TextField = cast target;
			
			if (targetTextField.type == INPUT) {
				
				Mouse.cursor = TEXT;
				
			} else {
				
				Mouse.cursor = ARROW;
				
			}
			
		} else {
			
			Mouse.cursor = ARROW;
			
		}
		
		for (target in __mouseOutStack) {
			
			if (stack.indexOf (target) == -1) {
				
				__mouseOutStack.remove (target);
				
				var localPoint = target.globalToLocal (targetPoint);
				target.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_OUT, false, false, localPoint.x, localPoint.y, cast target));
				
			}
			
		}
		
		for (target in stack) {
			
			if (__mouseOutStack.indexOf (target) == -1) {
				
				if (target.hasEventListener (MouseEvent.MOUSE_OVER)) {
					
					var localPoint = target.globalToLocal (targetPoint);
					target.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_OVER, false, false, localPoint.x, localPoint.y, cast target));
					
				}
				
				if (target.hasEventListener (MouseEvent.MOUSE_OUT)) {
					
					__mouseOutStack.push (target);
					
				}
				
			}
			
		}
		
		if (stage.__dragObject != null) {
			
			stage.__drag (targetPoint);
			
		}
		
	}
	
	
	public override function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
			
		}
		
		onMouse (type, x, y, button);
		
	}
	
	
	public override function onMouseMove (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_MOVE, x, y, 0);
		
	}
	
	
	public override function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
			
		}
		
		onMouse (type, x, y, button);
		
	}
	
	
	@:noCompletion private function onTouch (type:String, x:Float, y:Float, id:Int):Void {
		
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
		
		if (stage.__hitTest (x, y, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, localPoint, cast target);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, 0, localPoint, cast target);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			stage.__fireEvent (touchEvent, __stack);
			stage.__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, point, stage);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, 0, point, stage);
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
