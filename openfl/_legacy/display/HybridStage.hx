package openfl._legacy.display; #if (openfl_legacy && lime_hybrid)


import lime.app.Application;
import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.graphics.Renderer;
import lime.system.System;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Touch;
import lime.ui.Window;
import openfl._legacy.events.Event;
import openfl._legacy.Lib;
import openfl.ui.Keyboard;

@:access(openfl._legacy.Lib)
@:access(openfl.ui.Keyboard)


class HybridStage extends ManagedStage implements IModule {
	
	
	public function new (width:Int, height:Int, color:Null<Int> = null) {
		
		Lib.__stage = this;
		Lib.initWidth = width;
		Lib.initHeight = height;
		
		var flags = 0x00000080; // allow shaders
		
		super (width, height, flags);
		
		frameRate = 60;
		
		if (color != null) {
			
			this.color = color;
			
		}
		
		onWindowResize (null, width, height);
		
	}
	
	
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		pumpEvent ( { type: ManagedStage.etJoyAxisMove, id: gamepad.id, code: axis, value: value } );
		
	}
	
	
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		pumpEvent ( { type: ManagedStage.etJoyButtonDown, id: gamepad.id, code: button } );
		
	}
	
	
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		pumpEvent ( { type: ManagedStage.etJoyButtonUp, id: gamepad.id, code: button } );
		
	}
	
	
	public function onGamepadConnect (gamepad:Gamepad):Void {
		
		
		
	}
	
	
	public function onGamepadDisconnect (gamepad:Gamepad):Void {
		
		
		
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
		
		var flags = 0;
		if (modifier.shiftKey) flags |= ManagedStage.efShiftDown;
		if (modifier.ctrlKey) flags |= ManagedStage.efCtrlDown;
		if (modifier.altKey) flags |= ManagedStage.efAltDown;
		if (modifier.metaKey) flags |= ManagedStage.efCommandDown;
		
		var value = Keyboard.__convertKeyCode (keyCode);
		var code = Keyboard.__getCharCode (value, modifier.shiftKey);
		
		pumpEvent ( { type: ManagedStage.etKeyDown, value: value, code: code, flags: flags } );
		
	}
	
	
	public function onKeyUp (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var flags = 0;
		if (modifier.shiftKey) flags |= ManagedStage.efShiftDown;
		if (modifier.ctrlKey) flags |= ManagedStage.efCtrlDown;
		if (modifier.altKey) flags |= ManagedStage.efAltDown;
		if (modifier.metaKey) flags |= ManagedStage.efCommandDown;
		
		var value = Keyboard.__convertKeyCode (keyCode);
		var code = Keyboard.__getCharCode (value, modifier.shiftKey);
		
		pumpEvent ( { type: ManagedStage.etKeyUp, value: value, code: code, flags: flags } );
		
	}
	
	
	public function onModuleExit (code:Int):Void {
		
		
		
	}
	
	
	public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void {
		
		var flags = switch (button) {
			
			case 1: ManagedStage.efMiddleDown;
			case 2: ManagedStage.efRightDown;
			default: ManagedStage.efLeftDown;
			
		}
		
		flags |= ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etMouseDown, x: x, y: y, value: button, flags: flags } );
		
	}
	
	
	public function onMouseMove (window:Window, x:Float, y:Float):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etMouseMove, x: x, y: y, value: 0, flags: flags } );
		
	}
	
	
	public function onMouseMoveRelative (window:Window, x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void {
		
		var flags = switch (button) {
			
			case 1: ManagedStage.efMiddleDown;
			case 2: ManagedStage.efRightDown;
			default: ManagedStage.efLeftDown;
			
		}
		
		flags |= ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etMouseUp, x: x, y: y, value: button, flags: 0 } );
		
	}
	
	
	public function onMouseWheel (window:Window, deltaX:Float, deltaY:Float):Void {
		
		var value = deltaY > 0 ? 4 : 3;
		
		pumpEvent ( { type: ManagedStage.etMouseDown, x: 0, y: 0, value: value, flags: 0 } );
		
	}
	
	
	public function onPreloadComplete ():Void {
		
		
		
	}
	
	
	public function onPreloadProgress (loaded:Int, total:Int):Void {
		
		
		
	}
	
	
	public function onRenderContextLost (renderer:Renderer):Void {
		
		pumpEvent ( { type: ManagedStage.etRenderContextLost } );
		
	}
	
	
	public function onRenderContextRestored (renderer:Renderer, context:RenderContext):Void {
		
		pumpEvent ( { type: ManagedStage.etRenderContextRestored } );
		
	}
	
	
	public function onTextEdit (window:Window, text:String, start:Int, length:Int):Void {
		
		
		
	}
	
	
	public function onTextInput (window:Window, text:String):Void {
		
		
		
	}
	
	
	public function onTouchMove (touch:Touch):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etTouchMove, x: touch.x * stageWidth, y: touch.y * stageHeight, value: touch.id, flags: flags } );
		
	}
	
	
	public function onTouchEnd (touch:Touch):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etTouchEnd, x: touch.x * stageWidth, y: touch.y * stageHeight, value: touch.id, flags: flags } );
		
	}
	
	
	public function onTouchStart (touch:Touch):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etTouchBegin, x: touch.x * stageWidth, y: touch.y * stageHeight, value: touch.id, flags: flags } );
		
	}
	
	
	public function onWindowActivate (window:Window):Void {
		
		pumpEvent ( { type: ManagedStage.etActivate } );
		
	}
	
	
	public function onWindowClose (window:Window):Void {
		
		pumpEvent ( { type: ManagedStage.etQuit } );
		
	}
	
	
	public function onWindowCreate (window:Window):Void {
		
		
		
	}
	
	
	public function onWindowDeactivate (window:Window):Void {
		
		pumpEvent ( { type: ManagedStage.etDeactivate } );
		
	}
	
	
	public function onWindowDropFile (window:Window, file:String):Void {
		
		
		
	}
	
	
	public function onWindowEnter (window:Window):Void {
		
		
		
	}
	
	
	public function onWindowFocusIn (window:Window):Void {
		
		pumpEvent ( { type: ManagedStage.etGotInputFocus } );
		
	}
	
	
	public function onWindowFocusOut (window:Window):Void {
		
		pumpEvent ( { type: ManagedStage.etLostInputFocus } );
		
	}
	
	
	public function onWindowFullscreen (window:Window):Void {
		
		
		
	}
	
	
	public function onWindowLeave (window:Window):Void {
		
		dispatchEvent (new Event (Event.MOUSE_LEAVE));
		
	}
	
	
	public function onWindowMinimize (window:Window):Void {
		
		
		
	}
	
	
	public function onWindowMove (window:Window, x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onWindowResize (window:Window, width:Int, height:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etResize, x: width, y: height } );
		
	}
	
	
	public function onWindowRestore (window:Window):Void {
		
		
		
	}
	
	
	public function render (renderer:Renderer):Void {
		
		pumpEvent ( { type: ManagedStage.etPoll } );
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etPoll } );
		
	}
	
	
}


#end