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
		
		if (__currentState != null && __currentState.parent == this) {
			
			removeChild (__currentState);
			
		}
		
		if (state != null) {
			
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
			
			if (this.hitTestState != null && this.hitTestState.parent == this) {
				
				removeChild (this.hitTestState);
				
			}
			
			removeEventListener (MouseEvent.MOUSE_DOWN, __this_onMouseDown);
			removeEventListener (MouseEvent.MOUSE_OUT, __this_onMouseOut);
			removeEventListener (MouseEvent.MOUSE_OVER, __this_onMouseOver);
			removeEventListener (MouseEvent.MOUSE_UP, __this_onMouseUp);
			
			if (hitTestState != null) {
				
				addEventListener (MouseEvent.MOUSE_DOWN, __this_onMouseDown);
				addEventListener (MouseEvent.MOUSE_OUT, __this_onMouseOut);
				addEventListener (MouseEvent.MOUSE_OVER, __this_onMouseOver);
				addEventListener (MouseEvent.MOUSE_UP, __this_onMouseUp);
				
				hitTestState.alpha = 0.0;
				addChild (hitTestState);
				
			}
			
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
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function __this_onMouseDown (event:MouseEvent):Void {
		
		__currentState = downState;
		
	}
	
	
	@:noCompletion private function __this_onMouseOut (event:MouseEvent):Void {
		
		if (upState != __currentState) {
			
			__currentState = upState;
			
		}
		
	}
	
	
	@:noCompletion private function __this_onMouseOver (event:MouseEvent):Void {
		
		if (overState != __currentState) {
			
			__currentState = overState;
			
		}
		
	}
	
	
	@:noCompletion private function __this_onMouseUp (event:MouseEvent):Void {
		
		__currentState = overState;
		
	}
	
	
}


#else
typedef SimpleButton = openfl._v2.display.SimpleButton;
#end
#else
typedef SimpleButton = flash.display.SimpleButton;
#end