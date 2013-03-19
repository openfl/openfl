package flash.ui;
#if (flash || display)


/**
 * The methods of the Mouse class are used to hide and show the mouse pointer,
 * or to set the pointer to a specific style. The Mouse class is a top-level
 * class whose properties and methods you can access without using a
 * constructor. <ph outputclass="flashonly">The pointer is visible by default,
 * but you can hide it and implement a custom pointer.
 */
extern class Mouse {

	/**
	 * Sets or returns the type of cursor, or, for a native cursor, the cursor
	 * name.
	 *
	 * <p>The default value is <code>flash.ui.MouseCursor.AUTO</code>.</p>
	 *
	 * <p>To set values for this property, use the following string values:</p>
	 *
	 * <p><b>Note:</b> For Flash Player 10.2 or AIR 2.6 and later versions, this
	 * property sets or gets the cursor name when you are using a native cursor.
	 * A native cursor name defined using <code>Mouse.registerCursor()</code>
	 * overwrites currently predefined cursor types(such as
	 * <code>flash.ui.MouseCursor.IBEAM</code>).</p>
	 * 
	 * @throws ArgumentError If set to any value which is not a member of
	 *                       <code>flash.ui.MouseCursor</code>, or is not a
	 *                       string specified using the
	 *                       <code>Mouse.registerCursor()</code> method.
	 */
	@:require(flash10) static var cursor : Dynamic;

	/**
	 * Indicates whether the computer or device displays a persistent cursor.
	 *
	 * <p>The <code>supportsCursor</code> property is <code>true</code> on most
	 * desktop computers and <code>false</code> on most mobile devices.</p>
	 *
	 * <p><b>Note:</b> Mouse events can be dispatched whether or not this
	 * property is <code>true</code>. However, mouse events may behave
	 * differently depending on the physical characteristics of the pointing
	 * device.</p>
	 */
	@:require(flash10_1) static var supportsCursor(default,null) : Bool;

	/**
	 * Indicates whether the current configuration supports native cursors.
	 */
	//@:require(flash11) static var supportsNativeCursor(default,null) : Bool;

	/**
	 * Hides the pointer. The pointer is visible by default.
	 *
	 * <p><b>Note:</b> You need to call <code>Mouse.hide()</code> only once,
	 * regardless of the number of previous calls to
	 * <code>Mouse.show()</code>.</p>
	 * 
	 */
	static function hide() : Void;

	/**
	 * Registers a native cursor under the given name, with the given data.
	 * 
	 * @param name   The name to use as a reference to the native cursor
	 *               instance.
	 * @param cursor The properties for the native cursor, such as icon bitmap,
	 *               specified as a MouseCursorData instance.
	 */
	//@:require(flash10_2) static function registerCursor(name : String, cursor : MouseCursorData) : Void;

	/**
	 * Displays the pointer. The pointer is visible by default.
	 *
	 * <p><b>Note:</b> You need to call <code>Mouse.show()</code> only once,
	 * regardless of the number of previous calls to
	 * <code>Mouse.hide()</code>.</p>
	 * 
	 */
	static function show() : Void;

	/**
	 * Unregisters the native cursor with the given name.
	 * 
	 * @param name The name referring to the native cursor instance.
	 */
	//@:require(flash11) static function unregisterCursor(name : String) : Void;
}


#end
