package openfl.ui; #if !flash #if !lime_legacy


import lime.ui.Mouse in LimeMouse;
import openfl.Lib;


/**
 * The methods of the Mouse class are used to hide and show the mouse pointer,
 * or to set the pointer to a specific style. The Mouse class is a top-level
 * class whose properties and methods you can access without using a
 * constructor. <ph outputclass="flashonly">The pointer is visible by default,
 * but you can hide it and implement a custom pointer.
 */

@:access(openfl.display.Stage)


class Mouse {
	
	
	/**
	 * Hides the pointer. The pointer is visible by default.
	 *
	 * <p><b>Note:</b> You need to call <code>Mouse.hide()</code> only once,
	 * regardless of the number of previous calls to
	 * <code>Mouse.show()</code>.</p>
	 * 
	 */
	public static function hide ():Void {
		
		LimeMouse.hide ();
		
	}
	
	
	/**
	 * Displays the pointer. The pointer is visible by default.
	 *
	 * <p><b>Note:</b> You need to call <code>Mouse.show()</code> only once,
	 * regardless of the number of previous calls to
	 * <code>Mouse.hide()</code>.</p>
	 * 
	 */
	public static function show ():Void {
		
		LimeMouse.show ();
		
	}
	
	
}


#else
typedef Mouse = openfl._v2.ui.Mouse;
#end
#else
typedef Mouse = flash.ui.Mouse;
#end