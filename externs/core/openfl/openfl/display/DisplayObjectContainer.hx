package openfl.display; #if (display || !flash)


import openfl.geom.Point;


/**
 * The DisplayObjectContainer class is the base class for all objects that can
 * serve as display object containers on the display list. The display list
 * manages all objects displayed in the Flash runtimes. Use the
 * DisplayObjectContainer class to arrange the display objects in the display
 * list. Each DisplayObjectContainer object has its own child list for
 * organizing the z-order of the objects. The z-order is the front-to-back
 * order that determines which object is drawn in front, which is behind, and
 * so on.
 *
 * DisplayObject is an abstract base class; therefore, you cannot call
 * DisplayObject directly. Invoking `new DisplayObject()` throws an
 * `ArgumentError` exception.
 * The DisplayObjectContainer class is an abstract base class for all objects
 * that can contain child objects. It cannot be instantiated directly; calling
 * the `new DisplayObjectContainer()` constructor throws an
 * `ArgumentError` exception.
 *
 * For more information, see the "Display Programming" chapter of the
 * _ActionScript 3.0 Developer's Guide_.
 */
extern class DisplayObjectContainer extends InteractiveObject {
	
	
	/**
	 * Determines whether or not the children of the object are mouse, or user
	 * input device, enabled. If an object is enabled, a user can interact with
	 * it by using a mouse or user input device. The default is
	 * `true`.
	 *
	 * This property is useful when you create a button with an instance of
	 * the Sprite class(instead of using the SimpleButton class). When you use a
	 * Sprite instance to create a button, you can choose to decorate the button
	 * by using the `addChild()` method to add additional Sprite
	 * instances. This process can cause unexpected behavior with mouse events
	 * because the Sprite instances you add as children can become the target
	 * object of a mouse event when you expect the parent instance to be the
	 * target object. To ensure that the parent instance serves as the target
	 * objects for mouse events, you can set the `mouseChildren`
	 * property of the parent instance to `false`.
	 *
	 *  No event is dispatched by setting this property. You must use the
	 * `addEventListener()` method to create interactive
	 * functionality.
	 */
	public var mouseChildren:Bool;
	
	/**
	 * Returns the number of children of this object.
	 */
	public var numChildren (get, never):Int;
	
	
	/**
	 * Determines whether the children of the object are tab enabled. Enables or
	 * disables tabbing for the children of the object. The default is
	 * `true`.
	 *
	 * **Note:** Do not use the `tabChildren` property with
	 * Flex. Instead, use the
	 * `mx.core.UIComponent.hasFocusableChildren` property.
	 * 
	 * @throws IllegalOperationError Calling this property of the Stage object
	 *                               throws an exception. The Stage object does
	 *                               not implement this property.
	 */
	public var tabChildren:Bool;
	
	#if flash
	@:noCompletion @:dox(hide) public var textSnapshot (default, null):flash.text.TextSnapshot;
	#end
	
	
	/**
	 * Calling the `new DisplayObjectContainer()` constructor throws
	 * an `ArgumentError` exception. You _can_, however, call
	 * constructors for the following subclasses of DisplayObjectContainer:
	 * 
	 *  * `new Loader()`
	 *  * `new Sprite()`
	 *  * `new MovieClip()`
	 * 
	 */
	private function new ();
	
	
	/**
	 * Adds a child DisplayObject instance to this DisplayObjectContainer
	 * instance. The child is added to the front(top) of all other children in
	 * this DisplayObjectContainer instance.(To add a child to a specific index
	 * position, use the `addChildAt()` method.)
	 *
	 * If you add a child object that already has a different display object
	 * container as a parent, the object is removed from the child list of the
	 * other display object container. 
	 *
	 * **Note:** The command `stage.addChild()` can cause
	 * problems with a published SWF file, including security problems and
	 * conflicts with other loaded SWF files. There is only one Stage within a
	 * Flash runtime instance, no matter how many SWF files you load into the
	 * runtime. So, generally, objects should not be added to the Stage,
	 * directly, at all. The only object the Stage should contain is the root
	 * object. Create a DisplayObjectContainer to contain all of the items on the
	 * display list. Then, if necessary, add that DisplayObjectContainer instance
	 * to the Stage.
	 * 
	 * @param child The DisplayObject instance to add as a child of this
	 *              DisplayObjectContainer instance.
	 * @return The DisplayObject instance that you pass in the `child`
	 *         parameter.
	 * @throws ArgumentError Throws if the child is the same as the parent. Also
	 *                       throws if the caller is a child(or grandchild etc.)
	 *                       of the child being added.
	 * @event added Dispatched when a display object is added to the display
	 *              list.
	 */
	public function addChild (child:DisplayObject):DisplayObject;
	
	
	/**
	 * Adds a child DisplayObject instance to this DisplayObjectContainer
	 * instance. The child is added at the index position specified. An index of
	 * 0 represents the back(bottom) of the display list for this
	 * DisplayObjectContainer object.
	 *
	 * For example, the following example shows three display objects, labeled
	 * a, b, and c, at index positions 0, 2, and 1, respectively:
	 *
	 * If you add a child object that already has a different display object
	 * container as a parent, the object is removed from the child list of the
	 * other display object container. 
	 * 
	 * @param child The DisplayObject instance to add as a child of this
	 *              DisplayObjectContainer instance.
	 * @param index The index position to which the child is added. If you
	 *              specify a currently occupied index position, the child object
	 *              that exists at that position and all higher positions are
	 *              moved up one position in the child list.
	 * @return The DisplayObject instance that you pass in the `child`
	 *         parameter.
	 * @throws ArgumentError Throws if the child is the same as the parent. Also
	 *                       throws if the caller is a child(or grandchild etc.)
	 *                       of the child being added.
	 * @throws RangeError    Throws if the index position does not exist in the
	 *                       child list.
	 * @event added Dispatched when a display object is added to the display
	 *              list.
	 */
	public function addChildAt (child:DisplayObject, index:Int):DisplayObject;
	
	
	/**
	 * Indicates whether the security restrictions would cause any display
	 * objects to be omitted from the list returned by calling the
	 * `DisplayObjectContainer.getObjectsUnderPoint()` method with the
	 * specified `point` point. By default, content from one domain
	 * cannot access objects from another domain unless they are permitted to do
	 * so with a call to the `Security.allowDomain()` method. For more
	 * information, related to security, see the Flash Player Developer Center
	 * Topic: [Security](http://www.adobe.com/go/devnet_security_en).
	 *
	 * The `point` parameter is in the coordinate space of the
	 * Stage, which may differ from the coordinate space of the display object
	 * container(unless the display object container is the Stage). You can use
	 * the `globalToLocal()` and the `localToGlobal()`
	 * methods to convert points between these coordinate spaces.
	 * 
	 * @param point The point under which to look.
	 * @return `true` if the point contains child display objects with
	 *         security restrictions.
	 */
	public function areInaccessibleObjectsUnderPoint (point:Point):Bool;
	
	
	/**
	 * Determines whether the specified display object is a child of the
	 * DisplayObjectContainer instance or the instance itself. The search
	 * includes the entire display list including this DisplayObjectContainer
	 * instance. Grandchildren, great-grandchildren, and so on each return
	 * `true`.
	 * 
	 * @param child The child object to test.
	 * @return `true` if the `child` object is a child of
	 *         the DisplayObjectContainer or the container itself; otherwise
	 *         `false`.
	 */
	public function contains (child:DisplayObject):Bool;
	
	
	/**
	 * Returns the child display object instance that exists at the specified
	 * index.
	 * 
	 * @param index The index position of the child object.
	 * @return The child display object at the specified index position.
	 * @throws RangeError    Throws if the index does not exist in the child
	 *                       list.
	 * @throws SecurityError This child display object belongs to a sandbox to
	 *                       which you do not have access. You can avoid this
	 *                       situation by having the child movie call
	 *                       `Security.allowDomain()`.
	 */
	public function getChildAt (index:Int):DisplayObject;
	
	
	/**
	 * Returns the child display object that exists with the specified name. If
	 * more that one child display object has the specified name, the method
	 * returns the first object in the child list.
	 *
	 * The `getChildAt()` method is faster than the
	 * `getChildByName()` method. The `getChildAt()` method
	 * accesses a child from a cached array, whereas the
	 * `getChildByName()` method has to traverse a linked list to
	 * access a child.
	 * 
	 * @param name The name of the child to return.
	 * @return The child display object with the specified name.
	 * @throws SecurityError This child display object belongs to a sandbox to
	 *                       which you do not have access. You can avoid this
	 *                       situation by having the child movie call the
	 *                       `Security.allowDomain()` method.
	 */
	public function getChildByName (name:String):DisplayObject;
	
	
	/**
	 * Returns the index position of a `child` DisplayObject instance.
	 * 
	 * @param child The DisplayObject instance to identify.
	 * @return The index position of the child display object to identify.
	 * @throws ArgumentError Throws if the child parameter is not a child of this
	 *                       object.
	 */
	public function getChildIndex (child:DisplayObject):Int;
	
	
	/**
	 * Returns an array of objects that lie under the specified point and are
	 * children(or grandchildren, and so on) of this DisplayObjectContainer
	 * instance. Any child objects that are inaccessible for security reasons are
	 * omitted from the returned array. To determine whether this security
	 * restriction affects the returned array, call the
	 * `areInaccessibleObjectsUnderPoint()` method.
	 *
	 * The `point` parameter is in the coordinate space of the
	 * Stage, which may differ from the coordinate space of the display object
	 * container(unless the display object container is the Stage). You can use
	 * the `globalToLocal()` and the `localToGlobal()`
	 * methods to convert points between these coordinate spaces.
	 * 
	 * @param point The point under which to look.
	 * @return An array of objects that lie under the specified point and are
	 *         children(or grandchildren, and so on) of this
	 *         DisplayObjectContainer instance.
	 */
	public function getObjectsUnderPoint (point:Point):Array<DisplayObject>;
	
	
	/**
	 * Removes the specified `child` DisplayObject instance from the
	 * child list of the DisplayObjectContainer instance. The `parent`
	 * property of the removed child is set to `null` , and the object
	 * is garbage collected if no other references to the child exist. The index
	 * positions of any display objects above the child in the
	 * DisplayObjectContainer are decreased by 1.
	 *
	 * The garbage collector reallocates unused memory space. When a variable
	 * or object is no longer actively referenced or stored somewhere, the
	 * garbage collector sweeps through and wipes out the memory space it used to
	 * occupy if no other references to it exist.
	 * 
	 * @param child The DisplayObject instance to remove.
	 * @return The DisplayObject instance that you pass in the `child`
	 *         parameter.
	 * @throws ArgumentError Throws if the child parameter is not a child of this
	 *                       object.
	 */
	public function removeChild (child:DisplayObject):DisplayObject;
	
	
	/**
	 * Removes a child DisplayObject from the specified `index`
	 * position in the child list of the DisplayObjectContainer. The
	 * `parent` property of the removed child is set to
	 * `null`, and the object is garbage collected if no other
	 * references to the child exist. The index positions of any display objects
	 * above the child in the DisplayObjectContainer are decreased by 1.
	 *
	 * The garbage collector reallocates unused memory space. When a variable
	 * or object is no longer actively referenced or stored somewhere, the
	 * garbage collector sweeps through and wipes out the memory space it used to
	 * occupy if no other references to it exist.
	 * 
	 * @param index The child index of the DisplayObject to remove.
	 * @return The DisplayObject instance that was removed.
	 * @throws RangeError    Throws if the index does not exist in the child
	 *                       list.
	 * @throws SecurityError This child display object belongs to a sandbox to
	 *                       which the calling object does not have access. You
	 *                       can avoid this situation by having the child movie
	 *                       call the `Security.allowDomain()` method.
	 */
	public function removeChildAt (index:Int):DisplayObject;
	
	
	public function removeChildren (beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void;
	
	
	/**
	 * Changes the position of an existing child in the display object container.
	 * This affects the layering of child objects. For example, the following
	 * example shows three display objects, labeled a, b, and c, at index
	 * positions 0, 1, and 2, respectively:
	 *
	 * When you use the `setChildIndex()` method and specify an
	 * index position that is already occupied, the only positions that change
	 * are those in between the display object's former and new position. All
	 * others will stay the same. If a child is moved to an index LOWER than its
	 * current index, all children in between will INCREASE by 1 for their index
	 * reference. If a child is moved to an index HIGHER than its current index,
	 * all children in between will DECREASE by 1 for their index reference. For
	 * example, if the display object container in the previous example is named
	 * `container`, you can swap the position of the display objects
	 * labeled a and b by calling the following code:
	 *
	 * This code results in the following arrangement of objects:
	 * 
	 * @param child The child DisplayObject instance for which you want to change
	 *              the index number.
	 * @param index The resulting index number for the `child` display
	 *              object.
	 * @throws ArgumentError Throws if the child parameter is not a child of this
	 *                       object.
	 * @throws RangeError    Throws if the index does not exist in the child
	 *                       list.
	 */
	public function setChildIndex (child:DisplayObject, index:Int):Void;
	
	
	public function stopAllMovieClips ():Void;
	
	
	/**
	 * Swaps the z-order(front-to-back order) of the two specified child
	 * objects. All other child objects in the display object container remain in
	 * the same index positions.
	 * 
	 * @param child1 The first child object.
	 * @param child2 The second child object.
	 * @throws ArgumentError Throws if either child parameter is not a child of
	 *                       this object.
	 */
	public function swapChildren (child1:DisplayObject, child2:DisplayObject):Void;
	
	
	/**
	 * Swaps the z-order(front-to-back order) of the child objects at the two
	 * specified index positions in the child list. All other child objects in
	 * the display object container remain in the same index positions.
	 * 
	 * @param index1 The index position of the first child object.
	 * @param index2 The index position of the second child object.
	 * @throws RangeError If either index does not exist in the child list.
	 */
	public function swapChildrenAt (index1:Int, index2:Int):Void;
	
	
}


#else
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
#end