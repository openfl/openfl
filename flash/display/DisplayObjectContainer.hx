package flash.display;
#if (flash || display)


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
 * <p>DisplayObject is an abstract base class; therefore, you cannot call
 * DisplayObject directly. Invoking <code>new DisplayObject()</code> throws an
 * <code>ArgumentError</code> exception.</p>
 * The DisplayObjectContainer class is an abstract base class for all objects
 * that can contain child objects. It cannot be instantiated directly; calling
 * the <code>new DisplayObjectContainer()</code> constructor throws an
 * <code>ArgumentError</code> exception.
 *
 * <p>For more information, see the "Display Programming" chapter of the
 * <i>ActionScript 3.0 Developer's Guide</i>.</p>
 */
extern class DisplayObjectContainer extends InteractiveObject {

	/**
	 * Determines whether or not the children of the object are mouse, or user
	 * input device, enabled. If an object is enabled, a user can interact with
	 * it by using a mouse or user input device. The default is
	 * <code>true</code>.
	 *
	 * <p>This property is useful when you create a button with an instance of
	 * the Sprite class(instead of using the SimpleButton class). When you use a
	 * Sprite instance to create a button, you can choose to decorate the button
	 * by using the <code>addChild()</code> method to add additional Sprite
	 * instances. This process can cause unexpected behavior with mouse events
	 * because the Sprite instances you add as children can become the target
	 * object of a mouse event when you expect the parent instance to be the
	 * target object. To ensure that the parent instance serves as the target
	 * objects for mouse events, you can set the <code>mouseChildren</code>
	 * property of the parent instance to <code>false</code>.</p>
	 *
	 * <p> No event is dispatched by setting this property. You must use the
	 * <code>addEventListener()</code> method to create interactive
	 * functionality.</p>
	 */
	var mouseChildren : Bool;

	/**
	 * Returns the number of children of this object.
	 */
	var numChildren(default,null) : Int;

	/**
	 * Determines whether the children of the object are tab enabled. Enables or
	 * disables tabbing for the children of the object. The default is
	 * <code>true</code>.
	 *
	 * <p><b>Note:</b> Do not use the <code>tabChildren</code> property with
	 * Flex. Instead, use the
	 * <code>mx.core.UIComponent.hasFocusableChildren</code> property.</p>
	 * 
	 * @throws IllegalOperationError Calling this property of the Stage object
	 *                               throws an exception. The Stage object does
	 *                               not implement this property.
	 */
	var tabChildren : Bool;

	/**
	 * Returns a TextSnapshot object for this DisplayObjectContainer instance.
	 */
	#if !display
	var textSnapshot(default, null) : flash.text.TextSnapshot;
	#end

	/**
	 * Calling the <code>new DisplayObjectContainer()</code> constructor throws
	 * an <code>ArgumentError</code> exception. You <i>can</i>, however, call
	 * constructors for the following subclasses of DisplayObjectContainer:
	 * <ul>
	 *   <li><code>new Loader()</code></li>
	 *   <li><code>new Sprite()</code></li>
	 *   <li><code>new MovieClip()</code></li>
	 * </ul>
	 */
	private function new() : Void;

	/**
	 * Adds a child DisplayObject instance to this DisplayObjectContainer
	 * instance. The child is added to the front(top) of all other children in
	 * this DisplayObjectContainer instance.(To add a child to a specific index
	 * position, use the <code>addChildAt()</code> method.)
	 *
	 * <p>If you add a child object that already has a different display object
	 * container as a parent, the object is removed from the child list of the
	 * other display object container. </p>
	 *
	 * <p><b>Note:</b> The command <code>stage.addChild()</code> can cause
	 * problems with a published SWF file, including security problems and
	 * conflicts with other loaded SWF files. There is only one Stage within a
	 * Flash runtime instance, no matter how many SWF files you load into the
	 * runtime. So, generally, objects should not be added to the Stage,
	 * directly, at all. The only object the Stage should contain is the root
	 * object. Create a DisplayObjectContainer to contain all of the items on the
	 * display list. Then, if necessary, add that DisplayObjectContainer instance
	 * to the Stage.</p>
	 * 
	 * @param child The DisplayObject instance to add as a child of this
	 *              DisplayObjectContainer instance.
	 * @return The DisplayObject instance that you pass in the <code>child</code>
	 *         parameter.
	 * @throws ArgumentError Throws if the child is the same as the parent. Also
	 *                       throws if the caller is a child(or grandchild etc.)
	 *                       of the child being added.
	 * @event added Dispatched when a display object is added to the display
	 *              list.
	 */
	function addChild(child : DisplayObject) : DisplayObject;

	/**
	 * Adds a child DisplayObject instance to this DisplayObjectContainer
	 * instance. The child is added at the index position specified. An index of
	 * 0 represents the back(bottom) of the display list for this
	 * DisplayObjectContainer object.
	 *
	 * <p>For example, the following example shows three display objects, labeled
	 * a, b, and c, at index positions 0, 2, and 1, respectively:</p>
	 *
	 * <p>If you add a child object that already has a different display object
	 * container as a parent, the object is removed from the child list of the
	 * other display object container. </p>
	 * 
	 * @param child The DisplayObject instance to add as a child of this
	 *              DisplayObjectContainer instance.
	 * @param index The index position to which the child is added. If you
	 *              specify a currently occupied index position, the child object
	 *              that exists at that position and all higher positions are
	 *              moved up one position in the child list.
	 * @return The DisplayObject instance that you pass in the <code>child</code>
	 *         parameter.
	 * @throws ArgumentError Throws if the child is the same as the parent. Also
	 *                       throws if the caller is a child(or grandchild etc.)
	 *                       of the child being added.
	 * @throws RangeError    Throws if the index position does not exist in the
	 *                       child list.
	 * @event added Dispatched when a display object is added to the display
	 *              list.
	 */
	function addChildAt(child : DisplayObject, index : Int) : DisplayObject;

	/**
	 * Indicates whether the security restrictions would cause any display
	 * objects to be omitted from the list returned by calling the
	 * <code>DisplayObjectContainer.getObjectsUnderPoint()</code> method with the
	 * specified <code>point</code> point. By default, content from one domain
	 * cannot access objects from another domain unless they are permitted to do
	 * so with a call to the <code>Security.allowDomain()</code> method. For more
	 * information, related to security, see the Flash Player Developer Center
	 * Topic: <a href="http://www.adobe.com/go/devnet_security_en"
	 * scope="external">Security</a>.
	 *
	 * <p>The <code>point</code> parameter is in the coordinate space of the
	 * Stage, which may differ from the coordinate space of the display object
	 * container(unless the display object container is the Stage). You can use
	 * the <code>globalToLocal()</code> and the <code>localToGlobal()</code>
	 * methods to convert points between these coordinate spaces.</p>
	 * 
	 * @param point The point under which to look.
	 * @return <code>true</code> if the point contains child display objects with
	 *         security restrictions.
	 */
	function areInaccessibleObjectsUnderPoint(point : flash.geom.Point) : Bool;

	/**
	 * Determines whether the specified display object is a child of the
	 * DisplayObjectContainer instance or the instance itself. The search
	 * includes the entire display list including this DisplayObjectContainer
	 * instance. Grandchildren, great-grandchildren, and so on each return
	 * <code>true</code>.
	 * 
	 * @param child The child object to test.
	 * @return <code>true</code> if the <code>child</code> object is a child of
	 *         the DisplayObjectContainer or the container itself; otherwise
	 *         <code>false</code>.
	 */
	function contains(child : DisplayObject) : Bool;

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
	 *                       <code>Security.allowDomain()</code>.
	 */
	function getChildAt(index : Int) : DisplayObject;

	/**
	 * Returns the child display object that exists with the specified name. If
	 * more that one child display object has the specified name, the method
	 * returns the first object in the child list.
	 *
	 * <p>The <code>getChildAt()</code> method is faster than the
	 * <code>getChildByName()</code> method. The <code>getChildAt()</code> method
	 * accesses a child from a cached array, whereas the
	 * <code>getChildByName()</code> method has to traverse a linked list to
	 * access a child.</p>
	 * 
	 * @param name The name of the child to return.
	 * @return The child display object with the specified name.
	 * @throws SecurityError This child display object belongs to a sandbox to
	 *                       which you do not have access. You can avoid this
	 *                       situation by having the child movie call the
	 *                       <code>Security.allowDomain()</code> method.
	 */
	function getChildByName(name : String) : DisplayObject;

	/**
	 * Returns the index position of a <code>child</code> DisplayObject instance.
	 * 
	 * @param child The DisplayObject instance to identify.
	 * @return The index position of the child display object to identify.
	 * @throws ArgumentError Throws if the child parameter is not a child of this
	 *                       object.
	 */
	function getChildIndex(child : DisplayObject) : Int;

	/**
	 * Returns an array of objects that lie under the specified point and are
	 * children(or grandchildren, and so on) of this DisplayObjectContainer
	 * instance. Any child objects that are inaccessible for security reasons are
	 * omitted from the returned array. To determine whether this security
	 * restriction affects the returned array, call the
	 * <code>areInaccessibleObjectsUnderPoint()</code> method.
	 *
	 * <p>The <code>point</code> parameter is in the coordinate space of the
	 * Stage, which may differ from the coordinate space of the display object
	 * container(unless the display object container is the Stage). You can use
	 * the <code>globalToLocal()</code> and the <code>localToGlobal()</code>
	 * methods to convert points between these coordinate spaces.</p>
	 * 
	 * @param point The point under which to look.
	 * @return An array of objects that lie under the specified point and are
	 *         children(or grandchildren, and so on) of this
	 *         DisplayObjectContainer instance.
	 */
	function getObjectsUnderPoint(point : flash.geom.Point) : Array<DisplayObject>;

	/**
	 * Removes the specified <code>child</code> DisplayObject instance from the
	 * child list of the DisplayObjectContainer instance. The <code>parent</code>
	 * property of the removed child is set to <code>null</code> , and the object
	 * is garbage collected if no other references to the child exist. The index
	 * positions of any display objects above the child in the
	 * DisplayObjectContainer are decreased by 1.
	 *
	 * <p>The garbage collector reallocates unused memory space. When a variable
	 * or object is no longer actively referenced or stored somewhere, the
	 * garbage collector sweeps through and wipes out the memory space it used to
	 * occupy if no other references to it exist.</p>
	 * 
	 * @param child The DisplayObject instance to remove.
	 * @return The DisplayObject instance that you pass in the <code>child</code>
	 *         parameter.
	 * @throws ArgumentError Throws if the child parameter is not a child of this
	 *                       object.
	 */
	function removeChild(child : DisplayObject) : DisplayObject;

	/**
	 * Removes a child DisplayObject from the specified <code>index</code>
	 * position in the child list of the DisplayObjectContainer. The
	 * <code>parent</code> property of the removed child is set to
	 * <code>null</code>, and the object is garbage collected if no other
	 * references to the child exist. The index positions of any display objects
	 * above the child in the DisplayObjectContainer are decreased by 1.
	 *
	 * <p>The garbage collector reallocates unused memory space. When a variable
	 * or object is no longer actively referenced or stored somewhere, the
	 * garbage collector sweeps through and wipes out the memory space it used to
	 * occupy if no other references to it exist.</p>
	 * 
	 * @param index The child index of the DisplayObject to remove.
	 * @return The DisplayObject instance that was removed.
	 * @throws RangeError    Throws if the index does not exist in the child
	 *                       list.
	 * @throws SecurityError This child display object belongs to a sandbox to
	 *                       which the calling object does not have access. You
	 *                       can avoid this situation by having the child movie
	 *                       call the <code>Security.allowDomain()</code> method.
	 */
	function removeChildAt(index : Int) : DisplayObject;
	#if !display
	@:require(flash11) function removeChildren(beginIndex : Int = 0, endIndex : Int = 2147483647) : Void;
	#end

	/**
	 * Changes the position of an existing child in the display object container.
	 * This affects the layering of child objects. For example, the following
	 * example shows three display objects, labeled a, b, and c, at index
	 * positions 0, 1, and 2, respectively:
	 *
	 * <p>When you use the <code>setChildIndex()</code> method and specify an
	 * index position that is already occupied, the only positions that change
	 * are those in between the display object's former and new position. All
	 * others will stay the same. If a child is moved to an index LOWER than its
	 * current index, all children in between will INCREASE by 1 for their index
	 * reference. If a child is moved to an index HIGHER than its current index,
	 * all children in between will DECREASE by 1 for their index reference. For
	 * example, if the display object container in the previous example is named
	 * <code>container</code>, you can swap the position of the display objects
	 * labeled a and b by calling the following code:</p>
	 *
	 * <p>This code results in the following arrangement of objects:</p>
	 * 
	 * @param child The child DisplayObject instance for which you want to change
	 *              the index number.
	 * @param index The resulting index number for the <code>child</code> display
	 *              object.
	 * @throws ArgumentError Throws if the child parameter is not a child of this
	 *                       object.
	 * @throws RangeError    Throws if the index does not exist in the child
	 *                       list.
	 */
	function setChildIndex(child : DisplayObject, index : Int) : Void;

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
	function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : Void;

	/**
	 * Swaps the z-order(front-to-back order) of the child objects at the two
	 * specified index positions in the child list. All other child objects in
	 * the display object container remain in the same index positions.
	 * 
	 * @param index1 The index position of the first child object.
	 * @param index2 The index position of the second child object.
	 * @throws RangeError If either index does not exist in the child list.
	 */
	function swapChildrenAt(index1 : Int, index2 : Int) : Void;
}


#end
