package openfl.display; #if !openfl_legacy


import lime.ui.MouseCursor;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;
import openfl.utils.UnshrinkableArray;


class SimpleButton extends DisplayObjectContainer {


	public var downState (default, set):DisplayObject;
	public var enabled:Bool;
	public var hitTestState (default, set):DisplayObject;
	public var overState (default, set):DisplayObject;
	public var soundTransform (get, set):SoundTransform;
	public var trackAsMenu:Bool;
	public var upState (default, set):DisplayObject;
	public var useHandCursor:Bool;

	private var __currentState (default, set):DisplayObject;
	private var __ignoreEvent:Bool;
	private var __soundTransform:SoundTransform;
	private var __childRect = new Rectangle();


	public function new (upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {

		super ();

		enabled = true;
		trackAsMenu = false;
		useHandCursor = true;
		mouseChildren = false;

		this.upState = (upState != null) ? upState : new DisplayObject ();
		this.overState = overState;
		this.downState = downState;
		this.hitTestState = (hitTestState != null) ? hitTestState : new DisplayObject ();

		addEventListener (MouseEvent.MOUSE_DOWN, __this_onMouseDown);
		addEventListener (MouseEvent.MOUSE_OUT, __this_onMouseOut);
		addEventListener (MouseEvent.MOUSE_OVER, __this_onMouseOver);
		addEventListener (MouseEvent.MOUSE_UP, __this_onMouseUp);

		__currentState = this.upState;

	}

	private override function __getCursor ():MouseCursor {

		return (useHandCursor && !__ignoreEvent) ? POINTER : null;

	}

	// Getters & Setters


	private function set_downState (downState:DisplayObject):DisplayObject {

		if (downState != null) {
			addChild( downState );

			downState.visible = false;

			if (this.downState != null ) {

				removeChild(this.downState);
				if( __currentState == this.downState )
				{
					__currentState = downState;
				}

			}
		}
		else if ( this.overState != null ) {
			removeChild(this.overState);
		}

		return this.downState = downState;

	}


	private function set_hitTestState (hitTestState:DisplayObject):DisplayObject {

		if (downState != null) {
			addChild( hitTestState );

			hitTestState.visible = false;

			if (this.hitTestState != null ) {

				removeChild(this.hitTestState);
				if( __currentState == this.hitTestState )
				{
					__currentState = hitTestState;
				}

			}
		} else if ( this.downState != null ) {
			removeChild(this.overState);
		}

		return this.hitTestState = hitTestState;

	}


	private function set_overState (overState:DisplayObject):DisplayObject {

		if ( overState != null ) {
			addChild( overState );

			overState.visible = false;

			if (this.overState != null ) {

				removeChild(this.overState);
				if( __currentState == this.overState )
				{
					__currentState = overState;
				}

			}
		} else if ( this.overState != null ) {
			removeChild(this.overState);
		}

		return this.overState = overState;
	}


	private function get_soundTransform ():SoundTransform {

		if (__soundTransform == null) {

			__soundTransform = new SoundTransform ();

		}

		return new SoundTransform (__soundTransform.volume, __soundTransform.pan);

	}


	private function set_soundTransform (value:SoundTransform):SoundTransform {

		__soundTransform = new SoundTransform (value.volume, value.pan);
		return value;

	}


	private function set_upState (upState:DisplayObject):DisplayObject {

		if ( upState != null ) {
			addChild( upState );

			upState.visible = false;

			if (this.upState != null ) {

				removeChild(this.upState);
				if( __currentState == this.upState )
				{
					__currentState = upState;
				}

			}
		} else if ( this.upState != null ) {
			removeChild(this.upState);
		}

		return this.upState = upState;
	}


	private function set___currentState (value:DisplayObject):DisplayObject {

		if ( value == __currentState ) return value;

		if( __currentState != null ){
			__currentState.visible = false;
		}

		value.visible = true;
		return __currentState = value;

	}




	// Event Handlers




	private function __this_onMouseDown (event:MouseEvent):Void {

		if (downState != null) {

			__currentState = downState;

		}

	}


	private function __this_onMouseOut (event:MouseEvent):Void {

		__ignoreEvent = false;

		if (upState != __currentState) {

			__currentState = upState;

		}

	}


	private function __this_onMouseOver (event:MouseEvent):Void {

		if (event.buttonDown) {

			__ignoreEvent = true;

		}

		if (overState != __currentState && overState != null && !__ignoreEvent) {

			__currentState = overState;

		}

	}


	private function __this_onMouseUp (event:MouseEvent):Void {

		__ignoreEvent = false;

		if (overState != null) {

			__currentState = overState;

		} else {

			__currentState = upState;

		}

	}


}


#else
typedef SimpleButton = openfl._legacy.display.SimpleButton;
#end
