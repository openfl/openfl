package openfl.display;

#if !flash
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Rectangle;

/**
	The InteractiveObject class is the abstract base class for all display
	objects with which the user can interact, using the mouse, keyboard, or
	other user input device.

	You cannot instantiate the InteractiveObject class directly. A call to
	the `new InteractiveObject()` constructor throws an
	`ArgumentError` exception.

	The InteractiveObject class itself does not include any APIs for
	rendering content onscreen. To create a custom subclass of the
	InteractiveObject class, extend one of the subclasses that do have APIs for
	rendering content onscreen, such as the Sprite, SimpleButton, TextField, or
	MovieClip classes.

	@event clear                  Dispatched when the user selects 'Clear'(or
								  'Delete') from the text context menu. This
								  event is dispatched to the object that
								  currently has focus. If the object that
								  currently has focus is a TextField, the
								  default behavior of this event is to cause
								  any currently selected text in the text field
								  to be deleted.
	@event click                  Dispatched when a user presses and releases
								  the main button of the user's pointing device
								  over the same InteractiveObject. For a click
								  event to occur, it must always follow this
								  series of events in the order of occurrence:
								  mouseDown event, then mouseUp. The target
								  object must be identical for both of these
								  events; otherwise the `click`
								  event does not occur. Any number of other
								  mouse events can occur at any time between
								  the `mouseDown` or
								  `mouseUp` events; the
								  `click` event still occurs.
	@event contextMenu            Dispatched when a user gesture triggers the
								  context menu associated with this interactive
								  object in an AIR application.
	@event copy                   Dispatched when the user activates the
								  platform-specific accelerator key combination
								  for a copy operation or selects 'Copy' from
								  the text context menu. This event is
								  dispatched to the object that currently has
								  focus. If the object that currently has focus
								  is a TextField, the default behavior of this
								  event is to cause any currently selected text
								  in the text field to be copied to the
								  clipboard.
	@event cut                    Dispatched when the user activates the
								  platform-specific accelerator key combination
								  for a cut operation or selects 'Cut' from the
								  text context menu. This event is dispatched
								  to the object that currently has focus. If
								  the object that currently has focus is a
								  TextField, the default behavior of this event
								  is to cause any currently selected text in
								  the text field to be cut to the clipboard.
	@event doubleClick            Dispatched when a user presses and releases
								  the main button of a pointing device twice in
								  rapid succession over the same
								  InteractiveObject when that object's
								  `doubleClickEnabled` flag is set
								  to `true`. For a
								  `doubleClick` event to occur, it
								  must immediately follow the following series
								  of events: `mouseDown`,
								  `mouseUp`, `click`,
								  `mouseDown`, `mouseUp`.
								  All of these events must share the same
								  target as the `doubleClick` event.
								  The second click, represented by the second
								  `mouseDown` and
								  `mouseUp` events, must occur
								  within a specific period of time after the
								  `click` event. The allowable
								  length of this period varies by operating
								  system and can often be configured by the
								  user. If the target is a selectable text
								  field, the word under the pointer is selected
								  as the default behavior. If the target
								  InteractiveObject does not have its
								  `doubleClickEnabled` flag set to
								  `true` it receives two
								  `click` events.

								  The `doubleClickEnabled`
								  property defaults to `false`.

								  The double-click text selection behavior
								  of a TextField object is not related to the
								  `doubleClick` event. Use
								  `TextField.doubleClickEnabled` to
								  control TextField selections.
	@event focusIn                Dispatched _after_ a display object
								  gains focus. This situation happens when a
								  user highlights the object with a pointing
								  device or keyboard navigation. The recipient
								  of such focus is called the target object of
								  this event, while the corresponding
								  InteractiveObject instance that lost focus
								  because of this change is called the related
								  object. A reference to the related object is
								  stored in the receiving object's
								  `relatedObject` property. The
								  `shiftKey` property is not used.
								  This event follows the dispatch of the
								  previous object's `focusOut`
								  event.
	@event focusOut               Dispatched _after_ a display object
								  loses focus. This happens when a user
								  highlights a different object with a pointing
								  device or keyboard navigation. The object
								  that loses focus is called the target object
								  of this event, while the corresponding
								  InteractiveObject instance that receives
								  focus is called the related object. A
								  reference to the related object is stored in
								  the target object's
								  `relatedObject` property. The
								  `shiftKey` property is not used.
								  This event precedes the dispatch of the
								  `focusIn` event by the related
								  object.
	@event gesturePan             Dispatched when the user moves a point of
								  contact over the InteractiveObject instance
								  on a touch-enabled device(such as moving a
								  finger from left to right over a display
								  object on a mobile phone or tablet with a
								  touch screen). Some devices might also
								  interpret this contact as a
								  `mouseOver` event and as a
								  `touchOver` event.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, the
								  InteractiveObject instance can dispatch a
								  `mouseOver` event or a
								  `touchOver` event or a
								  `gesturePan` event, or all if the
								  current environment supports it. Choose how
								  you want to handle the user interaction. Use
								  the openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseOver` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `gesturePan` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event gesturePressAndTap     Dispatched when the user creates a point of
								  contact with an InteractiveObject instance,
								  then taps on a touch-enabled device(such as
								  placing several fingers over a display object
								  to open a menu and then taps one finger to
								  select a menu item on a mobile phone or
								  tablet with a touch screen). Some devices
								  might also interpret this contact as a
								  combination of several mouse events, as well.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, and then provides
								  a secondary tap, the InteractiveObject
								  instance can dispatch a
								  `mouseOver` event and a
								  `click` event(among others) as
								  well as the `gesturePressAndTap`
								  event, or all if the current environment
								  supports it. Choose how you want to handle
								  the user interaction. Use the
								  openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseOver` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `gesturePressAndTap` event, you
								  can design your event handler to respond to
								  the specific needs of a touch-enabled
								  environment and provide users with a richer
								  touch-enabled experience. You can also handle
								  both events, separately, to provide a
								  different response for a touch event than a
								  mouse event.

								  When handling the properties of the event
								  object, note that the `localX` and
								  `localY` properties are set to the
								  primary point of contact(the "push"). The
								  `offsetX` and `offsetY`
								  properties are the distance to the secondary
								  point of contact(the "tap").
	@event gestureRotate          Dispatched when the user performs a rotation
								  gesture at a point of contact with an
								  InteractiveObject instance(such as touching
								  two fingers and rotating them over a display
								  object on a mobile phone or tablet with a
								  touch screen). Two-finger rotation is a
								  common rotation gesture, but each device and
								  operating system can have its own
								  requirements to indicate rotation. Some
								  devices might also interpret this contact as
								  a combination of several mouse events, as
								  well.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, the
								  InteractiveObject instance can dispatch a
								  `mouseOver` event and a
								  `click` event(among others), in
								  addition to the `gestureRotate`
								  event, or all if the current environment
								  supports it. Choose how you want to handle
								  the user interaction. Use the
								  openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseOver` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `gestureRotate` event, you can
								  design your event handler to respond to the
								  specific needs of a touch-enabled environment
								  and provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  When handling the properties of the event
								  object, note that the `localX` and
								  `localY` properties are set to the
								  primary point of contact. The
								  `offsetX` and `offsetY`
								  properties are the distance to the point of
								  contact where the rotation gesture is
								  complete.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event gestureSwipe           Dispatched when the user performs a swipe
								  gesture at a point of contact with an
								  InteractiveObject instance(such as touching
								  three fingers to a screen and then moving
								  them in parallel over a display object on a
								  mobile phone or tablet with a touch screen).
								  Moving several fingers in parallel is a
								  common swipe gesture, but each device and
								  operating system can have its own
								  requirements for a swipe. Some devices might
								  also interpret this contact as a combination
								  of several mouse events, as well.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, and then moves the
								  fingers together, the InteractiveObject
								  instance can dispatch a `rollOver`
								  event and a `rollOut` event(among
								  others), in addition to the
								  `gestureSwipe` event, or all if
								  the current environment supports it. Choose
								  how you want to handle the user interaction.
								  If you choose to handle the
								  `rollOver` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `gestureSwipe` event, you can
								  design your event handler to respond to the
								  specific needs of a touch-enabled environment
								  and provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  When handling the properties of the event
								  object, note that the `localX` and
								  `localY` properties are set to the
								  primary point of contact. The
								  `offsetX` and `offsetY`
								  properties are the distance to the point of
								  contact where the swipe gesture is
								  complete.

								  **Note:** While some devices using the
								  Mac OS operating system can interpret a
								  four-finger swipe, this API only supports a
								  three-finger swipe.
	@event gestureTwoFingerTap    Dispatched when the user presses two points
								  of contact over the same InteractiveObject
								  instance on a touch-enabled device(such as
								  presses and releases two fingers over a
								  display object on a mobile phone or tablet
								  with a touch screen). Some devices might also
								  interpret this contact as a
								  `doubleClick` event.

								  Specifically, if a user taps two fingers
								  over an InteractiveObject, the
								  InteractiveObject instance can dispatch a
								  `doubleClick` event or a
								  `gestureTwoFingerTap` event, or
								  both if the current environment supports it.
								  Choose how you want to handle the user
								  interaction. Use the openfl.ui.Multitouch
								  class to manage touch event handling(enable
								  touch gesture event handling, simple touch
								  point event handling, or disable touch events
								  so only mouse events are dispatched). If you
								  choose to handle the `doubleClick`
								  event, then the same event handler will run
								  on a touch-enabled device and a mouse enabled
								  device. However, if you choose to handle the
								  `gestureTwoFingerTap` event, you
								  can design your event handler to respond to
								  the specific needs of a touch-enabled
								  environment and provide users with a richer
								  touch-enabled experience. You can also handle
								  both events, separately, to provide a
								  different response for a touch event than a
								  mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event gestureZoom            Dispatched when the user performs a zoom
								  gesture at a point of contact with an
								  InteractiveObject instance(such as touching
								  two fingers to a screen and then quickly
								  spreading the fingers apart over a display
								  object on a mobile phone or tablet with a
								  touch screen). Moving fingers apart is a
								  common zoom gesture, but each device and
								  operating system can have its own
								  requirements to indicate zoom. Some devices
								  might also interpret this contact as a
								  combination of several mouse events, as well.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, and then moves the
								  fingers apart, the InteractiveObject instance
								  can dispatch a `mouseOver` event
								  and a `click` event(among
								  others), in addition to the
								  `gestureZoom` event, or all if the
								  current environment supports it. Choose how
								  you want to handle the user interaction. Use
								  the openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseOver` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `gestureZoom` event, you can
								  design your event handler to respond to the
								  specific needs of a touch-enabled environment
								  and provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  When handling the properties of the event
								  object, note that the `localX` and
								  `localY` properties are set to the
								  primary point of contact. The
								  `offsetX` and `offsetY`
								  properties are the distance to the point of
								  contact where the zoom gesture is
								  complete.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event imeStartComposition    This event is dispatched to any client app
								  that supports inline input with an IME
	@event keyDown                Dispatched when the user presses a key.
								  Mappings between keys and specific characters
								  vary by device and operating system. This
								  event type is generated after such a mapping
								  occurs but before the processing of an input
								  method editor(IME). IMEs are used to enter
								  characters, such as Chinese ideographs, that
								  the standard QWERTY keyboard is ill-equipped
								  to produce. This event occurs before the
								  `keyUp` event.

								  In AIR, canceling this event prevents the
								  character from being entered into a text
								  field.
	@event keyFocusChange         Dispatched when the user attempts to change
								  focus by using keyboard navigation. The
								  default behavior of this event is to change
								  the focus and dispatch the corresponding
								  `focusIn` and
								  `focusOut` events.

								  This event is dispatched to the object
								  that currently has focus. The related object
								  for this event is the InteractiveObject
								  instance that receives focus if you do not
								  prevent the default behavior. You can prevent
								  the change in focus by calling the
								  `preventDefault()` method in an
								  event listener that is properly registered
								  with the target object. Focus changes and
								  `focusIn` and
								  `focusOut` events are dispatched
								  by default.
	@event keyUp                  Dispatched when the user releases a key.
								  Mappings between keys and specific characters
								  vary by device and operating system. This
								  event type is generated after such a mapping
								  occurs but before the processing of an input
								  method editor(IME). IMEs are used to enter
								  characters, such as Chinese ideographs, that
								  the standard QWERTY keyboard is ill-equipped
								  to produce. This event occurs after a
								  `keyDown` event and has the
								  following characteristics:
	@event middleClick            Dispatched when a user presses and releases
								  the middle button of the user's pointing
								  device over the same InteractiveObject. For a
								  `middleClick` event to occur, it
								  must always follow this series of events in
								  the order of occurrence:
								  `middleMouseDown` event, then
								  `middleMouseUp`. The target object
								  must be identical for both of these events;
								  otherwise the `middleClick` event
								  does not occur. Any number of other mouse
								  events can occur at any time between the
								  `middleMouseDown` or
								  `middleMouseUp` events; the
								  `middleClick` event still occurs.
	@event middleMouseDown        Dispatched when a user presses the middle
								  pointing device button over an
								  InteractiveObject instance.
	@event middleMouseUp          Dispatched when a user releases the pointing
								  device button over an InteractiveObject
								  instance.
	@event mouseDown              Dispatched when a user presses the pointing
								  device button over an InteractiveObject
								  instance. If the target is a SimpleButton
								  instance, the SimpleButton instance displays
								  the `downState` display object as
								  the default behavior. If the target is a
								  selectable text field, the text field begins
								  selection as the default behavior.
	@event mouseFocusChange       Dispatched when the user attempts to change
								  focus by using a pointer device. The default
								  behavior of this event is to change the focus
								  and dispatch the corresponding
								  `focusIn` and
								  `focusOut` events.

								  This event is dispatched to the object
								  that currently has focus. The related object
								  for this event is the InteractiveObject
								  instance that receives focus if you do not
								  prevent the default behavior. You can prevent
								  the change in focus by calling
								  `preventDefault()` in an event
								  listener that is properly registered with the
								  target object. The `shiftKey`
								  property is not used. Focus changes and
								  `focusIn` and
								  `focusOut` events are dispatched
								  by default.
	@event mouseMove              Dispatched when a user moves the pointing
								  device while it is over an InteractiveObject.
								  If the target is a text field that the user
								  is selecting, the selection is updated as the
								  default behavior.
	@event mouseOut               Dispatched when the user moves a pointing
								  device away from an InteractiveObject
								  instance. The event target is the object
								  previously under the pointing device. The
								  `relatedObject` is the object the
								  pointing device has moved to. If the target
								  is a SimpleButton instance, the button
								  displays the `upState` display
								  object as the default behavior.

								  The `mouseOut` event is
								  dispatched each time the mouse leaves the
								  area of any child object of the display
								  object container, even if the mouse remains
								  over another child object of the display
								  object container. This is different behavior
								  than the purpose of the `rollOut`
								  event, which is to simplify the coding of
								  rollover behaviors for display object
								  containers with children. When the mouse
								  leaves the area of a display object or the
								  area of any of its children to go to an
								  object that is not one of its children, the
								  display object dispatches the
								  `rollOut` event.The
								  `rollOut` events are dispatched
								  consecutively up the parent chain of the
								  object, starting with the object and ending
								  with the highest parent that is neither the
								  root nor an ancestor of the
								  `relatedObject`.
	@event mouseOver              Dispatched when the user moves a pointing
								  device over an InteractiveObject instance.
								  The `relatedObject` is the object
								  that was previously under the pointing
								  device. If the target is a SimpleButton
								  instance, the object displays the
								  `overState` or
								  `upState` display object,
								  depending on whether the mouse button is
								  down, as the default behavior.

								  The `mouseOver` event is
								  dispatched each time the mouse enters the
								  area of any child object of the display
								  object container, even if the mouse was
								  already over another child object of the
								  display object container. This is different
								  behavior than the purpose of the
								  `rollOver` event, which is to
								  simplify the coding of rollout behaviors for
								  display object containers with children. When
								  the mouse enters the area of a display object
								  or the area of any of its children from an
								  object that is not one of its children, the
								  display object dispatches the
								  `rollOver` event. The
								  `rollOver` events are dispatched
								  consecutively down the parent chain of the
								  object, starting with the highest parent that
								  is neither the root nor an ancestor of the
								  `relatedObject` and ending with
								  the object.
	@event mouseUp                Dispatched when a user releases the pointing
								  device button over an InteractiveObject
								  instance. If the target is a SimpleButton
								  instance, the object displays the
								  `upState` display object. If the
								  target is a selectable text field, the text
								  field ends selection as the default behavior.
	@event mouseWheel             Dispatched when a mouse wheel is spun over an
								  InteractiveObject instance. If the target is
								  a text field, the text scrolls as the default
								  behavior. Only available on Microsoft Windows
								  operating systems.
	@event nativeDragComplete     Dispatched by the drag initiator
								  InteractiveObject when the user releases the
								  drag gesture.

								  The event's dropAction property indicates
								  the action set by the drag target object; a
								  value of "none"
								 (`DragActions.NONE`) indicates
								  that the drop was canceled or was not
								  accepted.

								  The `nativeDragComplete` event
								  handler is a convenient place to update the
								  state of the initiating display object, for
								  example, by removing an item from a list(on
								  a drag action of "move"), or by changing the
								  visual properties.
	@event nativeDragDrop         Dispatched by the target InteractiveObject
								  when a dragged object is dropped on it and
								  the drop has been accepted with a call to
								  DragManager.acceptDragDrop().

								  Access the dropped data using the event
								  object `clipboard` property.

								  The handler for this event should set the
								  `DragManager.dropAction` property
								  to provide feedback to the initiator object
								  about which drag action was taken. If no
								  value is set, the DragManager will select a
								  default value from the list of allowed
								  actions.
	@event nativeDragEnter        Dispatched by an InteractiveObject when a
								  drag gesture enters its boundary.

								  Handle either the
								  `nativeDragEnter` or
								  `nativeDragOver` events to allow
								  the display object to become the drop
								  target.

								  To determine whether the dispatching
								  display object can accept the drop, check the
								  suitability of the data in
								  `clipboard` property of the event
								  object, and the allowed drag actions in the
								  `allowedActions` property.
	@event nativeDragExit         Dispatched by an InteractiveObject when a
								  drag gesture leaves its boundary.
	@event nativeDragOver         Dispatched by an InteractiveObject
								  continually while a drag gesture remains
								  within its boundary.

								  `nativeDragOver` events are
								  dispatched whenever the mouse is moved. On
								  Windows and Mac, they are also dispatched on
								  a short timer interval even when the mouse
								  has not moved.

								  Handle either the
								  `nativeDragOver` or
								  `nativeDragEnter` events to allow
								  the display object to become the drop
								  target.

								  To determine whether the dispatching
								  display object can accept the drop, check the
								  suitability of the data in
								  `clipboard` property of the event
								  object, and the allowed drag actions in the
								  `allowedActions` property.
	@event nativeDragStart        Dispatched at the beginning of a drag
								  operation by the InteractiveObject that is
								  specified as the drag initiator in the
								  DragManager.doDrag() call.
	@event nativeDragUpdate       Dispatched during a drag operation by the
								  InteractiveObject that is specified as the
								  drag initiator in the DragManager.doDrag()
								  call.

								  `nativeDragUpdate` events are
								  not dispatched on Linux.
	@event paste                  Dispatched when the user activates the
								  platform-specific accelerator key combination
								  for a paste operation or selects 'Paste' from
								  the text context menu. This event is
								  dispatched to the object that currently has
								  focus. If the object that currently has focus
								  is a TextField, the default behavior of this
								  event is to cause the contents of the
								  clipboard to be pasted into the text field at
								  the current insertion point replacing any
								  currently selected text in the text field.
	@event rightClick             Dispatched when a user presses and releases
								  the right button of the user's pointing
								  device over the same InteractiveObject. For a
								  `rightClick` event to occur, it
								  must always follow this series of events in
								  the order of occurrence:
								  `rightMouseDown` event, then
								  `rightMouseUp`. The target object
								  must be identical for both of these events;
								  otherwise the `rightClick` event
								  does not occur. Any number of other mouse
								  events can occur at any time between the
								  `rightMouseDown` or
								  `rightMouseUp` events; the
								  `rightClick` event still occurs.
	@event rightMouseDown         Dispatched when a user presses the pointing
								  device button over an InteractiveObject
								  instance.
	@event rightMouseUp           Dispatched when a user releases the pointing
								  device button over an InteractiveObject
								  instance.
	@event rollOut                Dispatched when the user moves a pointing
								  device away from an InteractiveObject
								  instance. The event target is the object
								  previously under the pointing device or a
								  parent of that object. The
								  `relatedObject` is the object that
								  the pointing device has moved to. The
								  `rollOut` events are dispatched
								  consecutively up the parent chain of the
								  object, starting with the object and ending
								  with the highest parent that is neither the
								  root nor an ancestor of the
								  `relatedObject`.

								  The purpose of the `rollOut`
								  event is to simplify the coding of rollover
								  behaviors for display object containers with
								  children. When the mouse leaves the area of a
								  display object or the area of any of its
								  children to go to an object that is not one
								  of its children, the display object
								  dispatches the `rollOut` event.
								  This is different behavior than that of the
								  `mouseOut` event, which is
								  dispatched each time the mouse leaves the
								  area of any child object of the display
								  object container, even if the mouse remains
								  over another child object of the display
								  object container.
	@event rollOver               Dispatched when the user moves a pointing
								  device over an InteractiveObject instance.
								  The event target is the object under the
								  pointing device or a parent of that object.
								  The `relatedObject` is the object
								  that was previously under the pointing
								  device. The `rollOver` events are
								  dispatched consecutively down the parent
								  chain of the object, starting with the
								  highest parent that is neither the root nor
								  an ancestor of the `relatedObject`
								  and ending with the object.

								  The purpose of the `rollOver`
								  event is to simplify the coding of rollout
								  behaviors for display object containers with
								  children. When the mouse enters the area of a
								  display object or the area of any of its
								  children from an object that is not one of
								  its children, the display object dispatches
								  the `rollOver` event. This is
								  different behavior than that of the
								  `mouseOver` event, which is
								  dispatched each time the mouse enters the
								  area of any child object of the display
								  object container, even if the mouse was
								  already over another child object of the
								  display object container.
	@event selectAll              Dispatched when the user activates the
								  platform-specific accelerator key combination
								  for a select all operation or selects 'Select
								  All' from the text context menu. This event
								  is dispatched to the object that currently
								  has focus. If the object that currently has
								  focus is a TextField, the default behavior of
								  this event is to cause all the contents of
								  the text field to be selected.
	@event softKeyboardActivate   Dispatched immediately after the soft
								  keyboard is raised.
	@event softKeyboardActivating Dispatched immediately before the soft
								  keyboard is raised.
	@event softKeyboardDeactivate Dispatched immediately after the soft
								  keyboard is lowered.
	@event tabChildrenChange      Dispatched when the value of the object's
								  `tabChildren` flag changes.
	@event tabEnabledChange       Dispatched when the object's
								  `tabEnabled` flag changes.
	@event tabIndexChange         Dispatched when the value of the object's
								  `tabIndex` property changes.
	@event textInput              Dispatched when a user enters one or more
								  characters of text. Various text input
								  methods can generate this event, including
								  standard keyboards, input method editors
								 (IMEs), voice or speech recognition systems,
								  and even the act of pasting plain text with
								  no formatting or style information.
	@event touchBegin             Dispatched when the user first contacts a
								  touch-enabled device(such as touches a
								  finger to a mobile phone or tablet with a
								  touch screen). Some devices might also
								  interpret this contact as a
								  `mouseDown` event.

								  Specifically, if a user touches a finger
								  to a touch screen, the InteractiveObject
								  instance can dispatch a
								  `mouseDown` event or a
								  `touchBegin` event, or both if the
								  current environment supports it. Choose how
								  you want to handle the user interaction. Use
								  the openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseDown` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `touchBegin` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchEnd               Dispatched when the user removes contact with
								  a touch-enabled device(such as lifts a
								  finger off a mobile phone or tablet with a
								  touch screen). Some devices might also
								  interpret this contact as a
								  `mouseUp` event.

								  Specifically, if a user lifts a finger
								  from a touch screen, the InteractiveObject
								  instance can dispatch a `mouseUp`
								  event or a `touchEnd` event, or
								  both if the current environment supports it.
								  Choose how you want to handle the user
								  interaction. Use the openfl.ui.Multitouch
								  class to manage touch event handling(enable
								  touch gesture event handling, simple touch
								  point event handling, or disable touch events
								  so only mouse events are dispatched). If you
								  choose to handle the `mouseUp`
								  event, then the same event handler will run
								  on a touch-enabled device and a mouse enabled
								  device. However, if you choose to handle the
								  `touchEnd` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchMove              Dispatched when the user moves the point of
								  contact with a touch-enabled device(such as
								  drags a finger across a mobile phone or
								  tablet with a touch screen). Some devices
								  might also interpret this contact as a
								  `mouseMove` event.

								  Specifically, if a user moves a finger
								  across a touch screen, the InteractiveObject
								  instance can dispatch a
								  `mouseMove` event or a
								  `touchMove` event, or both if the
								  current environment supports it. Choose how
								  you want to handle the user interaction. Use
								  the openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseMove` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `touchMove` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchOut               Dispatched when the user moves the point of
								  contact away from InteractiveObject instance
								  on a touch-enabled device(such as drags a
								  finger from one display object to another on
								  a mobile phone or tablet with a touch
								  screen). Some devices might also interpret
								  this contact as a `mouseOut`
								  event.

								  Specifically, if a user moves a finger
								  across a touch screen, the InteractiveObject
								  instance can dispatch a `mouseOut`
								  event or a `touchOut` event, or
								  both if the current environment supports it.
								  Choose how you want to handle the user
								  interaction. Use the openfl.ui.Multitouch
								  class to manage touch event handling(enable
								  touch gesture event handling, simple touch
								  point event handling, or disable touch events
								  so only mouse events are dispatched). If you
								  choose to handle the `mouseOut`
								  event, then the same event handler will run
								  on a touch-enabled device and a mouse enabled
								  device. However, if you choose to handle the
								  `touchOut` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchOver              Dispatched when the user moves the point of
								  contact over an InteractiveObject instance on
								  a touch-enabled device(such as drags a
								  finger from a point outside a display object
								  to a point over a display object on a mobile
								  phone or tablet with a touch screen). Some
								  devices might also interpret this contact as
								  a `mouseOver` event.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, the
								  InteractiveObject instance can dispatch a
								  `mouseOver` event or a
								  `touchOver` event, or both if the
								  current environment supports it. Choose how
								  you want to handle the user interaction. Use
								  the openfl.ui.Multitouch class to manage touch
								  event handling(enable touch gesture event
								  handling, simple touch point event handling,
								  or disable touch events so only mouse events
								  are dispatched). If you choose to handle the
								  `mouseOver` event, then the same
								  event handler will run on a touch-enabled
								  device and a mouse enabled device. However,
								  if you choose to handle the
								  `touchOver` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchRollOut           Dispatched when the user moves the point of
								  contact away from an InteractiveObject
								  instance on a touch-enabled device(such as
								  drags a finger from over a display object to
								  a point outside the display object on a
								  mobile phone or tablet with a touch screen).
								  Some devices might also interpret this
								  contact as a `rollOut` event.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, the
								  InteractiveObject instance can dispatch a
								  `rollOut` event or a
								  `touchRollOut` event, or both if
								  the current environment supports it. Choose
								  how you want to handle the user interaction.
								  Use the openfl.ui.Multitouch class to manage
								  touch event handling(enable touch gesture
								  event handling, simple touch point event
								  handling, or disable touch events so only
								  mouse events are dispatched). If you choose
								  to handle the `rollOut` event,
								  then the same event handler will run on a
								  touch-enabled device and a mouse enabled
								  device. However, if you choose to handle the
								  `touchRollOut` event, you can
								  design your event handler to respond to the
								  specific needs of a touch-enabled environment
								  and provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchRollOver          Dispatched when the user moves the point of
								  contact over an InteractiveObject instance on
								  a touch-enabled device(such as drags a
								  finger from a point outside a display object
								  to a point over a display object on a mobile
								  phone or tablet with a touch screen). Some
								  devices might also interpret this contact as
								  a `rollOver` event.

								  Specifically, if a user moves a finger
								  over an InteractiveObject, the
								  InteractiveObject instance can dispatch a
								  `rollOver` event or a
								  `touchRollOver` event, or both if
								  the current environment supports it. Choose
								  how you want to handle the user interaction.
								  Use the openfl.ui.Multitouch class to manage
								  touch event handling(enable touch gesture
								  event handling, simple touch point event
								  handling, or disable touch events so only
								  mouse events are dispatched). If you choose
								  to handle the `rollOver` event,
								  then the same event handler will run on a
								  touch-enabled device and a mouse enabled
								  device. However, if you choose to handle the
								  `touchRollOver` event, you can
								  design your event handler to respond to the
								  specific needs of a touch-enabled environment
								  and provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
	@event touchTap               Dispatched when the user lifts the point of
								  contact over the same InteractiveObject
								  instance on which the contact was initiated
								  on a touch-enabled device(such as presses
								  and releases a finger from a single point
								  over a display object on a mobile phone or
								  tablet with a touch screen). Some devices
								  might also interpret this contact as a
								  `click` event.

								  Specifically, if a user taps a finger over
								  an InteractiveObject, the InteractiveObject
								  instance can dispatch a `click`
								  event or a `touchTap` event, or
								  both if the current environment supports it.
								  Choose how you want to handle the user
								  interaction. Use the openfl.ui.Multitouch
								  class to manage touch event handling(enable
								  touch gesture event handling, simple touch
								  point event handling, or disable touch events
								  so only mouse events are dispatched). If you
								  choose to handle the `click`
								  event, then the same event handler will run
								  on a touch-enabled device and a mouse enabled
								  device. However, if you choose to handle the
								  `touchTap` event, you can design
								  your event handler to respond to the specific
								  needs of a touch-enabled environment and
								  provide users with a richer touch-enabled
								  experience. You can also handle both events,
								  separately, to provide a different response
								  for a touch event than a mouse event.

								  **Note:** See the Multitouch class for
								  environment compatibility information.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class InteractiveObject extends DisplayObject
{
	// @:noCompletion @:dox(hide) public var accessibilityImplementation:openfl.accessibility.AccessibilityImplementation;
	// @:noCompletion @:dox(hide) public var contextMenu:openfl.ui.ContextMenu;

	/**
		Specifies whether the object receives `doubleClick` events. The
		default value is `false`, which means that by default an
		InteractiveObject instance does not receive `doubleClick`
		events. If the `doubleClickEnabled` property is set to
		`true`, the instance receives `doubleClick` events
		within its bounds. The `mouseEnabled` property of the
		InteractiveObject instance must also be set to `true` for the
		object to receive `doubleClick` events.

		No event is dispatched by setting this property. You must use the
		`addEventListener()` method to add an event listener for the
		`doubleClick` event.
	**/
	public var doubleClickEnabled:Bool;

	/**
		Specifies whether this object displays a focus rectangle. It can take
		one of three values: `true`, `false`, or `null`. Values of `true` and
		`false` work as expected, specifying whether or not the focus
		rectangle appears. A value of `null` indicates that this object obeys
		the `stageFocusRect` property of the Stage.
	**/
	public var focusRect:Null<Bool>;

	/**
		Specifies whether this object receives mouse, or other user input,
		messages. The default value is `true`, which means that by
		default any InteractiveObject instance that is on the display list
		receives mouse events or other user input events. If
		`mouseEnabled` is set to `false`, the instance does
		not receive any mouse events(or other user input events like keyboard
		events). Any children of this instance on the display list are not
		affected. To change the `mouseEnabled` behavior for all
		children of an object on the display list, use
		`openfl.display.DisplayObjectContainer.mouseChildren`.

		 No event is dispatched by setting this property. You must use the
		`addEventListener()` method to create interactive
		functionality.
	**/
	public var mouseEnabled:Bool;

	/**
		Specifies whether a virtual keyboard(an on-screen, software keyboard)
		should display when this InteractiveObject instance receives focus.

		By default, the value is `false` and focusing an
		InteractiveObject instance does not raise a soft keyboard. If the
		`needsSoftKeyboard` property is set to `true`, the
		runtime raises a soft keyboard when the InteractiveObject instance is
		ready to accept user input. An InteractiveObject instance is ready to
		accept user input after a programmatic call to set the Stage
		`focus` property or a user interaction, such as a "tap." If the
		client system has a hardware keyboard available or does not support
		virtual keyboards, then the soft keyboard is not raised.

		The InteractiveObject instance dispatches
		`softKeyboardActivating`, `softKeyboardActivate`,
		and `softKeyboardDeactivate` events when the soft keyboard
		raises and lowers.

		**Note:** This property is not supported in AIR applications on
		iOS.
	**/
	public var needsSoftKeyboard:Bool;

	/**
		Defines the area that should remain on-screen when a soft keyboard is
		displayed.
		If the `needsSoftKeyboard` property of this InteractiveObject is
		`true`, then the runtime adjusts the display as needed to keep the
		object in view while the user types. Ordinarily, the runtime uses the
		object bounds obtained from the `DisplayObject.getBounds()` method.
		You can specify a different area using this
		`softKeyboardInputAreaOfInterest` property.

		Specify the `softKeyboardInputAreaOfInterest` in stage coordinates.

		**Note:** On Android, the `softKeyboardInputAreaOfInterest` is not
		respected in landscape orientations.
	**/
	public var softKeyboardInputAreaOfInterest:Rectangle;

	/**
		Specifies whether this object is in the tab order. If this object is
		in the tab order, the value is `true`; otherwise, the value is
		`false`. By default, the value is `false`, except for the following:
		* For a SimpleButton object, the value is `true`.
		* For a TextField object with `type = "input"`, the value is `true`.
		* For a Sprite object or MovieClip object with `buttonMode = true`,
		the value is `true`.
	**/
	public var tabEnabled(get, set):Bool;

	/**
		Specifies the tab ordering of objects in a SWF file. The `tabIndex`
		property is -1 by default, meaning no tab index is set for the object.

		If any currently displayed object in the SWF file contains a
		`tabIndex` property, automatic tab ordering is disabled, and the tab
		ordering is calculated from the `tabIndex` properties of objects in
		the SWF file. The custom tab ordering includes only objects that have
		`tabIndex` properties.

		The `tabIndex` property can be a non-negative integer. The objects are
		ordered according to their `tabIndex` properties, in ascending order.
		An object with a `tabIndex` value of 1 precedes an object with a
		`tabIndex` value of 2. Do not use the same `tabIndex` value for
		multiple objects.

		The custom tab ordering that the `tabIndex` property defines is
		_flat_. This means that no attention is paid to the hierarchical
		relationships of objects in the SWF file. All objects in the SWF file
		with `tabIndex` properties are placed in the tab order, and the tab
		order is determined by the order of the `tabIndex` values.

		**Note:** To set the tab order for TLFTextField instances, cast the
		display object child of the TLFTextField as an InteractiveObject, then
		set the `tabIndex` property. For example:

		```haxe
		cast(tlfInstance.getChildAt(1), InteractiveObject).tabIndex = 3;
		```

		To reverse the tab order from the default setting for three instances of
		a TLFTextField object (`tlfInstance1`, `tlfInstance2` and
		`tlfInstance3`), use:

		```haxe
		cast(tlfInstance1.getChildAt(1), InteractiveObject).tabIndex = 3;
		cast(tlfInstance2.getChildAt(1), InteractiveObject).tabIndex = 2;
		cast(tlfInstance3.getChildAt(1), InteractiveObject).tabIndex = 1;
		```
	**/
	public var tabIndex(get, set):Int;

	@:noCompletion private var __tabEnabled:Null<Bool>;
	@:noCompletion private var __tabIndex:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(InteractiveObject.prototype, {
			"tabEnabled": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_tabEnabled (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_tabEnabled (v); }")
			},
			"tabIndex": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_tabIndex (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_tabIndex (v); }")
			},
		});
	}
	#end

	/**
		Calling the `new InteractiveObject()` constructor throws an
		`ArgumentError` exception. You can, however, call constructors
		for the following subclasses of InteractiveObject:

		* `new SimpleButton()`
		* `new TextField()`
		* `new Loader()`
		* `new Sprite()`
		* `new MovieClip()`
	**/
	public function new()
	{
		super();

		doubleClickEnabled = false;
		mouseEnabled = true;
		needsSoftKeyboard = false;
		__tabEnabled = null;
		__tabIndex = -1;
	}

	#if !openfl_strict
	/**
		Raises a virtual keyboard.

		Calling this method focuses the InteractiveObject instance and raises
		the soft keyboard, if necessary. The `needsSoftKeyboard` must
		also be `true`. A keyboard is not raised if a hardware keyboard
		is available, or if the client system does not support virtual
		keyboards.

		**Note:** This method is not supported in AIR applications on
		iOS.

		@return A value of `true` means that the soft keyboard request
				was granted; `false` means that the soft keyboard was
				not raised.
	**/
	public function requestSoftKeyboard():Bool
	{
		openfl.utils._internal.Lib.notImplemented();
		return false;
	}
	#end

	@:noCompletion private function __allowMouseFocus():Bool
	{
		return mouseEnabled && tabEnabled;
	}

	@:noCompletion private override function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		if (stack != null)
		{
			stack.push(this);

			if (parent != null)
			{
				parent.__getInteractive(stack);
			}
		}

		return true;
	}

	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled)) return false;
		return super.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject);
	}

	@:noCompletion private function __tabTest(stack:Array<InteractiveObject>):Void
	{
		if (tabEnabled)
		{
			stack.push(this);
		}
	}

	// Get & Set Methods
	@:noCompletion private function get_tabEnabled():Bool
	{
		return __tabEnabled == true ? true : false;
	}

	@:noCompletion private function set_tabEnabled(value:Bool):Bool
	{
		if (__tabEnabled != value)
		{
			__tabEnabled = value;

			dispatchEvent(new Event(Event.TAB_ENABLED_CHANGE, true, false));
		}

		return __tabEnabled;
	}

	@:noCompletion private function get_tabIndex():Int
	{
		return __tabIndex;
	}

	@:noCompletion private function set_tabIndex(value:Int):Int
	{
		if (__tabIndex != value)
		{
			if (value < -1) throw new RangeError("Parameter tabIndex must be a non-negative number; got " + value);

			__tabIndex = value;

			dispatchEvent(new Event(Event.TAB_INDEX_CHANGE, true, false));
		}

		return __tabIndex;
	}
}
#else
typedef InteractiveObject = flash.display.InteractiveObject;
#end
