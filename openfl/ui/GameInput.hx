package openfl.ui; #if !flash


import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.GameInputEvent;

@:access(openfl.ui.GameInputControl)
@:access(openfl.ui.GameInputDevice)


class GameInput extends EventDispatcher {
	
	
	public static var isSupported = true;
	public static var numDevices (default, null) = 0;
	
	private static var __devices = new Map<Gamepad, GameInputDevice> ();
	private static var __instances = [];
	
	
	public function new () {
		
		super ();
		
		__instances.push (this);
		
	}
	
	
	public static function getDeviceAt (index:Int):GameInputDevice {
		
		if (Gamepad.devices.exists (index)) {
			
			return __devices.get (Gamepad.devices.get (index));
			
		}
		
		return null;
		
	}
	
	
	private static function __onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		var device = __devices.get (gamepad);
		if (device == null) return;
		
		if (device.enabled) {
			
			if (!device.__axis.exists (axis)) {
				
				var control = new GameInputControl (device, "AXIS_" + axis, -1, 1);
				device.__axis.set (axis, control);
				device.__controls.push (control);
				
			}
			
			var control = device.__axis.get (axis);
			control.value = value;
			control.dispatchEvent (new Event (Event.CHANGE));
			
		}
		
	}
	
	
	private static function __onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		var device = __devices.get (gamepad);
		
		if (device.enabled) {
			
			if (!device.__button.exists (button)) {
				
				var control = new GameInputControl (device, "BUTTON_" + button, 0, 1);
				device.__button.set (button, control);
				device.__controls.push (control);
				
			}
			
			var control = device.__button.get (button);
			control.value = 1;
			control.dispatchEvent (new Event (Event.CHANGE));
			
		}
		
	}
	
	
	private static function __onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		var device = __devices.get (gamepad);
		
		if (device.enabled) {
			
			if (!device.__button.exists (button)) {
				
				var control = new GameInputControl (device, "BUTTON_" + button, 0, 1);
				device.__button.set (button, control);
				device.__controls.push (control);
				
			}
			
			var control = device.__button.get (button);
			control.value = 0;
			control.dispatchEvent (new Event (Event.CHANGE));
			
		}
		
	}
	
	
	private static function __onGamepadConnect (gamepad:Gamepad):Void {
		
		var device = new GameInputDevice (gamepad.guid, gamepad.name);
		__devices.set (gamepad, device);
		numDevices = Lambda.count (__devices);
		
		for (instance in __instances) {
			
			instance.dispatchEvent (new GameInputEvent (GameInputEvent.DEVICE_ADDED, device));
			
		}
		
	}
	
	
	private static function __onGamepadDisconnect (gamepad:Gamepad):Void {
		
		var device = __devices.get (gamepad);
		
		if (device != null) {
			
			__devices.remove (gamepad);
			numDevices = Lambda.count (__devices);
			
			for (instance in __instances) {
				
				instance.dispatchEvent (new GameInputEvent (GameInputEvent.DEVICE_REMOVED, device));
				
			}
			
		}
		
	}
	
	
	
}


#else
typedef GameInput = flash.ui.GameInput;
#end
