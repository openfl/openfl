package openfl.display; #if !flash #if (display || openfl_next || js)


import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;


class SimpleButton extends DisplayObjectContainer {
	
	
	public var downState (default, set):DisplayObject;
	public var enabled:Bool;
	public var hitTestState (default, set):DisplayObject;
	public var overState (default, set):DisplayObject;
	public var soundTransform (get, set):SoundTransform;
	public var trackAsMenu:Bool;
	public var upState (default, set):DisplayObject;
	public var useHandCursor:Bool;
	
	@:noCompletion private var __currentState (default, set):DisplayObject;
	@:noCompletion private var __soundTransform:SoundTransform;
	
	
	public function new (upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {
		
		super ();
		
		enabled = true;
		trackAsMenu = false;
		useHandCursor = true;
		
		this.upState = (upState != null) ? upState : __generateDefaultState();
		this.overState = (overState != null) ? overState : __generateDefaultState();
		this.downState = (downState != null) ? downState : __generateDefaultState();
		this.hitTestState = (hitTestState != null) ? hitTestState : __generateDefaultState();
		
		__currentState = this.upState;
		
	}
	
	
	@:noCompletion private function switchState (state:DisplayObject):Void {
		
		if (__currentState != null && __currentState.stage != null) {
			
			removeChild (__currentState);
			addChild (state);
			
		} else {
			
			addChild (state);
			
		}
		
	}
	
	
	@:noCompletion private function __generateDefaultState ():DisplayObject {
		
		return new DisplayObject ();
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function set_downState (downState:DisplayObject):DisplayObject {
		
		if (this.downState != null && __currentState == this.downState) __currentState = downState;
		return this.downState = downState;
		
	}
	
	
	@:noCompletion private function set_hitTestState (hitTestState:DisplayObject):DisplayObject {
		
		if (hitTestState != this.hitTestState) {
			
			// Events bubble up to this instance.
			addEventListener (MouseEvent.MOUSE_OVER, function(_) { if (overState != __currentState) __currentState = overState; });
			addEventListener (MouseEvent.MOUSE_OUT, function(_) {  if (upState != __currentState) __currentState = upState; });
			addEventListener (MouseEvent.MOUSE_DOWN, function(_) { __currentState = downState; });
			addEventListener (MouseEvent.MOUSE_UP, function(_) { __currentState = overState; });
			
			hitTestState.alpha = 0.0;
			addChild (hitTestState);
			
		}
		
		return this.hitTestState = hitTestState;
		
	}
	
	
	@:noCompletion private function set_overState (overState:DisplayObject):DisplayObject {
		
		if (this.overState != null && __currentState == this.overState) __currentState = overState;
		return this.overState = overState;
		
	}
	
	
	@:noCompletion private function get_soundTransform ():SoundTransform {
		
		if (__soundTransform == null) {
			
			__soundTransform = new SoundTransform ();
			
		}
		
		return new SoundTransform (__soundTransform.volume, __soundTransform.pan);
		
	}
	
	
	@:noCompletion private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__soundTransform = new SoundTransform (value.volume, value.pan);
		return value;
		
	}
	
	
	@:noCompletion private function set_upState (upState:DisplayObject):DisplayObject {
		
		if (this.upState != null && __currentState == this.upState) __currentState = upState;
		return this.upState = upState;
		
	}
	
	
	@:noCompletion private function set___currentState (state:DisplayObject):DisplayObject {
		
		if (__currentState == state) return state;
		switchState (state);
		
		return __currentState = state;
		
	}
	
	
}


#else
typedef SimpleButton = openfl._v2.display.SimpleButton;
#end
#else
typedef SimpleButton = flash.display.SimpleButton;
#end