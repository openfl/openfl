package openfl.display; #if (display || !flash)


/**
 * This class is used to create lightweight shapes using the ActionScript
 * drawing application program interface(API). The Shape class includes a
 * `graphics` property, which lets you access methods from the
 * Graphics class.
 *
 * The Sprite class also includes a `graphics`property, and it
 * includes other features not available to the Shape class. For example, a
 * Sprite object is a display object container, whereas a Shape object is not
 * (and cannot contain child display objects). For this reason, Shape objects
 * consume less memory than Sprite objects that contain the same graphics.
 * However, a Sprite object supports user input events, while a Shape object
 * does not.
 */
extern class Shape extends DisplayObject {
	
	
	/**
	 * Specifies the Graphics object belonging to this Shape object, where vector
	 * drawing commands can occur.
	 */
	public var graphics (get, never):Graphics;
	
	
	/**
	 * Creates a new Shape object.
	 */
	public function new ();
	
	
}


#else
typedef Shape = flash.display.Shape;
#end