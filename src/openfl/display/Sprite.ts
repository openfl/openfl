import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import MouseCursor from "openfl/ui/MouseCursor";

namespace openfl.display
{
	/**
		The Sprite class is a basic display list building block: a display list
		node that can display graphics and can also contain children.

		A Sprite object is similar to a movie clip, but does not have a
		timeline. Sprite is an appropriate base class for objects that do not
		require timelines. For example, Sprite would be a logical base class for
		user interface(UI) components that typically do not use the timeline.

		The Sprite class is new in ActionScript 3.0. It provides an alternative
		to the functionality of the MovieClip class, which retains all the
		functionality of previous ActionScript releases to provide backward
		compatibility.
	**/
	export class Sprite extends DisplayObjectContainer
	{
		/**
			Specifies the button mode of this sprite. If `true`, this
			sprite behaves as a button, which means that it triggers the display of
			the hand cursor when the pointer passes over the sprite and can receive a
			`click` event if the enter or space keys are pressed when the
			sprite has focus. You can suppress the display of the hand cursor by
			setting the `useHandCursor` property to `false`, in
			which case the pointer is displayed.

			Although it is better to use the SimpleButton class to create buttons,
			you can use the `buttonMode` property to give a sprite some
			button-like functionality. To include a sprite in the tab order, set the
			`tabEnabled` property(inherited from the InteractiveObject
			class and `false` by default) to `true`.
			Additionally, consider whether you want the children of your sprite to be
			user input enabled. Most buttons do not enable user input interactivity
			for their child objects because it confuses the event flow. To disable
			user input interactivity for all child objects, you must set the
			`mouseChildren` property(inherited from the
			DisplayObjectContainer class) to `false`.

			If you use the `buttonMode` property with the MovieClip
			class(which is a subclass of the Sprite class), your button might have
			some added functionality. If you include frames labeled _up, _over, and
			_down, Flash Player provides automatic state changes(functionality
			similar to that provided in previous versions of ActionScript for movie
			clips used as buttons). These automatic state changes are not available
			for sprites, which have no timeline, and thus no frames to label.
		**/
		public buttonMode(get, set): boolean;

		/**
			Specifies the display object over which the sprite is being dragged,
			or on which the sprite was dropped.
		**/
		public dropTarget(default , null): DisplayObject;

		/**
			Specifies the Graphics object that belongs to this sprite where vector
			drawing commands can occur.
		**/
		public graphics(get, never): Graphics;

		/**
			Designates another sprite to serve as the hit area for a sprite. If
			the `hitArea` property does not exist or the value is `null` or
			`undefined`, the sprite itself is used as the hit area. The value of
			the `hitArea` property can be a reference to a Sprite object.
			You can change the `hitArea` property at any time; the modified sprite
			immediately uses the new hit area behavior. The sprite designated as
			the hit area does not need to be visible; its graphical shape,
			although not visible, is still detected as the hit area.

			**Note:** You must set to `false` the `mouseEnabled` property of the
			sprite designated as the hit area. Otherwise, your sprite button might
			not work because the sprite designated as the hit area receives the
			user input events instead of your sprite button.
		**/
		public hitArea: Sprite;

		#if false
		/**
			Controls sound within this sprite.
			**Note:** This property does not affect HTML content in an HTMLControl
			object (in Adobe AIR).
		**/
		// /** @hidden */ @:dox(hide) public soundTransform:SoundTransform;
		#end

		/**
			A Boolean value that indicates whether the pointing hand(hand cursor)
			appears when the pointer rolls over a sprite in which the
			`buttonMode` property is set to `true`. The default
			value of the `useHandCursor` property is `true`. If
			`useHandCursor` is set to `true`, the pointing hand
			used for buttons appears when the pointer rolls over a button sprite. If
			`useHandCursor` is `false`, the arrow pointer is
			used instead.

			You can change the `useHandCursor` property at any time; the
			modified sprite immediately takes on the new cursor appearance.

			**Note:** In Flex or Flash Builder, if your sprite has child
			sprites, you might want to set the `mouseChildren` property to
			`false`. For example, if you want a hand cursor to appear over
			a Flex <mx:Label> control, set the `useHandCursor` and
			`buttonMode` properties to `true`, and the
			`mouseChildren` property to `false`.
		**/
		public useHandCursor: boolean;

		protected __buttonMode: boolean;

		/**
			Creates a new Sprite instance. After you create the Sprite instance, call
			the `DisplayObjectContainer.addChild()` or
			`DisplayObjectContainer.addChildAt()` method to add the Sprite
			to a parent DisplayObjectContainer.
		**/
		public constructor()
		{
			super();

			__buttonMode = false;
			useHandCursor = true;
		}

		/**
			Lets the user drag the specified sprite. The sprite remains draggable
			until explicitly stopped through a call to the
			`Sprite.stopDrag()` method, or until another sprite is made
			draggable. Only one sprite is draggable at a time.

			Three-dimensional display objects follow the pointer and
			`Sprite.startDrag()` moves the object within the
			three-dimensional plane defined by the display object. Or, if the display
			object is a two-dimensional object and the child of a three-dimensional
			object, the two-dimensional object moves within the three dimensional
			plane defined by the three-dimensional parent object.

			@param lockCenter Specifies whether the draggable sprite is locked to the
							  center of the pointer position(`true`), or
							  locked to the point where the user first clicked the
							  sprite(`false`).
			@param bounds     Value relative to the coordinates of the Sprite's parent
							  that specify a constraint rectangle for the Sprite.
		**/
		public startDrag(lockCenter: boolean = false, bounds: Rectangle = null): void
		{
			if (stage != null)
			{
				stage.__startDrag(this, lockCenter, bounds);
			}
		}

		/**
			Lets the user drag the specified sprite on a touch-enabled device. The
			sprite remains draggable until explicitly stopped through a call to
			the `Sprite.stopTouchDrag()` method, or until another sprite is made
			draggable. Only one sprite is draggable at a time.
			Three-dimensional display objects follow the pointer and
			`Sprite.startTouchDrag()` moves the object within the
			three-dimensional plane defined by the display object. Or, if the
			display object is a two-dimensional object and the child of a
			three-dimensional object, the two-dimensional object moves within the
			three dimensional plane defined by the three-dimensional parent
			object.

			@param touchPointID An integer to assign to the touch point.
			@param lockCenter   Specifies whether the draggable sprite is locked
								to the center of the pointer position (`true`), or
								locked to the point where the user first clicked
								the sprite (`false`).
			@param bounds       Value relative to the coordinates of the Sprite's
								parent that specify a constraint rectangle for the
								Sprite.
		**/
		// /** @hidden */ @:dox(hide) public startTouchDrag (touchPointID:Int, lockCenter:Bool = false, bounds:Rectangle = null):Void;

		/**
			Ends the `startDrag()` method. A sprite that was made draggable
			with the `startDrag()` method remains draggable until a
			`stopDrag()` method is added, or until another sprite becomes
			draggable. Only one sprite is draggable at a time.

		**/
		public stopDrag(): void
		{
			if (stage != null)
			{
				stage.__stopDrag(this);
			}
		}

		/**
			Ends the `startTouchDrag()` method, for use with touch-enabled
			devices. A sprite that was made draggable with the `startTouchDrag()`
			method remains draggable until a `stopTouchDrag()` method is added, or
			until another sprite becomes draggable. Only one sprite is draggable
			at a time.

			@param touchPointID The integer assigned to the touch point in the
								`startTouchDrag` method.
		**/
		// /** @hidden */ @:dox(hide) public stopTouchDrag (touchPointID:Int):Void;

		protected__getCursor(): MouseCursor
		{
			return (__buttonMode && useHandCursor) ? BUTTON : null;
		}

		protected__hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean,
			hitObject: DisplayObject): boolean
		{
			if (interactiveOnly && !mouseEnabled && !mouseChildren) return false;
			if (!hitObject.visible || __isMask) return __hitTestHitArea(x, y, shapeFlag, stack, interactiveOnly, hitObject);
			if (mask != null && !mask.__hitTestMask(x, y)) return __hitTestHitArea(x, y, shapeFlag, stack, interactiveOnly, hitObject);

			if (__scrollRect != null)
			{
				var point = Point.__pool.get();
				point.setTo(x, y);
				__getRenderTransform().__transformInversePoint(point);

				if (!__scrollRect.containsPoint(point))
				{
					Point.__pool.release(point);
					return __hitTestHitArea(x, y, shapeFlag, stack, true, hitObject);
				}

				Point.__pool.release(point);
			}

			if (super.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject))
			{
				return (stack == null || interactiveOnly);
			}
			else if (hitArea == null && __graphics != null && __graphics.__hitTest(x, y, shapeFlag, __getRenderTransform()))
			{
				if (stack != null && (!interactiveOnly || mouseEnabled))
				{
					stack.push(hitObject);
				}

				return true;
			}

			return __hitTestHitArea(x, y, shapeFlag, stack, interactiveOnly, hitObject);
		}

		protected __hitTestHitArea(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean,
			hitObject: DisplayObject): boolean
		{
			if (hitArea != null)
			{
				if (!hitArea.mouseEnabled)
				{
					hitArea.mouseEnabled = true;
					var hitTest = hitArea.__hitTest(x, y, shapeFlag, null, true, hitObject);
					hitArea.mouseEnabled = false;

					if (stack != null && hitTest)
					{
						stack[stack.length] = hitObject;
					}

					return hitTest;
				}
			}

			return false;
		}

		protected__hitTestMask(x: number, y: number): boolean
		{
			if (super.__hitTestMask(x, y))
			{
				return true;
			}
			else if (__graphics != null && __graphics.__hitTest(x, y, true, __getRenderTransform()))
			{
				return true;
			}

			return false;
		}

		// Get & Set Methods
		protected get_graphics(): Graphics
		{
			if (__graphics == null)
			{
				__graphics = new Graphics(this);
			}

			return __graphics;
		}

		protectedget_tabEnabled(): boolean
		{
			return (__tabEnabled == null ? __buttonMode : __tabEnabled);
		}

		protected get_buttonMode(): boolean
		{
			return __buttonMode;
		}

		protected set_buttonMode(value: boolean): boolean
		{
			return __buttonMode = value;
		}
	}
}

export default openfl.display.Sprite;
