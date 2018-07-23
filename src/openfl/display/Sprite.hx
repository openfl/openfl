package openfl.display; #if !flash


import lime.ui.MouseCursor;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasShape;
import openfl._internal.renderer.dom.DOMShape;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;


/**
 * The Sprite class is a basic display list building block: a display list
 * node that can display graphics and can also contain children.
 *
 * A Sprite object is similar to a movie clip, but does not have a
 * timeline. Sprite is an appropriate base class for objects that do not
 * require timelines. For example, Sprite would be a logical base class for
 * user interface(UI) components that typically do not use the timeline.
 *
 * The Sprite class is new in ActionScript 3.0. It provides an alternative
 * to the functionality of the MovieClip class, which retains all the
 * functionality of previous ActionScript releases to provide backward
 * compatibility.
 */

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.Point)


class Sprite extends DisplayObjectContainer {
	
	
	/**
	 * Specifies the button mode of this sprite. If `true`, this
	 * sprite behaves as a button, which means that it triggers the display of
	 * the hand cursor when the pointer passes over the sprite and can receive a
	 * `click` event if the enter or space keys are pressed when the
	 * sprite has focus. You can suppress the display of the hand cursor by
	 * setting the `useHandCursor` property to `false`, in
	 * which case the pointer is displayed.
	 *
	 * Although it is better to use the SimpleButton class to create buttons,
	 * you can use the `buttonMode` property to give a sprite some
	 * button-like functionality. To include a sprite in the tab order, set the
	 * `tabEnabled` property(inherited from the InteractiveObject
	 * class and `false` by default) to `true`.
	 * Additionally, consider whether you want the children of your sprite to be
	 * user input enabled. Most buttons do not enable user input interactivity
	 * for their child objects because it confuses the event flow. To disable
	 * user input interactivity for all child objects, you must set the
	 * `mouseChildren` property(inherited from the
	 * DisplayObjectContainer class) to `false`.
	 *
	 * If you use the `buttonMode` property with the MovieClip
	 * class(which is a subclass of the Sprite class), your button might have
	 * some added functionality. If you include frames labeled _up, _over, and
	 * _down, Flash Player provides automatic state changes(functionality
	 * similar to that provided in previous versions of ActionScript for movie
	 * clips used as buttons). These automatic state changes are not available
	 * for sprites, which have no timeline, and thus no frames to label. 
	 */
	public var buttonMode (get, set):Bool;
	
	public var dropTarget (default, null):DisplayObject;
	
	/**
	 * Specifies the Graphics object that belongs to this sprite where vector
	 * drawing commands can occur.
	 */
	public var graphics (get, never):Graphics;
	
	public var hitArea:Sprite;
	
	// @:noCompletion @:dox(hide) public var soundTransform:SoundTransform;
	
	/**
	 * A Boolean value that indicates whether the pointing hand(hand cursor)
	 * appears when the pointer rolls over a sprite in which the
	 * `buttonMode` property is set to `true`. The default
	 * value of the `useHandCursor` property is `true`. If
	 * `useHandCursor` is set to `true`, the pointing hand
	 * used for buttons appears when the pointer rolls over a button sprite. If
	 * `useHandCursor` is `false`, the arrow pointer is
	 * used instead.
	 *
	 * You can change the `useHandCursor` property at any time; the
	 * modified sprite immediately takes on the new cursor appearance. 
	 *
	 * **Note:** In Flex or Flash Builder, if your sprite has child
	 * sprites, you might want to set the `mouseChildren` property to
	 * `false`. For example, if you want a hand cursor to appear over
	 * a Flex <mx:Label> control, set the `useHandCursor` and
	 * `buttonMode` properties to `true`, and the
	 * `mouseChildren` property to `false`.
	 */
	public var useHandCursor:Bool;
	
	
	@:noCompletion private var __buttonMode:Bool;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (Sprite.prototype, {
			"buttonMode": { get: untyped __js__ ("function () { return this.get_buttonMode (); }"), set: untyped __js__ ("function (v) { return this.set_buttonMode (v); }") },
			"graphics": { get: untyped __js__ ("function () { return this.get_graphics (); }") },
		});
		
	}
	#end
	
	
	/**
	 * Creates a new Sprite instance. After you create the Sprite instance, call
	 * the `DisplayObjectContainer.addChild()` or
	 * `DisplayObjectContainer.addChildAt()` method to add the Sprite
	 * to a parent DisplayObjectContainer.
	 */
	public function new () {
		
		super ();
		
		__buttonMode = false;
		useHandCursor = true;
		
	}
	
	
	/**
	 * Lets the user drag the specified sprite. The sprite remains draggable
	 * until explicitly stopped through a call to the
	 * `Sprite.stopDrag()` method, or until another sprite is made
	 * draggable. Only one sprite is draggable at a time.
	 *
	 * Three-dimensional display objects follow the pointer and
	 * `Sprite.startDrag()` moves the object within the
	 * three-dimensional plane defined by the display object. Or, if the display
	 * object is a two-dimensional object and the child of a three-dimensional
	 * object, the two-dimensional object moves within the three dimensional
	 * plane defined by the three-dimensional parent object.
	 * 
	 * @param lockCenter Specifies whether the draggable sprite is locked to the
	 *                   center of the pointer position(`true`), or
	 *                   locked to the point where the user first clicked the
	 *                   sprite(`false`).
	 * @param bounds     Value relative to the coordinates of the Sprite's parent
	 *                   that specify a constraint rectangle for the Sprite.
	 */
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void {
		
		if (stage != null) {
			
			stage.__startDrag (this, lockCenter, bounds);
			
		}
		
	}
	
	
	// @:noCompletion @:dox(hide) public function startTouchDrag (touchPointID:Int, lockCenter:Bool = false, bounds:Rectangle = null):Void;
	
	
	/**
	 * Ends the `startDrag()` method. A sprite that was made draggable
	 * with the `startDrag()` method remains draggable until a
	 * `stopDrag()` method is added, or until another sprite becomes
	 * draggable. Only one sprite is draggable at a time.
	 * 
	 */
	public function stopDrag ():Void {
		
		if (stage != null) {
			
			stage.__stopDrag (this);
			
		}
		
	}
	
	
	// @:noCompletion @:dox(hide) public function stopTouchDrag (touchPointID:Int):Void;
	
	
	@:noCompletion private override function __getCursor ():MouseCursor {
		
		return (__buttonMode && useHandCursor) ? POINTER : null;
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (interactiveOnly && !mouseEnabled && !mouseChildren) return false;
		if (!hitObject.visible || __isMask) return __hitTestHitArea (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		if (mask != null && !mask.__hitTestMask (x, y)) return __hitTestHitArea (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		
		if (__scrollRect != null) {
			
			var point = Point.__pool.get ();
			point.setTo (x, y);
			__getRenderTransform ().__transformInversePoint (point);
			
			if (!__scrollRect.containsPoint (point)) {
				
				Point.__pool.release (point);
				return __hitTestHitArea (x, y, shapeFlag, stack, true, hitObject);
				
			}
			
			Point.__pool.release (point);
			
		}
		
		if (super.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {
			
			return interactiveOnly;
			
		} else if (hitArea == null && __graphics != null && __graphics.__hitTest (x, y, shapeFlag, __getRenderTransform ())) {
			
			if (stack != null && (!interactiveOnly || mouseEnabled)) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return __hitTestHitArea (x, y, shapeFlag, stack, interactiveOnly, hitObject);
		
	}
	
	
	@:noCompletion private function __hitTestHitArea (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (hitArea != null) {
			
			if (!hitArea.mouseEnabled) {
				
				hitArea.mouseEnabled = true;
				var hitTest = hitArea.__hitTest (x, y, shapeFlag, null, true, hitObject);
				hitArea.mouseEnabled = false;
				
				if (stack != null && hitTest) {
					
					stack[stack.length] = hitObject;
					
				}
				
				return hitTest;
				
			}
			
		} 
		
		return false;
		
	}
	
	
	@:noCompletion private override function __hitTestMask (x:Float, y:Float):Bool {
		
		if (super.__hitTestMask (x, y)) {
			
			return true;
			
		} else if (__graphics != null && __graphics.__hitTest (x, y, true, __getRenderTransform ())) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_graphics ():Graphics {
		
		if (__graphics == null) {
			
			__graphics = new Graphics (this);
			
		}
		
		return __graphics;
		
	}
	
	
	@:noCompletion private override function get_tabEnabled ():Bool {
		
		return (__tabEnabled == null ? __buttonMode : __tabEnabled);
		
	}
	
	
	@:noCompletion private function get_buttonMode ():Bool {
		
		return __buttonMode;
		
	}
	
	
	@:noCompletion private function set_buttonMode (value:Bool):Bool {
		
		return __buttonMode = value;
		
	}
	
	
}


#else
typedef Sprite = flash.display.Sprite;
#end