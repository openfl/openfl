package openfl.display; #if !flash #if !lime_legacy


import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;


/**
 * The SimpleButton class lets you control all instances of button symbols in
 * a SWF file.
 *
 * <p>In Flash Professional, you can give a button an instance name in the
 * Property inspector. SimpleButton instance names are displayed in the Movie
 * Explorer and in the Insert Target Path dialog box in the Actions panel.
 * After you create an instance of a button in Flash Professional, you can use
 * the methods and properties of the SimpleButton class to manipulate buttons
 * with ActionScript.</p>
 *
 * <p>In ActionScript 3.0, you use the <code>new SimpleButton()</code>
 * constructor to create a SimpleButton instance.</p>
 *
 * <p>The SimpleButton class inherits from the InteractiveObject class.</p>
 */
class SimpleButton extends DisplayObjectContainer {
	
	
	/**
	 * Specifies a display object that is used as the visual object for the
	 * button "Down" state  - the state that the button is in when the user
	 * selects the <code>hitTestState</code> object.
	 */
	public var downState (default, set):DisplayObject;
	
	/**
	 * A Boolean value that specifies whether a button is enabled. When a button
	 * is disabled(the enabled property is set to <code>false</code>), the
	 * button is visible but cannot be clicked. The default value is
	 * <code>true</code>. This property is useful if you want to disable part of
	 * your navigation; for example, you might want to disable a button in the
	 * currently displayed page so that it can't be clicked and the page cannot
	 * be reloaded.
	 *
	 * <p><b>Note:</b> To prevent mouseClicks on a button, set both the
	 * <code>enabled</code> and <code>mouseEnabled</code> properties to
	 * <code>false</code>.</p>
	 */
	public var enabled:Bool;
	
	/**
	 * Specifies a display object that is used as the hit testing object for the
	 * button. For a basic button, set the <code>hitTestState</code> property to
	 * the same display object as the <code>overState</code> property. If you do
	 * not set the <code>hitTestState</code> property, the SimpleButton is
	 * inactive  -  it does not respond to user input events.
	 */
	public var hitTestState (default, set):DisplayObject;
	
	/**
	 * Specifies a display object that is used as the visual object for the
	 * button over state  -  the state that the button is in when the pointer is
	 * positioned over the button.
	 */
	public var overState (default, set):DisplayObject;
	
	/**
	 * The SoundTransform object assigned to this button. A SoundTransform object
	 * includes properties for setting volume, panning, left speaker assignment,
	 * and right speaker assignment. This SoundTransform object applies to all
	 * states of the button. This SoundTransform object affects only embedded
	 * sounds.
	 */
	public var soundTransform (get, set):SoundTransform;
	
	/**
	 * Indicates whether other display objects that are SimpleButton or MovieClip
	 * objects can receive user input release events. The
	 * <code>trackAsMenu</code> property lets you create menus. You can set the
	 * <code>trackAsMenu</code> property on any SimpleButton or MovieClip object.
	 * If the <code>trackAsMenu</code> property does not exist, the default
	 * behavior is <code>false</code>.
	 *
	 * <p>You can change the <code>trackAsMenu</code> property at any time; the
	 * modified button immediately takes on the new behavior. </p>
	 */
	public var trackAsMenu:Bool;
	
	/**
	 * Specifies a display object that is used as the visual object for the
	 * button up state  -  the state that the button is in when the pointer is
	 * not positioned over the button.
	 */
	public var upState (default, set):DisplayObject;
	
	/**
	 * A Boolean value that, when set to <code>true</code>, indicates whether the
	 * hand cursor is shown when the pointer rolls over a button. If this
	 * property is set to <code>false</code>, the arrow pointer cursor is
	 * displayed instead. The default is <code>true</code>.
	 *
	 * <p>You can change the <code>useHandCursor</code> property at any time; the
	 * modified button immediately uses the new cursor behavior. </p>
	 */
	public var useHandCursor:Bool;
	
	@:noCompletion private var __currentState (default, set):DisplayObject;
	@:noCompletion private var __soundTransform:SoundTransform;
	
	
	/**
	 * Creates a new SimpleButton instance. Any or all of the display objects
	 * that represent the various button states can be set as parameters in the
	 * constructor.
	 * 
	 * @param upState      The initial value for the SimpleButton up state.
	 * @param overState    The initial value for the SimpleButton over state.
	 * @param downState    The initial value for the SimpleButton down state.
	 * @param hitTestState The initial value for the SimpleButton hitTest state.
	 */
	public function new (upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {
		
		super ();
		
		enabled = true;
		trackAsMenu = false;
		useHandCursor = true;
		
		// TODO: Inherit from InteractiveObject, not DisplayObjectContainer
		mouseChildren = false;
		
		this.upState = (upState != null) ? upState : __generateDefaultState ();
		this.overState = (overState != null) ? overState : __generateDefaultState ();
		this.downState = (downState != null) ? downState : __generateDefaultState ();
		this.hitTestState = (hitTestState != null) ? hitTestState : __generateDefaultState ();
		
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