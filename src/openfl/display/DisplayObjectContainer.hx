package openfl.display;

#if !flash
import openfl.errors.ArgumentError;
import openfl.errors.RangeError;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

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
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.errors.Error)
@:access(openfl.geom.Point)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class DisplayObjectContainer extends InteractiveObject
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
	public var mouseChildren:Bool;

	/**
		Returns the number of children of this object.
	**/
	public var numChildren(get, never):Int;

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
	public var tabChildren(get, set):Bool;

	// @:noCompletion @:dox(hide) public var textSnapshot (default, never):openfl.text.TextSnapshot;
	@:noCompletion private var __removedChildren:Vector<DisplayObject>;
	@:noCompletion private var __tabChildren:Bool;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(DisplayObjectContainer.prototype, "numChildren", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_numChildren (); }")
		});
	}
	#end

	/**
		Calling the `new DisplayObjectContainer()` constructor throws
		an `ArgumentError` exception. You _can_, however, call
		constructors for the following subclasses of DisplayObjectContainer:

		* `new Loader()`
		* `new Sprite()`
		* `new MovieClip()`

	**/
	@:noCompletion private function new()
	{
		super();

		mouseChildren = true;
		__tabChildren = true;

		__children = new Array<DisplayObject>();
		__removedChildren = new Vector<DisplayObject>();
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
	public function addChild(child:DisplayObject):DisplayObject
	{
		return addChildAt(child, numChildren);
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
	public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		if (child == null)
		{
			var error = new TypeError("Error #2007: Parameter child must be non-null.");
			error.errorID = 2007;
			throw error;
		}
		#if ((haxe_ver >= "3.4.0") || !cpp)
		else if (child.stage == child)
		{
			var error = new ArgumentError("Error #3783: A Stage object cannot be added as the child of another object.");
			error.errorID = 3783;
			throw error;
		}
		#end

		if (index > __children.length || index < 0)
		{
			throw "Invalid index position " + index;
		}

		if (child.parent == this)
		{
			if (__children[index] != child)
			{
				__children.remove(child);
				__children.insert(index, child);

				__setRenderDirty();
			}
		}
		else
		{
			if (child.parent != null)
			{
				child.parent.removeChild(child);
			}

			__children.insert(index, child);
			child.parent = this;

			var addedToStage = (stage != null && child.stage == null);

			if (addedToStage)
			{
				child.__setStageReference(stage);
			}

			child.__setTransformDirty();
			child.__setRenderDirty();
			__setRenderDirty();

			// #if !openfl_disable_event_pooling
			// var event = Event.__pool.get();
			// event.type = Event.ADDED;
			// #else
			var event = new Event(Event.ADDED);
			// #end
			event.bubbles = true;

			event.target = child;

			child.__dispatchWithCapture(event);

			// #if !openfl_disable_event_pooling
			// Event.__pool.release(event);
			// #end

			if (addedToStage)
			{
				#if openfl_pool_events
				event = Event.__pool.get();
				event.type = Event.ADDED_TO_STAGE;
				#else
				event = new Event(Event.ADDED_TO_STAGE, false, false);
				#end

				child.__dispatchWithCapture(event);
				child.__dispatchChildren(event);

				#if openfl_pool_events
				Event.__pool.release(event);
				#end
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
	public function areInaccessibleObjectsUnderPoint(point:Point):Bool
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
	public function contains(child:DisplayObject):Bool
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
	public function getChildAt(index:Int):DisplayObject
	{
		if (index >= 0 && index < __children.length)
		{
			return __children[index];
		}

		return null;
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
	public function getChildByName(name:String):DisplayObject
	{
		for (child in __children)
		{
			if (child.name == name) return child;
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
	public function getChildIndex(child:DisplayObject):Int
	{
		for (i in 0...__children.length)
		{
			if (__children[i] == child) return i;
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
	public function getObjectsUnderPoint(point:Point):Array<DisplayObject>
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
	public function removeChild(child:DisplayObject):DisplayObject
	{
		if (child != null && child.parent == this)
		{
			child.__setTransformDirty();
			child.__setRenderDirty();
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
				child.__setStageReference(null);
			}

			child.parent = null;
			__children.remove(child);
			__removedChildren.push(child);
			child.__setTransformDirty();
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
	public function removeChildAt(index:Int):DisplayObject
	{
		if (index >= 0 && index < __children.length)
		{
			return removeChild(__children[index]);
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
	public function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void
	{
		if (endIndex == 0x7FFFFFFF)
		{
			endIndex = __children.length - 1;

			if (endIndex < 0)
			{
				return;
			}
		}

		if (beginIndex > __children.length - 1)
		{
			return;
		}
		else if (endIndex < beginIndex || beginIndex < 0 || endIndex > __children.length)
		{
			throw new RangeError("The supplied index is out of bounds.");
		}

		var numRemovals = endIndex - beginIndex;
		while (numRemovals >= 0)
		{
			removeChildAt(beginIndex);
			numRemovals--;
		}
	}

	@:noCompletion private function resolve(fieldName:String):DisplayObject
	{
		if (__children == null) return null;

		for (child in __children)
		{
			if (child.name == fieldName)
			{
				return child;
			}
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
	public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		if (index >= 0 && index <= __children.length && child.parent == this)
		{
			__children.remove(child);
			__children.insert(index, child);
		}
	}

	/**
		Recursively stops the timeline execution of all MovieClips rooted at this object.

		Child display objects belonging to a sandbox to which the excuting code does not
		have access are ignored.

		**Note:** Streaming media playback controlled via a NetStream object will not be
		stopped.
	**/
	public function stopAllMovieClips():Void
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
	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		if (child1.parent == this && child2.parent == this)
		{
			var index1 = __children.indexOf(child1);
			var index2 = __children.indexOf(child2);

			__children[index1] = child2;
			__children[index2] = child1;

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
	public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		var swap:DisplayObject = __children[index1];
		__children[index1] = __children[index2];
		__children[index2] = swap;
		swap = null;
		__setRenderDirty();
	}

	@:noCompletion private override function __cleanup():Void
	{
		super.__cleanup();

		for (child in __children)
		{
			child.__cleanup();
		}

		__cleanupRemovedChildren();
	}

	@:noCompletion private inline function __cleanupRemovedChildren():Void
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

	@:noCompletion private override function __dispatchChildren(event:Event):Void
	{
		if (__children != null)
		{
			for (child in __children)
			{
				event.target = child;

				if (!child.__dispatchWithCapture(event))
				{
					break;
				}

				child.__dispatchChildren(event);
			}
		}
	}

	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		for (child in __children)
		{
			child.__enterFrame(deltaTime);
		}
	}

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		super.__getBounds(rect, matrix);

		if (__children.length == 0) return;

		var childWorldTransform = Matrix.__pool.get();

		for (child in __children)
		{
			if (child.__scaleX == 0 || child.__scaleY == 0) continue;

			DisplayObject.__calculateAbsoluteTransform(child.__transform, matrix, childWorldTransform);

			child.__getBounds(rect, childWorldTransform);
		}

		Matrix.__pool.release(childWorldTransform);
	}

	@:noCompletion private override function __getFilterBounds(rect:Rectangle, matrix:Matrix):Void
	{
		super.__getFilterBounds(rect, matrix);
		if (__scrollRect != null) return;

		if (__children.length == 0) return;

		var childWorldTransform = Matrix.__pool.get();

		for (child in __children)
		{
			if (child.__scaleX == 0 || child.__scaleY == 0 || child.__isMask) continue;

			DisplayObject.__calculateAbsoluteTransform(child.__transform, matrix, childWorldTransform);

			var childRect = Rectangle.__pool.get();

			child.__getFilterBounds(childRect, childWorldTransform);
			rect.__expand(childRect.x, childRect.y, childRect.width, childRect.height);

			Rectangle.__pool.release(childRect);
		}

		Matrix.__pool.release(childWorldTransform);
	}

	@:noCompletion private override function __getRenderBounds(rect:Rectangle, matrix:Matrix):Void
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

		if (__children.length == 0) return;

		var childWorldTransform = Matrix.__pool.get();

		for (child in __children)
		{
			if (child.__scaleX == 0 || child.__scaleY == 0 || child.__isMask) continue;

			DisplayObject.__calculateAbsoluteTransform(child.__transform, matrix, childWorldTransform);

			child.__getRenderBounds(rect, childWorldTransform);
		}

		Matrix.__pool.release(childWorldTransform);
	}

	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
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

		var i = __children.length;
		if (interactiveOnly)
		{
			if (stack == null || !mouseChildren)
			{
				while (--i >= 0)
				{
					if (__children[i].__hitTest(x, y, shapeFlag, null, true, cast __children[i]))
					{
						if (stack != null)
						{
							stack.push(hitObject);
						}

						return true;
					}
				}
			}
			else if (stack != null)
			{
				var length = stack.length;

				var interactive = false;
				var hitTest = false;

				while (--i >= 0)
				{
					interactive = __children[i].__getInteractive(null);

					if (interactive || (mouseEnabled && !hitTest))
					{
						if (__children[i].__hitTest(x, y, shapeFlag, stack, true, cast __children[i]))
						{
							hitTest = true;

							if (interactive && stack.length > length)
							{
								break;
							}
						}
					}
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

			while (--i >= 0)
			{
				if (__children[i].__hitTest(x, y, shapeFlag, stack, false, cast __children[i]))
				{
					hitTest = true;
					if (stack == null) break;
				}
			}

			return hitTest;
		}

		return false;
	}

	@:noCompletion private override function __hitTestMask(x:Float, y:Float):Bool
	{
		var i = __children.length;

		while (--i >= 0)
		{
			if (__children[i].__hitTestMask(x, y))
			{
				return true;
			}
		}

		return false;
	}

	@:noCompletion private override function __readGraphicsData(graphicsData:Vector<IGraphicsData>, recurse:Bool):Void
	{
		super.__readGraphicsData(graphicsData, recurse);

		if (recurse)
		{
			for (child in __children)
			{
				child.__readGraphicsData(graphicsData, recurse);
			}
		}
	}

	@:noCompletion private override function __setStageReference(stage:Stage):Void
	{
		super.__setStageReference(stage);

		if (__children != null)
		{
			for (child in __children)
			{
				child.__setStageReference(stage);
			}
		}
	}

	@:noCompletion private override function __setWorldTransformInvalid():Void
	{
		if (!__worldTransformInvalid)
		{
			__worldTransformInvalid = true;

			if (__children != null)
			{
				for (child in __children)
				{
					child.__setWorldTransformInvalid();
				}
			}
		}
	}

	@:noCompletion private override function __stopAllMovieClips():Void
	{
		for (child in __children)
		{
			child.__stopAllMovieClips();
		}
	}

	@:noCompletion private override function __tabTest(stack:Array<InteractiveObject>):Void
	{
		super.__tabTest(stack);

		if (!tabChildren) return;

		var interactive = false;
		var interactiveObject:InteractiveObject = null;

		for (child in __children)
		{
			interactive = child.__getInteractive(null);

			if (interactive)
			{
				interactiveObject = cast child;
				interactiveObject.__tabTest(stack);
			}
		}
	}

	@:noCompletion private override function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		super.__update(transformOnly, updateChildren);

		if (updateChildren)
		{
			for (child in __children)
			{
				child.__update(transformOnly, true);
			}
		}
	}

	// Get & Set Methods

	@:noCompletion private function get_numChildren():Int
	{
		return __children.length;
	}

	@:noCompletion private function get_tabChildren():Bool
	{
		return __tabChildren;
	}

	@:noCompletion private function set_tabChildren(value:Bool):Bool
	{
		if (__tabChildren != value)
		{
			__tabChildren = value;

			dispatchEvent(new Event(Event.TAB_CHILDREN_CHANGE, true, false));
		}

		return __tabChildren;
	}
}
#else
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
#end
