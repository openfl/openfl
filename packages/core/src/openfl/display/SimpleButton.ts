import DisplayObjectType from "../_internal/renderer/DisplayObjectType";
import * as internal from "../_internal/utils/InternalAccess";
import DisplayObject from "../display/DisplayObject";
import InteractiveObject from "../display/InteractiveObject";
import Matrix from "../geom/Matrix";
import Rectangle from "../geom/Rectangle";
import MouseEvent from "../events/MouseEvent";
import SoundTransform from "../media/SoundTransform";
import MouseCursor from "../ui/MouseCursor";
import Vector from "../Vector";

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
export default class SimpleButton extends InteractiveObject
{
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
		A Boolean value that, when set to `true`, indicates whether the
		hand cursor is shown when the pointer rolls over a button. If this
		property is set to `false`, the arrow pointer cursor is
		displayed instead. The default is `true`.

		You can change the `useHandCursor` property at any time; the
		modified button immediately uses the new cursor behavior.
	**/
	public useHandCursor: boolean;

	protected static __constructor: (scope: SimpleButton) => void;

	protected __currentState: DisplayObject;
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

		this.__type = DisplayObjectType.SIMPLE_BUTTON;

		this.enabled = true;
		this.trackAsMenu = false;
		this.useHandCursor = true;

		this.__upState = (upState != null) ? upState : new DisplayObject();
		this.__overState = overState;
		this.__downState = downState;
		this.hitTestState = (hitTestState != null) ? hitTestState : new DisplayObject();

		this.addEventListener(MouseEvent.MOUSE_DOWN, this.__this_onMouseDown);
		this.addEventListener(MouseEvent.MOUSE_OUT, this.__this_onMouseOut);
		this.addEventListener(MouseEvent.MOUSE_OVER, this.__this_onMouseOver);
		this.addEventListener(MouseEvent.MOUSE_UP, this.__this_onMouseUp);

		this.__tabEnabled = true;
		this.__setCurrentState(this.__upState);

		if (SimpleButton.__constructor != null)
		{
			var method = SimpleButton.__constructor;
			SimpleButton.__constructor = null;

			method(this);
		}
	}

	protected __getBounds(rect: Rectangle, matrix: Matrix): void
	{
		super.__getBounds(rect, matrix);

		var childWorldTransform = (<internal.Matrix><any>Matrix).__pool.get();

		DisplayObject.__calculateAbsoluteTransform((<internal.DisplayObject><any>this.__currentState).__transform, matrix, childWorldTransform);

		(<internal.DisplayObject><any>this.__currentState).__getBounds(rect, childWorldTransform);

		(<internal.Matrix><any>Matrix).__pool.release(childWorldTransform);
	}

	protected __getRenderBounds(rect: Rectangle, matrix: Matrix): void
	{
		if (this.__scrollRect != null)
		{
			super.__getRenderBounds(rect, matrix);
			return;
		}
		else
		{
			super.__getBounds(rect, matrix);
		}

		var childWorldTransform = (<internal.Matrix><any>Matrix).__pool.get();

		DisplayObject.__calculateAbsoluteTransform((<internal.DisplayObject><any>this.__currentState).__transform, matrix, childWorldTransform);

		(<internal.DisplayObject><any>this.__currentState).__getRenderBounds(rect, childWorldTransform);

		(<internal.Matrix><any>Matrix).__pool.release(childWorldTransform);
	}

	protected __getCursor(): MouseCursor
	{
		return (this.useHandCursor && !this.__ignoreEvent && this.enabled) ? MouseCursor.BUTTON : null;
	}

	protected __hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean,
		hitObject: DisplayObject): boolean
	{
		var hitTest = false;

		if (this.__hitTestState != null)
		{
			if ((<internal.DisplayObject><any>this.__hitTestState).__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject))
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

				hitTest = (!interactiveOnly || this.mouseEnabled);
			}
		}
		else if (this.__currentState != null)
		{
			if (!hitObject.visible || this.__isMask || (interactiveOnly && !this.mouseEnabled) || (this.__mask != null && !(<internal.DisplayObject><any>this.__mask).__hitTestMask(x, y)))
			{
				hitTest = false;
			}
			else if ((<internal.DisplayObject><any>this.__currentState).__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject))
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

	protected __hitTestMask(x: number, y: number): boolean
	{
		var hitTest = false;

		if ((<internal.DisplayObject><any>this.__currentState).__hitTestMask(x, y))
		{
			hitTest = true;
		}

		return hitTest;
	}

	protected __setCurrentState(value: DisplayObject): DisplayObject
	{
		if (this.__currentState != null && this.__currentState != this.__hitTestState)
		{
			(<internal.DisplayObject><any>this.__currentState).__renderParent = null;
			(<internal.DisplayObject><any>this.__currentState).__setTransformDirty();
		}

		if (value != null && value.parent != null)
		{
			value.parent.removeChild(value);
		}

		if ((<internal.DisplayObject><any>DisplayObject).__supportDOM && this.__previousStates == null)
		{
			this.__previousStates = new Vector<DisplayObject>();
		}

		if (value != this.__currentState)
		{
			if ((<internal.DisplayObject><any>DisplayObject).__supportDOM)
			{
				if (this.__currentState != null)
				{
					(<internal.DisplayObject><any>this.__currentState).__setStageReferences(null);
					this.__previousStates.push(this.__currentState);
				}

				var index = this.__previousStates.indexOf(value);

				if (index > -1)
				{
					this.__previousStates.splice(index, 1);
				}
			}

			if (value != null)
			{
				(<internal.DisplayObject><any>value).__renderParent = this;
				(<internal.DisplayObject><any>value).__setTransformDirty();
				(<internal.DisplayObject><any>value).__setRenderDirty();
			}

			this.__localBoundsDirty = true;
			this.__setRenderDirty();
		}

		this.__currentState = value;

		return value;
	}

	protected __setTransformDirty(force: boolean = false): void
	{
		// inline super.__setTransformDirty(force);
		this.__transformDirty = true;

		if (this.__currentState != null)
		{
			(<internal.DisplayObject><any>this.__currentState).__setTransformDirty(force);
		}

		if (this.__hitTestState != null && this.__hitTestState != this.__currentState)
		{
			(<internal.DisplayObject><any>this.__hitTestState).__setTransformDirty(force);
		}
	}

	protected __update(transformOnly: boolean, updateChildren: boolean): void
	{
		this.__updateSingle(transformOnly, updateChildren);

		if (updateChildren)
		{
			if (this.__currentState != null)
			{
				(<internal.DisplayObject><any>this.__currentState).__update(transformOnly, true);
			}

			if (this.__hitTestState != null && this.__hitTestState != this.__currentState)
			{
				(<internal.DisplayObject><any>this.__hitTestState).__update(transformOnly, true);
			}
		}
	}

	// Getters & Setters

	/**
		Specifies a display object that is used as the visual object for the
		button "Down" state  - the state that the button is in when the user
		selects the `hitTestState` object.
	**/
	public get downState(): DisplayObject
	{
		return this.__downState;
	}

	public set downState(downState: DisplayObject)
	{
		if (this.__downState != null && this.__currentState == this.__downState)
		{
			this.__setCurrentState(this.__downState);
		}

		this.__downState = downState;
	}

	/**
		Specifies a display object that is used as the hit testing object for the
		button. For a basic button, set the `hitTestState` property to
		the same display object as the `overState` property. If you do
		not set the `hitTestState` property, the SimpleButton is
		inactive  -  it does not respond to user input events.
	**/
	public get hitTestState(): DisplayObject
	{
		return this.__hitTestState;
	}

	public set hitTestState(hitTestState: DisplayObject)
	{
		if (this.__hitTestState != null && this.__hitTestState != hitTestState)
		{
			if (this.__hitTestState != this.__downState && this.__hitTestState != this.__upState && this.__hitTestState != this.__overState)
			{
				(<internal.DisplayObject><any>this.__hitTestState).__renderParent = null;
				(<internal.DisplayObject><any>this.__hitTestState).__setTransformDirty();
			}
		}

		if (hitTestState != null)
		{
			(<internal.DisplayObject><any>hitTestState).__renderParent = this;
			(<internal.DisplayObject><any>hitTestState).__setTransformDirty();
			(<internal.DisplayObject><any>hitTestState).__setRenderDirty();
		}

		this.__hitTestState = hitTestState;
	}

	/**
		Specifies a display object that is used as the visual object for the
		button over state  -  the state that the button is in when the pointer is
		positioned over the button.
	**/
	public get overState(): DisplayObject
	{
		return this.__overState;
	}

	public set overState(overState: DisplayObject)
	{
		if (this.__overState != null && this.__currentState == this.__overState)
		{
			this.__setCurrentState(overState);
		}

		this.__overState = overState;
	}

	/**
		The SoundTransform object assigned to this button. A SoundTransform object
		includes properties for setting volume, panning, left speaker assignment,
		and right speaker assignment. This SoundTransform object applies to all
		states of the button. This SoundTransform object affects only embedded
		sounds.
	**/
	public get soundTransform(): SoundTransform
	{
		if (this.__soundTransform == null)
		{
			this.__soundTransform = new SoundTransform();
		}

		return new SoundTransform(this.__soundTransform.volume, this.__soundTransform.pan);
	}

	public set soundTransform(value: SoundTransform)
	{
		this.__soundTransform = new SoundTransform(value.volume, value.pan);
	}

	/**
		Specifies a display object that is used as the visual object for the
		button up state  -  the state that the button is in when the pointer is
		not positioned over the button.
	**/
	public get upState(): DisplayObject
	{
		return this.__upState;
	}

	public set upState(upState: DisplayObject)
	{
		if (this.__upState != null && this.__currentState == this.__upState)
		{
			this.__setCurrentState(upState);
		}

		this.__upState = upState;
	}

	// Event Handlers

	protected __this_onMouseDown(event: MouseEvent): void
	{
		if (this.enabled)
		{
			this.__setCurrentState(this.__downState);
		}
	}

	protected __this_onMouseOut(event: MouseEvent): void
	{
		this.__ignoreEvent = false;

		if (this.__upState != this.__currentState)
		{
			this.__setCurrentState(this.__upState);
		}
	}

	protected __this_onMouseOver(event: MouseEvent): void
	{
		if (event.buttonDown)
		{
			this.__ignoreEvent = true;
		}

		if (this.__overState != this.__currentState && this.__overState != null && !this.__ignoreEvent && this.enabled)
		{
			this.__setCurrentState(this.__overState);
		}
	}

	protected __this_onMouseUp(event: MouseEvent): void
	{
		this.__ignoreEvent = false;

		if (this.enabled && this.__overState != null)
		{
			this.__setCurrentState(this.__overState);
		}
		else
		{
			this.__setCurrentState(this.__upState);
		}
	}
}
