package openfl.display;


import lime.ui.MouseCursor;
import openfl._internal.renderer.RenderSession;
import openfl._internal.swf.SWFLite;
import openfl._internal.symbols.ButtonSymbol;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.symbols.SWFSymbol)
@:access(openfl.display.MovieClip)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class SimpleButton extends InteractiveObject {
	
	
	private static var __initSWF:SWFLite;
	private static var __initSymbol:ButtonSymbol;
	
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
	private var __previousStates:Vector<DisplayObject>;
	private var __soundTransform:SoundTransform;
	private var __symbol:ButtonSymbol;
	
	
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
		
		if (__initSymbol != null) {
			
			var swf = __initSWF;
			__symbol = __initSymbol;
			
			__initSWF = null;
			__initSymbol = null;
			
			__fromSymbol (swf, __symbol);
			
		}
		
	}
	
	
	private function __fromSymbol (swf:SWFLite, symbol:ButtonSymbol):Void {
		
		__symbol = symbol;
		
		if (symbol.downState != null) {
			
			downState = symbol.downState.__createObject (swf);
			
		}
		
		if (symbol.hitState != null) {
			
			hitTestState = symbol.hitState.__createObject (swf);
			
		}
		
		if (symbol.overState != null) {
			
			overState = symbol.overState.__createObject (swf);
			
		}
		
		if (symbol.upState != null) {
			
			upState = symbol.upState.__createObject (swf);
			
		}
		
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
			
			if (hitTestState.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
				
				if (stack != null) {
					
					if (stack.length == 0) {
						
						stack[0] = hitObject;
						
					} else {
						
						stack[stack.length - 1] = hitObject;
						
					}
					
				}
				
				hitTest = true;
				
			}
			
		} else if (__currentState != null) {
			
			if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;
			
			if (__currentState.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
				
				hitTest = interactiveOnly;
				
			}
			
		}
		
		// TODO: Better fix?
		// (this is caused by the "hitObject" logic in hit testing)
		
		if (stack != null) {
			
			while (stack.length > 1 && stack[stack.length - 1] == stack[stack.length - 2]) {
				
				stack.pop ();
				
			}
			
		}
		
		return hitTest;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var hitTest = false;
		
		if (__currentState.__hitTestMask (x, y)) {
			
			hitTest = true;
			
		}
		
		return hitTest;
		
	}
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0 || __currentState == null) return;
		
		renderSession.maskManager.pushObject (this);
		__currentState.__renderCairo (renderSession);
		renderSession.maskManager.popObject (this);
		
	}
	
	
	private override function __renderCairoMask (renderSession:RenderSession):Void {
		
		__currentState.__renderCairoMask (renderSession);
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0 || __currentState == null) return;
		
		#if !neko
		
		renderSession.maskManager.pushObject (this);
		__currentState.__renderCanvas (renderSession);
		renderSession.maskManager.popObject (this);
		
		#end
		
	}
	
	
	private override function __renderCanvasMask (renderSession:RenderSession):Void {
		
		var bounds = Rectangle.__pool.get ();
		__getLocalBounds (bounds);
		
		renderSession.context.rect (0, 0, bounds.width, bounds.height);
		
		Rectangle.__pool.release (bounds);
		__currentState.__renderCanvasMask (renderSession);
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		#if !neko
		
		renderSession.maskManager.pushObject (this);
		
		for (previousState in __previousStates) {
			
			previousState.__renderDOM (renderSession);
			
		}
		
		__previousStates.length = 0;
		
		if (__currentState != null) {
			
			__currentState.__renderDOM (renderSession);
			
		}
		
		renderSession.maskManager.popObject (this);
		
		#end
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0 || __currentState == null) return;
		
		renderSession.maskManager.pushObject (this);
		__currentState.__renderGL (renderSession);
		renderSession.maskManager.popObject (this);
		
	}
	
	
	private override function __setStageReference (stage:Stage):Void {
		
		super.__setStageReference (stage);
		
		if (__currentState != null) {
			
			__currentState.__setStageReference (stage);
			
		}
		
		if (hitTestState != null && hitTestState != __currentState) {
			
			hitTestState.__setStageReference (stage);
			
		}
		
	}
	
	
	private override function __setTransformDirty ():Void {
		
		super.__setTransformDirty ();
		
		if (__currentState != null) {
			
			__currentState.__setTransformDirty ();
			
		}
		
		if (hitTestState != null && hitTestState != __currentState) {
			
			hitTestState.__setTransformDirty ();
			
		}
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool, ?maskGraphics:Graphics = null):Void {
		
		super.__update (transformOnly, updateChildren, maskGraphics);
		
		if (updateChildren) {
			
			if (__currentState != null) {
				
				__currentState.__update (transformOnly, true, maskGraphics);
				
			}
			
			if (hitTestState != null && hitTestState != __currentState) {
				
				hitTestState.__update (transformOnly, true, maskGraphics);
				
			}
			
		}
		
	}
	
	
	public override function __updateChildren (transformOnly:Bool):Void {
		
		super.__updateChildren (transformOnly);
		
		if (__currentState != null) {
			
			__currentState.__updateChildren (transformOnly);
			
		}
		
		if (hitTestState != null && hitTestState != __currentState) {
			
			hitTestState.__updateChildren (transformOnly);
			
		}
		
	}
	
	
	public override function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		super.__updateTransforms (overrideTransform);
		
		if (__currentState != null) {
			
			__currentState.__updateTransforms ();
			
		}
		
		if (hitTestState != null && hitTestState != __currentState) {
			
			hitTestState.__updateTransforms ();
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_downState (downState:DisplayObject):DisplayObject {
		
		if (this.downState != null && __currentState == this.downState) {
			
			__currentState = downState;
			
		}
		
		return this.downState = downState;
		
	}
	
	
	private function set_hitTestState (hitTestState:DisplayObject):DisplayObject {
		
		if (this.hitTestState != null && this.hitTestState != hitTestState) {
			
			if (this.hitTestState != downState && this.hitTestState != upState && this.hitTestState != overState) {
				
				this.hitTestState.__renderParent = null;
				
			}
			
		}
		
		if (hitTestState != null) {
			
			hitTestState.__renderParent = this;
			hitTestState.__setRenderDirty ();
			
		}
		
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
		
		if (__currentState != null && __currentState != hitTestState) {
			
			__currentState.__renderParent = null;
			
		}
		
		if (value != null && value.parent != null) {
			
			value.parent.removeChild (value);
			
		}
		
		#if (js && html5 && dom)
		if (__previousStates == null) {
			
			__previousStates = new Vector<DisplayObject> ();
			
		}
		#end
		
		if (value != __currentState) {
			
			#if (js && html5 && dom)
			if (__currentState != null) {
				
				__currentState.__setStageReference (null);
				__previousStates.push (__currentState);
				
			}
			
			var index = __previousStates.indexOf (value);
			
			if (index > -1) {
				
				__previousStates.splice (index, 1);
				
			}
			#end
			
			if (value != null) {
				
				value.__renderParent = this;
				value.__setRenderDirty ();
				
			}
			
			__setRenderDirty ();
			
		}
		
		__currentState = value;
		
		return value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function __this_onMouseDown (event:MouseEvent):Void {
		
		__currentState = downState;
		
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