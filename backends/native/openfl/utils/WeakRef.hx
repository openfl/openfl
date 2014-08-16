package openfl.utils;


import openfl.Lib;


class WeakRef<T> {
	
	
	private var hardRef:T;
	private var weakRef:Int;
	
	
	public function new (object:T, makeWeak:Bool = true) {
		
		if (makeWeak) {
			
			weakRef = lime_weak_ref_create (this, object);
			hardRef = null;
			
		} else {
			
			weakRef = -1;
			hardRef = object;
			
		}
		
	}
	
	
	public function get ():T {
		
		if (hardRef != null) {
			
			return hardRef;
			
		}
		
		if (weakRef < 0) {
			
			return null;
			
		}
		
		var result = lime_weak_ref_get (weakRef);
		if (result == null) {
			
			weakRef = -1;
			
		}
		
		return result;
		
	}
	
	
	public function toString ():String {
		
		if (hardRef == null) {
			
			return "" + hardRef;
			
		}
		
		return "WeakRef(" + weakRef + ")";
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static function __init__ () {
		
		lime_weak_ref_create = Lib.load ("lime", "lime_weak_ref_create", 2);
		lime_weak_ref_get = Lib.load ("lime", "lime_weak_ref_get", 1);
		
	}
	
	
	private static var lime_weak_ref_create:Dynamic;
	private static var lime_weak_ref_get:Dynamic;
	
	
}
