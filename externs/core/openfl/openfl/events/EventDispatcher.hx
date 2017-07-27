package openfl.events; #if (display || !flash)


/**
 * The EventDispatcher class is the base class for all classes that dispatch
 * events. The EventDispatcher class implements the IEventDispatcher interface
 * and is the base class for the DisplayObject class. The EventDispatcher
 * class allows any object on the display list to be an event target and as
 * such, to use the methods of the IEventDispatcher interface.
 *
 * Event targets are an important part of the Flash<sup>®</sup> Player and
 * Adobe<sup>®</sup> AIR<sup>®</sup> event model. The event target serves as
 * the focal point for how events flow through the display list hierarchy.
 * When an event such as a mouse click or a keypress occurs, Flash Player or
 * the AIR application dispatches an event object into the event flow from the
 * root of the display list. The event object then makes its way through the
 * display list until it reaches the event target, at which point it begins
 * its return trip through the display list. This round-trip journey to the
 * event target is conceptually divided into three phases: the capture phase
 * comprises the journey from the root to the last node before the event
 * target's node, the target phase comprises only the event target node, and
 * the bubbling phase comprises any subsequent nodes encountered on the return
 * trip to the root of the display list.
 *
 * In general, the easiest way for a user-defined class to gain event
 * dispatching capabilities is to extend EventDispatcher. If this is
 * impossible(that is, if the class is already extending another class), you
 * can instead implement the IEventDispatcher interface, create an
 * EventDispatcher member, and write simple hooks to route calls into the
 * aggregated EventDispatcher.
 * 
 * @event activate   [broadcast event] Dispatched when the Flash Player or AIR
 *                   application gains operating system focus and becomes
 *                   active. This event is a broadcast event, which means that
 *                   it is dispatched by all EventDispatcher objects with a
 *                   listener registered for this event. For more information
 *                   about broadcast events, see the DisplayObject class.
 * @event deactivate [broadcast event] Dispatched when the Flash Player or AIR
 *                   application operating loses system focus and is becoming
 *                   inactive. This event is a broadcast event, which means
 *                   that it is dispatched by all EventDispatcher objects with
 *                   a listener registered for this event. For more
 *                   information about broadcast events, see the DisplayObject
 *                   class.
 */
extern class EventDispatcher implements IEventDispatcher {
	
	
	/**
	 * Aggregates an instance of the EventDispatcher class.
	 *
	 * The EventDispatcher class is generally used as a base class, which
	 * means that most developers do not need to use this constructor function.
	 * However, advanced developers who are implementing the IEventDispatcher
	 * interface need to use this constructor. If you are unable to extend the
	 * EventDispatcher class and must instead implement the IEventDispatcher
	 * interface, use this constructor to aggregate an instance of the
	 * EventDispatcher class.
	 * 
	 * @param target The target object for events dispatched to the
	 *               EventDispatcher object. This parameter is used when the
	 *               EventDispatcher instance is aggregated by a class that
	 *               implements IEventDispatcher; it is necessary so that the
	 *               containing object can be the target for events. Do not use
	 *               this parameter in simple cases in which a class extends
	 *               EventDispatcher.
	 */
	public function new (target:IEventDispatcher = null):Void;
	
	
	/**
	 * Registers an event listener object with an EventDispatcher object so that
	 * the listener receives notification of an event. You can register event
	 * listeners on all nodes in the display list for a specific type of event,
	 * phase, and priority.
	 *
	 * After you successfully register an event listener, you cannot change
	 * its priority through additional calls to `addEventListener()`.
	 * To change a listener's priority, you must first call
	 * `removeListener()`. Then you can register the listener again
	 * with the new priority level. 
	 *
	 * Keep in mind that after the listener is registered, subsequent calls to
	 * `addEventListener()` with a different `type` or
	 * `useCapture` value result in the creation of a separate
	 * listener registration. For example, if you first register a listener with
	 * `useCapture` set to `true`, it listens only during
	 * the capture phase. If you call `addEventListener()` again using
	 * the same listener object, but with `useCapture` set to
	 * `false`, you have two separate listeners: one that listens
	 * during the capture phase and another that listens during the target and
	 * bubbling phases. 
	 *
	 * You cannot register an event listener for only the target phase or the
	 * bubbling phase. Those phases are coupled during registration because
	 * bubbling applies only to the ancestors of the target node.
	 *
	 * If you no longer need an event listener, remove it by calling
	 * `removeEventListener()`, or memory problems could result. Event
	 * listeners are not automatically removed from memory because the garbage
	 * collector does not remove the listener as long as the dispatching object
	 * exists(unless the `useWeakReference` parameter is set to
	 * `true`).
	 *
	 * Copying an EventDispatcher instance does not copy the event listeners
	 * attached to it.(If your newly created node needs an event listener, you
	 * must attach the listener after creating the node.) However, if you move an
	 * EventDispatcher instance, the event listeners attached to it move along
	 * with it.
	 *
	 * If the event listener is being registered on a node while an event is
	 * being processed on this node, the event listener is not triggered during
	 * the current phase but can be triggered during a later phase in the event
	 * flow, such as the bubbling phase.
	 *
	 * If an event listener is removed from a node while an event is being
	 * processed on the node, it is still triggered by the current actions. After
	 * it is removed, the event listener is never invoked again(unless
	 * registered again for future processing). 
	 * 
	 * @param type             The type of event.
	 * @param useCapture       Determines whether the listener works in the
	 *                         capture phase or the target and bubbling phases.
	 *                         If `useCapture` is set to
	 *                         `true`, the listener processes the
	 *                         event only during the capture phase and not in the
	 *                         target or bubbling phase. If
	 *                         `useCapture` is `false`, the
	 *                         listener processes the event only during the
	 *                         target or bubbling phase. To listen for the event
	 *                         in all three phases, call
	 *                         `addEventListener` twice, once with
	 *                         `useCapture` set to `true`,
	 *                         then again with `useCapture` set to
	 *                         `false`.
	 * @param priority         The priority level of the event listener. The
	 *                         priority is designated by a signed 32-bit integer.
	 *                         The higher the number, the higher the priority.
	 *                         All listeners with priority _n_ are processed
	 *                         before listeners of priority _n_-1. If two or
	 *                         more listeners share the same priority, they are
	 *                         processed in the order in which they were added.
	 *                         The default priority is 0.
	 * @param useWeakReference Determines whether the reference to the listener
	 *                         is strong or weak. A strong reference(the
	 *                         default) prevents your listener from being
	 *                         garbage-collected. A weak reference does not.
	 *
	 *                         Class-level member functions are not subject to
	 *                         garbage collection, so you can set
	 *                         `useWeakReference` to `true`
	 *                         for class-level member functions without
	 *                         subjecting them to garbage collection. If you set
	 *                         `useWeakReference` to `true`
	 *                         for a listener that is a nested inner function,
	 *                         the function will be garbage-collected and no
	 *                         longer persistent. If you create references to the
	 *                         inner function(save it in another variable) then
	 *                         it is not garbage-collected and stays
	 *                         persistent.
	 * @throws ArgumentError The `listener` specified is not a
	 *                       function.
	 */
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	
	
	/**
	 * Dispatches an event into the event flow. The event target is the
	 * EventDispatcher object upon which the `dispatchEvent()` method
	 * is called.
	 * 
	 * @param event The Event object that is dispatched into the event flow. If
	 *              the event is being redispatched, a clone of the event is
	 *              created automatically. After an event is dispatched, its
	 *              `target` property cannot be changed, so you must
	 *              create a new copy of the event for redispatching to work.
	 * @return A value of `true` if the event was successfully
	 *         dispatched. A value of `false` indicates failure or
	 *         that `preventDefault()` was called on the event.
	 * @throws Error The event dispatch recursion limit has been reached.
	 */
	public function dispatchEvent (event:Event):Bool;
	
	
	/**
	 * Checks whether the EventDispatcher object has any listeners registered for
	 * a specific type of event. This allows you to determine where an
	 * EventDispatcher object has altered handling of an event type in the event
	 * flow hierarchy. To determine whether a specific event type actually
	 * triggers an event listener, use `willTrigger()`.
	 *
	 * The difference between `hasEventListener()` and
	 * `willTrigger()` is that `hasEventListener()`
	 * examines only the object to which it belongs, whereas
	 * `willTrigger()` examines the entire event flow for the event
	 * specified by the `type` parameter. 
	 *
	 * When `hasEventListener()` is called from a LoaderInfo
	 * object, only the listeners that the caller can access are considered.
	 * 
	 * @param type The type of event.
	 * @return A value of `true` if a listener of the specified type
	 *         is registered; `false` otherwise.
	 */
	public function hasEventListener (type:String):Bool;
	
	
	/**
	 * Removes a listener from the EventDispatcher object. If there is no
	 * matching listener registered with the EventDispatcher object, a call to
	 * this method has no effect.
	 * 
	 * @param type       The type of event.
	 * @param useCapture Specifies whether the listener was registered for the
	 *                   capture phase or the target and bubbling phases. If the
	 *                   listener was registered for both the capture phase and
	 *                   the target and bubbling phases, two calls to
	 *                   `removeEventListener()` are required to
	 *                   remove both, one call with `useCapture()` set
	 *                   to `true`, and another call with
	 *                   `useCapture()` set to `false`.
	 */
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	
	
	public function toString ():String;
	
	
	/**
	 * Checks whether an event listener is registered with this EventDispatcher
	 * object or any of its ancestors for the specified event type. This method
	 * returns `true` if an event listener is triggered during any
	 * phase of the event flow when an event of the specified type is dispatched
	 * to this EventDispatcher object or any of its descendants.
	 *
	 * The difference between the `hasEventListener()` and the
	 * `willTrigger()` methods is that `hasEventListener()`
	 * examines only the object to which it belongs, whereas the
	 * `willTrigger()` method examines the entire event flow for the
	 * event specified by the `type` parameter. 
	 *
	 * When `willTrigger()` is called from a LoaderInfo object,
	 * only the listeners that the caller can access are considered.
	 * 
	 * @param type The type of event.
	 * @return A value of `true` if a listener of the specified type
	 *         will be triggered; `false` otherwise.
	 */
	public function willTrigger (type:String):Bool;
	
	
}


#else
typedef EventDispatcher = flash.events.EventDispatcher;
#end