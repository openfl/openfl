package openfl.display; #if !openfl_legacy


import lime.ui.MouseCursor;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;

@:access(openfl.geom.Matrix)


class SimpleButton extends InteractiveObject {
	
	
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
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
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
	
	
	private override function __getRenderBounds (rect:Rectangle, matrix:Matrix):Void {
		
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
	
	
	private override function __getCursor ():MouseCursor {
		
		return (useHandCursor && !__ignoreEvent) ? POINTER : null;
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		var hitTest = false;
		
		if (hitTestState != null) {
			
			var cacheTransform = __updateTransform (hitTestState);
			
			if (hitTestState.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
				
				stack[stack.length - 1] = hitObject;
				hitTest = true;
				
			}
			
			__resetTransform (hitTestState, cacheTransform);
			
		} else if (__currentState != null) {
			
			if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;
			
			var cacheTransform = __updateTransform (__currentState);
			
			if (__currentState.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
				
				hitTest = interactiveOnly;
				
			}
			
			__resetTransform (__currentState, cacheTransform);
			
		}
		
		return hitTest;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var hitTest = false;
		
		var cacheTransform = __updateTransform (__currentState);
		
		if (__currentState.__hitTestMask (x, y)) {
			
			hitTest = true;
			
		}
		
		__resetTransform (__currentState, cacheTransform);
		
		return hitTest;
		
	}
	
	
	public override function __renderCairo (renderSession:RenderSession):Void {
		
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
	
	
	public override function __renderCairoMask (renderSession:RenderSession):Void {
		
		__currentState.__renderCairoMask (renderSession);
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
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
	
	
	public override function __renderCanvasMask (renderSession:RenderSession):Void {
		
		var bounds = new Rectangle ();
		__getLocalBounds (bounds);
		
		renderSession.context.rect (0, 0, bounds.width, bounds.height);
		
		__currentState.__renderCanvasMask (renderSession);
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
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
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
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
	
	
	private function __resetTransform (state:DisplayObject, cacheTransform:Matrix):Void {
		
		state.__updateTransforms (cacheTransform);
		state.__updateChildren (false);
		
	}
	
	
	private function __updateTransform (state:DisplayObject):Matrix {
		
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
	
	
	public override function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		super.__updateTransforms (overrideTransform);
		
		__updateTransform (__currentState);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_downState (downState:DisplayObject):DisplayObject {
		
		if (this.downState != null && __currentState == this.downState) {
			
			__currentState = downState;
			
		}
		
		return this.downState = downState;
		
	}
	
	
	private function set_hitTestState (hitTestState:DisplayObject):DisplayObject {
		
		return this.hitTestState = hitTestState;
		
	}
	
	
	private function set_overState (overState:DisplayObject):DisplayObject {
		
		if (this.overState != null && __currentState == this.overState) {
			
			__currentState = overState;
			
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
		
		if (this.upState != null && __currentState == this.upState) {
			
			__currentState = upState;
			
		}
		
		return this.upState = upState;
		
	}
	
	
	private function set___currentState (value:DisplayObject):DisplayObject {
		
		if (value.parent != null) {
			
			value.parent.removeChild (value);
			
		}
		
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