package flash.display;
#if (flash || display)


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
extern class Sprite extends DisplayObjectContainer {

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
	var buttonMode : Bool;

	/**
	 * Specifies the display object over which the sprite is being dragged, or on
	 * which the sprite was dropped.
	 */
	var dropTarget(default,null) : DisplayObject;

	/**
	 * Specifies the Graphics object that belongs to this sprite where vector
	 * drawing commands can occur.
	 */
	var graphics(default,null) : Graphics;

	/**
	 * Designates another sprite to serve as the hit area for a sprite. If the
	 * <code>hitArea</code> property does not exist or the value is
	 * <code>null</code> or <code>undefined</code>, the sprite itself is used as
	 * the hit area. The value of the <code>hitArea</code> property can be a
	 * reference to a Sprite object.
	 *
	 * <p>You can change the <code>hitArea</code> property at any time; the
	 * modified sprite immediately uses the new hit area behavior. The sprite
	 * designated as the hit area does not need to be visible; its graphical
	 * shape, although not visible, is still detected as the hit area.</p>
	 *
	 * <p><b>Note:</b> You must set to <code>false</code> the
	 * <code>mouseEnabled</code> property of the sprite designated as the hit
	 * area. Otherwise, your sprite button might not work because the sprite
	 * designated as the hit area receives the user input events instead of your
	 * sprite button.</p>
	 */
	var hitArea : Sprite;

	/**
	 * Controls sound within this sprite.
	 *
	 * <p><b>Note:</b> This property does not affect HTML content in an
	 * HTMLControl object(in Adobe AIR).</p>
	 */
	var soundTransform : flash.media.SoundTransform;

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
	var useHandCursor : Bool;

	/**
	 * Creates a new Sprite instance. After you create the Sprite instance, call
	 * the <code>DisplayObjectContainer.addChild()</code> or
	 * <code>DisplayObjectContainer.addChildAt()</code> method to add the Sprite
	 * to a parent DisplayObjectContainer.
	 */
	function new() : Void;

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
	function startDrag(lockCenter : Bool = false, ?bounds : flash.geom.Rectangle) : Void;

	/**
	 * Lets the user drag the specified sprite on a touch-enabled device. The
	 * sprite remains draggable until explicitly stopped through a call to the
	 * <code>Sprite.stopTouchDrag()</code> method, or until another sprite is
	 * made draggable. Only one sprite is draggable at a time.
	 *
	 * <p>Three-dimensional display objects follow the pointer and
	 * <code>Sprite.startTouchDrag()</code> moves the object within the
	 * three-dimensional plane defined by the display object. Or, if the display
	 * object is a two-dimensional object and the child of a three-dimensional
	 * object, the two-dimensional object moves within the three dimensional
	 * plane defined by the three-dimensional parent object.</p>
	 * 
	 * @param touchPointID An integer to assign to the touch point.
	 * @param lockCenter   Specifies whether the draggable sprite is locked to
	 *                     the center of the pointer position
	 *                    (<code>true</code>), or locked to the point where the
	 *                     user first clicked the sprite(<code>false</code>).
	 * @param bounds       Value relative to the coordinates of the Sprite's
	 *                     parent that specify a constraint rectangle for the
	 *                     Sprite.
	 */
	@:require(flash10_1) function startTouchDrag(touchPointID : Int, lockCenter : Bool = false, ?bounds : flash.geom.Rectangle) : Void;

	/**
	 * Ends the <code>startDrag()</code> method. A sprite that was made draggable
	 * with the <code>startDrag()</code> method remains draggable until a
	 * <code>stopDrag()</code> method is added, or until another sprite becomes
	 * draggable. Only one sprite is draggable at a time.
	 * 
	 */
	function stopDrag() : Void;

	/**
	 * Ends the <code>startTouchDrag()</code> method, for use with touch-enabled
	 * devices. A sprite that was made draggable with the
	 * <code>startTouchDrag()</code> method remains draggable until a
	 * <code>stopTouchDrag()</code> method is added, or until another sprite
	 * becomes draggable. Only one sprite is draggable at a time.
	 * 
	 * @param touchPointID The integer assigned to the touch point in the
	 *                     <code>startTouchDrag</code> method.
	 */
	@:require(flash10_1) function stopTouchDrag(touchPointID : Int) : Void;
}


#end
