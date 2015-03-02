package openfl._v2.display; #if lime_legacy


import openfl.media.SoundTransform;
import openfl.Lib;


class SimpleButton extends InteractiveObject {
	
	
	public var downState (default, set):DisplayObject;
	public var enabled (get, set):Bool;
	public var hitTestState (default, set):DisplayObject;
	public var overState (default, set):DisplayObject;
	public var soundTransform (get, set):SoundTransform;
	public var trackAsMenu:Bool;
	public var upState (default, set):DisplayObject;
	public var useHandCursor (get, set):Bool;
	
	private var __soundTransform:SoundTransform;
	
	
	public function new (upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {
		
		super (lime_simple_button_create (), "SimpleButton");
		
		this.upState = upState;
		this.overState = overState;
		this.downState = downState;
		this.hitTestState = hitTestState;
		trackAsMenu = false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_downState (value:DisplayObject):DisplayObject {
		
		downState = value;
		lime_simple_button_set_state (__handle, 1, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	private function get_enabled ():Bool { return lime_simple_button_get_enabled (__handle); }
	private function set_enabled (value):Bool {
		
		lime_simple_button_set_enabled (__handle, value);
		return value;
		
	}
	
	
	private function get_useHandCursor ():Bool { return lime_simple_button_get_hand_cursor (__handle); }
	private function set_useHandCursor (value):Bool {
		
		lime_simple_button_set_hand_cursor (__handle, value);
		return value;
		
	}
	
	
	private function set_hitTestState (value:DisplayObject):DisplayObject {
		
		hitTestState = value;
		lime_simple_button_set_state (__handle, 3, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	public function set_overState (value:DisplayObject):DisplayObject {
		
		overState = value;
		lime_simple_button_set_state (__handle, 2, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	private function get_soundTransform ():SoundTransform {
		
		if (__soundTransform == null) {
			
			__soundTransform = new SoundTransform ();
			
		}
		
		return __soundTransform.clone ();
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__soundTransform = value.clone ();
		return value;
		
	}
	
	
	public function set_upState (value:DisplayObject):DisplayObject {
		
		upState = value;
		lime_simple_button_set_state (__handle, 0, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_simple_button_set_state = Lib.load ("lime", "lime_simple_button_set_state", 3);
	private static var lime_simple_button_get_enabled = Lib.load ("lime", "lime_simple_button_get_enabled", 1);
	private static var lime_simple_button_set_enabled = Lib.load ("lime", "lime_simple_button_set_enabled", 2);
	private static var lime_simple_button_get_hand_cursor = Lib.load ("lime", "lime_simple_button_get_hand_cursor", 1);
	private static var lime_simple_button_set_hand_cursor = Lib.load ("lime", "lime_simple_button_set_hand_cursor", 2);
	private static var lime_simple_button_create = Lib.load ("lime", "lime_simple_button_create", 0);
	
	
}


#end