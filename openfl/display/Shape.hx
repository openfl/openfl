package openfl.display; #if !flash #if !lime_legacy


import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasShape;
import openfl._internal.renderer.dom.DOMShape;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


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
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, __worldTransform);
			
		}
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (visible && __graphics != null && __graphics.__hitTest (x, y, shapeFlag, __getTransform ())) {
			
			if (!interactiveOnly) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasShape.render (this, renderSession);
		
	}
	
	
	@:noCompletion public override function __renderDOM (renderSession:RenderSession):Void {
		
		DOMShape.render (this, renderSession);
		
	}
	
	
	@:noCompletion public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__graphics != null) {
			
			GraphicsRenderer.render (this, renderSession);
			
		}
		
	}
	
	
	@:noCompletion public override function __renderMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics ();
			
		}
		
		return __graphics;
		
	}
	
	
}


#else
typedef Shape = openfl._v2.display.Shape;
#end
#else
typedef Shape = flash.display.Shape;
#end