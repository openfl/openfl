package openfl.display; #if !openfl_legacy


import haxe.EnumFlags;
import lime.app.Application;
import lime.app.IModule;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.CanvasRenderContext;
import lime.graphics.ConsoleRenderContext;
import lime.graphics.DOMRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.RenderContext;
import lime.graphics.Renderer;
import lime.math.Matrix4;
import lime.system.System;
import lime.ui.Touch;
import lime.utils.GLUtils;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Mouse;
import lime.ui.Window;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.console.ConsoleRenderer;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl.display.DisplayObjectContainer;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.FullScreenEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.events.TouchEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.ui.GameInput;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;

#if hxtelemetry
import openfl.profiler.Telemetry;
#end

#if (js && html5)
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import js.Browser;
#end

@:access(openfl.events.Event)
@:access(openfl.ui.GameInput)
@:access(openfl.ui.Keyboard)


class Stage extends DisplayObjectContainer implements IModule {
	
	
	public var align:StageAlign;
	public var allowsFullScreen (default, null):Bool;
	public var allowsFullScreenInteractive (default, null):Bool;
	public var application (default, null):Application;
	public var color (get, set):Int;
	public var displayState (get, set):StageDisplayState;
	public var focus (get, set):InteractiveObject;
	public var frameRate (get, set):Float;
	public var quality:StageQuality;
	public var scaleMode:StageScaleMode;
	public var stage3Ds (default, null):Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight (default, null):Int;
	public var stageWidth (default, null):Int;
	
	public var window (default, null):Window;
	
	private var __clearBeforeRender:Bool;
	private var __color:Int;
	private var __colorSplit:Array<Float>;
	private var __colorString:String;
	private var __deltaTime:Int;
	private var __dirty:Bool;
	private var __displayState:StageDisplayState;
	private var __dragBounds:Rectangle;
	private var __dragObject:Sprite;
	private var __dragOffsetX:Float;
	private var __dragOffsetY:Float;
	private var __focus:InteractiveObject;
	private var __fullscreen:Bool;
	private var __invalidated:Bool;
	private var __lastClickTime:Int;
	private var __macKeyboard:Bool;
	private var __mouseDownLeft:InteractiveObject;
	private var __mouseDownMiddle:InteractiveObject;
	private var __mouseDownRight:InteractiveObject;
	private var __mouseOutStack:Array<DisplayObject>;
	private var __mouseX:Float;
	private var __mouseY:Float;
	private var __originalWidth:Int;
	private var __originalHeight:Int;
	private var __renderer:AbstractRenderer;
	private var __rendering:Bool;
	private var __stack:Array<DisplayObject>;
	private var __transparent:Bool;
	private var __wasDirty:Bool;
	
	#if (js && html5)
	//private var __div:DivElement;
	//private var __element:HtmlElement;
	#if stats
	private var __stats:Dynamic;
	#end
	#end
	
	
	public function new (window:Window, color:Null<Int> = null) {
		
		#if hxtelemetry
		Telemetry.__initialize ();
		#end
		
		super ();
		
		this.application = window.application;
		this.window = window;
		
		if (color == null) {
			
			__transparent = true;
			this.color = 0x000000;
			
		} else {
			
			this.color = color;
			
		}
		
		this.name = null;
		
		__deltaTime = 0;
		__displayState = NORMAL;
		__mouseX = 0;
		__mouseY = 0;
		__lastClickTime = 0;
		
		stageWidth = Std.int (window.width * window.scale);
		stageHeight = Std.int (window.height * window.scale);
		
		this.stage = this;
		
		align = StageAlign.TOP_LEFT;
		#if html5
		allowsFullScreen = false;
		allowsFullScreenInteractive = false;
		#else
		allowsFullScreen = true;
		allowsFullScreenInteractive = true;
		#end
		quality = StageQuality.HIGH;
		scaleMode = StageScaleMode.NO_SCALE;
		stageFocusRect = true;
		
		#if mac
		__macKeyboard = true;
		#elseif (js && html5)
		__macKeyboard = untyped __js__ ("/AppleWebKit/.test (navigator.userAgent) && /Mobile\\/\\w+/.test (navigator.userAgent) || /Mac/.test (navigator.platform)");
		#end
		
		__clearBeforeRender = true;
		__stack = [];
		__mouseOutStack = [];
		
		stage3Ds = new Vector ();
		stage3Ds.push (new Stage3D ());
		
		if (Lib.current.stage == null) {
			
			stage.addChild (Lib.current);
			
		}
		
	}
	
	
	public override function globalToLocal (pos:Point):Point {
		
		return pos.clone ();
		
	}
	
	
	public function invalidate ():Void {
		
		__invalidated = true;
		
	}
	
	
	public override function localToGlobal (pos:Point):Point {
		
		return pos.clone ();
		
	}
	
	
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		GameInput.__onGamepadAxisMove (gamepad, axis, value);
		
	}
	
	
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		GameInput.__onGamepadButtonDown (gamepad, button);
		
	}
	
	
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		GameInput.__onGamepadButtonUp (gamepad, button);
		
	}
	
	
	public function onGamepadConnect (gamepad:Gamepad):Void {
		
		GameInput.__onGamepadConnect (gamepad);
		
	}
	
	
	public function onGamepadDisconnect (gamepad:Gamepad):Void {
		
		GameInput.__onGamepadDisconnect (gamepad);
		
	}
	
	
	public function onJoystickAxisMove (joystick:Joystick, axis:Int, value:Float):Void {
		
		
		
	}
	
	
	public function onJoystickButtonDown (joystick:Joystick, button:Int):Void {
		
		
		
	}
	
	
	public function onJoystickButtonUp (joystick:Joystick, button:Int):Void {
		
		
		
	}
	
	
	public function onJoystickConnect (joystick:Joystick):Void {
		
		
		
	}
	
	
	public function onJoystickDisconnect (joystick:Joystick):Void {
		
		
		
	}
	
	
	public function onJoystickHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void {
		
		
		
	}
	
	
	public function onJoystickTrackballMove (joystick:Joystick, trackball:Int, value:Float):Void {
		
		
		
	}
	
	
	public function onKeyDown (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		
		if (this.window == null || this.window != window) return;
		
		__onKey (KeyboardEvent.KEY_DOWN, keyCode, modifier);
		
	}
	
	
	public function onKeyUp (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		
		if (this.window == null || this.window != window) return;
		
		__onKey (KeyboardEvent.KEY_UP, keyCode, modifier);
		
	}
	
	
	public function onModuleExit (code:Int):Void {
		
		if (window != null) {
			
			var event = new Event (Event.DEACTIVATE);
			__broadcast (event, true);
			
		}
		
	}
	
	
	public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void {
		
		if (this.window == null || this.window != window) return;
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
			
		}
		
		__onMouse (type, Std.int (x * window.scale), Std.int (y * window.scale), button);
		
	}
	
	
	public function onMouseMove (window:Window, x:Float, y:Float):Void {
		
		if (this.window == null || this.window != window) return;
		
		__onMouse (MouseEvent.MOUSE_MOVE, Std.int (x * window.scale), Std.int (y * window.scale), 0);
		
	}
	
	
	public function onMouseMoveRelative (window:Window, x:Float, y:Float):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void {
		
		if (this.window == null || this.window != window) return;
		
		var type = switch (button) {
			
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
			
		}
		
		__onMouse (type, Std.int (x * window.scale), Std.int (y * window.scale), button);
		
	}
	
	
	public function onMouseWheel (window:Window, deltaX:Float, deltaY:Float):Void {
		
		if (this.window == null || this.window != window) return;
		
		__onMouseWheel (Std.int (deltaX * window.scale), Std.int (deltaY * window.scale));
		
	}
	
	
	public function onPreloadComplete ():Void {
		
		
		
	}
	
	
	public function onPreloadProgress (loaded:Int, total:Int):Void {
		
		
		
	}
	
	
	public function onRenderContextLost (renderer:Renderer):Void {
		
		
		
	}
	
	
	public function onRenderContextRestored (renderer:Renderer, context:RenderContext):Void {
		
		
		
	}
	
	
	public function onTextEdit (window:Window, text:String, start:Int, length:Int):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onTextInput (window:Window, text:String):Void {
		
		if (this.window == null || this.window != window) return;
		
		// TODO: Move to TextField
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		var event = new TextEvent (TextEvent.TEXT_INPUT, true, false, text);
		if (stack.length > 0) {
			
			stack.reverse ();
			__fireEvent (event, stack);
			
		} else {
			
			__broadcast (event, true);
		}
		
	}
	
	
	public function onTouchMove (touch:Touch):Void {
		
		__onTouch (TouchEvent.TOUCH_MOVE, touch);
		
	}
	
	
	public function onTouchEnd (touch:Touch):Void {
		
		__onTouch (TouchEvent.TOUCH_END, touch);
		
	}
	
	
	public function onTouchStart (touch:Touch):Void {
		
		__onTouch (TouchEvent.TOUCH_BEGIN, touch);
		
	}
	
	
	public function onWindowActivate (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		var event = new Event (Event.ACTIVATE);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowClose (window:Window):Void {
		
		if (this.window == window) {
			
			this.window = null;
			
		}
		
	}
	
	
	public function onWindowCreate (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		if (window.renderer != null) {
			
			switch (window.renderer.context) {
				
				case OPENGL (gl):
					
					#if (!disable_cffi && (!html5 || webgl))
					__renderer = new GLRenderer (stageWidth, stageHeight, gl);
					#end
				
				case CANVAS (context):
					
					__renderer = new CanvasRenderer (stageWidth, stageHeight, context);
				
				case DOM (element):
					
					#if (!html5 || dom)
					__renderer = new DOMRenderer (stageWidth, stageHeight, element);
					#end
				
				case CAIRO (cairo):
					
					#if !html5
					__renderer = new CairoRenderer (stageWidth, stageHeight, cairo);
					#end
				
				case CONSOLE (ctx):
					
					#if !html5
					__renderer = new ConsoleRenderer (stageWidth, stageHeight, ctx);
					#end
				
				default:
				
			}
			
		}
		
	}
	
	
	public function onWindowDeactivate (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		var event = new Event (Event.DEACTIVATE);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowDropFile (window:Window, file:String):Void {
		
		
		
	}
	
	
	public function onWindowEnter (window:Window):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onWindowFocusIn (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, null, false, 0);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowFocusOut (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, null, false, 0);
		__broadcast (event, true);
		
	}
	
	
	public function onWindowFullscreen (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		if (__displayState == NORMAL) {
			
			__displayState = FULL_SCREEN_INTERACTIVE;
			
		}
		
	}
	
	
	public function onWindowLeave (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		__dispatchEvent (new Event (Event.MOUSE_LEAVE));
		
	}
	
	
	public function onWindowMinimize (window:Window):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onWindowMove (window:Window, x:Float, y:Float):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onWindowResize (window:Window, width:Int, height:Int):Void {
		
		if (this.window == null || this.window != window) return;
		
		if (__displayState != NORMAL && !window.fullscreen) {
			
			__displayState = NORMAL;
			
		}
		
		stageWidth = Std.int (width * window.scale);
		stageHeight = Std.int (height * window.scale);
		
		if (__renderer != null) {
			
			__renderer.resize (stageWidth, stageHeight);
			
		}
		
		var event = new Event (Event.RESIZE);
		__broadcast (event, false);
		
	}
	
	
	public function onWindowRestore (window:Window):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function render (renderer:Renderer):Void {
		
		if (renderer.window == null || renderer.window != window) return;
		
		// TODO: Fix multiple stages more gracefully
		
		if (application != null && application.windows.length > 0) {
			
			__setTransformDirty ();
			__setRenderDirty ();
			
		}
		
		if (__rendering) return;
		__rendering = true;
		
		#if hxtelemetry
		Telemetry.__advanceFrame ();
		#end
		
		__broadcast (new Event (Event.ENTER_FRAME), true);
		
		if (__invalidated) {
			
			__invalidated = false;
			__broadcast (new Event (Event.RENDER), true);
			
		}
		
		#if hxtelemetry
		var stack = Telemetry.__unwindStack ();
		Telemetry.__startTiming (TelemetryCommandName.RENDER);
		#end
		
		__renderable = true;
		
		__enterFrame (__deltaTime);
		__deltaTime = 0;
		__update (false, true);
		
		if (__renderer != null) {
			
			switch (renderer.context) {
				
				case CAIRO (cairo):
					
					cast (__renderer, CairoRenderer).cairo = cairo;
					@:privateAccess (__renderer.renderSession).cairo = cairo;
				
				default:
					
			}
			
			__renderer.render (this);
			
		}
		
		#if hxtelemetry
		Telemetry.__endTiming (TelemetryCommandName.RENDER);
		Telemetry.__rewindStack (stack);
		#end
		
		__rendering = false;
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		__deltaTime = deltaTime;
		
	}
	
	
	private function __drag (mouse:Point):Void {
		
		var parent = __dragObject.parent;
		if (parent != null) {
			
			mouse = parent.globalToLocal (mouse);
			
		}
		
		var x = mouse.x + __dragOffsetX;
		var y = mouse.y + __dragOffsetY;
		
		if (__dragBounds != null) {
			
			if (x < __dragBounds.x) {
				
				x = __dragBounds.x;
				
			} else if (x > __dragBounds.right) {
				
				x = __dragBounds.right;
				
			}
			
			if (y < __dragBounds.y) {
				
				y = __dragBounds.y;
				
			} else if (y > __dragBounds.bottom) {
				
				y = __dragBounds.bottom;
				
			}
			
		}
		
		__dragObject.x = x;
		__dragObject.y = y;
		
	}
	
	
	private function __fireEvent (event:Event, stack:Array<DisplayObject>):Void {
		
		var length = stack.length;
		
		if (length == 0) {
			
			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);
			
		} else {
			
			event.eventPhase = EventPhase.CAPTURING_PHASE;
			event.target = stack[stack.length - 1];
			
			for (i in 0...length - 1) {
				
				stack[i].__broadcast (event, false);
				
				if (event.__isCanceled) {
					
					return;
					
				}
				
			}
			
			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);
			
			if (event.__isCanceled) {
				
				return;
				
			}
			
			if (event.bubbles) {
				
				event.eventPhase = EventPhase.BUBBLING_PHASE;
				var i = length - 2;
				
				while (i >= 0) {
					
					stack[i].__broadcast (event, false);
					
					if (event.__isCanceled) {
						
						return;
						
					}
					
					i--;
					
				}
				
			}
			
		}
		
	}
	
	
	private override function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		if (stack != null) {
			
			stack.push (this);
			
		}
		
		return true;
		
	}
	
	
	private function __onKey (type:String, keyCode:KeyCode, modifier:KeyModifier):Void {
		
		MouseEvent.__altKey = modifier.altKey;
		MouseEvent.__commandKey = modifier.metaKey;
		MouseEvent.__ctrlKey = modifier.ctrlKey;
		MouseEvent.__shiftKey = modifier.shiftKey;
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {
			
			var keyLocation = Keyboard.__getKeyLocation (keyCode);
			var keyCode = Keyboard.__convertKeyCode (keyCode);
			var charCode = Keyboard.__getCharCode (keyCode, modifier.shiftKey);
			
			var event = new KeyboardEvent (type, true, false, charCode, keyCode, keyLocation, __macKeyboard ? modifier.ctrlKey || modifier.metaKey : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);
			
			stack.reverse ();
			__fireEvent (event, stack);
			
			if (event.__isCanceled) {
				
				if (type == KeyboardEvent.KEY_DOWN) {
					
					window.onKeyDown.cancel ();
					
				} else {
					
					window.onKeyUp.cancel ();
					
				}
				
			}
			
		}
		
	}
	
	
	private function __onMouse (type:String, x:Float, y:Float, button:Int):Void {
		
		if (button > 2) return;
		
		__mouseX = x;
		__mouseY = y;
		
		var stack = [];
		var target:InteractiveObject = null;
		var targetPoint = new Point (x, y);
		
		if (__hitTest (x, y, true, stack, true, this)) {
			
			target = cast stack[stack.length - 1];
			
		} else {
			
			target = this;
			stack = [ this ];
			
		}
		
		if (target == null) target = this;
		
		var clickType = null;
		
		switch (type) {
			
			case MouseEvent.MOUSE_DOWN:
				
				if (target.tabEnabled) {
					
					focus = target;
					
				} else {
					
					focus = null;
					
				}
				
				__mouseDownLeft = target;
			
			case MouseEvent.MIDDLE_MOUSE_DOWN:
				
				__mouseDownMiddle = target;
			
			case MouseEvent.RIGHT_MOUSE_DOWN:
				
				__mouseDownRight = target;
			
			case MouseEvent.MOUSE_UP:
				
				if (__mouseDownLeft == target) {
					
					clickType = MouseEvent.CLICK;
					
					
				}
				
				__mouseDownLeft = null;
			
			case MouseEvent.MIDDLE_MOUSE_UP:
				
				if (__mouseDownMiddle == target) {
					
					clickType = MouseEvent.MIDDLE_CLICK;
					
					
				}
				
				__mouseDownMiddle = null;
			
			case MouseEvent.RIGHT_MOUSE_UP:
				
				if (__mouseDownRight == target) {
					
					clickType = MouseEvent.RIGHT_CLICK;
					
				}
				
				__mouseDownRight = null;
			
			default:
			
		}
		
		
		__fireEvent (MouseEvent.__create (type, button, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
		
		if (clickType != null) {
			
			__fireEvent (MouseEvent.__create (clickType, button, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
			
			if (type == MouseEvent.MOUSE_UP && cast (target, openfl.display.InteractiveObject).doubleClickEnabled) {
				
				var currentTime = Lib.getTimer ();
				if (currentTime - __lastClickTime < 500) {
					
					__fireEvent (MouseEvent.__create (MouseEvent.DOUBLE_CLICK, button, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target), stack);
					__lastClickTime = 0;
					
				} else {
					
					__lastClickTime = currentTime;
					
				}
				
			}
			
		}
		
		var cursor = null;
		
		for (target in stack) {
			
			cursor = target.__getCursor ();
			
			if (cursor != null) {
				
				Mouse.cursor = cursor;
				break;
				
			}
			
		}
		
		if (cursor == null) {
			
			Mouse.cursor = ARROW;
			
		}
		
		var event, localPoint;
		
		for (target in __mouseOutStack) {
			
			if (stack.indexOf (target) == -1) {
				
				__mouseOutStack.remove (target);
				
				localPoint = target.globalToLocal (targetPoint);
				event = MouseEvent.__create (MouseEvent.MOUSE_OUT, button, __mouseX, __mouseY, localPoint, cast target);
				event.bubbles = false;
				target.__dispatchEvent (event);
				
			}
			
		}
		
		for (target in stack) {
			
			if (__mouseOutStack.indexOf (target) == -1) {
				
				if (target.hasEventListener (MouseEvent.MOUSE_OVER)) {
					
					localPoint = target.globalToLocal (targetPoint);
					event = MouseEvent.__create (MouseEvent.MOUSE_OVER, button, __mouseX, __mouseY, localPoint, cast target);
					event.bubbles = false;
					target.__dispatchEvent (event);
					
				}
				
				if (target.hasEventListener (MouseEvent.MOUSE_OUT)) {
					
					__mouseOutStack.push (target);
					
				}
				
			}
			
		}
		
		if (__dragObject != null) {
			
			__drag (targetPoint);
			
		}
		
	}
	
	
	private function __onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		var x = __mouseX;
		var y = __mouseY;
		
		var stack = [];
		
		if (!__hitTest (x, y, false, stack, true, this)) {
			
			stack = [ this ];
			
		}
		
		var target:InteractiveObject = cast stack[stack.length - 1];
		var targetPoint = new Point (x, y);
		var delta = Std.int (deltaY);
		
		__fireEvent (MouseEvent.__create (MouseEvent.MOUSE_WHEEL, 0, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, delta), stack);
		
	}
	
	
	private function __onTouch (type:String, touch:Touch):Void {
		
		var point = new Point (touch.x * stageWidth, touch.y * stageHeight);
		
		__mouseX = point.x;
		__mouseY = point.y;
		
		var __stack = [];
		
		if (__hitTest (__mouseX, __mouseY, false, __stack, true, this)) {
			
			var target = __stack[__stack.length - 1];
			if (target == null) target = this;
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, __mouseX, __mouseY, localPoint, cast target);
			touchEvent.touchPointID = touch.id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			__fireEvent (touchEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, __mouseX, __mouseY, point, this);
			touchEvent.touchPointID = touch.id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			__fireEvent (touchEvent, [ stage ]);
			
		}
		
	}
	
	
	private function __resize ():Void {
		
		/*
		if (__element != null && (__div == null || (__div != null && __fullscreen))) {
			
			if (__fullscreen) {
				
				stageWidth = __element.clientWidth;
				stageHeight = __element.clientHeight;
				
				if (__canvas != null) {
					
					if (__element != cast __canvas) {
						
						__canvas.width = stageWidth;
						__canvas.height = stageHeight;
						
					}
					
				} else {
					
					__div.style.width = stageWidth + "px";
					__div.style.height = stageHeight + "px";
					
				}
				
			} else {
				
				var scaleX = __element.clientWidth / __originalWidth;
				var scaleY = __element.clientHeight / __originalHeight;
				
				var currentRatio = scaleX / scaleY;
				var targetRatio = Math.min (scaleX, scaleY);
				
				if (__canvas != null) {
					
					if (__element != cast __canvas) {
						
						__canvas.style.width = __originalWidth * targetRatio + "px";
						__canvas.style.height = __originalHeight * targetRatio + "px";
						__canvas.style.marginLeft = ((__element.clientWidth - (__originalWidth * targetRatio)) / 2) + "px";
						__canvas.style.marginTop = ((__element.clientHeight - (__originalHeight * targetRatio)) / 2) + "px";
						
					}
					
				} else {
					
					__div.style.width = __originalWidth * targetRatio + "px";
					__div.style.height = __originalHeight * targetRatio + "px";
					__div.style.marginLeft = ((__element.clientWidth - (__originalWidth * targetRatio)) / 2) + "px";
					__div.style.marginTop = ((__element.clientHeight - (__originalHeight * targetRatio)) / 2) + "px";
					
				}
				
			}
			
		}*/
		
	}
	
	
	private function __startDrag (sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void {
		
		__dragBounds = (bounds == null) ? null : bounds.clone ();
		__dragObject = sprite;
		
		if (__dragObject != null) {
			
			if (lockCenter) {
				
				__dragOffsetX = -__dragObject.width / 2;
				__dragOffsetY = -__dragObject.height / 2;
				
			} else {
				
				var mouse = new Point (mouseX, mouseY);
				var parent = __dragObject.parent;
				
				if (parent != null) {
					
					mouse = parent.globalToLocal (mouse);
					
				}
				
				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				
			}
			
		}
		
	}
	
	
	private function __stopDrag (sprite:Sprite):Void {
		
		__dragBounds = null;
		__dragObject = null;
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool, ?maskGrahpics:Graphics = null):Void {
		
		if (transformOnly) {
			
			if (DisplayObject.__worldTransformDirty > 0) {
				
				super.__update (true, updateChildren, maskGrahpics);
				
				if (updateChildren) {
					
					DisplayObject.__worldTransformDirty = 0;
					__dirty = true;
					
				}
				
			}
			
		} else {
			
			if (DisplayObject.__worldTransformDirty > 0 || __dirty || DisplayObject.__worldRenderDirty > 0) {
				
				super.__update (false, updateChildren, maskGrahpics);
				
				if (updateChildren) {
					
					#if dom
					__wasDirty = true;
					#end
					
					DisplayObject.__worldTransformDirty = 0;
					DisplayObject.__worldRenderDirty = 0;
					__dirty = false;
					
				}
				
			} #if dom else if (__wasDirty) {
				
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				
				super.__update (false, updateChildren, maskGrahpics);
				
				if (updateChildren) {
					
					__wasDirty = false;
					
				}
				
			} #end
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private override function get_mouseX ():Float {
		
		return __mouseX;
		
	}
	
	
	private override function get_mouseY ():Float {
		
		return __mouseY;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	#if (js && html5)
	private function canvas_onContextLost (event:js.html.webgl.ContextEvent):Void {
		
		//__glContextLost = true;
		
	}
	
	
	private function canvas_onContextRestored (event:js.html.webgl.ContextEvent):Void {
		
		//__glContextLost = false;
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_color ():Int {
		
		return __color;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		var r = (value & 0xFF0000) >>> 16;
		var g = (value & 0x00FF00) >>> 8;
		var b = (value & 0x0000FF);
		
		__colorSplit = [ r / 0xFF, g / 0xFF, b / 0xFF ];
		__colorString = "#" + StringTools.hex (value, 6);
		
		return __color = value;
		
	}
	
	
	private function get_displayState ():StageDisplayState {
		
		return __displayState;
		
	}
	
	
	private function set_displayState (value:StageDisplayState):StageDisplayState {
		
		if (window != null) {
			
			switch (value) {
				
				case NORMAL:
					
					if (window.fullscreen) {
						
						//window.minimized = false;
						window.fullscreen = false;
						
						dispatchEvent (new FullScreenEvent (FullScreenEvent.FULL_SCREEN, false, false, false, true));
						
					}
				
				default:
					
					if (!window.fullscreen) {
						
						//window.minimized = false;
						window.fullscreen = true;
						
						dispatchEvent (new FullScreenEvent (FullScreenEvent.FULL_SCREEN, false, false, true, true));
						
					}
				
			}
			
		}
		
		return __displayState = value;
		
	}
	
	
	private function get_focus ():InteractiveObject {
		
		return __focus;
		
	}
	
	
	private function set_focus (value:InteractiveObject):InteractiveObject {
		
		if (value != __focus) {
			
			var oldFocus = __focus;
			__focus = value;
			
			if (oldFocus != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, __focus, false, 0);
				__stack = [];
				oldFocus.__getInteractive (__stack);
				__stack.reverse ();
				__fireEvent (event, __stack);
				
			}
			
			if (__focus != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, oldFocus, false, 0);
				__stack = [];
				value.__getInteractive (__stack);
				__stack.reverse ();
				__fireEvent (event, __stack);
				
			}
			
		}
		
		return __focus;
		
	}
	
	
	private function get_frameRate ():Float {
		
		if (application != null) {
			
			return application.frameRate;
			
		}
		
		return 0;
		
	}
	
	
	private function set_frameRate (value:Float):Float {
		
		if (application != null) {
			
			return application.frameRate = value;
			
		}
		
		return value;
		
	}

}


#else
typedef Stage = openfl._legacy.display.Stage;
#end