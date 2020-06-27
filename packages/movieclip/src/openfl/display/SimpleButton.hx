package openfl.display;

#if !flash
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;
import openfl.ui.MouseCursor;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.MovieClip)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class SimpleButton extends InteractiveObject
{
	public var downState(get, set):DisplayObject;
	public var enabled:Bool;
	public var hitTestState(get, set):DisplayObject;
	public var overState(get, set):DisplayObject;
	public var soundTransform(get, set):SoundTransform;
	public var trackAsMenu:Bool;
	public var upState(get, set):DisplayObject;
	public var useHandCursor:Bool;

	@:noCompletion private static var __constructor:SimpleButton->Void;

	@:noCompletion private var __currentState(default, set):DisplayObject;
	@:noCompletion private var __downState:DisplayObject;
	@:noCompletion private var __hitTestState:DisplayObject;
	@:noCompletion private var __ignoreEvent:Bool;
	@:noCompletion private var __overState:DisplayObject;
	@:noCompletion private var __previousStates:Vector<DisplayObject>;
	@:noCompletion private var __soundTransform:SoundTransform;
	@:noCompletion private var __upState:DisplayObject;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(SimpleButton.prototype, {
			"downState": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_downState (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_downState (v); }")
			},
			"hitTestState": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_hitTestState (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_hitTestState (v); }")
			},
			"overState": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_overState (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_overState (v); }")
			},
			"soundTransform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_soundTransform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_soundTransform (v); }")
			},
			"upState": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_upState (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_upState (v); }")
			},
		});
	}
	#end

	public function new(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null)
	{
		super();

		// __type = SIMPLE_BUTTON;

		enabled = true;
		trackAsMenu = false;
		useHandCursor = true;

		__upState = (upState != null) ? upState : new DisplayObject();
		__overState = overState;
		__downState = downState;
		this.hitTestState = (hitTestState != null) ? hitTestState : new DisplayObject();

		addEventListener(MouseEvent.MOUSE_DOWN, __this_onMouseDown);
		addEventListener(MouseEvent.MOUSE_OUT, __this_onMouseOut);
		addEventListener(MouseEvent.MOUSE_OVER, __this_onMouseOver);
		addEventListener(MouseEvent.MOUSE_UP, __this_onMouseUp);

		__tabEnabled = true;
		__currentState = __upState;

		if (__constructor != null)
		{
			var method = __constructor;
			__constructor = null;

			method(this);
		}
	}

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		super.__getBounds(rect, matrix);

		var childWorldTransform = Matrix.__pool.get();

		DisplayObject.__calculateAbsoluteTransform(__currentState.__transform, matrix, childWorldTransform);

		__currentState.__getBounds(rect, childWorldTransform);

		Matrix.__pool.release(childWorldTransform);
	}

	@:noCompletion private override function __getRenderBounds(rect:Rectangle, matrix:Matrix):Void
	{
		if (__scrollRect != null)
		{
			super.__getRenderBounds(rect, matrix);
			return;
		}
		else
		{
			super.__getBounds(rect, matrix);
		}

		var childWorldTransform = Matrix.__pool.get();

		DisplayObject.__calculateAbsoluteTransform(__currentState.__transform, matrix, childWorldTransform);

		__currentState.__getRenderBounds(rect, childWorldTransform);

		Matrix.__pool.release(childWorldTransform);
	}

	@:noCompletion private override function __getCursor():MouseCursor
	{
		return (useHandCursor && !__ignoreEvent && enabled) ? BUTTON : null;
	}

	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
	{
		var hitTest = false;

		if (hitTestState != null)
		{
			if (hitTestState.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject))
			{
				if (stack != null)
				{
					if (stack.length == 0)
					{
						stack[0] = hitObject;
					}
					else
					{
						stack[stack.length - 1] = hitObject;
					}
				}

				hitTest = (!interactiveOnly || mouseEnabled);
			}
		}
		else if (__currentState != null)
		{
			if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled) || (mask != null && !mask.__hitTestMask(x, y)))
			{
				hitTest = false;
			}
			else if (__currentState.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject))
			{
				hitTest = interactiveOnly;
			}
		}

		// TODO: Better fix?
		// (this is caused by the "hitObject" logic in hit testing)

		if (stack != null)
		{
			while (stack.length > 1 && stack[stack.length - 1] == stack[stack.length - 2])
			{
				stack.pop();
			}
		}

		return hitTest;
	}

	@:noCompletion private override function __hitTestMask(x:Float, y:Float):Bool
	{
		var hitTest = false;

		if (__currentState.__hitTestMask(x, y))
		{
			hitTest = true;
		}

		return hitTest;
	}

	@:noCompletion private override function __renderCairo(renderer:CairoRenderer):Void
	{
		if (!__renderable || __worldAlpha <= 0 || __currentState == null) return;

		renderer.__pushMaskObject(this);
		__currentState.__renderCairo(renderer);
		renderer.__popMaskObject(this);

		__renderEvent(renderer);
	}

	@:noCompletion private override function __renderCairoMask(renderer:CairoRenderer):Void
	{
		__currentState.__renderCairoMask(renderer);
	}

	@:noCompletion private override function __renderCanvas(renderer:CanvasRenderer):Void
	{
		if (!__renderable || __worldAlpha <= 0 || __currentState == null) return;

		#if !neko
		renderer.__pushMaskObject(this);
		__currentState.__renderCanvas(renderer);
		renderer.__popMaskObject(this);

		__renderEvent(renderer);
		#end
	}

	@:noCompletion private override function __renderCanvasMask(renderer:CanvasRenderer):Void
	{
		// var bounds = Rectangle.__pool.get ();
		// __getLocalBounds (bounds);

		// renderer.context.rect (bounds.x, bounds.y, bounds.width, bounds.height);

		// Rectangle.__pool.release (bounds);
		__currentState.__renderCanvasMask(renderer);
	}

	@:noCompletion private override function __renderDOM(renderer:DOMRenderer):Void
	{
		#if !neko
		renderer.__pushMaskObject(this);

		for (previousState in __previousStates)
		{
			previousState.__renderDOM(renderer);
		}

		__previousStates.length = 0;

		if (__currentState != null)
		{
			if (__currentState.stage != stage)
			{
				__currentState.__setStageReference(stage);
			}

			__currentState.__renderDOM(renderer);
		}

		renderer.__popMaskObject(this);

		__renderEvent(renderer);
		#end
	}

	@:noCompletion private override function __renderGL(renderer:OpenGLRenderer):Void
	{
		if (!__renderable || __worldAlpha <= 0 || __currentState == null) return;

		renderer.__pushMaskObject(this);
		__currentState.__renderGL(renderer);
		renderer.__popMaskObject(this);

		__renderEvent(renderer);
	}

	@:noCompletion private override function __renderGLMask(renderer:OpenGLRenderer):Void
	{
		if (__currentState == null) return;

		__currentState.__renderGLMask(renderer);
	}

	@:noCompletion private override function __setStageReference(stage:Stage):Void
	{
		super.__setStageReference(stage);

		if (__currentState != null)
		{
			__currentState.__setStageReference(stage);
		}

		if (hitTestState != null && hitTestState != __currentState)
		{
			hitTestState.__setStageReference(stage);
		}
	}

	@:noCompletion private override function __setTransformDirty():Void
	{
		super.__setTransformDirty();

		if (__currentState != null)
		{
			__currentState.__setTransformDirty();
		}

		if (hitTestState != null && hitTestState != __currentState)
		{
			hitTestState.__setTransformDirty();
		}
	}

	@:noCompletion private override function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		super.__update(transformOnly, updateChildren);

		if (updateChildren)
		{
			if (__currentState != null)
			{
				__currentState.__update(transformOnly, true);
			}

			if (hitTestState != null && hitTestState != __currentState)
			{
				hitTestState.__update(transformOnly, true);
			}
		}
	}

	@:noCompletion private override function __updateTransforms(overrideTransform:Matrix = null):Void
	{
		super.__updateTransforms(overrideTransform);

		if (__currentState != null)
		{
			__currentState.__updateTransforms();
		}

		if (hitTestState != null && hitTestState != __currentState)
		{
			hitTestState.__updateTransforms();
		}
	}

	// Getters & Setters
	@:noCompletion private function get_downState():DisplayObject
	{
		return __downState;
	}

	@:noCompletion private function set_downState(downState:DisplayObject):DisplayObject
	{
		if (__downState != null && __currentState == __downState)
		{
			__currentState = __downState;
		}

		return __downState = downState;
	}

	@:noCompletion private function get_hitTestState():DisplayObject
	{
		return __hitTestState;
	}

	@:noCompletion private function set_hitTestState(hitTestState:DisplayObject):DisplayObject
	{
		if (__hitTestState != null && __hitTestState != hitTestState)
		{
			if (__hitTestState != downState && __hitTestState != upState && __hitTestState != overState)
			{
				__hitTestState.__renderParent = null;
			}
		}

		if (hitTestState != null)
		{
			hitTestState.__renderParent = this;
			hitTestState.__setRenderDirty();
		}

		return __hitTestState = hitTestState;
	}

	@:noCompletion private function get_overState():DisplayObject
	{
		return __overState;
	}

	@:noCompletion private function set_overState(overState:DisplayObject):DisplayObject
	{
		if (__overState != null && __currentState == __overState)
		{
			__currentState = overState;
		}

		return __overState = overState;
	}

	@:noCompletion private function get_soundTransform():SoundTransform
	{
		if (__soundTransform == null)
		{
			__soundTransform = new SoundTransform();
		}

		return new SoundTransform(__soundTransform.volume, __soundTransform.pan);
	}

	@:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		__soundTransform = new SoundTransform(value.volume, value.pan);
		return value;
	}

	@:noCompletion private function get_upState():DisplayObject
	{
		return __upState;
	}

	@:noCompletion private function set_upState(upState:DisplayObject):DisplayObject
	{
		if (__upState != null && __currentState == __upState)
		{
			__currentState = upState;
		}

		return __upState = upState;
	}

	@:noCompletion private function set___currentState(value:DisplayObject):DisplayObject
	{
		if (__currentState != null && __currentState != hitTestState)
		{
			__currentState.__renderParent = null;
		}

		if (value != null && value.parent != null)
		{
			value.parent.removeChild(value);
		}

		// #if (js && html5 && dom)
		#if (js && html5)
		if (DisplayObject.__supportDOM && __previousStates == null)
		{
			__previousStates = new Vector<DisplayObject>();
		}
		#end

		if (value != __currentState)
		{
			// #if (js && html5 && dom)
			#if (js && html5)
			if (DisplayObject.__supportDOM)
			{
				if (__currentState != null)
				{
					__currentState.__setStageReference(null);
					__previousStates.push(__currentState);
				}

				var index = __previousStates.indexOf(value);

				if (index > -1)
				{
					__previousStates.splice(index, 1);
				}
			}
			#end

			if (value != null)
			{
				value.__renderParent = this;
				value.__setRenderDirty();
			}

			__setRenderDirty();
		}

		__currentState = value;

		return value;
	}

	// Event Handlers
	@:noCompletion private function __this_onMouseDown(event:MouseEvent):Void
	{
		if (enabled)
		{
			__currentState = downState;
		}
	}

	@:noCompletion private function __this_onMouseOut(event:MouseEvent):Void
	{
		__ignoreEvent = false;

		if (upState != __currentState)
		{
			__currentState = upState;
		}
	}

	@:noCompletion private function __this_onMouseOver(event:MouseEvent):Void
	{
		if (event.buttonDown)
		{
			__ignoreEvent = true;
		}

		if (overState != __currentState && overState != null && !__ignoreEvent && enabled)
		{
			__currentState = overState;
		}
	}

	@:noCompletion private function __this_onMouseUp(event:MouseEvent):Void
	{
		__ignoreEvent = false;

		if (enabled && overState != null)
		{
			__currentState = overState;
		}
		else
		{
			__currentState = upState;
		}
	}
}
#else
typedef SimpleButton = flash.display.SimpleButton;
#end
