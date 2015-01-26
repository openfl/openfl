package openfl._v2.display; #if lime_legacy


import openfl.Lib;


class InteractiveObject extends DisplayObject {
	
	
	public var doubleClickEnabled:Bool;
	public var mouseEnabled (get, set):Bool;
	public var moveForSoftKeyboard (get, set):Bool;
	public var needsSoftKeyboard (get, set):Bool;
	
	@:noCompletion private var __mouseEnabled:Bool;
	
	
	public function new (handle:Dynamic, type:String) {
		
		doubleClickEnabled = false;
		__mouseEnabled = true;
		
		super (handle, type);
		
	}
	
	
	public function __dismissSoftKeyboard ():Bool {
		
		return lime_display_object_dismiss_soft_keyboard (__handle);
		
	}
	
	
	public function requestSoftKeyboard ():Bool {
		
		return lime_display_object_request_soft_keyboard (__handle);
		
	}
	
	
	@:noCompletion override private function __asInteractiveObject ():InteractiveObject {
		
		return this;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_mouseEnabled ():Bool { return __mouseEnabled; }
	private function set_mouseEnabled (value:Bool):Bool {
		
		__mouseEnabled = value;
		lime_display_object_set_mouse_enabled (__handle, value);
		return __mouseEnabled;
		
	}
	
	
	private function set_moveForSoftKeyboard (value:Bool):Bool {
		
		lime_display_object_set_moves_for_soft_keyboard (__handle, value);
		return value;
		
	}
	
	
	private function get_moveForSoftKeyboard ():Bool {
		
		return lime_display_object_get_moves_for_soft_keyboard (__handle);
		
	}
	
	
	private function set_needsSoftKeyboard (value):Bool {
		
		lime_display_object_set_needs_soft_keyboard (__handle, value);
		return value;
		
	}
	
	
	private function get_needsSoftKeyboard ():Bool {
		
		return lime_display_object_get_needs_soft_keyboard (__handle);
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_display_object_set_mouse_enabled = Lib.load ("lime", "lime_display_object_set_mouse_enabled", 2);
	private static var lime_display_object_set_needs_soft_keyboard = Lib.load ("lime", "lime_display_object_set_needs_soft_keyboard", 2);
	private static var lime_display_object_get_needs_soft_keyboard = Lib.load ("lime", "lime_display_object_get_needs_soft_keyboard", 1);
	private static var lime_display_object_set_moves_for_soft_keyboard = Lib.load ("lime", "lime_display_object_set_moves_for_soft_keyboard", 2);
	private static var lime_display_object_get_moves_for_soft_keyboard = Lib.load ("lime", "lime_display_object_get_moves_for_soft_keyboard", 1);
	private static var lime_display_object_dismiss_soft_keyboard = Lib.load ("lime", "lime_display_object_dismiss_soft_keyboard", 1);
	private static var lime_display_object_request_soft_keyboard = Lib.load ("lime", "lime_display_object_request_soft_keyboard", 1);
	
	
}


#end