package openfl.display; #if !flash #if !openfl_legacy
import openfl._internal.renderer.RenderSession;


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

@:access(openfl.display.Graphics)

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
	
	
	@:noCompletion @:dox(hide) public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (scrollRect != null) {
			
			renderSession.maskManager.pushRect(scrollRect, __renderMatrix);
			
		}
		
		var masked = __mask != null && __maskGraphics != null && __maskGraphics.__commands.length > 0;
		
		if (masked) {
			
			renderSession.maskManager.pushMask (this);
			
		}
		
		super.__renderGL (renderSession);
		
		if (masked) {
			
			renderSession.maskManager.popMask ();
			
		}
		
		if (scrollRect != null) {
			
			renderSession.maskManager.popRect ();
			
		}
		
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