package openfl._legacy.display; #if (openfl_legacy && lime_hybrid)


import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;


class HybridStage extends ManagedStage implements IModule {
	
	
	public function new (width:Int, height:Int, color:Null<Int> = null) {
		
		var flags = 0x00000080; // allow shaders
		
		super (width, height, flags);
		
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
		
		// TODO: Translate key code and set modifier
		
		pumpEvent ( { type: ManagedStage.etKeyDown, value: keyCode, code: keyCode, flags: 0 } );
		
	}
	
	
	public function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		// TODO: Translate key code and set modifier
		
		pumpEvent ( { type: ManagedStage.etKeyUp, value: keyCode, code: keyCode, flags: 0 } );
		
	}
	
	
	public function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etMouseDown, x: x, y: y, value: button, flags: 0 } );
		
	}
	
	
	public function onMouseMove (x:Float, y:Float):Void {
		
		pumpEvent ( { type: ManagedStage.etMouseMove, x: x, y: y, value: 0, flags: 0 } );
		
	}
	
	
	public function onMouseMoveRelative (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onMouseUp (x:Float, y:Float, button:Int):Void {
		
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
	
	
	public function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etTouchMove, x: x, y: y, value: id, flags: 0 } );
		
	}
	
	
	public function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etTouchEnd, x: x, y: y, value: id, flags: 0 } );
		
	}
	
	
	public function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		pumpEvent ( { type: ManagedStage.etTouchBegin, x: x, y: y, value: id, flags: 0 } );
		
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
	
	
	public function onWindowFocusIn ():Void {
		
		pumpEvent ( { type: ManagedStage.etGotInputFocus } );
		
	}
	
	
	public function onWindowFocusOut ():Void {
		
		pumpEvent ( { type: ManagedStage.etLostInputFocus } );
		
	}
	
	
	public function onWindowFullscreen ():Void {
		
		
		
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
		
		__render (true);
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		
		
	}
	
	
}


#end