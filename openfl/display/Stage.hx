package openfl.display;


import haxe.CallStack;
import haxe.EnumFlags;
import lime.app.Application;
import lime.app.IModule;
import lime.app.Preloader;
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
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Mouse in LimeMouse;
import lime.ui.Window;
import lime.utils.GLUtils;
import lime.utils.Log;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.console.ConsoleRenderer;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
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
import openfl.events.UncaughtErrorEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.text.TextField;
import openfl.ui.GameInput;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.utils.TouchData;

#if hxtelemetry
import openfl.profiler.Telemetry;
#end

#if (js && html5)
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.renderer.AbstractRenderer)
@:access(openfl.display.Sprite)
@:access(openfl.display.Stage3D)
@:access(openfl.events.Event)
@:access(openfl.geom.Point)
@:access(openfl.ui.GameInput)
@:access(openfl.ui.Keyboard)
@:access(openfl.ui.Mouse)
@:access(openfl.utils.TouchData)


class Stage extends DisplayObjectContainer implements IModule {
	
	
	public var align:StageAlign;
	public var allowsFullScreen (default, null):Bool;
	public var allowsFullScreenInteractive (default, null):Bool;
	public var application (default, null):Application;
	public var color (get, set):Int;
	public var displayState (get, set):StageDisplayState;
	public var focus (get, set):InteractiveObject;
	public var frameRate (get, set):Float;
	public var fullScreenHeight (get, never):UInt;
	public var fullScreenWidth (get, never):UInt;
	public var quality:StageQuality;
	public var scaleMode:StageScaleMode;
	public var showDefaultContextMenu:Bool;
	public var softKeyboardRect:Rectangle;
	public var stage3Ds (default, null):Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight (default, null):Int;
	public var stageWidth (default, null):Int;
	public var window (default, null):Window;
	
	private var __cacheFocus:InteractiveObject;
	private var __clearBeforeRender:Bool;
	private var __color:Int;
	private var __colorSplit:Array<Float>;
	private var __colorString:String;
	private var __deltaTime:Int;
	private var __dirty:Bool;
	private var __displayMatrix:Matrix;
	private var __displayState:StageDisplayState;
	private var __dragBounds:Rectangle;
	private var __dragObject:Sprite;
	private var __dragOffsetX:Float;
	private var __dragOffsetY:Float;
	private var __focus:InteractiveObject;
	private var __fullscreen:Bool;
	private var __invalidated:Bool;
	private var __lastClickTime:Int;
	private var __logicalWidth:Int;
	private var __logicalHeight:Int;
	private var __macKeyboard:Bool;
	private var __mouseDownLeft:InteractiveObject;
	private var __mouseDownMiddle:InteractiveObject;
	private var __mouseDownRight:InteractiveObject;
	private var __mouseOverTarget:InteractiveObject;
	private var __mouseX:Float;
	private var __mouseY:Float;
	private var __primaryTouch:Touch;
	private var __renderer:AbstractRenderer;
	private var __rendering:Bool;
	private var __rollOutStack:Array<DisplayObject>;
	private var __stack:Array<DisplayObject>;
	private var __transparent:Bool;
	private var __wasDirty:Bool;
	
	private var __touchData:Map<Int, TouchData>;
	
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
		__logicalWidth = 0;
		__logicalHeight = 0;
		__displayMatrix = new Matrix ();
		__renderDirty = true;
		
		stage3Ds = new Vector ();
		stage3Ds.push (new Stage3D ());
		
		__resize ();
		
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
		showDefaultContextMenu = true;
		softKeyboardRect = new Rectangle ();
		stageFocusRect = true;
		
		#if mac
		__macKeyboard = true;
		#elseif (js && html5)
		__macKeyboard = untyped __js__ ("/AppleWebKit/.test (navigator.userAgent) && /Mobile\\/\\w+/.test (navigator.userAgent) || /Mac/.test (navigator.platform)");
		#end
		
		__clearBeforeRender = true;
		__stack = [];
		__rollOutStack = [];
		__touchData = new Map<Int, TouchData>();
		
		if (Lib.current.stage == null) {
			
			stage.addChild (Lib.current);
			
		}
		
	}
	
	
	@:noCompletion public function addRenderer (renderer:Renderer):Void {
		
		renderer.onRender.add (render.bind (renderer));
		renderer.onContextLost.add (onRenderContextLost.bind (renderer));
		renderer.onContextRestored.add (onRenderContextRestored.bind (renderer));
		
	}
	
	
	@:noCompletion public function addWindow (window:Window):Void {
		
		if (this.window != window) return;
		
		window.onActivate.add (onWindowActivate.bind (window));
		window.onClose.add (onWindowClose.bind (window), false, -9000);
		window.onCreate.add (onWindowCreate.bind (window));
		window.onDeactivate.add (onWindowDeactivate.bind (window));
		window.onDropFile.add (onWindowDropFile.bind (window));
		window.onEnter.add (onWindowEnter.bind (window));
		window.onFocusIn.add (onWindowFocusIn.bind (window));
		window.onFocusOut.add (onWindowFocusOut.bind (window));
		window.onFullscreen.add (onWindowFullscreen.bind (window));
		window.onKeyDown.add (onKeyDown.bind (window));
		window.onKeyUp.add (onKeyUp.bind (window));
		window.onLeave.add (onWindowLeave.bind (window));
		window.onMinimize.add (onWindowMinimize.bind (window));
		window.onMouseDown.add (onMouseDown.bind (window));
		window.onMouseMove.add (onMouseMove.bind (window));
		window.onMouseMoveRelative.add (onMouseMoveRelative.bind (window));
		window.onMouseUp.add (onMouseUp.bind (window));
		window.onMouseWheel.add (onMouseWheel.bind (window));
		window.onMove.add (onWindowMove.bind (window));
		window.onResize.add (onWindowResize.bind (window));
		window.onRestore.add (onWindowRestore.bind (window));
		window.onTextEdit.add (onTextEdit.bind (window));
		window.onTextInput.add (onTextInput.bind (window));
		
		if (window.id > -1) {
			
			onWindowCreate (window);
			
		}
		
	}
	
	
	@:noCompletion public function registerModule (application:Application):Void {
		
		application.onExit.add (onModuleExit, false, 0);
		application.onUpdate.add (update);
		
		for (gamepad in Gamepad.devices) {
			
			__onGamepadConnect (gamepad);
			
		}
		
		Gamepad.onConnect.add (__onGamepadConnect);
		Touch.onStart.add (onTouchStart);
		Touch.onMove.add (onTouchMove);
		Touch.onEnd.add (onTouchEnd);
		
	}
	
	
	@:noCompletion public function removeRenderer (renderer:Renderer):Void { }
	@:noCompletion public function removeWindow (window:Window):Void { }
	@:noCompletion public function setPreloader (preloader:Preloader):Void { }
	
	
	@:noCompletion public function unregisterModule (application:Application):Void {
		
		application.onExit.remove (onModuleExit);
		application.onUpdate.remove (update);
		
		Gamepad.onConnect.remove (__onGamepadConnect);
		Touch.onStart.remove (onTouchStart);
		Touch.onMove.remove (onTouchMove);
		Touch.onEnd.remove (onTouchEnd);
		
	}
	
	
	public function invalidate ():Void {
		
		__invalidated = true;
		
	}
	
	
	public override function localToGlobal (pos:Point):Point {
		
		return pos.clone ();
		
	}
	
	
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		try {
			
			GameInput.__onGamepadAxisMove (gamepad, axis, value);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		try {
			
			GameInput.__onGamepadButtonDown (gamepad, button);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		try {
			
			GameInput.__onGamepadButtonUp (gamepad, button);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onGamepadConnect (gamepad:Gamepad):Void {
		
		try {
			
			GameInput.__onGamepadConnect (gamepad);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onGamepadDisconnect (gamepad:Gamepad):Void {
		
		try {
			
			GameInput.__onGamepadDisconnect (gamepad);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
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
		
		try {
			
			__onKey (KeyboardEvent.KEY_DOWN, keyCode, modifier);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onKeyUp (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__onKey (KeyboardEvent.KEY_UP, keyCode, modifier);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onModuleExit (code:Int):Void {
		
		if (window != null) {
			
			try {
				
				__broadcastEvent (new Event (Event.DEACTIVATE));
				
			} catch (e:Dynamic) {
				
				__handleError (e);
				
			}
			
		}
		
	}
	
	
	public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			var type = switch (button) {
				
				case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
				case 2: MouseEvent.RIGHT_MOUSE_DOWN;
				default: MouseEvent.MOUSE_DOWN;
				
			}
			
			__onMouse (type, Std.int (x * window.scale), Std.int (y * window.scale), button);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onMouseMove (window:Window, x:Float, y:Float):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__onMouse (MouseEvent.MOUSE_MOVE, Std.int (x * window.scale), Std.int (y * window.scale), 0);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onMouseMoveRelative (window:Window, x:Float, y:Float):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			var type = switch (button) {
				
				case 1: MouseEvent.MIDDLE_MOUSE_UP;
				case 2: MouseEvent.RIGHT_MOUSE_UP;
				default: MouseEvent.MOUSE_UP;
				
			}
			
			__onMouse (type, Std.int (x * window.scale), Std.int (y * window.scale), button);
			
			if (!showDefaultContextMenu && button == 2) {
				
				window.onMouseUp.cancel ();
				
			}
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onMouseWheel (window:Window, deltaX:Float, deltaY:Float):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__onMouseWheel (Std.int (deltaX * window.scale), Std.int (deltaY * window.scale));
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onPreloadComplete ():Void {
		
		
		
	}
	
	
	public function onPreloadProgress (loaded:Int, total:Int):Void {
		
		
		
	}
	
	
	public function onRenderContextLost (renderer:Renderer):Void {
		
		__renderer = null;
		
	}
	
	
	public function onRenderContextRestored (renderer:Renderer, context:RenderContext):Void {
		
		__createRenderer ();
		
	}
	
	
	public function onTextEdit (window:Window, text:String, start:Int, length:Int):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onTextInput (window:Window, text:String):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			var stack = new Array <DisplayObject> ();
			
			if (__focus == null) {
				
				__getInteractive (stack);
				
			} else {
				
				__focus.__getInteractive (stack);
				
			}
			
			var event = new TextEvent (TextEvent.TEXT_INPUT, true, false, text);
			if (stack.length > 0) {
				
				stack.reverse ();
				__dispatchStack (event, stack);
				
			} else {
				
				__dispatchEvent (event);
				
			}
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onTouchMove (touch:Touch):Void {
		
		try {
			
			__onTouch (TouchEvent.TOUCH_MOVE, touch);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onTouchEnd (touch:Touch):Void {
		
		try {
			
			if (__primaryTouch == touch) {
				
				__primaryTouch = null;
				
			}
			
			__onTouch (TouchEvent.TOUCH_END, touch);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onTouchStart (touch:Touch):Void {
		
		try {
			
			if (__primaryTouch == null) {
				
				__primaryTouch = touch;
				
			}
			
			__onTouch (TouchEvent.TOUCH_BEGIN, touch);
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowActivate (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		//try {
			//
			//__broadcastEvent (new Event (Event.ACTIVATE));
			//
		//} catch (e:Dynamic) {
			//
			//__handleError (e);
			//
		//}
		
	}
	
	
	public function onWindowClose (window:Window):Void {
		
		if (this.window == window) {
			
			this.window = null;
			
		}
		
		try {
			
			__primaryTouch = null;
			__broadcastEvent (new Event (Event.DEACTIVATE));
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowCreate (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			if (window.renderer != null) {
				
				__createRenderer ();
				
			}
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowDeactivate (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		//try {
			//
			//__primaryTouch = null;
			//__broadcastEvent (new Event (Event.DEACTIVATE));
			//
		//} catch (e:Dynamic) {
			//
			//__handleError (e);
			//
		//}
		
	}
	
	
	public function onWindowDropFile (window:Window, file:String):Void {
		
		
		
	}
	
	
	public function onWindowEnter (window:Window):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onWindowFocusIn (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__renderDirty = true;
			__broadcastEvent (new Event (Event.ACTIVATE));
			
			focus = __cacheFocus;
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowFocusOut (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__primaryTouch = null;
			__broadcastEvent (new Event (Event.DEACTIVATE));
			
			var currentFocus = focus;
			focus = null;
			__cacheFocus = currentFocus;
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowFullscreen (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__resize ();
			
			if (__displayState == NORMAL) {
				
				__displayState = FULL_SCREEN_INTERACTIVE;
				__dispatchEvent (new FullScreenEvent (FullScreenEvent.FULL_SCREEN, false, false, false, true));
				
			}
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowLeave (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__dispatchEvent (new Event (Event.MOUSE_LEAVE));
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowMinimize (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		//try {
			//
			//__primaryTouch = null;
			//__broadcastEvent (new Event (Event.DEACTIVATE));
			//
		//} catch (e:Dynamic) {
			//
			//__handleError (e);
			//
		//}
		
	}
	
	
	public function onWindowMove (window:Window, x:Float, y:Float):Void {
		
		//if (this.window == null || this.window != window) return;
		
	}
	
	
	public function onWindowResize (window:Window, width:Int, height:Int):Void {
		
		if (this.window == null || this.window != window) return;
		
		try {
			
			__renderDirty = true;
			__resize ();
			
			if (__displayState != NORMAL && !window.fullscreen) {
				
				__displayState = NORMAL;
				__dispatchEvent (new FullScreenEvent (FullScreenEvent.FULL_SCREEN, false, false, true, true));
				
			}
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function onWindowRestore (window:Window):Void {
		
		if (this.window == null || this.window != window) return;
		
		//try {
			//
			//__broadcastEvent (new Event (Event.ACTIVATE));
			//
		//} catch (e:Dynamic) {
			//
			//__handleError (e);
			//
		//}
		
	}
	
	
	public function render (renderer:Renderer):Void {
		
		if (renderer.window == null || renderer.window != window) return;
		
		try {
			
			if (__rendering) return;
			__rendering = true;
			
			#if hxtelemetry
			Telemetry.__advanceFrame ();
			#end
			
			if (__renderer != null && (Stage3D.__active || stage3Ds[0].__contextRequested)) {
				
				__renderer.clear ();
				__renderer.renderStage3D ();
				__renderDirty = true;
				
			}
			
			__broadcastEvent (new Event (Event.ENTER_FRAME));
			__broadcastEvent (new Event (Event.FRAME_CONSTRUCTED));
			__broadcastEvent (new Event (Event.EXIT_FRAME));
			
			if (__invalidated) {
				
				__invalidated = false;
				__broadcastEvent (new Event (Event.RENDER));
				
			}
			
			#if hxtelemetry
			var stack = Telemetry.__unwindStack ();
			Telemetry.__startTiming (TelemetryCommandName.RENDER);
			#end
			
			__renderable = true;
			
			__enterFrame (__deltaTime);
			__deltaTime = 0;
			__update (false, true);
			
			if (__renderer != null #if !openfl_always_render && __renderDirty #end) {
				
				if (!Stage3D.__active) {
					
					__renderer.clear ();
					
				}
				
				if (renderer.type == CAIRO) {
					
					switch (renderer.context) {
						
						case CAIRO (cairo):
							
							#if lime_cairo
							cast (__renderer, CairoRenderer).cairo = cairo;
							@:privateAccess (__renderer.renderSession).cairo = cairo;
							#end
						
						default:
							
					}
					
				}
				
				__renderer.render ();
				
			} else {
				
				renderer.onRender.cancel ();
				
			}
			
			#if hxtelemetry
			Telemetry.__endTiming (TelemetryCommandName.RENDER);
			Telemetry.__rewindStack (stack);
			#end
			
			__rendering = false;
			
		} catch (e:Dynamic) {
			
			__handleError (e);
			
		}
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		__deltaTime = deltaTime;
		
	}
	
	
	private function __broadcastEvent (event:Event):Void {
		
		if (DisplayObject.__broadcastEvents.exists (event.type)) {
			
			var dispatchers = DisplayObject.__broadcastEvents.get (event.type);
			
			for (dispatcher in dispatchers) {
				
				dispatcher.__dispatch (event);
				
			}
			
		}
		
	}
	
	
	private function __createRenderer ():Void {
		
		switch (window.renderer.context) {
			
			case OPENGL (gl):
				
				#if (!disable_cffi && (!html5 || !canvas))
				__renderer = new GLRenderer (this, gl);
				#end
			
			case CANVAS (context):
				
				__renderer = new CanvasRenderer (this, context);
			
			case DOM (element):
				
				#if dom
				__renderer = new DOMRenderer (this, element);
				#end
			
			case CAIRO (cairo):
				
				#if lime_cairo
				__renderer = new CairoRenderer (this, cairo);
				#end
			
			case CONSOLE (ctx):
				
				#if lime_console
				__renderer = new ConsoleRenderer (this, ctx);
				#end
			
			default:
			
		}
		
	}
	
	
	private function __drag (mouse:Point):Void {
		
		var parent = __dragObject.parent;
		if (parent != null) {
			
			parent.__getWorldTransform ().__transformInversePoint (mouse);
			
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
	
	
	private override function __getInteractive (stack:Array<DisplayObject>):Bool {
		
		if (stack != null) {
			
			stack.push (this);
			
		}
		
		return true;
		
	}
	
	
	private override function __globalToLocal (global:Point, local:Point):Point {
		
		if (global != local) {
			
			local.copyFrom (global);
			
		}
		
		return local;
		
	}
	
	
	private function __handleError (e:Dynamic):Void {
		
		var event = new UncaughtErrorEvent (UncaughtErrorEvent.UNCAUGHT_ERROR, true, true, e);
		Lib.current.__loaderInfo.uncaughtErrorEvents.dispatchEvent (event);
		
		if (!event.__preventDefault) {
			
			#if mobile
			Log.println (CallStack.toString (CallStack.exceptionStack ()));
			Log.println (Std.string (e));
			#end
			
			#if cpp
			untyped __cpp__ ("throw e");
			#elseif neko
			neko.Lib.rethrow (e);
			#elseif js
			untyped __js__ ("throw e");
			#elseif cs
			throw e;
			//cs.Lib.rethrow (e);
			#else
			throw e;
			#end
			
		}
		
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
			
			// Flash Player events are not cancelable, should we make only some events (like APP_CONTROL_BACK) cancelable?
			
			var event = new KeyboardEvent (type, true, true, charCode, keyCode, keyLocation, __macKeyboard ? modifier.ctrlKey || modifier.metaKey : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);
			
			stack.reverse ();
			__dispatchStack (event, stack);
			
			if (event.__preventDefault) {
				
				if (type == KeyboardEvent.KEY_DOWN) {
					
					window.onKeyDown.cancel ();
					
				} else {
					
					window.onKeyUp.cancel ();
					
				}
				
			}
			
		}
		
	}
	
	
	private function __onGamepadConnect (gamepad:Gamepad):Void {
		
		onGamepadConnect (gamepad);
		
		gamepad.onAxisMove.add (onGamepadAxisMove.bind (gamepad));
		gamepad.onButtonDown.add (onGamepadButtonDown.bind (gamepad));
		gamepad.onButtonUp.add (onGamepadButtonUp.bind (gamepad));
		gamepad.onDisconnect.add (onGamepadDisconnect.bind (gamepad));
		
	}
	
	
	private function __onMouse (type:String, x:Float, y:Float, button:Int):Void {
		
		if (button > 2) return;
		
		var targetPoint = Point.__pool.get ();
		targetPoint.setTo (x, y);
		__displayMatrix.__transformInversePoint (targetPoint);
		
		__mouseX = targetPoint.x;
		__mouseY = targetPoint.y;
		
		var stack = [];
		var target:InteractiveObject = null;
		
		if (__hitTest (__mouseX, __mouseY, true, stack, true, this)) {
			
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
		
		var localPoint = Point.__pool.get ();
		
		__dispatchStack (MouseEvent.__create (type, button, __mouseX, __mouseY, target.__globalToLocal (targetPoint, localPoint), target), stack);
		
		if (clickType != null) {
			
			__dispatchStack (MouseEvent.__create (clickType, button, __mouseX, __mouseY, target.__globalToLocal (targetPoint, localPoint), target), stack);
			
			if (type == MouseEvent.MOUSE_UP && cast (target, openfl.display.InteractiveObject).doubleClickEnabled) {
				
				var currentTime = Lib.getTimer ();
				if (currentTime - __lastClickTime < 500) {
					
					__dispatchStack (MouseEvent.__create (MouseEvent.DOUBLE_CLICK, button, __mouseX, __mouseY, target.__globalToLocal (targetPoint, localPoint), target), stack);
					__lastClickTime = 0;
					
				} else {
					
					__lastClickTime = currentTime;
					
				}
				
			}
			
		}
		
		if (Mouse.__cursor == MouseCursor.AUTO) {
			
			var cursor = null;
			
			if (__mouseDownLeft != null) {
				
				cursor = __mouseDownLeft.__getCursor ();
				
			} else {
				
				for (target in stack) {
					
					cursor = target.__getCursor ();
					
					if (cursor != null) {
						
						LimeMouse.cursor = cursor;
						break;
						
					}
					
				}
				
			}
			
			if (cursor == null) {
				
				LimeMouse.cursor = ARROW;
				
			}
			
		}
		
		var event;
		
		if (target != __mouseOverTarget) {
			
			if (__mouseOverTarget != null) {
				
				event = MouseEvent.__create (MouseEvent.MOUSE_OUT, button, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal (targetPoint, localPoint), cast __mouseOverTarget);
				__mouseOverTarget.__dispatchEvent (event);
				
			}
			
		}
		
		for (target in __rollOutStack) {
			
			if (stack.indexOf (target) == -1) {
				
				__rollOutStack.remove (target);
				
				event = MouseEvent.__create (MouseEvent.ROLL_OUT, button, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal (targetPoint, localPoint), cast __mouseOverTarget);
				event.bubbles = false;
				target.__dispatchEvent (event);
				
			}
			
		}
		
		for (target in stack) {
			
			if (__rollOutStack.indexOf (target) == -1 && __mouseOverTarget != null) {
				
				if (target.hasEventListener (MouseEvent.ROLL_OVER)) {
					
					event = MouseEvent.__create (MouseEvent.ROLL_OVER, button, __mouseX, __mouseY, __mouseOverTarget.__globalToLocal (targetPoint, localPoint), cast target);
					event.bubbles = false;
					target.__dispatchEvent (event);
					
				}
				
				if (target.hasEventListener (MouseEvent.ROLL_OUT)) {
					
					__rollOutStack.push (target);
					
				}
				
			}
			
		}
		
		if (target != __mouseOverTarget) {
			
			if (target != null) {
				
				event = MouseEvent.__create (MouseEvent.MOUSE_OVER, button, __mouseX, __mouseY, target.__globalToLocal (targetPoint, localPoint), cast target);
				event.bubbles = true;
				target.__dispatchEvent (event);
				
			}
			
			__mouseOverTarget = target;
			
		}
		
		if (__dragObject != null) {
			
			__drag (targetPoint);
			
			var dropTarget = null;
			
			if (__mouseOverTarget == __dragObject) {
				
				var cacheMouseEnabled = __dragObject.mouseEnabled;
				var cacheMouseChildren = __dragObject.mouseChildren;
				
				__dragObject.mouseEnabled = false;
				__dragObject.mouseChildren = false;
				
				var stack = [];
				
				if (__hitTest (__mouseX, __mouseY, true, stack, true, this)) {
					
					dropTarget = stack[stack.length - 1];
					
				}
				
				__dragObject.mouseEnabled = cacheMouseEnabled;
				__dragObject.mouseChildren = cacheMouseChildren;
				
			} else if (__mouseOverTarget != this) {
				
				dropTarget = __mouseOverTarget;
				
			}
			
			__dragObject.dropTarget = dropTarget;
			
		}
		
		Point.__pool.release (targetPoint);
		Point.__pool.release (localPoint);
		
	}
	
	
	private function __onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		var x = __mouseX;
		var y = __mouseY;
		
		var stack = [];
		var target:InteractiveObject = null;
		
		if (__hitTest (__mouseX, __mouseY, true, stack, true, this)) {
			
			target = cast stack[stack.length - 1];
			
		} else {
			
			target = this;
			stack = [ this ];
			
		}
		
		if (target == null) target = this;
		var targetPoint = Point.__pool.get ();
		targetPoint.setTo (x, y);
		__displayMatrix.__transformInversePoint (targetPoint);
		var delta = Std.int (deltaY);
		
		__dispatchStack (MouseEvent.__create (MouseEvent.MOUSE_WHEEL, 0, __mouseX, __mouseY, target.__globalToLocal (targetPoint, targetPoint), target, delta), stack);
		
		Point.__pool.release (targetPoint);
		
	}
	
	
	private function __onTouch (type:String, touch:Touch):Void {
		
		var targetPoint = Point.__pool.get ();
		targetPoint.setTo (Math.round (touch.x * window.width * window.scale), Math.round (touch.y * window.height * window.scale));
		__displayMatrix.__transformInversePoint (targetPoint);
		
		var touchX = targetPoint.x;
		var touchY = targetPoint.y;
		
		var stack = [];
		var target:InteractiveObject = null;
		
		if (__hitTest (touchX, touchY, false, stack, true, this)) {
			
			target = cast stack[stack.length - 1];
			
		}
		else {
			
			target = this;
			stack = [ this ];
			
		}
		
		if (target == null) target = this;
		
		var touchId:Int = touch.id;
		var touchData:TouchData = null;
		
		if (__touchData.exists(touchId)) {
			
			touchData = __touchData.get(touchId);
			
		} else {
			
			touchData = TouchData.__pool.get ();
			touchData.reset();
			touchData.touch = touch;
			__touchData.set(touchId, touchData);
			
		}
		
		var touchType = null;
		var releaseTouchData:Bool = false;
		
		switch (type) {
			
			case TouchEvent.TOUCH_BEGIN:
			
				touchData.touchDownTarget = target;
			
			case TouchEvent.TOUCH_END:
				
				if (touchData.touchDownTarget == target) {
					
					touchType = TouchEvent.TOUCH_TAP;
					
				}
				
				touchData.touchDownTarget = null;
				releaseTouchData = true;
			
			default:
			
			
		}
		
		var localPoint = Point.__pool.get ();
		var isPrimaryTouchPoint:Bool = (__primaryTouch == touch);
		var touchEvent = TouchEvent.__create (type, null, touchX, touchY, target.__globalToLocal (targetPoint, localPoint), cast target);
		touchEvent.touchPointID = touchId;
		touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
		
		__dispatchStack (touchEvent, stack);
		
		if (touchType != null) {
			
			touchEvent = TouchEvent.__create (touchType, null, touchX, touchY, target.__globalToLocal (targetPoint, localPoint), cast target);
			touchEvent.touchPointID = touchId;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			
			__dispatchStack (touchEvent, stack);
			
		}
		
		var touchOverTarget = touchData.touchOverTarget;
		
		if (target != touchOverTarget && touchOverTarget != null) {
			
			touchEvent = TouchEvent.__create (TouchEvent.TOUCH_OUT, null, touchX, touchY, touchOverTarget.__globalToLocal (targetPoint, localPoint), cast touchOverTarget);
			touchEvent.touchPointID = touchId;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			
			touchOverTarget.__dispatchEvent (touchEvent);
			
		}
		
		var touchOutStack = touchData.rollOutStack;
		
		for (target in touchOutStack) {
			
			if (stack.indexOf (target) == -1) {
				
				touchOutStack.remove (target);
				
				touchEvent = TouchEvent.__create (TouchEvent.TOUCH_ROLL_OUT, null, touchX, touchY, touchOverTarget.__globalToLocal (targetPoint, localPoint), cast touchOverTarget);
				touchEvent.touchPointID = touchId;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				touchEvent.bubbles = false;
				
				target.__dispatchEvent (touchEvent);
				
			}
			
		}
		
		for (target in stack) {
			
			if (touchOutStack.indexOf (target) == -1) {
				
				if (target.hasEventListener (TouchEvent.TOUCH_ROLL_OVER)) {
					
					touchEvent = TouchEvent.__create (TouchEvent.TOUCH_ROLL_OVER, null, touchX, touchY, touchOverTarget.__globalToLocal (targetPoint, localPoint), cast target);
					touchEvent.touchPointID = touchId;
					touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
					touchEvent.bubbles = false;
					
					target.__dispatchEvent (touchEvent);
					
				}
				
				if (target.hasEventListener (TouchEvent.TOUCH_ROLL_OUT)) {
					
					touchOutStack.push (target);
					
				}
				
			}
			
		}
		
		if (target != touchOverTarget) {
			
			if (target != null) {
				
				touchEvent = TouchEvent.__create (TouchEvent.TOUCH_OVER, null, touchX, touchY, target.__globalToLocal (targetPoint, localPoint), cast target);
				touchEvent.touchPointID = touchId;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				touchEvent.bubbles = true;
				
				target.__dispatchEvent (touchEvent);
				
			}
			
			touchData.touchOverTarget = target;
			
		}
		
		Point.__pool.release (targetPoint);
		Point.__pool.release (localPoint);
		
		if (releaseTouchData) {
			
			__touchData.remove(touchId);
			touchData.reset();
			TouchData.__pool.release (touchData);
			
		}
		
	}
	
	
	private function __resize ():Void {
		
		var cacheWidth = stageWidth;
		var cacheHeight = stageHeight;
		
		var windowWidth = Std.int (window.width * window.scale);
		var windowHeight = Std.int (window.height * window.scale);
		
		#if (js && html5)
		__logicalWidth = windowWidth;
		__logicalHeight = windowHeight;
		#end
		
		__displayMatrix.identity ();
		
		if (__logicalWidth == 0 && __logicalHeight == 0) {
			
			stageWidth = windowWidth;
			stageHeight = windowHeight;
			
		} else {
			
			stageWidth = __logicalWidth;
			stageHeight = __logicalHeight;
			
			var scaleX = windowWidth / stageWidth;
			var scaleY = windowHeight / stageHeight;
			var targetScale = Math.min (scaleX, scaleY);
			
			var offsetX = Math.round ((windowWidth - (stageWidth * targetScale)) / 2);
			var offsetY = Math.round ((windowHeight - (stageHeight * targetScale)) / 2);
			
			__displayMatrix.scale (targetScale, targetScale);
			__displayMatrix.translate (offsetX, offsetY);
			
		}
		
		for (stage3D in stage3Ds) {
			
			stage3D.__resize (stageWidth, stageHeight);
			
		}
		
		if (__renderer != null) {
			
			__renderer.resize (windowWidth, windowHeight);
			
		}
		
		if (stageWidth != cacheWidth || stageHeight != cacheHeight) {
			
			__dispatchEvent (new Event (Event.RESIZE));
			
		}
		
	}
	
	
	private function __setLogicalSize (width:Int, height:Int):Void {
		
		__logicalWidth = width;
		__logicalHeight = height;
		
		__resize ();
		
	}
	
	
	private function __startDrag (sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void {
		
		__dragBounds = (bounds == null) ? null : bounds.clone ();
		__dragObject = sprite;
		
		if (__dragObject != null) {
			
			if (lockCenter) {
				
				__dragOffsetX = 0;
				__dragOffsetY = 0;
				
			} else {
				
				var mouse = Point.__pool.get ();
				mouse.setTo (mouseX, mouseY);
				var parent = __dragObject.parent;
				
				if (parent != null) {
					
					parent.__getWorldTransform ().__transformInversePoint (mouse);
					
				}
				
				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				Point.__pool.release (mouse);
				
			}
			
		}
		
	}
	
	
	private function __stopDrag (sprite:Sprite):Void {
		
		__dragBounds = null;
		__dragObject = null;
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool, maskGraphics:Graphics = null):Void {
		
		if (transformOnly) {
			
			if (__transformDirty) {
				
				super.__update (true, updateChildren, maskGraphics);
				
				if (updateChildren) {
					
					__transformDirty = false;
					//__dirty = true;
					
				}
				
			}
			
		} else {
			
			if (__transformDirty || __renderDirty) {
				
				super.__update (false, updateChildren, maskGraphics);
				
				if (updateChildren) {
					
					#if dom
					__wasDirty = true;
					#end
					
					//__dirty = false;
					
				}
				
			} #if dom else if (__wasDirty) {
				
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				
				super.__update (false, updateChildren, maskGraphics);
				
				if (updateChildren) {
					
					__wasDirty = false;
					
				}
				
			} #end
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_color ():Int {
		
		return __color;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		var r = (value & 0xFF0000) >>> 16;
		var g = (value & 0x00FF00) >>> 8;
		var b = (value & 0x0000FF);
		
		__colorSplit = [ r / 0xFF, g / 0xFF, b / 0xFF ];
		__colorString = "#" + StringTools.hex (value & 0xFFFFFF, 6);
		
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
						
					}
				
				default:
					
					if (!window.fullscreen) {
						
						//window.minimized = false;
						window.fullscreen = true;
						
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
			__cacheFocus = value;
			
			if (oldFocus != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, __focus, false, 0);
				var stack = new Array <DisplayObject> ();
				oldFocus.__getInteractive (stack);
				stack.reverse ();
				__dispatchStack (event, stack);
				
			}
			
			if (__focus != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, oldFocus, false, 0);
				var stack = new Array <DisplayObject> ();
				value.__getInteractive (stack);
				stack.reverse ();
				__dispatchStack (event, stack);
				
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
	
	
	private function get_fullScreenHeight ():UInt {
		
		return window.display.currentMode.height;
		
	}
	
	
	private function get_fullScreenWidth ():UInt {
		
		return window.display.currentMode.width;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		return this.height;
		
	}
	
	
	private override function get_mouseX ():Float {
		
		return __mouseX;
		
	}
	
	
	private override function get_mouseY ():Float {
		
		return __mouseY;
		
	}
	
	
	private override function set_rotation (value:Float):Float {
		
		return 0;
		
	}
	
	
	private override function set_scaleX (value:Float):Float {
		
		return 0;
		
	}
	
	
	private override function set_scaleY (value:Float):Float {
		
		return 0;
		
	}
	
	
	private override function set_transform (value:Transform):Transform {
		
		return this.transform;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		return this.width;
		
	}
	
	
	private override function set_x (value:Float):Float {
		
		return 0;
		
	}
	
	
	private override function set_y (value:Float):Float {
		
		return 0;
		
	}
	
	
}
