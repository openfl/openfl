package openfl.display;

#if !flash
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.media.SoundTransform;
import openfl.ui.MouseCursor;
import openfl.Vector;

/**
	The SimpleButton class lets you control all instances of button symbols in
	a SWF file.

	In Flash Professional, you can give a button an instance name in the
	Property inspector. SimpleButton instance names are displayed in the Movie
	Explorer and in the Insert Target Path dialog box in the Actions panel.
	After you create an instance of a button in Flash Professional, you can use
	the methods and properties of the SimpleButton class to manipulate buttons
	with ActionScript.

	In ActionScript 3.0, you use the `new SimpleButton()`
	constructor to create a SimpleButton instance.

	The SimpleButton class inherits from the InteractiveObject class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.MovieClip)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:autoBuild(openfl.utils._internal.AssetsMacro.initBinding())
class SimpleButton extends InteractiveObject
{
	/**
		Specifies a display object that is used as the visual object for the
		button "Down" state  - the state that the button is in when the user
		selects the `hitTestState` object.
	**/
	public var downState(get, set):DisplayObject;

	/**
		A Boolean value that specifies whether a button is enabled. When a button
		is disabled(the enabled property is set to `false`), the
		button is visible but cannot be clicked. The default value is
		`true`. This property is useful if you want to disable part of
		your navigation; for example, you might want to disable a button in the
		currently displayed page so that it can't be clicked and the page cannot
		be reloaded.

		**Note:** To prevent mouseClicks on a button, set both the
		`enabled` and `mouseEnabled` properties to
		`false`.
	**/
	public var enabled:Bool;

	/**
		Specifies a display object that is used as the hit testing object for the
		button. For a basic button, set the `hitTestState` property to
		the same display object as the `overState` property. If you do
		not set the `hitTestState` property, the SimpleButton is
		inactive  -  it does not respond to user input events.
	**/
	public var hitTestState(get, set):DisplayObject;

	/**
		Specifies a display object that is used as the visual object for the
		button over state  -  the state that the button is in when the pointer is
		positioned over the button.
	**/
	public var overState(get, set):DisplayObject;

	/**
		The SoundTransform object assigned to this button. A SoundTransform object
		includes properties for setting volume, panning, left speaker assignment,
		and right speaker assignment. This SoundTransform object applies to all
		states of the button. This SoundTransform object affects only embedded
		sounds.
	**/
	public var soundTransform(get, set):SoundTransform;

	/**
		Indicates whether other display objects that are SimpleButton or MovieClip
		objects can receive user input release events. The
		`trackAsMenu` property lets you create menus. You can set the
		`trackAsMenu` property on any SimpleButton or MovieClip object.
		If the `trackAsMenu` property does not exist, the default
		behavior is `false`.

		You can change the `trackAsMenu` property at any time; the
		modified button immediately takes on the new behavior.
	**/
	public var trackAsMenu:Bool;

	/**
		Specifies a display object that is used as the visual object for the
		button up state  -  the state that the button is in when the pointer is
		not positioned over the button.
	**/
	public var upState(get, set):DisplayObject;

	/**
		A Boolean value that, when set to `true`, indicates whether the
		hand cursor is shown when the pointer rolls over a button. If this
		property is set to `false`, the arrow pointer cursor is
		displayed instead. The default is `true`.

		You can change the `useHandCursor` property at any time; the
		modified button immediately uses the new cursor behavior.
	**/
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

	/**
		Creates a new SimpleButton instance. Any or all of the display objects
		that represent the various button states can be set as parameters in the
		constructor.

		@param upState      The initial value for the SimpleButton up state.
		@param overState    The initial value for the SimpleButton over state.
		@param downState    The initial value for the SimpleButton down state.
		@param hitTestState The initial value for the SimpleButton hitTest state.
	**/
	public function new(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null)
	{
		super();

		__drawableType = SIMPLE_BUTTON;
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
typedef SimpleButton2 = flash.display.SimpleButton.SimpleButton2;
#end
