import ArgumentError from "openfl/errors/ArgumentError";
import RangeError from "openfl/errors/RangeError";
import TypeError from "openfl/errors/TypeError";
import Event from "openfl/events/Event";
import Matrix from "openfl/geom/Matrix";
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import TextField from "openfl/text/TextField";
import Video from "openfl/media/Video";
import Vector from "openfl/Vector";

// using openfl._internal.utils.DisplayObjectLinkedList;

namespace openfl.display
{
	/**
		The DisplayObjectContainer class is the base class for all objects that can
		serve as display object containers on the display list. The display list
		manages all objects displayed in the Flash runtimes. Use the
		DisplayObjectContainer class to arrange the display objects in the display
		list. Each DisplayObjectContainer object has its own child list for
		organizing the z-order of the objects. The z-order is the front-to-back
		order that determines which object is drawn in front, which is behind, and
		so on.

		DisplayObject is an abstract base class; therefore, you cannot call
		DisplayObject directly. Invoking `new DisplayObject()` throws an
		`ArgumentError` exception.
		The DisplayObjectContainer class is an abstract base class for all objects
		that can contain child objects. It cannot be instantiated directly; calling
		the `new DisplayObjectContainer()` constructor throws an
		`ArgumentError` exception.

		For more information, see the "Display Programming" chapter of the
		_ActionScript 3.0 Developer's Guide_.
	**/
	export class DisplayObjectContainer extends InteractiveObject
	{
		/**
			Determines whether or not the children of the object are mouse, or user
			input device, enabled. If an object is enabled, a user can interact with
			it by using a mouse or user input device. The default is
			`true`.

			This property is useful when you create a button with an instance of
			the Sprite class(instead of using the SimpleButton class). When you use a
			Sprite instance to create a button, you can choose to decorate the button
			by using the `addChild()` method to add additional Sprite
			instances. This process can cause unexpected behavior with mouse events
			because the Sprite instances you add as children can become the target
			object of a mouse event when you expect the parent instance to be the
			target object. To ensure that the parent instance serves as the target
			objects for mouse events, you can set the `mouseChildren`
			property of the parent instance to `false`.

			 No event is dispatched by setting this property. You must use the
			`addEventListener()` method to create interactive
			functionality.
		**/
		public mouseChildren: boolean;

		/**
			Returns the number of children of this object.
		**/
		public numChildren(default , null): number;

		/**
			Determines whether the children of the object are tab enabled. Enables or
			disables tabbing for the children of the object. The default is
			`true`.

			**Note:** Do not use the `tabChildren` property with
			Flex. Instead, use the
			`mx.core.UIComponent.hasFocusableChildren` property.

			@throws IllegalOperationError Calling this property of the Stage object
										  throws an exception. The Stage object does
										  not implement this property.
		**/
		public tabChildren(get, set): boolean;

		// /** @hidden */ @:dox(hide) public textSnapshot (default, never):openfl.text.TextSnapshot;
		protected __removedChildren: Vector<DisplayObject>;
		protected __tabChildren: boolean;

		/**
			Calling the `new DisplayObjectContainer()` constructor throws
			an `ArgumentError` exception. You _can_, however, call
			constructors for the following subclasses of DisplayObjectContainer:

			* `new Loader()`
			* `new Sprite()`
			* `new MovieClip()`

		**/
		protected constructor()
		{
			super();

			this.__type = DISPLAY_OBJECT_CONTAINER;

			this.mouseChildren = true;
			this.__tabChildren = true;

			this.numChildren = 0;
			this.__removedChildren = new Vector<DisplayObject>();
		}

		/**
			Adds a child DisplayObject instance to this DisplayObjectContainer
			instance. The child is added to the front(top) of all other children in
			this DisplayObjectContainer instance.(To add a child to a specific index
			position, use the `addChildAt()` method.)

			If you add a child object that already has a different display object
			container as a parent, the object is removed from the child list of the
			other display object container.

			**Note:** The command `stage.addChild()` can cause
			problems with a published SWF file, including security problems and
			conflicts with other loaded SWF files. There is only one Stage within a
			Flash runtime instance, no matter how many SWF files you load into the
			runtime. So, generally, objects should not be added to the Stage,
			directly, at all. The only object the Stage should contain is the root
			object. Create a DisplayObjectContainer to contain all of the items on the
			display list. Then, if necessary, add that DisplayObjectContainer instance
			to the Stage.

			@param child The DisplayObject instance to add as a child of this
						 DisplayObjectContainer instance.
			@return The DisplayObject instance that you pass in the `child`
					parameter.
			@throws ArgumentError Throws if the child is the same as the parent. Also
								  throws if the caller is a child(or grandchild etc.)
								  of the child being added.
			@event added Dispatched when a display object is added to the display
						 list.
		**/
		public addChild(child: DisplayObject): DisplayObject
		{
			if (child == null)
			{
				var error = new TypeError("Error #2007: Parameter child must be non-null.");
				error.errorID = 2007;
				throw error;
			}
			else if (child.stage == child)
			{
				var error = new ArgumentError("Error #3783: A Stage object cannot be added as the child of another object.");
				error.errorID = 3783;
				throw error;
			}

			if (child.parent == this)
			{
				this.__addChild(child);
			}
			else
			{
				this.__reparent(child);
				this.__addChild(child);

				var addedToStage = (stage != null && child.stage == null);

				if (addedToStage)
				{
					child.__setStageReferences(stage);
				}

				child.__setTransformDirty(true);
				child.__setParentRenderDirty();
				child.__setRenderDirty();
				__localBoundsDirty = true;
				__setRenderDirty();

				var event = Event.__pool.get();
				event.type = Event.ADDED;
				event.bubbles = true;

				event.target = child;

				child.__dispatchWithCapture(event);

				Event.__pool.release(event);

				if (addedToStage)
				{
					event = Event.__pool.get(Event.ADDED_TO_STAGE);

					child.__dispatchWithCapture(event);
					child.__dispatchChildren(event);

					Event.__pool.release(event);
				}
			}

			return child;
		}

		/**
			Adds a child DisplayObject instance to this DisplayObjectContainer
			instance. The child is added at the index position specified. An index of
			0 represents the back(bottom) of the display list for this
			DisplayObjectContainer object.

			For example, the following example shows three display objects, labeled
			a, b, and c, at index positions 0, 2, and 1, respectively:

			![b over c over a](/images/DisplayObjectContainer_layers.jpg)

			If you add a child object that already has a different display object
			container as a parent, the object is removed from the child list of the
			other display object container.

			@param child The DisplayObject instance to add as a child of this
						 DisplayObjectContainer instance.
			@param index The index position to which the child is added. If you
						 specify a currently occupied index position, the child object
						 that exists at that position and all higher positions are
						 moved up one position in the child list.
			@return The DisplayObject instance that you pass in the `child`
					parameter.
			@throws ArgumentError Throws if the child is the same as the parent. Also
								  throws if the caller is a child(or grandchild etc.)
								  of the child being added.
			@throws RangeError    Throws if the index position does not exist in the
								  child list.
			@event added Dispatched when a display object is added to the display
						 list.
		**/
		public addChildAt(child: DisplayObject, index: number): DisplayObject
		{
			if (index == numChildren)
			{
				return addChild(child);
			}

			if (child == null)
			{
				var error = new TypeError("Error #2007: Parameter child must be non-null.");
				error.errorID = 2007;
				throw error;
			}
			else if (child.stage == child)
			{
				var error = new ArgumentError("Error #3783: A Stage object cannot be added as the child of another object.");
				error.errorID = 3783;
				throw error;
			}

			if (index < 0 || index > numChildren)
			{
				throw "Invalid index position " + index;
			}

			if (child.parent == this)
			{
				if (index == 0)
				{
					if (__firstChild != child)
					{
						this.__unshiftChild(child);
						__setRenderDirty();
					}
				}
				else
				{
					this.__swapChildren(child, getChildAt(index));
					__setRenderDirty();
				}
			}
			else
			{
				this.__reparent(child);
				this.__insertChildAt(child, index);
				__setRenderDirty();

				var addedToStage = (stage != null && child.stage == null);

				if (addedToStage)
				{
					child.__setStageReferences(stage);
				}

				child.__setTransformDirty(true);
				child.__setParentRenderDirty();
				child.__setRenderDirty();
				__localBoundsDirty = true;
				__setRenderDirty();

				var event = Event.__pool.get();
				event.type = Event.ADDED;
				event.bubbles = true;

				event.target = child;

				child.__dispatchWithCapture(event);

				Event.__pool.release(event);

				if (addedToStage)
				{
					event = Event.__pool.get(Event.ADDED_TO_STAGE);

					child.__dispatchWithCapture(event);
					child.__dispatchChildren(event);

					Event.__pool.release(event);
				}
			}

			return child;
		}

		/**
			Indicates whether the security restrictions would cause any display
			objects to be omitted from the list returned by calling the
			`DisplayObjectContainer.getObjectsUnderPoint()` method with the
			specified `point` point. By default, content from one domain
			cannot access objects from another domain unless they are permitted to do
			so with a call to the `Security.allowDomain()` method. For more
			information, related to security, see the Flash Player Developer Center
			Topic: [Security](http://www.adobe.com/go/devnet_security_en).

			The `point` parameter is in the coordinate space of the
			Stage, which may differ from the coordinate space of the display object
			container(unless the display object container is the Stage). You can use
			the `globalToLocal()` and the `localToGlobal()`
			methods to convert points between these coordinate spaces.

			@param point The point under which to look.
			@return `true` if the point contains child display objects with
					security restrictions.
		**/
		public areInaccessibleObjectsUnderPoint(point: Point): boolean
		{
			return false;
		}

		/**
			Determines whether the specified display object is a child of the
			DisplayObjectContainer instance or the instance itself. The search
			includes the entire display list including this DisplayObjectContainer
			instance. Grandchildren, great-grandchildren, and so on each return
			`true`.

			@param child The child object to test.
			@return `true` if the `child` object is a child of
					the DisplayObjectContainer or the container itself; otherwise
					`false`.
		**/
		public contains(child: DisplayObject): boolean
		{
			while (child != this && child != null)
			{
				child = child.parent;
			}

			return child == this;
		}

		/**
			Returns the child display object instance that exists at the specified
			index.

			@param index The index position of the child object.
			@return The child display object at the specified index position.
			@throws RangeError    Throws if the index does not exist in the child
								  list.
			@throws SecurityError This child display object belongs to a sandbox to
								  which you do not have access. You can avoid this
								  situation by having the child movie call
								  `Security.allowDomain()`.
		**/
		public getChildAt(index: number): DisplayObject
		{
			if (index < 0 || index > numChildren - 1)
			{
				return null;
			}

			var child = __firstChild;
			if (child != null)
			{
				for (i in 0...index)
				{
					child = child.__nextSibling;
				}
			}

			return child;
		}

		/**
			Returns the child display object that exists with the specified name. If
			more that one child display object has the specified name, the method
			returns the first object in the child list.

			The `getChildAt()` method is faster than the
			`getChildByName()` method. The `getChildAt()` method
			accesses a child from a cached array, whereas the
			`getChildByName()` method has to traverse a linked list to
			access a child.

			@param name The name of the child to return.
			@return The child display object with the specified name.
			@throws SecurityError This child display object belongs to a sandbox to
								  which you do not have access. You can avoid this
								  situation by having the child movie call the
								  `Security.allowDomain()` method.
		**/
		public getChildByName(name: string): DisplayObject
		{
			var child = __firstChild;
			while (child != null)
			{
				if (child.name == name)
				{
					return child;
				}
				child = child.__nextSibling;
			}
			return null;
		}

		/**
			Returns the index position of a `child` DisplayObject instance.

			@param child The DisplayObject instance to identify.
			@return The index position of the child display object to identify.
			@throws ArgumentError Throws if the child parameter is not a child of this
								  object.
		**/
		public getChildIndex(child: DisplayObject): number
		{
			var current = __firstChild;
			if (current != null)
			{
				for (i in 0...numChildren)
				{
					if (current == child) return i;
					current = current.__nextSibling;
				}
			}
			return -1;
		}

		/**
			Returns an array of objects that lie under the specified point and are
			children(or grandchildren, and so on) of this DisplayObjectContainer
			instance. Any child objects that are inaccessible for security reasons are
			omitted from the returned array. To determine whether this security
			restriction affects the returned array, call the
			`areInaccessibleObjectsUnderPoint()` method.

			The `point` parameter is in the coordinate space of the
			Stage, which may differ from the coordinate space of the display object
			container(unless the display object container is the Stage). You can use
			the `globalToLocal()` and the `localToGlobal()`
			methods to convert points between these coordinate spaces.

			@param point The point under which to look.
			@return An array of objects that lie under the specified point and are
					children(or grandchildren, and so on) of this
					DisplayObjectContainer instance.
		**/
		public getObjectsUnderPoint(point: Point): Array<DisplayObject>
		{
			var stack = new Array<DisplayObject>();
			__hitTest(point.x, point.y, false, stack, false, this);
			stack.reverse();
			return stack;
		}

		/**
			Removes the specified `child` DisplayObject instance from the
			child list of the DisplayObjectContainer instance. The `parent`
			property of the removed child is set to `null` , and the object
			is garbage collected if no other references to the child exist. The index
			positions of any display objects above the child in the
			DisplayObjectContainer are decreased by 1.

			The garbage collector reallocates unused memory space. When a variable
			or object is no longer actively referenced or stored somewhere, the
			garbage collector sweeps through and wipes out the memory space it used to
			occupy if no other references to it exist.

			@param child The DisplayObject instance to remove.
			@return The DisplayObject instance that you pass in the `child`
					parameter.
			@throws ArgumentError Throws if the child parameter is not a child of this
								  object.
		**/
		public removeChild(child: DisplayObject): DisplayObject
		{
			if (child != null && child.parent == this)
			{
				child.__setTransformDirty();
				child.__setParentRenderDirty();
				child.__setRenderDirty();
				__localBoundsDirty = true;
				__setRenderDirty();

				var event = new Event(Event.REMOVED, true);
				child.__dispatchWithCapture(event);

				if (stage != null)
				{
					if (child.stage != null && stage.focus == child)
					{
						stage.focus = null;
					}

					var event = new Event(Event.REMOVED_FROM_STAGE, false, false);
					child.__dispatchWithCapture(event);
					child.__dispatchChildren(event);
					child.__setStageReferences(null);
				}

				this.__removeChild(child);

				__removedChildren.push(child);
				child.__setTransformDirty(true);
				child.__setParentRenderDirty();
			}

			return child;
		}

		/**
			Removes a child DisplayObject from the specified `index`
			position in the child list of the DisplayObjectContainer. The
			`parent` property of the removed child is set to
			`null`, and the object is garbage collected if no other
			references to the child exist. The index positions of any display objects
			above the child in the DisplayObjectContainer are decreased by 1.

			The garbage collector reallocates unused memory space. When a variable
			or object is no longer actively referenced or stored somewhere, the
			garbage collector sweeps through and wipes out the memory space it used to
			occupy if no other references to it exist.

			@param index The child index of the DisplayObject to remove.
			@return The DisplayObject instance that was removed.
			@throws RangeError    Throws if the index does not exist in the child
								  list.
			@throws SecurityError This child display object belongs to a sandbox to
								  which the calling object does not have access. You
								  can avoid this situation by having the child movie
								  call the `Security.allowDomain()` method.
		**/
		public removeChildAt(index: number): DisplayObject
		{
			if (index >= 0 && index < numChildren)
			{
				var child = __firstChild;
				if (child != null)
				{
					for (i in 0...numChildren)
					{
						if (i == index)
						{
							return removeChild(child);
						}
						child = child.__nextSibling;
					}
				}
			}

			return null;
		}

		/**
			Removes all `child` DisplayObject instances from the child list of the DisplayObjectContainer
			instance. The `parent` property of the removed children is set to `null`, and the objects are
			garbage collected if no other references to the children exist.

			The garbage collector reallocates unused memory space. When a variable or object is no
			longer actively referenced or stored somewhere, the garbage collector sweeps through and
			wipes out the memory space it used to occupy if no other references to it exist.
			@param	beginIndex	The beginning position. A value smaller than 0 throws a `RangeError`.
			@param	endIndex	The ending position. A value smaller than 0 throws a `RangeError`.
		**/
		public removeChildren(beginIndex: number = 0, endIndex: number = 0x7FFFFFFF): void
		{
			if (endIndex == 0x7FFFFFFF)
			{
				endIndex = numChildren - 1;

				if (endIndex < 0)
				{
					return;
				}
			}

			if (beginIndex > numChildren - 1)
			{
				return;
			}
			else if (endIndex < beginIndex || beginIndex < 0 || endIndex > numChildren)
			{
				throw new RangeError("The supplied index is out of bounds.");
			}

			var child = __firstChild;
			if (child != null)
			{
				for (i in 0...beginIndex)
				{
					child = child.__nextSibling;
				}
			}

			var numRemovals = endIndex - beginIndex;
			var next = null;

			while (numRemovals >= 0)
			{
				next = child.__nextSibling;
				removeChild(child);
				child = next;
				numRemovals--;
			}
		}

		protected resolve(fieldName: string): DisplayObject
		{
			var child = __firstChild;
			while (child != null)
			{
				if (child.name == fieldName)
				{
					return child;
				}
				child = child.__nextSibling;
			}

			return null;
		}

		/**
			Changes the position of an existing child in the display object container.
			This affects the layering of child objects. For example, the following
			example shows three display objects, labeled a, b, and c, at index
			positions 0, 1, and 2, respectively:

			![c over b over a](/images/DisplayObjectContainerSetChildIndex1.jpg)

			When you use the `setChildIndex()` method and specify an
			index position that is already occupied, the only positions that change
			are those in between the display object's former and new position. All
			others will stay the same. If a child is moved to an index LOWER than its
			current index, all children in between will INCREASE by 1 for their index
			reference. If a child is moved to an index HIGHER than its current index,
			all children in between will DECREASE by 1 for their index reference. For
			example, if the display object container in the previous example is named
			`container`, you can swap the position of the display objects
			labeled a and b by calling the following code:

			```haxe
			container.setChildIndex(container.getChildAt(1), 0);
			```

			This code results in the following arrangement of objects:

			![c over a over b](/images/DisplayObjectContainerSetChildIndex2.jpg)

			@param child The child DisplayObject instance for which you want to change
						 the index number.
			@param index The resulting index number for the `child` display
						 object.
			@throws ArgumentError Throws if the child parameter is not a child of this
								  object.
			@throws RangeError    Throws if the index does not exist in the child
								  list.
		**/
		public setChildIndex(child: DisplayObject, index: number): void
		{
			if (index >= 0 && index <= numChildren && numChildren > 1 && child.parent == this)
			{
				if (index == 0)
				{
					this.__unshiftChild(child);
				}
				else if (index >= numChildren - 1)
				{
					this.__addChild(child);
				}
				else
				{
					this.__insertChildAt(child, index);
				}
				__setRenderDirty();
			}
		}

		/**
			Recursively stops the timeline execution of all MovieClips rooted at this object.

			Child display objects belonging to a sandbox to which the excuting code does not
			have access are ignored.

			**Note:** Streaming media playback controlled via a NetStream object will not be
			stopped.
		**/
		public stopAllMovieClips(): void
		{
			__stopAllMovieClips();
		}

		/**
			Swaps the z-order (front-to-back order) of the two specified child
			objects. All other child objects in the display object container remain in
			the same index positions.

			@param child1 The first child object.
			@param child2 The second child object.
			@throws ArgumentError Throws if either child parameter is not a child of
								  this object.
		**/
		public swapChildren(child1: DisplayObject, child2: DisplayObject): void
		{
			if (child1.parent == this && child2.parent == this && child1 != child2)
			{
				this.__swapChildren(child1, child2);
				__setRenderDirty();
			}
		}

		/**
			Swaps the z-order (front-to-back order) of the child objects at the two
			specified index positions in the child list. All other child objects in
			the display object container remain in the same index positions.

			@param index1 The index position of the first child object.
			@param index2 The index position of the second child object.
			@throws RangeError If either index does not exist in the child list.
		**/
		public swapChildrenAt(index1: number, index2: number): void
		{
			if (index1 >= 0 && index1 < numChildren && index1 != index2 && index2 >= 0 && index2 < numChildren)
			{
				var child1 = null, child2 = null;
				var current = __firstChild;

				if (current != null)
				{
					for (i in 0...numChildren)
					{
						if (i == index1)
						{
							child1 = current;
						}
						else if (i == index2)
						{
							child2 = current;
						}
						current = current.__nextSibling;
					}
				}

				this.__swapChildren(child1, child2);
				__setRenderDirty();
			}
		}

		protected inline __cleanupRemovedChildren(): void
		{
			for (orphan in __removedChildren)
			{
				if (orphan.stage == null)
				{
					orphan.__cleanup();
				}
			}

			__removedChildren.length = 0;
		}

		protected__getBounds(rect: Rectangle, matrix: Matrix): void
		{
			super.__getBounds(rect, matrix);

			if (numChildren == 0) return;

			var childWorldTransform = Matrix.__pool.get();

			var child = __firstChild;
			while (child != null)
			{
				if (child.__scaleX != 0 && child.__scaleY != 0)
				{
					DisplayObject.__calculateAbsoluteTransform(child.__transform, matrix, childWorldTransform);
					child.__getBounds(rect, childWorldTransform);
				}
				child = child.__nextSibling;
			}

			Matrix.__pool.release(childWorldTransform);
		}

		protected__getFilterBounds(rect: Rectangle, matrix: Matrix): void
		{
			super.__getFilterBounds(rect, matrix);
			if (__scrollRect != null) return;

			if (numChildren == 0) return;

			var childWorldTransform = Matrix.__pool.get();

			var child = __firstChild;
			while (child != null)
			{
				if (child.__scaleX != 0 && child.__scaleY != 0 && !child.__isMask)
				{
					DisplayObject.__calculateAbsoluteTransform(child.__transform, matrix, childWorldTransform);
					child.__getFilterBounds(rect, childWorldTransform);
				}
				child = child.__nextSibling;
			}

			Matrix.__pool.release(childWorldTransform);
		}

		protected__getRenderBounds(rect: Rectangle, matrix: Matrix): void
		{
			if (__scrollRect != null)
			{
				super.__getRenderBounds(rect, matrix);
				return;
			}
			else
			{
				super.__getBounds(rect, matrix);
			}

			if (numChildren == 0) return;

			var childWorldTransform = Matrix.__pool.get();

			var child = __firstChild;
			while (child != null)
			{
				if (child.__scaleX != 0 && child.__scaleY != 0 && !child.__isMask)
				{
					DisplayObject.__calculateAbsoluteTransform(child.__transform, matrix, childWorldTransform);
					child.__getRenderBounds(rect, childWorldTransform);
				}
				child = child.__nextSibling;
			}

			Matrix.__pool.release(childWorldTransform);
		}

		protected__hitTest(x: number, y: number, shapeFlag: boolean, stack: Array<DisplayObject>, interactiveOnly: boolean,
			hitObject: DisplayObject): boolean
		{
			if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled && !mouseChildren)) return false;
			if (mask != null && !mask.__hitTestMask(x, y)) return false;

			if (__scrollRect != null)
			{
				var point = Point.__pool.get();
				point.setTo(x, y);
				__getRenderTransform().__transformInversePoint(point);

				if (!__scrollRect.containsPoint(point))
				{
					Point.__pool.release(point);
					return false;
				}

				Point.__pool.release(point);
			}

			var child = __lastChild;
			if (interactiveOnly)
			{
				if (stack == null || !mouseChildren)
				{
					while (child != null)
					{
						if (child.__hitTest(x, y, shapeFlag, null, true, cast child))
						{
							if (stack != null)
							{
								stack.push(hitObject);
							}

							return true;
						}
						child = child.__previousSibling;
					}
				}
				else if (stack != null)
				{
					var length = stack.length;

					var interactive = false;
					var hitTest = false;

					while (child != null)
					{
						interactive = child.__getInteractive(null);

						if (interactive || (mouseEnabled && !hitTest))
						{
							if (child.__hitTest(x, y, shapeFlag, stack, true, cast child))
							{
								hitTest = true;

								if (interactive && stack.length > length)
								{
									break;
								}
							}
						}
						child = child.__previousSibling;
					}

					if (hitTest)
					{
						stack.insert(length, hitObject);
						return true;
					}
				}
			}
			else
			{
				var hitTest = false;

				while (child != null)
				{
					if (child.__hitTest(x, y, shapeFlag, stack, false, cast child))
					{
						hitTest = true;
						if (stack == null) break;
					}
					child = child.__previousSibling;
				}

				return hitTest;
			}

			return false;
		}

		// protected__hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
		// 		hitObject:DisplayObject):Bool
		// {
		// 	if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled && !mouseChildren)) return false;
		// 	if (mask != null && !mask.__hitTestMask(x, y)) return false;
		// 	if (__scrollRect != null)
		// 	{
		// 		var point = Point.__pool.get();
		// 		point.setTo(x, y);
		// 		__getRenderTransform().__transformInversePoint(point);
		// 		if (!__scrollRect.containsPoint(point))
		// 		{
		// 			Point.__pool.release(point);
		// 			return false;
		// 		}
		// 		Point.__pool.release(point);
		// 	}
		// 	if (numChildren > 0)
		// 	{
		// 		var stackRef = (interactiveOnly && !mouseChildren) ? null : stack;
		// 		var hitTest = false;
		// 		var interactive = false;
		// 		var stackLength = -1;
		// 		var children = __childIterator();
		// 		for (child in children)
		// 		{
		// 			if (interactiveOnly && stackRef != null)
		// 			{
		// 				interactive = child.__getInteractive(null);
		// 				if (!interactive && !mouseEnabled && hitTest)
		// 				{
		// 					children.skip(child);
		// 					continue;
		// 				}
		// 				stackLength = stack.length;
		// 			}
		// 			inline super_hitTest(child:DisplayObject, x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
		// 					hitObject:DisplayObject):Bool
		// 			{
		// 				var hitTest = false;
		// 				if (child.__graphics != null)
		// 				{
		// 					if (!hitObject.__visible || child.__isMask || (child.mask != null && !child.mask.__hitTestMask(x, y)))
		// 					{
		// 						hitTest = false;
		// 					}
		// 					else if (child.__graphics.__hitTest(x, y, shapeFlag, child.__getRenderTransform()))
		// 					{
		// 						if (stack != null && !interactiveOnly)
		// 						{
		// 							stack.push(hitObject);
		// 						}
		// 						hitTest = true;
		// 					}
		// 				}
		// 				return hitTest;
		// 			}
		// 			var childHit = switch (child.__type)
		// 			{
		// 				case BITMAP:
		// 					var bitmap:Bitmap = cast child;
		// 					inline bitmap.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 				case SIMPLE_BUTTON:
		// 					var simpleButton:SimpleButton = cast child;
		// 					inline simpleButton.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
		// 					// inline super.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 					super_hitTest(child, x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 				case TEXTFIELD:
		// 					var textField:TextField = cast child;
		// 					inline textField.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 				case TILEMAP:
		// 					var tilemap:Tilemap = cast child;
		// 					inline tilemap.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 				case VIDEO:
		// 					var video:Video = cast child;
		// 					inline video.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
		// 				default: false;
		// 			}
		// 			if (childHit)
		// 			{
		// 				hitTest = true;
		// 				if (stackRef == null || (interactive && stack.length > stackLength))
		// 				{
		// 					break;
		// 				}
		// 			}
		// 		}
		// 		if (hitTest && interactiveOnly && stack != null)
		// 		{
		// 			if (stackLength > -1)
		// 			{
		// 				stack.insert(stackLength, hitObject);
		// 			}
		// 			else
		// 			{
		// 				stack.push(hitObject);
		// 			}
		// 		}
		// 		return hitTest;
		// 	}
		// 	else
		// 	{
		// 		return false;
		// 	}
		// }

		protected__hitTestMask(x: number, y: number): boolean
		{
			// if (super.__hitTestMask(x, y))
			// {
			// 	return true;
			// }
			if (__graphics != null && __graphics.__hitTest(x, y, true, __getRenderTransform()))
			{
				return true;
			}

			if (numChildren > 0)
			{
				for (child in __childIterator())
				{
					if (switch (child.__type)
						{
							case BITMAP:
								var bitmap: Bitmap = cast child;
								bitmap.__hitTestMask(x, y);
								break;
							case SIMPLE_BUTTON:
								var simpleButton: SimpleButton = cast child;
								simpleButton.__hitTestMask(x, y);
								break;
							case TEXTFIELD:
								var textField: TextField = cast child;
								textField.__hitTestMask(x, y);
								break;
							case VIDEO:
								var video: Video = cast child;
								video.__hitTestMask(x, y);
								break;
							case DISPLAY_OBJECT_CONTAINER,
								MOVIE_CLIP: // inline super.__hitTestMask(x, y) || (child.__graphics != null && child.__graphics.__hitTest(x, y, true, child.__getRenderTransform()));
								(__graphics != null && __graphics.__hitTest(x, y, true, __getRenderTransform()))
									|| (child.__graphics != null && child.__graphics.__hitTest(x, y, true, child.__getRenderTransform()));
							default: super.__hitTestMask(x, y);
						})
					{
						return true;
					}
				}
			}

			return false;
		}

		protected__readGraphicsData(graphicsData: Vector<IGraphicsData>, recurse: boolean): void
		{
			// super.__readGraphicsData(graphicsData, recurse);
			if (__graphics != null)
			{
				__graphics.__readGraphicsData(graphicsData);
			}

			if (recurse && numChildren > 0)
			{
				for (child in __childIterator())
				{
					// inline super.__readGraphicsData(graphicsData, recurse);
					if (child.__graphics != null)
					{
						child.__graphics.__readGraphicsData(graphicsData);
					}
				}
			}
		}

		protected__setTransformDirty(force: boolean = false): void
		{
			// inline super.__setTransformDirty(force);
			__transformDirty = true;

			if (numChildren > 0 && (!__childTransformDirty || force))
			{
				for (child in __childIterator())
				{
					if (child.__type == SIMPLE_BUTTON)
					{
						var simpleButton: SimpleButton = cast child;
						simpleButton.__setTransformDirty(force);
					}
					else
					{
						// inline super.__setTransformDirty(force);
						child.__transformDirty = true;
					}
				}

				__childTransformDirty = true;
			}
		}

		protected__stopAllMovieClips(): void
		{
			if (numChildren > 0)
			{
				for (child in __childIterator())
				{
					if (child.__type == MOVIE_CLIP)
					{
						var movieClip: MovieClip = cast child;
						movieClip.stop();
					}
				}
			}
		}

		protected__tabTest(stack: Array<InteractiveObject>): void
		{
			// inline super.__tabTest(stack);
			if (tabEnabled)
			{
				stack.push(this);
			}
			if (!tabChildren) return;

			if (numChildren > 0)
			{
				var children = __childIterator();
				for (child in children)
				{
					switch (child.__type)
					{
						case MOVIE_CLIP:
							var movieClip: MovieClip = cast child;
							if (!movieClip.enabled)
							{
								children.skip(movieClip);
								continue;
							}
							else if (movieClip.tabEnabled)
							{
								stack.push(movieClip);
							}
							if (!movieClip.tabChildren)
							{
								children.skip(movieClip);
								continue;
							}
							break;
						case DISPLAY_OBJECT_CONTAINER:
							var displayObjectContainer: DisplayObjectContainer = cast child;
							if (displayObjectContainer.tabEnabled)
							{
								stack.push(displayObjectContainer);
							}
							if (!displayObjectContainer.tabChildren)
							{
								children.skip(displayObjectContainer);
								continue;
							}
							break;
						case SIMPLE_BUTTON, TEXTFIELD:
							var interactiveObject: InteractiveObject = cast child;
							if (interactiveObject.tabEnabled)
							{
								stack.push(interactiveObject);
							}
							break;
						default:
					}
				}
			}
		}

		protected__update(transformOnly: boolean, updateChildren: boolean): void
		{
			__updateSingle(transformOnly, updateChildren);

			if (updateChildren && numChildren > 0)
			{
				for (child in __childIterator())
				{
					var transformDirty = child.__transformDirty;

					// TODO: Flatten masks
					child.__updateSingle(transformOnly, updateChildren);

					switch (child.__type)
					{
						case SIMPLE_BUTTON:
							// TODO: Flatten this into the allChildren() call?
							if (updateChildren)
							{
								var button: SimpleButton = cast child;
								if (button.__currentState != null)
								{
									button.__currentState.__update(transformOnly, true);
								}

								if (button.hitTestState != null && button.hitTestState != button.__currentState)
								{
									button.hitTestState.__update(transformOnly, true);
								}
							}
							break;

						case TEXTFIELD:
							if (transformDirty)
							{
								var textField: TextField = cast child;
								textField.__renderTransform.__translateTransformed(textField.__offsetX, textField.__offsetY);
							}
							break;

						case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
							// Ensure children are marked as dirty again
							// as we no longer know if they all are dirty
							// since at least one has been updated
							child.__childTransformDirty = false;
							break;

						default:
					}
				}
			}

			__childTransformDirty = false;
		}

		// Get & Set Methods
		protected get_tabChildren(): boolean
		{
			return __tabChildren;
		}

		protected set_tabChildren(value: boolean): boolean
		{
			if (__tabChildren != value)
			{
				__tabChildren = value;

				dispatchEvent(new Event(Event.TAB_CHILDREN_CHANGE, true, false));
			}

			return __tabChildren;
		}
	}
}

export default openfl.display.DisplayObjectContainer;
