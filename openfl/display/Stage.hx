package openfl.display; #if !openfl_legacy


import haxe.EnumFlags;
import haxe.ds.Vector as HaxeVector;
import lime.app.Application;
import lime.app.IModule;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
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
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl.display.DisplayObjectContainer;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.EventDispatcher;
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
import openfl.utils.UnshrinkableArray;

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
	public var frameTime(default, null):Int;
	public var quality:StageQuality;
	public var scaleMode (get, set):StageScaleMode;
	public var stage3Ds (default, null):Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight (default, null):Int;
	public var stageWidth (default, null):Int;
	public var fullScreenWidth (get, never):Int;
	public var fullScreenHeight (get, never):Int;

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
	private var __mouseOutStack:UnshrinkableArray<DisplayObject>;
	private var __mouseX:Float;
	private var __mouseY:Float;
	private var __originalWidth:Int;
	private var __originalHeight:Int;
	private var __renderer:AbstractRenderer;
	private var __rendering:Bool;
	private var __stack:UnshrinkableArray<DisplayObject>;
	private var __focusStack:UnshrinkableArray<DisplayObject>;
	private var __allChildrenStack:UnshrinkableArray<DisplayObject>;
	private var __allChildrenTempStack:UnshrinkableArray<Int> = new UnshrinkableArray<Int>(128);
	private var __pingPongChildrenStack:Array<UnshrinkableArray<DisplayObject>> = [new UnshrinkableArray<DisplayObject>(4096), new UnshrinkableArray<DisplayObject>(4096)];
	private var __pingPongIndex:Int = 0;
	private var __transparent:Bool;
	private var __wasDirty:Bool;
	private var __scaleMode:StageScaleMode = StageScaleMode.SHOW_ALL;
	private var __outElements:UnshrinkableArray<DisplayObject> = new UnshrinkableArray<DisplayObject>(32);
	private var __inElements:UnshrinkableArray<DisplayObject> = new UnshrinkableArray<DisplayObject>(32);
	private var __mouseDownStates:Map<Int,Bool> = new Map<Int, Bool>();

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
		__branchDepth = 0;

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

		stageWidth = Std.int (window.originalWidth * window.scale);
		stageHeight = Std.int (window.originalHeight * window.scale);

		this.stage = this;

		align = StageAlign.TOP_LEFT;
		allowsFullScreen = true;
		allowsFullScreenInteractive = true;
		quality = StageQuality.HIGH;
		stageFocusRect = true;

		#if mac
		__macKeyboard = true;
		#elseif (js && html5)
		__macKeyboard = untyped __js__ ("/AppleWebKit/.test (navigator.userAgent) && /Mobile\\/\\w+/.test (navigator.userAgent) || /Mac/.test (navigator.platform)");
		#end

		__clearBeforeRender = true;
		__stack = new openfl.utils.UnshrinkableArray(128);
		__focusStack = new openfl.utils.UnshrinkableArray(16);
		__mouseOutStack = new openfl.utils.UnshrinkableArray(128);

		stage3Ds = new Vector ();
		stage3Ds.push (new Stage3D ());

		if (Lib.current.stage == null) {

			stage.addChild (Lib.current);

		}

		__allChildrenStack = __pingPongChildrenStack[__pingPongIndex];
		__allChildrenStack.push(stage);

	}


	public function invalidate ():Void {

		__invalidated = true;

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

			__broadcastFromStage (Event.__create (Event.DEACTIVATE), true);

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

		__stack.clear();

		if (__focus == null) {

			__getInteractive (__stack);

		} else {

			__focus.__getInteractive (__stack);

		}

		var event = new TextEvent (TextEvent.TEXT_INPUT, true, false, text);
		if (__stack.length > 0) {

			__stack.reverse ();
			fireEvent (event, __stack);

		} else {

			__broadcastFromStage (event, true);
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

		var event = Event.__create (Event.ACTIVATE);
		__broadcastFromStage (event, true);

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

					#if !disable_cffi
					__renderer = new GLRenderer (stageWidth, stageHeight, gl);
					#end

				default:

			}

			#if !neko
				if ( window.resizable ) {
					ApplicationMain.resizeStatic({width: window.width, height: window.height});
				}
			#end

		}

	}


	public function onWindowDeactivate (window:Window):Void {

		if (this.window == null || this.window != window) return;

		var event = Event.__create (Event.DEACTIVATE);
		__broadcastFromStage (event, true);

	}


	public function onWindowEnter (window:Window):Void {

		//if (this.window == null || this.window != window) return;

	}


	public function onWindowFocusIn (window:Window):Void {

		if (this.window == null || this.window != window) return;

		// :NOTE: This is highly inperformant. Verify if we need this. Mouse event should generate new focus element?
		var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, null, false, 0);
		__broadcastFromStage (event, true);

	}


	public function onWindowFocusOut (window:Window):Void {

		if (this.window == null || this.window != window) return;

		var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, null, false, 0);
		__broadcastFromStage (event, true);

	}


	public function onWindowFullscreen (window:Window):Void {

		if (this.window == null || this.window != window) return;

		if (__displayState == NORMAL) {

			__displayState = FULL_SCREEN_INTERACTIVE;

		}

	}


	public function onWindowLeave (window:Window):Void {

		if (this.window == null || this.window != window) return;

		__dispatchEvent (Event.__create (Event.MOUSE_LEAVE));

		for( button in __mouseDownStates.keys() ) {
			var state = __mouseDownStates.get(button);
			if ( state ) {
				onMouseUp(window, __mouseX, __mouseY, button);
			}
		}
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

		width = Std.int (width * window.scale);
		height = Std.int( height * window.scale);

		var oldScaleX = this.scaleX;
		var oldScaleY = this.scaleY;

		var aspect_ratio = stageWidth / stageHeight;
		var new_aspect_ratio = width / height;
		if ( aspect_ratio == new_aspect_ratio && scaleMode != StageScaleMode.NO_SCALE ) {
			this.scaleX = width / stageWidth;
			this.scaleY = height / stageHeight;
		} else {
			switch(scaleMode) {
				case StageScaleMode.EXACT_FIT:
					this.scaleX = width / stageWidth;
					this.scaleY = height / stageHeight;
				case StageScaleMode.NO_BORDER:
					if ( aspect_ratio < new_aspect_ratio ) {
						var new_width = width / stageWidth;
						this.scaleX = new_width;
						this.scaleY = new_width;
						height = Math.ceil(stageHeight * new_width);
					} else {
						var new_height = height / stageHeight;
						this.scaleX = new_height;
						this.scaleY = new_height;
						width = Math.ceil(stageWidth * new_height);
					}

				case StageScaleMode.NO_SCALE:
					width = stageWidth;
					height = stageHeight;
				case StageScaleMode.SHOW_ALL:
					if ( aspect_ratio < new_aspect_ratio ) {
						var new_height = height / stageHeight;
						this.scaleX = new_height;
						this.scaleY = new_height;
						width = Math.ceil(stageWidth * new_height);
					} else {
						var new_width = width / stageWidth;
						this.scaleX = new_width;
						this.scaleY = new_width;
						height = Math.ceil(stageHeight * new_width);
					}
			}
		}

		__update(false, true);

		if (__renderer != null) {

			trace('Resizing renderer to $width, $height');
			__renderer.resize (width, height);
			window.resizeViewport(width, height);

		}

		if ( oldScaleX != scaleX || oldScaleY != scaleY ) {
			var event = Event.__create (Event.RESIZE);
			__broadcastFromStage (event, false);
		}

	}

	public function get_scaleMode():StageScaleMode {
		return __scaleMode;
	}

	public function set_scaleMode(scaleMode):StageScaleMode {
		if ( scaleMode != __scaleMode ) {
			onWindowResize(window, window.width, window.height);
		}
		return __scaleMode = scaleMode;
	}

	public function onWindowRestore (window:Window):Void {

		//if (this.window == null || this.window != window) return;

	}

	private function __concatDepthFirstChildren(array:UnshrinkableArray<DisplayObject>, head:DisplayObject) {
		#if dev
			if (__allChildrenTempStack.length > 0) throw "working stack should be empty";
		#end

		__allChildrenTempStack.push (0);

		inline function push() {
			if (head != null) {
				head.__branchDirty = false;
				head.__branchDepth = head.parent != null ? head.parent.__branchDepth + 1 : 0;
				array.push (head);
			}
		}

		push ();

		while (__allChildrenTempStack.length > 0) {
			var first = __allChildrenTempStack.last ();
			if (head.__children == null || head.__children.length == 0 || first >= head.__children.length) {
				__allChildrenTempStack.pop();
				if (__allChildrenTempStack.length > 0) {
					__allChildrenTempStack.push (__allChildrenTempStack.pop() + 1);
				}
				head = head.parent;
			} else {
				head = head.__children[first];
				push ();
				__allChildrenTempStack.push (0);
			}
		}
	}

	private function __updateAllChildrenStack() {
		if ( DisplayObject.__worldBranchDirty == 0 ) {
			return;
		}
		DisplayObject.__worldBranchDirty = 0;

		var previousIndex = __pingPongIndex;
		__pingPongIndex ^= 1;
		var previousChildrenStack = __pingPongChildrenStack[previousIndex];
		var newChildrenStack = __pingPongChildrenStack[__pingPongIndex];
		var previousCursor = 0;

		inline function __updatePreviousCursorByDepth(targetDepth:Int, cursorValue:Int) {
			while(++cursorValue < previousChildrenStack.length) {
				var nextDepth = previousChildrenStack[cursorValue].__branchDepth;
				if (nextDepth <= targetDepth) {
					break;
				}
			}
			return cursorValue;
		}

		while(previousCursor < previousChildrenStack.length) {
			var child = previousChildrenStack[previousCursor];
			if ( !child.__branchDirty ) {
				previousCursor++;
				newChildrenStack.push(child);
			} else {
				__concatDepthFirstChildren(newChildrenStack,child);
				previousCursor = __updatePreviousCursorByDepth(child.__branchDepth, previousCursor);
			}
		}

		previousChildrenStack.clear();
		__allChildrenStack = newChildrenStack;
	}

	public override function __enterFrame(deltaTime:Int):Void {

		var child;
		var i = 1;

		while (i < __allChildrenStack.length) {
			child = __allChildrenStack[i];
			if(child.stage != null) {
				child.__enterFrame(deltaTime);
			}
			++i;
		}
	}

	public function __broadcastFromStage(event:Event, notifyChilden:Bool) {
		inline function broadcast(event:Event, element:DisplayObject) :Bool {
			if (element.__eventMap != null && element.hasEventListener (event.type)) {

				var result = EventDispatcher.__dispatchEventStatic (element, event);

				if (event.__isCanceled) {

					return true;

				}

				return result;

			}

			return false;
		}

		if (event.target == null) {
			event.target = this;
		}

		event.acquire();
		var result = broadcast (event, this);

		if (!event.__isCanceled && notifyChilden) {

			var i = 1;
			var stack_id;
			while (i < __allChildrenStack.length) {
				stack_id = __allChildrenStack[i];

				// :TRICKY: display objects can have been removed from the hierarchy by previous listeners
				// :TODO: handle object addition too
				if (stack_id.stage == this) {
					broadcast(event, stack_id);
				}

				if (event.__isCanceled) {
					event.release();
					return true;
				}
				++i;
			}
		}

		event.release();
		return result;
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

		__broadcastFromStage (Event.__create (Event.ENTER_FRAME), true);

		if (__invalidated) {

			__invalidated = false;
			__broadcastFromStage (Event.__create (Event.RENDER), true);

		}

		#if hxtelemetry
		var stack = Telemetry.__unwindStack ();
		Telemetry.__startTiming (TelemetryCommandName.RENDER);
		#end

		__renderable = true;

		__updateAllChildrenStack();
		__enterFrame (__deltaTime);
		__updateAllChildrenStack();
		__deltaTime = 0;
		__updateDirtyElements (false, true);

		if (__renderer != null) {

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
		// :TRICKY: Update mouse each frame, to show the correct cursor at all times.
		if ( !__calledOnMouseThisFrame) {
			__onMouse (null, __mouseX, __mouseY, 0);
		}
		__calledOnMouseThisFrame = false;

		__updateAllChildrenStack();
	}

	public static function fireEvent (event:Event, stack:UnshrinkableArray<DisplayObject>):Void {

		var length = stack.length;

		if (length == 0) {

			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);

		} else {

			event.eventPhase = EventPhase.CAPTURING_PHASE;
			event.target = stack[stack.length - 1];
			event.acquire();

			for (i in 0...length - 1) {

				stack[i].__broadcast (event, false);

				if (event.__isCanceled) {
					event.release();
					return;

				}

			}

			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);

			if (event.__isCanceled) {

				event.release();
				return;

			}

			if (event.bubbles) {

				event.eventPhase = EventPhase.BUBBLING_PHASE;
				var i = length - 2;

				while (i >= 0) {

					stack[i].__broadcast (event, false);

					if (event.__isCanceled) {
						event.release();
						return;

					}

					i--;

				}

			}

			event.release();

		}
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

	private override function __getInteractive (stack:UnshrinkableArray<DisplayObject>):Bool {

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

		__stack.clear();

		if (__focus == null) {

			__getInteractive (__stack);

		} else {

			__focus.__getInteractive (__stack);

		}

		if (__stack.length > 0) {

			var keyLocation = Keyboard.__getKeyLocation (keyCode);
			var keyCode = Keyboard.__convertKeyCode (keyCode);
			var charCode = Keyboard.__getCharCode (keyCode, modifier.shiftKey);

			var event = new KeyboardEvent (type, true, false, charCode, keyCode, keyLocation, __macKeyboard ? modifier.ctrlKey || modifier.metaKey : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

			__stack.reverse ();
			fireEvent (event, __stack);

			if (event.__isCanceled) {

				if (type == KeyboardEvent.KEY_DOWN) {

					window.onKeyDown.cancel ();

				} else {

					window.onKeyUp.cancel ();

				}

			}

		}

	}

	private static var __calledOnMouseThisFrame = false;

	private function __onMouse (type:String, x:Float, y:Float, button:Int):Void {

		if (button > 2) return;

		__calledOnMouseThisFrame = true;

		__mouseX = x;
		__mouseY = y;

		var unscaledMouseX = x / scaleX;
		var unscaledMouseY = y / scaleY;

		var target:InteractiveObject = null;
		var targetPoint = Point.pool.get();
		var targetPointLocal = Point.pool.get();

		targetPoint.setTo (mouseX, mouseY);

		__stack.clear();

		if (__hitTest (x, y, true, __stack, true, this)) {

			target = cast __stack[__stack.length - 1];

		} else {

			target = this;
			__stack.clear();
			__stack.push(this);
		}

		if (target == null) target = this;

		targetPointLocal.copyFrom (targetPoint);
		target.convertToLocal (targetPointLocal);

		var clickType = null;

		switch (type) {

			case MouseEvent.MOUSE_DOWN:

				if (target.tabEnabled) {

					focus = target;

				} else {

					focus = null;

				}


				__mouseDownStates.set(button, true);

				__mouseDownLeft = target;

			case MouseEvent.MIDDLE_MOUSE_DOWN:

				__mouseDownStates.set(button, true);

				__mouseDownMiddle = target;

			case MouseEvent.RIGHT_MOUSE_DOWN:

				__mouseDownStates.set(button, true);

				__mouseDownRight = target;

			case MouseEvent.MOUSE_UP:

				__mouseDownStates.set(button, false);

				if (__mouseDownLeft == target) {

					clickType = MouseEvent.CLICK;


				}

				__mouseDownLeft = null;

			case MouseEvent.MIDDLE_MOUSE_UP:

				__mouseDownStates.set(button, false);

				if (__mouseDownMiddle == target) {

					clickType = MouseEvent.MIDDLE_CLICK;


				}

				__mouseDownMiddle = null;

			case MouseEvent.RIGHT_MOUSE_UP:

				__mouseDownStates.set(button, false);

				if (__mouseDownRight == target) {

					clickType = MouseEvent.RIGHT_CLICK;

				}

				__mouseDownRight = null;

			default:

		}


		fireEvent (MouseEvent.__create (type, unscaledMouseX, unscaledMouseY, (target == this ? targetPoint : targetPointLocal), target), __stack);

		if (clickType != null) {

			fireEvent (MouseEvent.__create (clickType, unscaledMouseX, unscaledMouseY, (target == this ? targetPoint : targetPointLocal), target), __stack);

			if (type == MouseEvent.MOUSE_UP && cast (target, openfl.display.InteractiveObject).doubleClickEnabled) {

				var currentTime = Lib.getTimer ();
				if (currentTime - __lastClickTime < 500) {

					fireEvent (MouseEvent.__create (MouseEvent.DOUBLE_CLICK, unscaledMouseX, unscaledMouseY, (target == this ? targetPoint : targetPointLocal), target), __stack);
					__lastClickTime = 0;

				} else {

					__lastClickTime = currentTime;

				}

			}

		}

		#if !neko
		var cursor = null;

		for (t in 0...__stack.length) {
			var target = __stack[t];
			cursor = target.__getCursor ();

			if (cursor != null) {

				Mouse.cursor = cursor;
				break;

			}

		}

		if (cursor == null) {

			Mouse.cursor = ARROW;

		}
		#end

		var event;

		if ( __stack.length > 0 && ( __mouseOutStack.length == 0 || ( __mouseOutStack.length > 0 && __mouseOutStack[__mouseOutStack.length-1] != __stack[__stack.length-1] ) ) ) {
			__outElements.clear();
			__inElements.clear();

			inline function diffStacks() {
				if ( __mouseOutStack.length == 0 ) {
					__inElements.copyFrom(__stack);
				}

				var biggestStackCount = Std.int(Math.max(__stack.length, __mouseOutStack.length));
				for(i in 0...biggestStackCount) {
					if ( __stack[i] != __mouseOutStack[i] ) {
						__outElements.copyFrom(__mouseOutStack, i);
						__inElements.copyFrom(__stack, i);
						break;
					}
				}
			}

			inline function mouseOut(target:DisplayObject) {
				targetPointLocal.copyFrom (targetPoint);
				target.convertToLocal (targetPointLocal);
				event = MouseEvent.__create (MouseEvent.MOUSE_OUT, unscaledMouseX, unscaledMouseY, targetPointLocal, cast target);
				event.bubbles = true;
				target.__dispatchEvent (event);
			}

			inline function rollOut(target:DisplayObject) {
				if ( target.hasEventListener(MouseEvent.ROLL_OUT) ) {
					targetPointLocal.copyFrom (targetPoint);
					target.convertToLocal (targetPointLocal);
					event = MouseEvent.__create (MouseEvent.ROLL_OUT, unscaledMouseX, unscaledMouseY, targetPointLocal, cast target);
					event.bubbles = false;
					target.__dispatchEvent (event);
				}
			}

			inline function rollOver(target:DisplayObject) {
				if ( target.hasEventListener(MouseEvent.ROLL_OVER) ) {
					targetPointLocal.copyFrom (targetPoint);
					target.convertToLocal (targetPointLocal);
					event = MouseEvent.__create (MouseEvent.ROLL_OVER, unscaledMouseX, unscaledMouseY, targetPointLocal, cast target);
					event.bubbles = false;
					target.__dispatchEvent (event);
				}
			}

			inline function mouseOver(target:DisplayObject) {
				targetPointLocal.copyFrom (targetPoint);
				target.convertToLocal (targetPointLocal);
				event = MouseEvent.__create (MouseEvent.MOUSE_OVER, unscaledMouseX, unscaledMouseY, targetPointLocal, cast target);
				event.bubbles = true;
				target.__dispatchEvent (event);
			}

			diffStacks();

			if (__mouseOutStack.length > 0 ) {
				mouseOut( __mouseOutStack[__mouseOutStack.length-1] );
			}

			var i = __outElements.length - 1;
			while(i >= 0) {
				rollOut(__outElements[i]);
				--i;
			}

			for (target in __inElements) {
				rollOver(target);
			}

			mouseOver(__stack[__stack.length-1]);
		}


		if (__dragObject != null) {

			__drag (targetPoint);

		}

		__mouseOutStack.copyFrom(__stack);
		Point.pool.put(targetPoint);
		Point.pool.put(targetPointLocal);

	}


	private function __onMouseWheel (deltaX:Float, deltaY:Float):Void {

		var x = __mouseX;
		var y = __mouseY;

		__stack.clear();

		if (!__hitTest (x, y, false, __stack, true, this)) {

			__stack.clear();
			__stack.push(this);

		}

		var target:InteractiveObject = cast __stack[__stack.length - 1];
		var targetPoint = Point.pool.get ();
		targetPoint.setTo (x, y);
		var delta = Std.int (deltaY);

		fireEvent (MouseEvent.__create (MouseEvent.MOUSE_WHEEL, __mouseX, __mouseY, (target == this ? targetPoint : target.globalToLocal (targetPoint)), target, delta), __stack);

		Point.pool.put(targetPoint);
	}


	private function __onTouch (type:String, touch:Touch):Void {

		var point = Point.pool.get();
		point.setTo (touch.x * stageWidth, touch.y * stageHeight);

		__mouseX = point.x;
		__mouseY = point.y;

		__stack.clear();

		if (__hitTest (__mouseX, __mouseY, false, __stack, true, this)) {

			var target = __stack[__stack.length - 1];
			if (target == null) target = this;
			var localPoint = target.globalToLocal (point);

			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, __mouseX, __mouseY, localPoint, cast target);
			touchEvent.touchPointID = touch.id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;

			fireEvent (touchEvent, __stack);

		} else {

			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, __mouseX, __mouseY, point, this);
			touchEvent.touchPointID = touch.id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;

			__stack.clear();
			__stack.push(stage);
			fireEvent (touchEvent, __stack);

		}

		Point.pool.put(point);
	}

	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		var result = super.__hitTest(x,y,shapeFlag,stack,interactiveOnly,hitObject);
		if ( !result ) {
			var rect = Rectangle.pool.get();
			rect.x = this.x;
			rect.y = this.y;
			rect.width = scaleX * stageWidth;
			rect.height = scaleY * stageHeight;
			result = rect.contains(x, y);
			Rectangle.pool.put(rect);
			if ( result && stack != null ) {
				stack.push(this);
			}
		}

		#if dev
			if (DisplayObjectContainer.__mouseListenerBranchDepthStack.length > 0) throw "inconsistent mouse listener depth branch stack";
		#end
		return result;
	}



	private function __resize ():Void {
	}


	private function __startDrag (sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void {

		__dragBounds = (bounds == null) ? null : bounds.clone ();
		__dragObject = sprite;

		if (__dragObject != null) {

			if (lockCenter) {

				__dragOffsetX = -__dragObject.width / 2;
				__dragOffsetY = -__dragObject.height / 2;

			} else {

				var mouse = Point.pool.get ();
				mouse.setTo (mouseX, mouseY);

				var parent = __dragObject.parent;

				if (parent != null) {

					mouse = parent.globalToLocal (mouse);

				}

				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;

				Point.pool.put(mouse);

			}

		}

	}


	private function __stopDrag (sprite:Sprite):Void {

		__dragBounds = null;
		__dragObject = null;

	}

	public function __updateDirtyElements (transformOnly:Bool, updateChildren:Bool):Void {

		if (DisplayObject.__worldTransformDirty > 0 && ( transformOnly || ( __dirty || DisplayObject.__worldRenderDirty > 0 ) ) ) {
			__inlineUpdate(transformOnly, updateChildren);
			var i = 0;
			// :NOTE: Length can change here. don't cache it.
			while (i < __allChildrenStack.length ) {
				var child = __allChildrenStack[i];
				if ( child.__updateDirty ) {
					child.__update(transformOnly, updateChildren);
				}
				++i;
			}
			if (updateChildren) {
				DisplayObject.__worldTransformDirty = 0;
				if ( !transformOnly ) {
					DisplayObject.__worldRenderDirty = 0;
				}
				__dirty = transformOnly;
			}

		}
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
				__focusStack.clear();
				oldFocus.__getInteractive (__focusStack);
				__focusStack.reverse ();
				fireEvent (event, __focusStack);

			}

			if (__focus != null) {

				var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, oldFocus, false, 0);
				__focusStack.clear();
				value.__getInteractive (__focusStack);
				__focusStack.reverse ();
				fireEvent (event, __focusStack);

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

		frameTime = Std.int(1000 / value);

		if (application != null) {

			return application.frameRate = value;

		}

		return value;

	}

	private function get_fullScreenWidth():Int {
		return window.screenWidth;
	}

	private function get_fullScreenHeight():Int {
		return window.screenHeight;
	}

}


#else
typedef Stage = openfl._legacy.display.Stage;
#end
