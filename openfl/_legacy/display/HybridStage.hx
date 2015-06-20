package openfl._legacy.display; #if (openfl_legacy && lime_hybrid)


import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.system.System;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
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
		
		onWindowResize (width, height);
		
	}
	
	
	public function init (context:RenderContext):Void {
		
		
		
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
	
	
	public function onKeyDown (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var flags = 0;
		if (modifier.shiftKey) flags |= ManagedStage.efShiftDown;
		if (modifier.ctrlKey) flags |= ManagedStage.efCtrlDown;
		if (modifier.altKey) flags |= ManagedStage.efAltDown;
		if (modifier.metaKey) flags |= ManagedStage.efCommandDown;
		
		var value = Keyboard.__convertKeyCode (keyCode);
		var code = Keyboard.__getCharCode (value, modifier.shiftKey);
		
		pumpEvent ( { type: ManagedStage.etKeyDown, value: value, code: code, flags: flags } );
		
	}
	
	
	public function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		var flags = 0;
		if (modifier.shiftKey) flags |= ManagedStage.efShiftDown;
		if (modifier.ctrlKey) flags |= ManagedStage.efCtrlDown;
		if (modifier.altKey) flags |= ManagedStage.efAltDown;
		if (modifier.metaKey) flags |= ManagedStage.efCommandDown;
		
		var value = Keyboard.__convertKeyCode (keyCode);
		var code = Keyboard.__getCharCode (value, modifier.shiftKey);
		
		pumpEvent ( { type: ManagedStage.etKeyUp, value: value, code: code, flags: flags } );
		
	}
	
	
	public function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		var flags = switch (button) {
			
			case 1: ManagedStage.efMiddleDown;
			case 2: ManagedStage.efRightDown;
			default: ManagedStage.efLeftDown;
			
		}
		
		flags |= ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etMouseDown, x: x, y: y, value: button, flags: flags } );
		
	}
	
	
	public function onMouseMove (x:Float, y:Float):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etMouseMove, x: x, y: y, value: 0, flags: flags } );
		
	}
	
	
	public function onMouseMoveRelative (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		var flags = switch (button) {
			
			case 1: ManagedStage.efMiddleDown;
			case 2: ManagedStage.efRightDown;
			default: ManagedStage.efLeftDown;
			
		}
		
		flags |= ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etMouseUp, x: x, y: y, value: button, flags: 0 } );
		
	}
	
	
	public function onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		var value = deltaY > 0 ? 4 : 3;
		
		pumpEvent ( { type: ManagedStage.etMouseDown, x: 0, y: 0, value: value, flags: 0 } );
		
	}
	
	
	public function onRenderContextLost ():Void {
		
		pumpEvent ( { type: ManagedStage.etRenderContextLost } );
		
	}
	
	
	public function onRenderContextRestored (context:RenderContext):Void {
		
		pumpEvent ( { type: ManagedStage.etRenderContextRestored } );
		
	}
	
	
	public function onTextEdit (text:String, start:Int, length:Int):Void {
		
		
		
	}
	
	
	public function onTextInput (text:String):Void {
		
		
		
	}
	
	
	public function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etTouchMove, x: x, y: y, value: id, flags: flags } );
		
	}
	
	
	public function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etTouchEnd, x: x, y: y, value: id, flags: flags } );
		
	}
	
	
	public function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		var flags = ManagedStage.efPrimaryTouch;
		
		pumpEvent ( { type: ManagedStage.etTouchBegin, x: x, y: y, value: id, flags: flags } );
		
	}
	
	
	public function onWindowActivate ():Void {
		
		pumpEvent ( { type: ManagedStage.etActivate } );
		
	}
	
	
	public function onWindowClose ():Void {
		
		pumpEvent ( { type: ManagedStage.etQuit } );
		
	}
	
	
	public function onWindowDeactivate ():Void {
		
		pumpEvent ( { type: ManagedStage.etDeactivate } );
		
	}
	
	
	public function onWindowEnter ():Void {
		
		
		
	}
	
	
	public function onWindowFocusIn ():Void {
		
		pumpEvent ( { type: ManagedStage.etGotInputFocus } );
		
	}
	
	
	public function onWindowFocusOut ():Void {
		
		pumpEvent ( { type: ManagedStage.etLostInputFocus } );
		
	}
	
	
	public function onWindowFullscreen ():Void {
		
		
		
	}
	
	
	public function onWindowLeave ():Void {
		
		dispatchEvent (new Event (Event.MOUSE_LEAVE));
		
	}
	
	
	public function onWindowMinimize ():Void {
		
		
		
	}
	
	
	public function onWindowMove (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onWindowResize (width:Int, height:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etResize, x: width, y: height } );
		
	}
	
	
	public function onWindowRestore ():Void {
		
		
		
	}
	
	
	public function render (context:RenderContext):Void {
		
		pumpEvent ( { type: ManagedStage.etPoll } );
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etPoll } );
		
	}
	
	
}


#end