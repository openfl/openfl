package flash.display;
#if (flash || display)


/**
 * The InteractiveObject class is the abstract base class for all display
 * objects with which the user can interact, using the mouse, keyboard, or
 * other user input device.
 *
 * <p>You cannot instantiate the InteractiveObject class directly. A call to
 * the <code>new InteractiveObject()</code> constructor throws an
 * <code>ArgumentError</code> exception.</p>
 *
 * <p>The InteractiveObject class itself does not include any APIs for
 * rendering content onscreen. To create a custom subclass of the
 * InteractiveObject class, extend one of the subclasses that do have APIs for
 * rendering content onscreen, such as the Sprite, SimpleButton, TextField, or
 * MovieClip classes.</p>
 * 
 * @event clear                  Dispatched when the user selects 'Clear'(or
 *                               'Delete') from the text context menu. This
 *                               event is dispatched to the object that
 *                               currently has focus. If the object that
 *                               currently has focus is a TextField, the
 *                               default behavior of this event is to cause
 *                               any currently selected text in the text field
 *                               to be deleted.
 * @event click                  Dispatched when a user presses and releases
 *                               the main button of the user's pointing device
 *                               over the same InteractiveObject. For a click
 *                               event to occur, it must always follow this
 *                               series of events in the order of occurrence:
 *                               mouseDown event, then mouseUp. The target
 *                               object must be identical for both of these
 *                               events; otherwise the <code>click</code>
 *                               event does not occur. Any number of other
 *                               mouse events can occur at any time between
 *                               the <code>mouseDown</code> or
 *                               <code>mouseUp</code> events; the
 *                               <code>click</code> event still occurs.
 * @event contextMenu            Dispatched when a user gesture triggers the
 *                               context menu associated with this interactive
 *                               object in an AIR application.
 * @event copy                   Dispatched when the user activates the
 *                               platform-specific accelerator key combination
 *                               for a copy operation or selects 'Copy' from
 *                               the text context menu. This event is
 *                               dispatched to the object that currently has
 *                               focus. If the object that currently has focus
 *                               is a TextField, the default behavior of this
 *                               event is to cause any currently selected text
 *                               in the text field to be copied to the
 *                               clipboard.
 * @event cut                    Dispatched when the user activates the
 *                               platform-specific accelerator key combination
 *                               for a cut operation or selects 'Cut' from the
 *                               text context menu. This event is dispatched
 *                               to the object that currently has focus. If
 *                               the object that currently has focus is a
 *                               TextField, the default behavior of this event
 *                               is to cause any currently selected text in
 *                               the text field to be cut to the clipboard.
 * @event doubleClick            Dispatched when a user presses and releases
 *                               the main button of a pointing device twice in
 *                               rapid succession over the same
 *                               InteractiveObject when that object's
 *                               <code>doubleClickEnabled</code> flag is set
 *                               to <code>true</code>. For a
 *                               <code>doubleClick</code> event to occur, it
 *                               must immediately follow the following series
 *                               of events: <code>mouseDown</code>,
 *                               <code>mouseUp</code>, <code>click</code>,
 *                               <code>mouseDown</code>, <code>mouseUp</code>.
 *                               All of these events must share the same
 *                               target as the <code>doubleClick</code> event.
 *                               The second click, represented by the second
 *                               <code>mouseDown</code> and
 *                               <code>mouseUp</code> events, must occur
 *                               within a specific period of time after the
 *                               <code>click</code> event. The allowable
 *                               length of this period varies by operating
 *                               system and can often be configured by the
 *                               user. If the target is a selectable text
 *                               field, the word under the pointer is selected
 *                               as the default behavior. If the target
 *                               InteractiveObject does not have its
 *                               <code>doubleClickEnabled</code> flag set to
 *                               <code>true</code> it receives two
 *                               <code>click</code> events.
 *
 *                               <p>The <code>doubleClickEnabled</code>
 *                               property defaults to <code>false</code>. </p>
 *
 *                               <p>The double-click text selection behavior
 *                               of a TextField object is not related to the
 *                               <code>doubleClick</code> event. Use
 *                               <code>TextField.doubleClickEnabled</code> to
 *                               control TextField selections.</p>
 * @event focusIn                Dispatched <i>after</i> a display object
 *                               gains focus. This situation happens when a
 *                               user highlights the object with a pointing
 *                               device or keyboard navigation. The recipient
 *                               of such focus is called the target object of
 *                               this event, while the corresponding
 *                               InteractiveObject instance that lost focus
 *                               because of this change is called the related
 *                               object. A reference to the related object is
 *                               stored in the receiving object's
 *                               <code>relatedObject</code> property. The
 *                               <code>shiftKey</code> property is not used.
 *                               This event follows the dispatch of the
 *                               previous object's <code>focusOut</code>
 *                               event.
 * @event focusOut               Dispatched <i>after</i> a display object
 *                               loses focus. This happens when a user
 *                               highlights a different object with a pointing
 *                               device or keyboard navigation. The object
 *                               that loses focus is called the target object
 *                               of this event, while the corresponding
 *                               InteractiveObject instance that receives
 *                               focus is called the related object. A
 *                               reference to the related object is stored in
 *                               the target object's
 *                               <code>relatedObject</code> property. The
 *                               <code>shiftKey</code> property is not used.
 *                               This event precedes the dispatch of the
 *                               <code>focusIn</code> event by the related
 *                               object.
 * @event gesturePan             Dispatched when the user moves a point of
 *                               contact over the InteractiveObject instance
 *                               on a touch-enabled device(such as moving a
 *                               finger from left to right over a display
 *                               object on a mobile phone or tablet with a
 *                               touch screen). Some devices might also
 *                               interpret this contact as a
 *                               <code>mouseOver</code> event and as a
 *                               <code>touchOver</code> event.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, the
 *                               InteractiveObject instance can dispatch a
 *                               <code>mouseOver</code> event or a
 *                               <code>touchOver</code> event or a
 *                               <code>gesturePan</code> event, or all if the
 *                               current environment supports it. Choose how
 *                               you want to handle the user interaction. Use
 *                               the flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseOver</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>gesturePan</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event gesturePressAndTap     Dispatched when the user creates a point of
 *                               contact with an InteractiveObject instance,
 *                               then taps on a touch-enabled device(such as
 *                               placing several fingers over a display object
 *                               to open a menu and then taps one finger to
 *                               select a menu item on a mobile phone or
 *                               tablet with a touch screen). Some devices
 *                               might also interpret this contact as a
 *                               combination of several mouse events, as well.
 *
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, and then provides
 *                               a secondary tap, the InteractiveObject
 *                               instance can dispatch a
 *                               <code>mouseOver</code> event and a
 *                               <code>click</code> event(among others) as
 *                               well as the <code>gesturePressAndTap</code>
 *                               event, or all if the current environment
 *                               supports it. Choose how you want to handle
 *                               the user interaction. Use the
 *                               flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseOver</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>gesturePressAndTap</code> event, you
 *                               can design your event handler to respond to
 *                               the specific needs of a touch-enabled
 *                               environment and provide users with a richer
 *                               touch-enabled experience. You can also handle
 *                               both events, separately, to provide a
 *                               different response for a touch event than a
 *                               mouse event.</p>
 *
 *                               <p>When handling the properties of the event
 *                               object, note that the <code>localX</code> and
 *                               <code>localY</code> properties are set to the
 *                               primary point of contact(the "push"). The
 *                               <code>offsetX</code> and <code>offsetY</code>
 *                               properties are the distance to the secondary
 *                               point of contact(the "tap").</p>
 * @event gestureRotate          Dispatched when the user performs a rotation
 *                               gesture at a point of contact with an
 *                               InteractiveObject instance(such as touching
 *                               two fingers and rotating them over a display
 *                               object on a mobile phone or tablet with a
 *                               touch screen). Two-finger rotation is a
 *                               common rotation gesture, but each device and
 *                               operating system can have its own
 *                               requirements to indicate rotation. Some
 *                               devices might also interpret this contact as
 *                               a combination of several mouse events, as
 *                               well.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, the
 *                               InteractiveObject instance can dispatch a
 *                               <code>mouseOver</code> event and a
 *                               <code>click</code> event(among others), in
 *                               addition to the <code>gestureRotate</code>
 *                               event, or all if the current environment
 *                               supports it. Choose how you want to handle
 *                               the user interaction. Use the
 *                               flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseOver</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>gestureRotate</code> event, you can
 *                               design your event handler to respond to the
 *                               specific needs of a touch-enabled environment
 *                               and provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p>When handling the properties of the event
 *                               object, note that the <code>localX</code> and
 *                               <code>localY</code> properties are set to the
 *                               primary point of contact. The
 *                               <code>offsetX</code> and <code>offsetY</code>
 *                               properties are the distance to the point of
 *                               contact where the rotation gesture is
 *                               complete.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event gestureSwipe           Dispatched when the user performs a swipe
 *                               gesture at a point of contact with an
 *                               InteractiveObject instance(such as touching
 *                               three fingers to a screen and then moving
 *                               them in parallel over a display object on a
 *                               mobile phone or tablet with a touch screen).
 *                               Moving several fingers in parallel is a
 *                               common swipe gesture, but each device and
 *                               operating system can have its own
 *                               requirements for a swipe. Some devices might
 *                               also interpret this contact as a combination
 *                               of several mouse events, as well.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, and then moves the
 *                               fingers together, the InteractiveObject
 *                               instance can dispatch a <code>rollOver</code>
 *                               event and a <code>rollOut</code> event(among
 *                               others), in addition to the
 *                               <code>gestureSwipe</code> event, or all if
 *                               the current environment supports it. Choose
 *                               how you want to handle the user interaction.
 *                               If you choose to handle the
 *                               <code>rollOver</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>gestureSwipe</code> event, you can
 *                               design your event handler to respond to the
 *                               specific needs of a touch-enabled environment
 *                               and provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p>When handling the properties of the event
 *                               object, note that the <code>localX</code> and
 *                               <code>localY</code> properties are set to the
 *                               primary point of contact. The
 *                               <code>offsetX</code> and <code>offsetY</code>
 *                               properties are the distance to the point of
 *                               contact where the swipe gesture is
 *                               complete.</p>
 *
 *                               <p><b>Note:</b> While some devices using the
 *                               Mac OS operating system can interpret a
 *                               four-finger swipe, this API only supports a
 *                               three-finger swipe.</p>
 * @event gestureTwoFingerTap    Dispatched when the user presses two points
 *                               of contact over the same InteractiveObject
 *                               instance on a touch-enabled device(such as
 *                               presses and releases two fingers over a
 *                               display object on a mobile phone or tablet
 *                               with a touch screen). Some devices might also
 *                               interpret this contact as a
 *                               <code>doubleClick</code> event.
 *
 *                               <p>Specifically, if a user taps two fingers
 *                               over an InteractiveObject, the
 *                               InteractiveObject instance can dispatch a
 *                               <code>doubleClick</code> event or a
 *                               <code>gestureTwoFingerTap</code> event, or
 *                               both if the current environment supports it.
 *                               Choose how you want to handle the user
 *                               interaction. Use the flash.ui.Multitouch
 *                               class to manage touch event handling(enable
 *                               touch gesture event handling, simple touch
 *                               point event handling, or disable touch events
 *                               so only mouse events are dispatched). If you
 *                               choose to handle the <code>doubleClick</code>
 *                               event, then the same event handler will run
 *                               on a touch-enabled device and a mouse enabled
 *                               device. However, if you choose to handle the
 *                               <code>gestureTwoFingerTap</code> event, you
 *                               can design your event handler to respond to
 *                               the specific needs of a touch-enabled
 *                               environment and provide users with a richer
 *                               touch-enabled experience. You can also handle
 *                               both events, separately, to provide a
 *                               different response for a touch event than a
 *                               mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event gestureZoom            Dispatched when the user performs a zoom
 *                               gesture at a point of contact with an
 *                               InteractiveObject instance(such as touching
 *                               two fingers to a screen and then quickly
 *                               spreading the fingers apart over a display
 *                               object on a mobile phone or tablet with a
 *                               touch screen). Moving fingers apart is a
 *                               common zoom gesture, but each device and
 *                               operating system can have its own
 *                               requirements to indicate zoom. Some devices
 *                               might also interpret this contact as a
 *                               combination of several mouse events, as well.
 *
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, and then moves the
 *                               fingers apart, the InteractiveObject instance
 *                               can dispatch a <code>mouseOver</code> event
 *                               and a <code>click</code> event(among
 *                               others), in addition to the
 *                               <code>gestureZoom</code> event, or all if the
 *                               current environment supports it. Choose how
 *                               you want to handle the user interaction. Use
 *                               the flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseOver</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>gestureZoom</code> event, you can
 *                               design your event handler to respond to the
 *                               specific needs of a touch-enabled environment
 *                               and provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p>When handling the properties of the event
 *                               object, note that the <code>localX</code> and
 *                               <code>localY</code> properties are set to the
 *                               primary point of contact. The
 *                               <code>offsetX</code> and <code>offsetY</code>
 *                               properties are the distance to the point of
 *                               contact where the zoom gesture is
 *                               complete.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event imeStartComposition    This event is dispatched to any client app
 *                               that supports inline input with an IME
 * @event keyDown                Dispatched when the user presses a key.
 *                               Mappings between keys and specific characters
 *                               vary by device and operating system. This
 *                               event type is generated after such a mapping
 *                               occurs but before the processing of an input
 *                               method editor(IME). IMEs are used to enter
 *                               characters, such as Chinese ideographs, that
 *                               the standard QWERTY keyboard is ill-equipped
 *                               to produce. This event occurs before the
 *                               <code>keyUp</code> event.
 *
 *                               <p>In AIR, canceling this event prevents the
 *                               character from being entered into a text
 *                               field.</p>
 * @event keyFocusChange         Dispatched when the user attempts to change
 *                               focus by using keyboard navigation. The
 *                               default behavior of this event is to change
 *                               the focus and dispatch the corresponding
 *                               <code>focusIn</code> and
 *                               <code>focusOut</code> events.
 *
 *                               <p>This event is dispatched to the object
 *                               that currently has focus. The related object
 *                               for this event is the InteractiveObject
 *                               instance that receives focus if you do not
 *                               prevent the default behavior. You can prevent
 *                               the change in focus by calling the
 *                               <code>preventDefault()</code> method in an
 *                               event listener that is properly registered
 *                               with the target object. Focus changes and
 *                               <code>focusIn</code> and
 *                               <code>focusOut</code> events are dispatched
 *                               by default.</p>
 * @event keyUp                  Dispatched when the user releases a key.
 *                               Mappings between keys and specific characters
 *                               vary by device and operating system. This
 *                               event type is generated after such a mapping
 *                               occurs but before the processing of an input
 *                               method editor(IME). IMEs are used to enter
 *                               characters, such as Chinese ideographs, that
 *                               the standard QWERTY keyboard is ill-equipped
 *                               to produce. This event occurs after a
 *                               <code>keyDown</code> event and has the
 *                               following characteristics:
 * @event middleClick            Dispatched when a user presses and releases
 *                               the middle button of the user's pointing
 *                               device over the same InteractiveObject. For a
 *                               <code>middleClick</code> event to occur, it
 *                               must always follow this series of events in
 *                               the order of occurrence:
 *                               <code>middleMouseDown</code> event, then
 *                               <code>middleMouseUp</code>. The target object
 *                               must be identical for both of these events;
 *                               otherwise the <code>middleClick</code> event
 *                               does not occur. Any number of other mouse
 *                               events can occur at any time between the
 *                               <code>middleMouseDown</code> or
 *                               <code>middleMouseUp</code> events; the
 *                               <code>middleClick</code> event still occurs.
 * @event middleMouseDown        Dispatched when a user presses the middle
 *                               pointing device button over an
 *                               InteractiveObject instance.
 * @event middleMouseUp          Dispatched when a user releases the pointing
 *                               device button over an InteractiveObject
 *                               instance.
 * @event mouseDown              Dispatched when a user presses the pointing
 *                               device button over an InteractiveObject
 *                               instance. If the target is a SimpleButton
 *                               instance, the SimpleButton instance displays
 *                               the <code>downState</code> display object as
 *                               the default behavior. If the target is a
 *                               selectable text field, the text field begins
 *                               selection as the default behavior.
 * @event mouseFocusChange       Dispatched when the user attempts to change
 *                               focus by using a pointer device. The default
 *                               behavior of this event is to change the focus
 *                               and dispatch the corresponding
 *                               <code>focusIn</code> and
 *                               <code>focusOut</code> events.
 *
 *                               <p>This event is dispatched to the object
 *                               that currently has focus. The related object
 *                               for this event is the InteractiveObject
 *                               instance that receives focus if you do not
 *                               prevent the default behavior. You can prevent
 *                               the change in focus by calling
 *                               <code>preventDefault()</code> in an event
 *                               listener that is properly registered with the
 *                               target object. The <code>shiftKey</code>
 *                               property is not used. Focus changes and
 *                               <code>focusIn</code> and
 *                               <code>focusOut</code> events are dispatched
 *                               by default.</p>
 * @event mouseMove              Dispatched when a user moves the pointing
 *                               device while it is over an InteractiveObject.
 *                               If the target is a text field that the user
 *                               is selecting, the selection is updated as the
 *                               default behavior.
 * @event mouseOut               Dispatched when the user moves a pointing
 *                               device away from an InteractiveObject
 *                               instance. The event target is the object
 *                               previously under the pointing device. The
 *                               <code>relatedObject</code> is the object the
 *                               pointing device has moved to. If the target
 *                               is a SimpleButton instance, the button
 *                               displays the <code>upState</code> display
 *                               object as the default behavior.
 *
 *                               <p>The <code>mouseOut</code> event is
 *                               dispatched each time the mouse leaves the
 *                               area of any child object of the display
 *                               object container, even if the mouse remains
 *                               over another child object of the display
 *                               object container. This is different behavior
 *                               than the purpose of the <code>rollOut</code>
 *                               event, which is to simplify the coding of
 *                               rollover behaviors for display object
 *                               containers with children. When the mouse
 *                               leaves the area of a display object or the
 *                               area of any of its children to go to an
 *                               object that is not one of its children, the
 *                               display object dispatches the
 *                               <code>rollOut</code> event.The
 *                               <code>rollOut</code> events are dispatched
 *                               consecutively up the parent chain of the
 *                               object, starting with the object and ending
 *                               with the highest parent that is neither the
 *                               root nor an ancestor of the
 *                               <code>relatedObject</code>.</p>
 * @event mouseOver              Dispatched when the user moves a pointing
 *                               device over an InteractiveObject instance.
 *                               The <code>relatedObject</code> is the object
 *                               that was previously under the pointing
 *                               device. If the target is a SimpleButton
 *                               instance, the object displays the
 *                               <code>overState</code> or
 *                               <code>upState</code> display object,
 *                               depending on whether the mouse button is
 *                               down, as the default behavior.
 *
 *                               <p>The <code>mouseOver</code> event is
 *                               dispatched each time the mouse enters the
 *                               area of any child object of the display
 *                               object container, even if the mouse was
 *                               already over another child object of the
 *                               display object container. This is different
 *                               behavior than the purpose of the
 *                               <code>rollOver</code> event, which is to
 *                               simplify the coding of rollout behaviors for
 *                               display object containers with children. When
 *                               the mouse enters the area of a display object
 *                               or the area of any of its children from an
 *                               object that is not one of its children, the
 *                               display object dispatches the
 *                               <code>rollOver</code> event. The
 *                               <code>rollOver</code> events are dispatched
 *                               consecutively down the parent chain of the
 *                               object, starting with the highest parent that
 *                               is neither the root nor an ancestor of the
 *                               <code>relatedObject</code> and ending with
 *                               the object.</p>
 * @event mouseUp                Dispatched when a user releases the pointing
 *                               device button over an InteractiveObject
 *                               instance. If the target is a SimpleButton
 *                               instance, the object displays the
 *                               <code>upState</code> display object. If the
 *                               target is a selectable text field, the text
 *                               field ends selection as the default behavior.
 * @event mouseWheel             Dispatched when a mouse wheel is spun over an
 *                               InteractiveObject instance. If the target is
 *                               a text field, the text scrolls as the default
 *                               behavior. Only available on Microsoft Windows
 *                               operating systems.
 * @event nativeDragComplete     Dispatched by the drag initiator
 *                               InteractiveObject when the user releases the
 *                               drag gesture.
 *
 *                               <p>The event's dropAction property indicates
 *                               the action set by the drag target object; a
 *                               value of "none"
 *                              (<code>DragActions.NONE</code>) indicates
 *                               that the drop was canceled or was not
 *                               accepted.</p>
 *
 *                               <p>The <code>nativeDragComplete</code> event
 *                               handler is a convenient place to update the
 *                               state of the initiating display object, for
 *                               example, by removing an item from a list(on
 *                               a drag action of "move"), or by changing the
 *                               visual properties.</p>
 * @event nativeDragDrop         Dispatched by the target InteractiveObject
 *                               when a dragged object is dropped on it and
 *                               the drop has been accepted with a call to
 *                               DragManager.acceptDragDrop().
 *
 *                               <p>Access the dropped data using the event
 *                               object <code>clipboard</code> property.</p>
 *
 *                               <p>The handler for this event should set the
 *                               <code>DragManager.dropAction</code> property
 *                               to provide feedback to the initiator object
 *                               about which drag action was taken. If no
 *                               value is set, the DragManager will select a
 *                               default value from the list of allowed
 *                               actions.</p>
 * @event nativeDragEnter        Dispatched by an InteractiveObject when a
 *                               drag gesture enters its boundary.
 *
 *                               <p>Handle either the
 *                               <code>nativeDragEnter</code> or
 *                               <code>nativeDragOver</code> events to allow
 *                               the display object to become the drop
 *                               target.</p>
 *
 *                               <p>To determine whether the dispatching
 *                               display object can accept the drop, check the
 *                               suitability of the data in
 *                               <code>clipboard</code> property of the event
 *                               object, and the allowed drag actions in the
 *                               <code>allowedActions</code> property.</p>
 * @event nativeDragExit         Dispatched by an InteractiveObject when a
 *                               drag gesture leaves its boundary.
 * @event nativeDragOver         Dispatched by an InteractiveObject
 *                               continually while a drag gesture remains
 *                               within its boundary.
 *
 *                               <p><code>nativeDragOver</code> events are
 *                               dispatched whenever the mouse is moved. On
 *                               Windows and Mac, they are also dispatched on
 *                               a short timer interval even when the mouse
 *                               has not moved.</p>
 *
 *                               <p>Handle either the
 *                               <code>nativeDragOver</code> or
 *                               <code>nativeDragEnter</code> events to allow
 *                               the display object to become the drop
 *                               target.</p>
 *
 *                               <p>To determine whether the dispatching
 *                               display object can accept the drop, check the
 *                               suitability of the data in
 *                               <code>clipboard</code> property of the event
 *                               object, and the allowed drag actions in the
 *                               <code>allowedActions</code> property.</p>
 * @event nativeDragStart        Dispatched at the beginning of a drag
 *                               operation by the InteractiveObject that is
 *                               specified as the drag initiator in the
 *                               DragManager.doDrag() call.
 * @event nativeDragUpdate       Dispatched during a drag operation by the
 *                               InteractiveObject that is specified as the
 *                               drag initiator in the DragManager.doDrag()
 *                               call.
 *
 *                               <p><code>nativeDragUpdate</code> events are
 *                               not dispatched on Linux.</p>
 * @event paste                  Dispatched when the user activates the
 *                               platform-specific accelerator key combination
 *                               for a paste operation or selects 'Paste' from
 *                               the text context menu. This event is
 *                               dispatched to the object that currently has
 *                               focus. If the object that currently has focus
 *                               is a TextField, the default behavior of this
 *                               event is to cause the contents of the
 *                               clipboard to be pasted into the text field at
 *                               the current insertion point replacing any
 *                               currently selected text in the text field.
 * @event rightClick             Dispatched when a user presses and releases
 *                               the right button of the user's pointing
 *                               device over the same InteractiveObject. For a
 *                               <code>rightClick</code> event to occur, it
 *                               must always follow this series of events in
 *                               the order of occurrence:
 *                               <code>rightMouseDown</code> event, then
 *                               <code>rightMouseUp</code>. The target object
 *                               must be identical for both of these events;
 *                               otherwise the <code>rightClick</code> event
 *                               does not occur. Any number of other mouse
 *                               events can occur at any time between the
 *                               <code>rightMouseDown</code> or
 *                               <code>rightMouseUp</code> events; the
 *                               <code>rightClick</code> event still occurs.
 * @event rightMouseDown         Dispatched when a user presses the pointing
 *                               device button over an InteractiveObject
 *                               instance.
 * @event rightMouseUp           Dispatched when a user releases the pointing
 *                               device button over an InteractiveObject
 *                               instance.
 * @event rollOut                Dispatched when the user moves a pointing
 *                               device away from an InteractiveObject
 *                               instance. The event target is the object
 *                               previously under the pointing device or a
 *                               parent of that object. The
 *                               <code>relatedObject</code> is the object that
 *                               the pointing device has moved to. The
 *                               <code>rollOut</code> events are dispatched
 *                               consecutively up the parent chain of the
 *                               object, starting with the object and ending
 *                               with the highest parent that is neither the
 *                               root nor an ancestor of the
 *                               <code>relatedObject</code>.
 *
 *                               <p>The purpose of the <code>rollOut</code>
 *                               event is to simplify the coding of rollover
 *                               behaviors for display object containers with
 *                               children. When the mouse leaves the area of a
 *                               display object or the area of any of its
 *                               children to go to an object that is not one
 *                               of its children, the display object
 *                               dispatches the <code>rollOut</code> event.
 *                               This is different behavior than that of the
 *                               <code>mouseOut</code> event, which is
 *                               dispatched each time the mouse leaves the
 *                               area of any child object of the display
 *                               object container, even if the mouse remains
 *                               over another child object of the display
 *                               object container.</p>
 * @event rollOver               Dispatched when the user moves a pointing
 *                               device over an InteractiveObject instance.
 *                               The event target is the object under the
 *                               pointing device or a parent of that object.
 *                               The <code>relatedObject</code> is the object
 *                               that was previously under the pointing
 *                               device. The <code>rollOver</code> events are
 *                               dispatched consecutively down the parent
 *                               chain of the object, starting with the
 *                               highest parent that is neither the root nor
 *                               an ancestor of the <code>relatedObject</code>
 *                               and ending with the object.
 *
 *                               <p>The purpose of the <code>rollOver</code>
 *                               event is to simplify the coding of rollout
 *                               behaviors for display object containers with
 *                               children. When the mouse enters the area of a
 *                               display object or the area of any of its
 *                               children from an object that is not one of
 *                               its children, the display object dispatches
 *                               the <code>rollOver</code> event. This is
 *                               different behavior than that of the
 *                               <code>mouseOver</code> event, which is
 *                               dispatched each time the mouse enters the
 *                               area of any child object of the display
 *                               object container, even if the mouse was
 *                               already over another child object of the
 *                               display object container. </p>
 * @event selectAll              Dispatched when the user activates the
 *                               platform-specific accelerator key combination
 *                               for a select all operation or selects 'Select
 *                               All' from the text context menu. This event
 *                               is dispatched to the object that currently
 *                               has focus. If the object that currently has
 *                               focus is a TextField, the default behavior of
 *                               this event is to cause all the contents of
 *                               the text field to be selected.
 * @event softKeyboardActivate   Dispatched immediately after the soft
 *                               keyboard is raised.
 * @event softKeyboardActivating Dispatched immediately before the soft
 *                               keyboard is raised.
 * @event softKeyboardDeactivate Dispatched immediately after the soft
 *                               keyboard is lowered.
 * @event tabChildrenChange      Dispatched when the value of the object's
 *                               <code>tabChildren</code> flag changes.
 * @event tabEnabledChange       Dispatched when the object's
 *                               <code>tabEnabled</code> flag changes.
 * @event tabIndexChange         Dispatched when the value of the object's
 *                               <code>tabIndex</code> property changes.
 * @event textInput              Dispatched when a user enters one or more
 *                               characters of text. Various text input
 *                               methods can generate this event, including
 *                               standard keyboards, input method editors
 *                              (IMEs), voice or speech recognition systems,
 *                               and even the act of pasting plain text with
 *                               no formatting or style information.
 * @event touchBegin             Dispatched when the user first contacts a
 *                               touch-enabled device(such as touches a
 *                               finger to a mobile phone or tablet with a
 *                               touch screen). Some devices might also
 *                               interpret this contact as a
 *                               <code>mouseDown</code> event.
 *
 *                               <p>Specifically, if a user touches a finger
 *                               to a touch screen, the InteractiveObject
 *                               instance can dispatch a
 *                               <code>mouseDown</code> event or a
 *                               <code>touchBegin</code> event, or both if the
 *                               current environment supports it. Choose how
 *                               you want to handle the user interaction. Use
 *                               the flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseDown</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>touchBegin</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchEnd               Dispatched when the user removes contact with
 *                               a touch-enabled device(such as lifts a
 *                               finger off a mobile phone or tablet with a
 *                               touch screen). Some devices might also
 *                               interpret this contact as a
 *                               <code>mouseUp</code> event.
 *
 *                               <p>Specifically, if a user lifts a finger
 *                               from a touch screen, the InteractiveObject
 *                               instance can dispatch a <code>mouseUp</code>
 *                               event or a <code>touchEnd</code> event, or
 *                               both if the current environment supports it.
 *                               Choose how you want to handle the user
 *                               interaction. Use the flash.ui.Multitouch
 *                               class to manage touch event handling(enable
 *                               touch gesture event handling, simple touch
 *                               point event handling, or disable touch events
 *                               so only mouse events are dispatched). If you
 *                               choose to handle the <code>mouseUp</code>
 *                               event, then the same event handler will run
 *                               on a touch-enabled device and a mouse enabled
 *                               device. However, if you choose to handle the
 *                               <code>touchEnd</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchMove              Dispatched when the user moves the point of
 *                               contact with a touch-enabled device(such as
 *                               drags a finger across a mobile phone or
 *                               tablet with a touch screen). Some devices
 *                               might also interpret this contact as a
 *                               <code>mouseMove</code> event.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               across a touch screen, the InteractiveObject
 *                               instance can dispatch a
 *                               <code>mouseMove</code> event or a
 *                               <code>touchMove</code> event, or both if the
 *                               current environment supports it. Choose how
 *                               you want to handle the user interaction. Use
 *                               the flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseMove</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>touchMove</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchOut               Dispatched when the user moves the point of
 *                               contact away from InteractiveObject instance
 *                               on a touch-enabled device(such as drags a
 *                               finger from one display object to another on
 *                               a mobile phone or tablet with a touch
 *                               screen). Some devices might also interpret
 *                               this contact as a <code>mouseOut</code>
 *                               event.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               across a touch screen, the InteractiveObject
 *                               instance can dispatch a <code>mouseOut</code>
 *                               event or a <code>touchOut</code> event, or
 *                               both if the current environment supports it.
 *                               Choose how you want to handle the user
 *                               interaction. Use the flash.ui.Multitouch
 *                               class to manage touch event handling(enable
 *                               touch gesture event handling, simple touch
 *                               point event handling, or disable touch events
 *                               so only mouse events are dispatched). If you
 *                               choose to handle the <code>mouseOut</code>
 *                               event, then the same event handler will run
 *                               on a touch-enabled device and a mouse enabled
 *                               device. However, if you choose to handle the
 *                               <code>touchOut</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchOver              Dispatched when the user moves the point of
 *                               contact over an InteractiveObject instance on
 *                               a touch-enabled device(such as drags a
 *                               finger from a point outside a display object
 *                               to a point over a display object on a mobile
 *                               phone or tablet with a touch screen). Some
 *                               devices might also interpret this contact as
 *                               a <code>mouseOver</code> event.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, the
 *                               InteractiveObject instance can dispatch a
 *                               <code>mouseOver</code> event or a
 *                               <code>touchOver</code> event, or both if the
 *                               current environment supports it. Choose how
 *                               you want to handle the user interaction. Use
 *                               the flash.ui.Multitouch class to manage touch
 *                               event handling(enable touch gesture event
 *                               handling, simple touch point event handling,
 *                               or disable touch events so only mouse events
 *                               are dispatched). If you choose to handle the
 *                               <code>mouseOver</code> event, then the same
 *                               event handler will run on a touch-enabled
 *                               device and a mouse enabled device. However,
 *                               if you choose to handle the
 *                               <code>touchOver</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchRollOut           Dispatched when the user moves the point of
 *                               contact away from an InteractiveObject
 *                               instance on a touch-enabled device(such as
 *                               drags a finger from over a display object to
 *                               a point outside the display object on a
 *                               mobile phone or tablet with a touch screen).
 *                               Some devices might also interpret this
 *                               contact as a <code>rollOut</code> event.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, the
 *                               InteractiveObject instance can dispatch a
 *                               <code>rollOut</code> event or a
 *                               <code>touchRollOut</code> event, or both if
 *                               the current environment supports it. Choose
 *                               how you want to handle the user interaction.
 *                               Use the flash.ui.Multitouch class to manage
 *                               touch event handling(enable touch gesture
 *                               event handling, simple touch point event
 *                               handling, or disable touch events so only
 *                               mouse events are dispatched). If you choose
 *                               to handle the <code>rollOut</code> event,
 *                               then the same event handler will run on a
 *                               touch-enabled device and a mouse enabled
 *                               device. However, if you choose to handle the
 *                               <code>touchRollOut</code> event, you can
 *                               design your event handler to respond to the
 *                               specific needs of a touch-enabled environment
 *                               and provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchRollOver          Dispatched when the user moves the point of
 *                               contact over an InteractiveObject instance on
 *                               a touch-enabled device(such as drags a
 *                               finger from a point outside a display object
 *                               to a point over a display object on a mobile
 *                               phone or tablet with a touch screen). Some
 *                               devices might also interpret this contact as
 *                               a <code>rollOver</code> event.
 *
 *                               <p>Specifically, if a user moves a finger
 *                               over an InteractiveObject, the
 *                               InteractiveObject instance can dispatch a
 *                               <code>rollOver</code> event or a
 *                               <code>touchRollOver</code> event, or both if
 *                               the current environment supports it. Choose
 *                               how you want to handle the user interaction.
 *                               Use the flash.ui.Multitouch class to manage
 *                               touch event handling(enable touch gesture
 *                               event handling, simple touch point event
 *                               handling, or disable touch events so only
 *                               mouse events are dispatched). If you choose
 *                               to handle the <code>rollOver</code> event,
 *                               then the same event handler will run on a
 *                               touch-enabled device and a mouse enabled
 *                               device. However, if you choose to handle the
 *                               <code>touchRollOver</code> event, you can
 *                               design your event handler to respond to the
 *                               specific needs of a touch-enabled environment
 *                               and provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 * @event touchTap               Dispatched when the user lifts the point of
 *                               contact over the same InteractiveObject
 *                               instance on which the contact was initiated
 *                               on a touch-enabled device(such as presses
 *                               and releases a finger from a single point
 *                               over a display object on a mobile phone or
 *                               tablet with a touch screen). Some devices
 *                               might also interpret this contact as a
 *                               <code>click</code> event.
 *
 *                               <p>Specifically, if a user taps a finger over
 *                               an InteractiveObject, the InteractiveObject
 *                               instance can dispatch a <code>click</code>
 *                               event or a <code>touchTap</code> event, or
 *                               both if the current environment supports it.
 *                               Choose how you want to handle the user
 *                               interaction. Use the flash.ui.Multitouch
 *                               class to manage touch event handling(enable
 *                               touch gesture event handling, simple touch
 *                               point event handling, or disable touch events
 *                               so only mouse events are dispatched). If you
 *                               choose to handle the <code>click</code>
 *                               event, then the same event handler will run
 *                               on a touch-enabled device and a mouse enabled
 *                               device. However, if you choose to handle the
 *                               <code>touchTap</code> event, you can design
 *                               your event handler to respond to the specific
 *                               needs of a touch-enabled environment and
 *                               provide users with a richer touch-enabled
 *                               experience. You can also handle both events,
 *                               separately, to provide a different response
 *                               for a touch event than a mouse event.</p>
 *
 *                               <p><b>Note:</b> See the Multitouch class for
 *                               environment compatibility information.</p>
 */
extern class InteractiveObject extends DisplayObject {

	/**
	 * The current accessibility implementation(AccessibilityImplementation) for
	 * this InteractiveObject instance.
	 */
	#if !display
	var accessibilityImplementation : flash.accessibility.AccessibilityImplementation;
	#end

	/**
	 * Specifies the context menu associated with this object.
	 *
	 * <p>For content running in Flash Player, this property is a ContextMenu
	 * object. In the AIR runtime, the ContextMenu class extends the NativeMenu
	 * class, however Flash Player only supports the ContextMenu class, not the
	 * NativeMenu class. </p>
	 *
	 * <p><b>Note:</b> TextField objects always include a clipboard menu in the
	 * context menu. The clipboard menu contains Cut, Copy, Paste, Clear, and
	 * Select All commands. You cannot remove these commands from the context
	 * menu for TextField objects. For TextField objects, selecting these
	 * commands(or their keyboard equivalents) does not generate
	 * <code>clear</code>, <code>copy</code>, <code>cut</code>,
	 * <code>paste</code>, or <code>selectAll</code> events.</p>
	 */
	#if !display
	var contextMenu : flash.ui.ContextMenu;
	#end

	/**
	 * Specifies whether the object receives <code>doubleClick</code> events. The
	 * default value is <code>false</code>, which means that by default an
	 * InteractiveObject instance does not receive <code>doubleClick</code>
	 * events. If the <code>doubleClickEnabled</code> property is set to
	 * <code>true</code>, the instance receives <code>doubleClick</code> events
	 * within its bounds. The <code>mouseEnabled</code> property of the
	 * InteractiveObject instance must also be set to <code>true</code> for the
	 * object to receive <code>doubleClick</code> events.
	 *
	 * <p>No event is dispatched by setting this property. You must use the
	 * <code>addEventListener()</code> method to add an event listener for the
	 * <code>doubleClick</code> event.</p>
	 */
	var doubleClickEnabled : Bool;

	/**
	 * Specifies whether this object displays a focus rectangle. It can take one
	 * of three values: <code>true</code>, <code>false</code>, or
	 * <code>null</code>. Values of <code>true</code> and <code>false</code> work
	 * as expected, specifying whether or not the focus rectangle appears. A
	 * value of <code>null</code> indicates that this object obeys the
	 * <code>stageFocusRect</code> property of the Stage.
	 */
	var focusRect : Dynamic;

	/**
	 * Specifies whether this object receives mouse, or other user input,
	 * messages. The default value is <code>true</code>, which means that by
	 * default any InteractiveObject instance that is on the display list
	 * receives mouse events or other user input events. If
	 * <code>mouseEnabled</code> is set to <code>false</code>, the instance does
	 * not receive any mouse events(or other user input events like keyboard
	 * events). Any children of this instance on the display list are not
	 * affected. To change the <code>mouseEnabled</code> behavior for all
	 * children of an object on the display list, use
	 * <code>flash.display.DisplayObjectContainer.mouseChildren</code>.
	 *
	 * <p> No event is dispatched by setting this property. You must use the
	 * <code>addEventListener()</code> method to create interactive
	 * functionality.</p>
	 */
	var mouseEnabled : Bool;

	/**
	 * Specifies whether a virtual keyboard(an on-screen, software keyboard)
	 * should display when this InteractiveObject instance receives focus.
	 *
	 * <p>By default, the value is <code>false</code> and focusing an
	 * InteractiveObject instance does not raise a soft keyboard. If the
	 * <code>needsSoftKeyboard</code> property is set to <code>true</code>, the
	 * runtime raises a soft keyboard when the InteractiveObject instance is
	 * ready to accept user input. An InteractiveObject instance is ready to
	 * accept user input after a programmatic call to set the Stage
	 * <code>focus</code> property or a user interaction, such as a "tap." If the
	 * client system has a hardware keyboard available or does not support
	 * virtual keyboards, then the soft keyboard is not raised.</p>
	 *
	 * <p>The InteractiveObject instance dispatches
	 * <code>softKeyboardActivating</code>, <code>softKeyboardActivate</code>,
	 * and <code>softKeyboardDeactivate</code> events when the soft keyboard
	 * raises and lowers.</p>
	 *
	 * <p><b>Note:</b> This property is not supported in AIR applications on
	 * iOS.</p>
	 */
	@:require(flash11) var needsSoftKeyboard : Bool;

	/**
	 * Defines the area that should remain on-screen when a soft keyboard is
	 * displayed.
	 *
	 * <p>If the <code>needsSoftKeyboard</code> property of this
	 * InteractiveObject is <code>true</code>, then the runtime adjusts the
	 * display as needed to keep the object in view while the user types.
	 * Ordinarily, the runtime uses the object bounds obtained from the
	 * <code>DisplayObject.getBounds()</code> method. You can specify a different
	 * area using this <code>softKeyboardInputAreaOfInterest</code> property.</p>
	 *
	 * <p>Specify the <code>softKeyboardInputAreaOfInterest</code> in stage
	 * coordinates.</p>
	 *
	 * <p><b>Note:</b> On Android, the
	 * <code>softKeyboardInputAreaOfInterest</code> is not respected in landscape
	 * orientations.</p>
	 */
	@:require(flash11) var softKeyboardInputAreaOfInterest : flash.geom.Rectangle;

	/**
	 * Specifies whether this object is in the tab order. If this object is in
	 * the tab order, the value is <code>true</code>; otherwise, the value is
	 * <code>false</code>. By default, the value is <code>false</code>, except
	 * for the following:
	 * <ul>
	 *   <li>For a SimpleButton object, the value is <code>true</code>.</li>
	 *   <li>For a TextField object with <code>type = "input"</code>, the value
	 * is <code>true</code>.</li>
	 *   <li>For a Sprite object or MovieClip object with <code>buttonMode =
	 * true</code>, the value is <code>true</code>.</li>
	 * </ul>
	 */
	var tabEnabled : Bool;

	/**
	 * Specifies the tab ordering of objects in a SWF file. The
	 * <code>tabIndex</code> property is -1 by default, meaning no tab index is
	 * set for the object.
	 *
	 * <p>If any currently displayed object in the SWF file contains a
	 * <code>tabIndex</code> property, automatic tab ordering is disabled, and
	 * the tab ordering is calculated from the <code>tabIndex</code> properties
	 * of objects in the SWF file. The custom tab ordering includes only objects
	 * that have <code>tabIndex</code> properties.</p>
	 *
	 * <p>The <code>tabIndex</code> property can be a non-negative integer. The
	 * objects are ordered according to their <code>tabIndex</code> properties,
	 * in ascending order. An object with a <code>tabIndex</code> value of 1
	 * precedes an object with a <code>tabIndex</code> value of 2. Do not use the
	 * same <code>tabIndex</code> value for multiple objects.</p>
	 *
	 * <p>The custom tab ordering that the <code>tabIndex</code> property defines
	 * is <i>flat</i>. This means that no attention is paid to the hierarchical
	 * relationships of objects in the SWF file. All objects in the SWF file with
	 * <code>tabIndex</code> properties are placed in the tab order, and the tab
	 * order is determined by the order of the <code>tabIndex</code> values. </p>
	 *
	 * <p><b>Note:</b> To set the tab order for TLFTextField instances, cast the
	 * display object child of the TLFTextField as an InteractiveObject, then set
	 * the <code>tabIndex</code> property. For example: <pre
	 * xml:space="preserve">
	 * InteractiveObject(tlfInstance.getChildAt(1)).tabIndex = 3; </pre> To
	 * reverse the tab order from the default setting for three instances of a
	 * TLFTextField object(<code>tlfInstance1</code>, <code>tlfInstance2</code>
	 * and <code>tlfInstance3</code>), use: <pre xml:space="preserve">
	 * InteractiveObject(tlfInstance1.getChildAt(1)).tabIndex = 3;
	 * InteractiveObject(tlfInstance2.getChildAt(1)).tabIndex = 2;
	 * InteractiveObject(tlfInstance3.getChildAt(1)).tabIndex = 1; </pre> </p>
	 */
	var tabIndex : Int;

	/**
	 * Calling the <code>new InteractiveObject()</code> constructor throws an
	 * <code>ArgumentError</code> exception. You can, however, call constructors
	 * for the following subclasses of InteractiveObject:
	 * <ul>
	 *   <li><code>new SimpleButton()</code></li>
	 *   <li><code>new TextField()</code></li>
	 *   <li><code>new Loader()</code></li>
	 *   <li><code>new Sprite()</code></li>
	 *   <li><code>new MovieClip()</code></li>
	 * </ul>
	 */
	function new() : Void;

	/**
	 * Raises a virtual keyboard.
	 *
	 * <p>Calling this method focuses the InteractiveObject instance and raises
	 * the soft keyboard, if necessary. The <code>needsSoftKeyboard</code> must
	 * also be <code>true</code>. A keyboard is not raised if a hardware keyboard
	 * is available, or if the client system does not support virtual
	 * keyboards.</p>
	 *
	 * <p><b>Note:</b> This method is not supported in AIR applications on
	 * iOS.</p>
	 * 
	 * @return A value of <code>true</code> means that the soft keyboard request
	 *         was granted; <code>false</code> means that the soft keyboard was
	 *         not raised.
	 */
	@:require(flash11) function requestSoftKeyboard() : Bool;
}


#end
