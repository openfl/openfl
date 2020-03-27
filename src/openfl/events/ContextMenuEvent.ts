import ObjectPool from "../_internal/utils/ObjectPool";
import InteractiveObject from "../display/InteractiveObject";
import Event from "../events/Event";
import EventType from "../events/EventType";

/**
	An InteractiveObject dispatches a ContextMenuEvent object when the user
	opens or interacts with the context menu. There are two types of
	ContextMenuEvent objects:
	* `ContextMenuEvent.MENU_ITEM_SELECT`
	* `ContextMenuEvent.MENU_SELECT`

**/
export default class ContextMenuEvent extends Event
{
	/**
		Defines the value of the `type` property of a `menuItemSelect` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `contextMenuOwner` | The display list object to which the menu is attached. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `mouseTarget` | The display list object on which the user right-clicked to display the context menu. |
		| `target` | The ContextMenuItem object that has been selected. The target is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static readonly MENU_ITEM_SELECT: EventType<ContextMenuEvent> = "menuItemSelect";

	/**
		Defines the value of the `type` property of a `menuSelect` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `contextMenuOwner` | The display list object to which the menu is attached. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `mouseTarget` | The display list object on which the user right-clicked to display the context menu. |
		| `target` | The ContextMenu object that is about to be displayed. The target is not always the object in the display list that registered the event listener. Use the `currentTarget` property to access the object in the display list that is currently processing the event. |
	**/
	public static readonly MENU_SELECT: EventType<ContextMenuEvent> = "menuSelect";

	/**
		The display list object to which the menu is attached. This could be
		the mouse target (`mouseTarget`) or one of its ancestors in the
		display list.
	**/
	public contextMenuOwner: InteractiveObject;

	/**
		Indicates whether the `mouseTarget` property was set to `null` for
		security reasons. If the nominal value of `menuTarget` would be a
		reference to a `DisplayObject` in another security sandbox, then
		`menuTarget` is set to `null` unless there is permission in both
		directions across this sandbox boundary. Permission is established by
		calling `Security.allowDomain()` from a SWF file, or providing a
		policy file from the server of an image file, and setting the
		`LoaderContext.checkPolicyFile` flag when loading the image.
	**/
	// /** @hidden */ @:dox(hide) @:require(flash10) public isMouseTargetInaccessible:Bool;

	/**
		The display list object on which the user right-clicked to display the
		context menu. This could be the display list object to which the menu
		is attached (`contextMenuOwner`) or one of its display list
		descendants.
		The value of this property can be `null` in two circumstances: if
		there no mouse target, for example when you mouse over something from
		the background; or there is a mouse target, but it is in a security
		sandbox to which you don't have access. Use the
		`isMouseTargetInaccessible()` property to determine which of these
		reasons applies.
	**/
	public mouseTarget: InteractiveObject;

	protected static __pool: ObjectPool<ContextMenuEvent> = new ObjectPool<ContextMenuEvent>(() => new ContextMenuEvent(null),
		(event) => event.__init());

	/**
		Creates an Event object that contains specific information about menu
		events. Event objects are passed as parameters to event listeners.

		@param type             The type of the event. Possible values are:
								* `ContextMenuEvent.MENU_ITEM_SELECT`
								* `ContextMenuEvent.MENU_SELECT`
		@param bubbles          Determines whether the Event object
								participates in the bubbling stage of the
								event flow. Event listeners can access this
								information through the inherited `bubbles`
								property.
		@param cancelable       Determines whether the Event object can be
								canceled. Event listeners can access this
								information through the inherited `cancelable`
								property.
		@param mouseTarget      The display list object on which the user
								right-clicked to display the context menu.
								This could be the `contextMenuOwner` or one of
								its display list descendants.
		@param contextMenuOwner The display list object to which the menu is
								attached. This could be the `mouseTarget` or
								one of its ancestors in the display list.
	**/
	public constructor(type: string, bubbles: boolean = false, cancelable: boolean = false, mouseTarget: InteractiveObject = null,
		contextMenuOwner: InteractiveObject = null)
	{
		super(type, bubbles, cancelable);

		this.mouseTarget = mouseTarget;
		this.contextMenuOwner = contextMenuOwner;
	}

	public clone(): ContextMenuEvent
	{
		var event = new ContextMenuEvent(this.__type, this.__bubbles, this.__cancelable, this.mouseTarget, this.contextMenuOwner);
		event.__target = this.__target;
		event.__currentTarget = this.__currentTarget;
		event.__eventPhase = this.__eventPhase;
		return event;
	}

	public toString(): string
	{
		return this.formatToString("ContextMenuEvent", "type", "bubbles", "cancelable", "mouseTarget", "contextMenuOwner");
	}

	protected __init(): void
	{
		super.__init();
		this.mouseTarget = null;
		this.contextMenuOwner = null;
	}
}
