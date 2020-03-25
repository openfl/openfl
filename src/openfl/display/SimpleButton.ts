import Matrix from "openfl/geom/Matrix";
import Rectangle from "openfl/geom/Rectangle";
import MouseEvent from "openfl/events/MouseEvent";
import SoundTransform from "openfl/media/SoundTransform";
import MouseCursor from "openfl/ui/MouseCursor";
import Vector from "openfl/Vector";

namespace openfl.display
{
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
	export class SimpleButton extends InteractiveObject
	{
		/**
			Specifies a display object that is used as the visual object for the
			button "Down" state  - the state that the button is in when the user
			selects the `hitTestState` object.
		**/
		public downState(get, set): DisplayObject;

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
		public enabled: boolean;

		/**
			Specifies a display object that is used as the hit testing object for the
			button. For a basic button, set the `hitTestState` property to
			the same display object as the `overState` property. If you do
			not set the `hitTestState` property, the SimpleButton is
			inactive  -  it does not respond to user input events.
		**/
		public hitTestState(get, set): DisplayObject;

		/**
			Specifies a display object that is used as the visual object for the
			button over state  -  the state that the button is in when the pointer is
			positioned over the button.
		**/
		public overState(get, set): DisplayObject;

		/**
			The SoundTransform object assigned to this button. A SoundTransform object
			includes properties for setting volume, panning, left speaker assignment,
			and right speaker assignment. This SoundTransform object applies to all
			states of the button. This SoundTransform object affects only embedded
			sounds.
		**/
		public soundTransform(get, set): SoundTransform;

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
		public trackAsMenu: boolean;

		/**
			Specifies a display object that is used as the visual object for the
			button up state  -  the state that the button is in when the pointer is
			not positioned over the button.
		**/
		public upState(get, set): DisplayObject;

		/**
			A Boolean value that, when set to `true`, indicates whether the
			hand cursor is shown when the pointer rolls over a button. If this
			property is set to `false`, the arrow pointer cursor is
			displayed instead. The default is `true`.

			You can change the `useHandCursor` property at any time; the
			modified button immediately uses the new cursor behavior.
		**/
		public useHandCursor: boolean;

		protected static __constructor: SimpleButton-> Void;

	protected __currentState(default, set): DisplayObject;
	protected __downState: DisplayObject;
	protected __hitTestState: DisplayObject;
	protected __ignoreEvent: boolean;
	protected __overState: DisplayObject;
	protected __previousStates: Vector<DisplayObject>;
	protected __soundTransform: SoundTransform;
	protected __upState: DisplayObject;

/**
	Creates a new SimpleButton instance. Any or all of the display objects
	that represent the various button states can be set as parameters in the
	constructor.

	@param upState      The initial value for the SimpleButton up state.
	@param overState    The initial value for the SimpleButton over state.
	@param downState    The initial value for the SimpleButton down state.
	@param hitTestState The initial value for the SimpleButton hitTest state.
**/
public constructor(upState: DisplayObject = null, overState: DisplayObject = null, downState: DisplayObject = null, hitTestState: DisplayObject = null)
	{
		super();

		__type = SIMPLE_BUTTON;

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

	protected__getBounds(rect: Rectangle, matrix: Matrix): void
		{
			super.__getBounds(rect, matrix);

			var childWorldTransform = Matrix.__pool.get();

			DisplayObject.__calculateAbsoluteTransform(__currentState.__transform, matrix, childWorldTransform);

			__currentState.__getBounds(rect, childWorldTransform);

			Matrix.__pool.release(childWorldTransform);
		}

	protected__getRenderBounds(rect: Rectangle, matrix: Matrix): void
		{
			if(__scrollRect != null)
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

protected__getCursor(): MouseCursor
{
	return (useHandCursor && !__ignoreEvent && enabled) ? BUTTON : null;
}

protected__hitTest(x : number, y : number, shapeFlag : boolean, stack: Array < DisplayObject >, interactiveOnly : boolean,
	hitObject: DisplayObject) : boolean
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

protected__hitTestMask(x : number, y : number) : boolean
{
	var hitTest = false;

	if (__currentState.__hitTestMask(x, y))
	{
		hitTest = true;
	}

	return hitTest;
}

protected__setTransformDirty(force : boolean = false): void
	{
		// inline super.__setTransformDirty(force);
		__transformDirty = true;

		if(__currentState != null)
{
	__currentState.__setTransformDirty(force);
}

if (hitTestState != null && hitTestState != __currentState)
{
	hitTestState.__setTransformDirty(force);
}
}

protected__update(transformOnly : boolean, updateChildren : boolean): void
	{
		__updateSingle(transformOnly, updateChildren);

	if(updateChildren)
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

	// Getters & Setters
	protected get_downState(): DisplayObject
{
	return __downState;
}

	protected set_downState(downState: DisplayObject): DisplayObject
{
	if (__downState != null && __currentState == __downState)
	{
		__currentState = __downState;
	}

	return __downState = downState;
}

	protected get_hitTestState(): DisplayObject
{
	return __hitTestState;
}

	protected set_hitTestState(hitTestState: DisplayObject): DisplayObject
{
	if (__hitTestState != null && __hitTestState != hitTestState)
	{
		if (__hitTestState != downState && __hitTestState != upState && __hitTestState != overState)
		{
			__hitTestState.__renderParent = null;
			__hitTestState.__setTransformDirty();
		}
	}

	if (hitTestState != null)
	{
		hitTestState.__renderParent = this;
		hitTestState.__setTransformDirty();
		hitTestState.__setRenderDirty();
	}

	return __hitTestState = hitTestState;
}

	protected get_overState(): DisplayObject
{
	return __overState;
}

	protected set_overState(overState: DisplayObject): DisplayObject
{
	if (__overState != null && __currentState == __overState)
	{
		__currentState = overState;
	}

	return __overState = overState;
}

	protected get_soundTransform(): SoundTransform
{
	if (__soundTransform == null)
	{
		__soundTransform = new SoundTransform();
	}

	return new SoundTransform(__soundTransform.volume, __soundTransform.pan);
}

	protected set_soundTransform(value: SoundTransform): SoundTransform
{
	__soundTransform = new SoundTransform(value.volume, value.pan);
	return value;
}

	protected get_upState(): DisplayObject
{
	return __upState;
}

	protected set_upState(upState: DisplayObject): DisplayObject
{
	if (__upState != null && __currentState == __upState)
	{
		__currentState = upState;
	}

	return __upState = upState;
}

	protected set___currentState(value: DisplayObject): DisplayObject
{
	if (__currentState != null && __currentState != hitTestState)
	{
		__currentState.__renderParent = null;
		__currentState.__setTransformDirty();
	}

	if (value != null && value.parent != null)
	{
		value.parent.removeChild(value);
	}

		// #if (openfl_html5 && dom)
		#if openfl_html5
	if (DisplayObject.__supportDOM && __previousStates == null)
	{
		__previousStates = new Vector<DisplayObject>();
	}
		#end

	if (value != __currentState)
	{
			// #if (openfl_html5 && dom)
			#if openfl_html5
		if (DisplayObject.__supportDOM)
		{
			if (__currentState != null)
			{
				__currentState.__setStageReferences(null);
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
			value.__setTransformDirty();
			value.__setRenderDirty();
		}

		__localBoundsDirty = true;
		__setRenderDirty();
	}

	__currentState = value;

	return value;
}

	// Event Handlers
	protected __this_onMouseDown(event: MouseEvent): void
	{
		if(enabled)
		{
			__currentState = downState;
		}
	}

	protected __this_onMouseOut(event: MouseEvent): void
	{
		__ignoreEvent = false;

		if(upState != __currentState)
{
	__currentState = upState;
}
}

	protected __this_onMouseOver(event: MouseEvent): void
	{
		if(event.buttonDown)
	{
	__ignoreEvent = true;
}

if (overState != __currentState && overState != null && !__ignoreEvent && enabled)
{
	__currentState = overState;
}
}

	protected __this_onMouseUp(event: MouseEvent): void
	{
		__ignoreEvent = false;

		if(enabled && overState != null)
{
	__currentState = overState;
}
	else
{
	__currentState = upState;
}
}
}
}

export default openfl.display.SimpleButton;
