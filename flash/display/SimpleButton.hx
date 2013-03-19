package flash.display;
#if (flash || display)


/**
 * The SimpleButton class lets you control all instances of button symbols in
 * a SWF file.
 *
 * <p>In Flash Professional, you can give a button an instance name in the
 * Property inspector. SimpleButton instance names are displayed in the Movie
 * Explorer and in the Insert Target Path dialog box in the Actions panel.
 * After you create an instance of a button in Flash Professional, you can use
 * the methods and properties of the SimpleButton class to manipulate buttons
 * with ActionScript.</p>
 *
 * <p>In ActionScript 3.0, you use the <code>new SimpleButton()</code>
 * constructor to create a SimpleButton instance.</p>
 *
 * <p>The SimpleButton class inherits from the InteractiveObject class.</p>
 */
extern class SimpleButton extends InteractiveObject {

	/**
	 * Specifies a display object that is used as the visual object for the
	 * button "Down" state  - the state that the button is in when the user
	 * selects the <code>hitTestState</code> object.
	 */
	var downState : DisplayObject;

	/**
	 * A Boolean value that specifies whether a button is enabled. When a button
	 * is disabled(the enabled property is set to <code>false</code>), the
	 * button is visible but cannot be clicked. The default value is
	 * <code>true</code>. This property is useful if you want to disable part of
	 * your navigation; for example, you might want to disable a button in the
	 * currently displayed page so that it can't be clicked and the page cannot
	 * be reloaded.
	 *
	 * <p><b>Note:</b> To prevent mouseClicks on a button, set both the
	 * <code>enabled</code> and <code>mouseEnabled</code> properties to
	 * <code>false</code>.</p>
	 */
	var enabled : Bool;

	/**
	 * Specifies a display object that is used as the hit testing object for the
	 * button. For a basic button, set the <code>hitTestState</code> property to
	 * the same display object as the <code>overState</code> property. If you do
	 * not set the <code>hitTestState</code> property, the SimpleButton is
	 * inactive  -  it does not respond to user input events.
	 */
	var hitTestState : DisplayObject;

	/**
	 * Specifies a display object that is used as the visual object for the
	 * button over state  -  the state that the button is in when the pointer is
	 * positioned over the button.
	 */
	var overState : DisplayObject;

	/**
	 * The SoundTransform object assigned to this button. A SoundTransform object
	 * includes properties for setting volume, panning, left speaker assignment,
	 * and right speaker assignment. This SoundTransform object applies to all
	 * states of the button. This SoundTransform object affects only embedded
	 * sounds.
	 */
	var soundTransform : flash.media.SoundTransform;

	/**
	 * Indicates whether other display objects that are SimpleButton or MovieClip
	 * objects can receive user input release events. The
	 * <code>trackAsMenu</code> property lets you create menus. You can set the
	 * <code>trackAsMenu</code> property on any SimpleButton or MovieClip object.
	 * If the <code>trackAsMenu</code> property does not exist, the default
	 * behavior is <code>false</code>.
	 *
	 * <p>You can change the <code>trackAsMenu</code> property at any time; the
	 * modified button immediately takes on the new behavior. </p>
	 */
	var trackAsMenu : Bool;

	/**
	 * Specifies a display object that is used as the visual object for the
	 * button up state  -  the state that the button is in when the pointer is
	 * not positioned over the button.
	 */
	var upState : DisplayObject;

	/**
	 * A Boolean value that, when set to <code>true</code>, indicates whether the
	 * hand cursor is shown when the pointer rolls over a button. If this
	 * property is set to <code>false</code>, the arrow pointer cursor is
	 * displayed instead. The default is <code>true</code>.
	 *
	 * <p>You can change the <code>useHandCursor</code> property at any time; the
	 * modified button immediately uses the new cursor behavior. </p>
	 */
	var useHandCursor : Bool;

	/**
	 * Creates a new SimpleButton instance. Any or all of the display objects
	 * that represent the various button states can be set as parameters in the
	 * constructor.
	 * 
	 * @param upState      The initial value for the SimpleButton up state.
	 * @param overState    The initial value for the SimpleButton over state.
	 * @param downState    The initial value for the SimpleButton down state.
	 * @param hitTestState The initial value for the SimpleButton hitTest state.
	 */
	function new(?upState : DisplayObject, ?overState : DisplayObject, ?downState : DisplayObject, ?hitTestState : DisplayObject) : Void;
}


#end
