package openfl.display; #if !flash #if !lime_legacy


import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasShape;
import openfl._internal.renderer.dom.DOMShape;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;


/**
 * The Sprite class is a basic display list building block: a display list
 * node that can display graphics and can also contain children.
 *
 * <p>A Sprite object is similar to a movie clip, but does not have a
 * timeline. Sprite is an appropriate base class for objects that do not
 * require timelines. For example, Sprite would be a logical base class for
 * user interface(UI) components that typically do not use the timeline.</p>
 *
 * <p>The Sprite class is new in ActionScript 3.0. It provides an alternative
 * to the functionality of the MovieClip class, which retains all the
 * functionality of previous ActionScript releases to provide backward
 * compatibility.</p>
 */

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)


class Sprite extends DisplayObjectContainer {
	
	
	/**
	 * Specifies the button mode of this sprite. If <code>true</code>, this
	 * sprite behaves as a button, which means that it triggers the display of
	 * the hand cursor when the pointer passes over the sprite and can receive a
	 * <code>click</code> event if the enter or space keys are pressed when the
	 * sprite has focus. You can suppress the display of the hand cursor by
	 * setting the <code>useHandCursor</code> property to <code>false</code>, in
	 * which case the pointer is displayed.
	 *
	 * <p>Although it is better to use the SimpleButton class to create buttons,
	 * you can use the <code>buttonMode</code> property to give a sprite some
	 * button-like functionality. To include a sprite in the tab order, set the
	 * <code>tabEnabled</code> property(inherited from the InteractiveObject
	 * class and <code>false</code> by default) to <code>true</code>.
	 * Additionally, consider whether you want the children of your sprite to be
	 * user input enabled. Most buttons do not enable user input interactivity
	 * for their child objects because it confuses the event flow. To disable
	 * user input interactivity for all child objects, you must set the
	 * <code>mouseChildren</code> property(inherited from the
	 * DisplayObjectContainer class) to <code>false</code>.</p>
	 *
	 * <p>If you use the <code>buttonMode</code> property with the MovieClip
	 * class(which is a subclass of the Sprite class), your button might have
	 * some added functionality. If you include frames labeled _up, _over, and
	 * _down, Flash Player provides automatic state changes(functionality
	 * similar to that provided in previous versions of ActionScript for movie
	 * clips used as buttons). These automatic state changes are not available
	 * for sprites, which have no timeline, and thus no frames to label. </p>
	 */
	public var buttonMode:Bool;
	
	/**
	 * Specifies the Graphics object that belongs to this sprite where vector
	 * drawing commands can occur.
	 */
	public var graphics (get, null):Graphics;
	
	/**
	 * A Boolean value that indicates whether the pointing hand(hand cursor)
	 * appears when the pointer rolls over a sprite in which the
	 * <code>buttonMode</code> property is set to <code>true</code>. The default
	 * value of the <code>useHandCursor</code> property is <code>true</code>. If
	 * <code>useHandCursor</code> is set to <code>true</code>, the pointing hand
	 * used for buttons appears when the pointer rolls over a button sprite. If
	 * <code>useHandCursor</code> is <code>false</code>, the arrow pointer is
	 * used instead.
	 *
	 * <p>You can change the <code>useHandCursor</code> property at any time; the
	 * modified sprite immediately takes on the new cursor appearance. </p>
	 *
	 * <p><b>Note:</b> In Flex or Flash Builder, if your sprite has child
	 * sprites, you might want to set the <code>mouseChildren</code> property to
	 * <code>false</code>. For example, if you want a hand cursor to appear over
	 * a Flex <mx:Label> control, set the <code>useHandCursor</code> and
	 * <code>buttonMode</code> properties to <code>true</code>, and the
	 * <code>mouseChildren</code> property to <code>false</code>.</p>
	 */
	public var useHandCursor:Bool;
	
	
	/**
	 * Creates a new Sprite instance. After you create the Sprite instance, call
	 * the <code>DisplayObjectContainer.addChild()</code> or
	 * <code>DisplayObjectContainer.addChildAt()</code> method to add the Sprite
	 * to a parent DisplayObjectContainer.
	 */
	public function new () {
		
		super ();
		
		buttonMode = false;
		useHandCursor = true;
		loaderInfo = LoaderInfo.create (null);
		
	}
	
	
	/**
	 * Lets the user drag the specified sprite. The sprite remains draggable
	 * until explicitly stopped through a call to the
	 * <code>Sprite.stopDrag()</code> method, or until another sprite is made
	 * draggable. Only one sprite is draggable at a time.
	 *
	 * <p>Three-dimensional display objects follow the pointer and
	 * <code>Sprite.startDrag()</code> moves the object within the
	 * three-dimensional plane defined by the display object. Or, if the display
	 * object is a two-dimensional object and the child of a three-dimensional
	 * object, the two-dimensional object moves within the three dimensional
	 * plane defined by the three-dimensional parent object.</p>
	 * 
	 * @param lockCenter Specifies whether the draggable sprite is locked to the
	 *                   center of the pointer position(<code>true</code>), or
	 *                   locked to the point where the user first clicked the
	 *                   sprite(<code>false</code>).
	 * @param bounds     Value relative to the coordinates of the Sprite's parent
	 *                   that specify a constraint rectangle for the Sprite.
	 */
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void {
		
		if (stage != null) {
			
			stage.__startDrag (this, lockCenter, bounds);
			
		}
		
	}
	
	
	/**
	 * Ends the <code>startDrag()</code> method. A sprite that was made draggable
	 * with the <code>startDrag()</code> method remains draggable until a
	 * <code>stopDrag()</code> method is added, or until another sprite becomes
	 * draggable. Only one sprite is draggable at a time.
	 * 
	 */
	public function stopDrag ():Void {
		
		if (stage != null) {
			
			stage.__stopDrag (this);
			
		}
		
	}
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		super.__getBounds (rect, matrix);
		
		if (__graphics != null) {
			
			__graphics.__getBounds (rect, matrix != null ? matrix : __worldTransform);
			
		}
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || (interactiveOnly && !mouseEnabled)) return false;
		
		var length = 0;
		
		if (stack != null) {
			
			length = stack.length;
			
		}
		
		if (super.__hitTest (x, y, shapeFlag, stack, interactiveOnly)) {
			
			return interactiveOnly;
			
		} else if (__graphics != null && __graphics.__hitTest (x, y, shapeFlag, __getTransform ())) {
			
			if (stack != null) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion public override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasShape.render (this, renderSession);
		
		super.__renderCanvas (renderSession);
		
	}
	
	
	@:noCompletion public override function __renderDOM (renderSession:RenderSession):Void {
		
		DOMShape.render (this, renderSession);
		
		super.__renderDOM (renderSession);
		
	}
	
	
	@:noCompletion public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__graphics != null) {
			
			GraphicsRenderer.render (this, renderSession);
			//__graphics.__render (renderSession);
			
			/*if (__graphics.__canvas != null) {
				
				
			}*/
			
		}
		
		super.__renderGL (renderSession);
		
	}
	
	
	@:noCompletion public override function __renderMask (renderSession:RenderSession):Void {
		
		if (__graphics != null) {
			
			CanvasGraphics.renderMask (__graphics, renderSession);
			
		} else {
			
			super.__renderMask (renderSession);
			
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
typedef Sprite = openfl._v2.display.Sprite;
#end
#else
typedef Sprite = flash.display.Sprite;
#end