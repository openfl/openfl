package openfl.display; #if !flash #if !openfl_legacy


import lime.ui.MouseCursor;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
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

@:access(openfl.geom.Matrix)


class SimpleButton extends InteractiveObject {
	
	
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
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		super.__getBounds (rect, matrix);
		
		if (matrix != null) {
			
			__updateTransforms (matrix);
			__updateChildren (true);
			
		}
		
		__currentState.__getBounds (rect, __currentState.__worldTransform);
		
		if (matrix != null) {
			
			__updateTransforms ();
			__updateChildren (true);
			
		}
		
	}
	
	
	@:noCompletion private override function __getRenderBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__scrollRect != null) {
			
			super.__getRenderBounds (rect, matrix);
			return;
			
		} else {
			
			super.__getBounds (rect, matrix);
			
		}
		
		if (matrix != null) {
			
			__updateTransforms (matrix);
			__updateChildren (true);
			
		}
		
		__currentState.__getRenderBounds (rect, __currentState.__worldTransform);
		
		if (matrix != null) {
			
			__updateTransforms ();
			__updateChildren (true);
			
		}
		
	}
	
	
	@:noCompletion private override function __getCursor ():MouseCursor {
		
		return useHandCursor ? POINTER : null;
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:InteractiveObject):Bool {
		
		var hitTest = false;
		
		if (hitTestState != null) {
			
			var cacheTransform = __updateTransform (hitTestState);
			
			if (hitTestState.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
				
				stack[stack.length - 1] = hitObject;
				hitTest = true;
				
			}
			
			__resetTransform (hitTestState, cacheTransform);
			
		} else if (__currentState != null) {
			
			if (!hitObject.visible || __isMask || (interactiveOnly && !hitObject.mouseEnabled)) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;
			
			var cacheTransform = __updateTransform (__currentState);
			
			if (__currentState.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
				
				hitTest = interactiveOnly;
				
			}
			
			__resetTransform (__currentState, cacheTransform);
			
		}
		
		return hitTest;
		
	}
	
	
	@:noCompletion private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var hitTest = false;
		
		var cacheTransform = __updateTransform (__currentState);
		
		if (__currentState.__hitTestMask (x, y)) {
			
			hitTest = true;
			
		}
		
		__resetTransform (__currentState, cacheTransform);
		
		return hitTest;
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect (scrollRect, __worldTransform);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.pushMask (__mask);
			
		}
		
		__currentState.__renderCairo (renderSession);
		
		if (__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderCairoMask (renderSession:RenderSession):Void {
		
		__currentState.__renderCairoMask (renderSession);
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		#if !neko
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect (scrollRect, __worldTransform);
			
		}
		
		if (__mask != null) {
			
			renderSession.maskManager.pushMask (__mask);
			
		}
		
		__currentState.__renderCanvas (renderSession);
		
		if (__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
		#end
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderCanvasMask (renderSession:RenderSession):Void {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		renderSession.context.rect (0, 0, bounds.width, bounds.height);
		
		__currentState.__renderCanvasMask (renderSession);
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderDOM (renderSession:RenderSession):Void {
		
		#if !neko
		
		//if (!__renderable) return;
		
		if (__mask != null) {
			
			renderSession.maskManager.pushMask (__mask);
			
		}
		
		// TODO: scrollRect
		
		__currentState.__renderDOM (renderSession);
		
		//for (orphan in __removedChildren) {
			//
			//if (orphan.stage == null) {
				//
				//orphan.__renderDOM (renderSession);
				//
			//}
			//
		//}
		
		if (__mask != null) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		#end
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__cacheAsBitmap) {
			__cacheGL(renderSession);
			return;
		}
		
		__preRenderGL (renderSession);
		__drawGraphicsGL (renderSession);
		
		__currentState.__renderGL (renderSession);
		
		__postRenderGL (renderSession);
		
	}
	
	
	@:noCompletion private function __resetTransform (state:DisplayObject, cacheTransform:Matrix):Void {
		
		state.__updateTransforms (cacheTransform);
		state.__updateChildren (false);
		
	}
	
	
	@:noCompletion private function __updateTransform (state:DisplayObject):Matrix {
		
		var cacheTransform = state.__worldTransform;
		
		var local = state.__transform;
		var parentTransform = __worldTransform;
		var overrideTransform = Matrix.__temp;
		
		overrideTransform.a = local.a * parentTransform.a + local.b * parentTransform.c;
		overrideTransform.b = local.a * parentTransform.b + local.b * parentTransform.d;
		overrideTransform.c = local.c * parentTransform.a + local.d * parentTransform.c;
		overrideTransform.d = local.c * parentTransform.b + local.d * parentTransform.d;
		overrideTransform.tx = local.tx * parentTransform.a + local.ty * parentTransform.c + parentTransform.tx;
		overrideTransform.ty = local.tx * parentTransform.b + local.ty * parentTransform.d + parentTransform.ty;
		
		state.__updateTransforms (overrideTransform);
		state.__updateChildren (true);
		
		return cacheTransform;
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		super.__updateTransforms (overrideTransform);
		
		__updateTransform (__currentState);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function set_downState (downState:DisplayObject):DisplayObject {
		
		if (this.downState != null && __currentState == this.downState) {
			
			__currentState = downState;
			
		}
		
		return this.downState = downState;
		
	}
	
	
	@:noCompletion private function set_hitTestState (hitTestState:DisplayObject):DisplayObject {
		
		return this.hitTestState = hitTestState;
		
	}
	
	
	@:noCompletion private function set_overState (overState:DisplayObject):DisplayObject {
		
		if (this.overState != null && __currentState == this.overState) {
			
			__currentState = overState;
			
		}
		
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
		
		if (this.upState != null && __currentState == this.upState) {
			
			__currentState = upState;
			
		}
		
		return this.upState = upState;
		
	}
	
	
	@:noCompletion private function set___currentState (value:DisplayObject):DisplayObject {
		
		if (value.parent != null) {
			
			value.parent.removeChild (value);
			
		}
		
		return __currentState = value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function __this_onMouseDown (event:MouseEvent):Void {
		
		if (downState != null) {
			
			__currentState = downState;
			
		}
		
	}
	
	
	@:noCompletion private function __this_onMouseOut (event:MouseEvent):Void {
		
		if (upState != __currentState) {
			
			__currentState = upState;
			
		}
		
	}
	
	
	@:noCompletion private function __this_onMouseOver (event:MouseEvent):Void {
		
		if (overState != __currentState && overState != null) {
			
			__currentState = overState;
			
		}
		
	}
	
	
	@:noCompletion private function __this_onMouseUp (event:MouseEvent):Void {
	
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
#else
typedef SimpleButton = flash.display.SimpleButton;
#end