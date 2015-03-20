package openfl.display; #if !flash #if !openfl_legacy


/**
 * This class is used to create lightweight shapes using the ActionScript
 * drawing application program interface(API). The Shape class includes a
 * <code>graphics</code> property, which lets you access methods from the
 * Graphics class.
 *
 * <p>The Sprite class also includes a <code>graphics</code>property, and it
 * includes other features not available to the Shape class. For example, a
 * Sprite object is a display object container, whereas a Shape object is not
 * (and cannot contain child display objects). For this reason, Shape objects
 * consume less memory than Sprite objects that contain the same graphics.
 * However, a Sprite object supports user input events, while a Shape object
 * does not.</p>
 */


class Shape extends DisplayObject {
	
	
	/**
	 * Specifies the Graphics object belonging to this Shape object, where vector
	 * drawing commands can occur.
	 */
	public var graphics (get, null):Graphics;
	
	
	/**
	 * Creates a new Shape object.
	 */
	public function new () {
		
		super ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics ();
			@:privateAccess __graphics.__owner = this;
			
		}
		
		return __graphics;
		
	}
	
	
}


#else
typedef Shape = openfl._legacy.display.Shape;
#end
#else
typedef Shape = flash.display.Shape;
#end