package openfl.display;

import openfl.errors.ArgumentError;
import openfl.errors.RangeError;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events._Event;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Point;
import openfl.geom._Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text._TextField;
import openfl.media.Video;
import openfl.media._Video;
import openfl.Vector;

using openfl._internal.utils.DisplayObjectLinkedList;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.events.Event)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.SimpleButton)
@:access(openfl.errors.Error)
@:access(openfl.geom.Point)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:access(openfl.text.TextField)
@:noCompletion
class _DisplayObjectContainer extends _InteractiveObject
{
	public var mouseChildren:Bool;
	public var numChildren:Int;
	public var tabChildren(get, set):Bool;

	public var __removedChildren:Vector<DisplayObject>;
	public var __tabChildren:Bool;

	private var displayObjectContainer:DisplayObjectContainer;

	public function new(displayObjectContainer:DisplayObjectContainer)
	{
		this.displayObjectContainer = displayObjectContainer;

		super(displayObjectContainer);

		__type = DISPLAY_OBJECT_CONTAINER;

		mouseChildren = true;
		__tabChildren = true;

		numChildren = 0;
		__removedChildren = new Vector<DisplayObject>();
	}

	public function addChild(child:DisplayObject):DisplayObject
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

		if (child.parent == this.displayObjectContainer)
		{
			DisplayObjectLinkedList.__addChild(this.displayObjectContainer, child);
		}
		else
		{
			DisplayObjectLinkedList.__reparent(this.displayObjectContainer, child);
			DisplayObjectLinkedList.__addChild(this.displayObjectContainer, child);

			var addedToStage = (stage != null && child.stage == null);

			if (addedToStage)
			{
				(child._ : _DisplayObject).__setStageReferences(stage);
			}

				(child._ : _DisplayObject).__setTransformDirty(true);
			(child._ : _DisplayObject).__setParentRenderDirty();
			(child._ : _DisplayObject).__setRenderDirty();
			__localBoundsDirty = true;
			__setRenderDirty();

			#if !openfl_disable_event_pooling
			var event = _Event.__pool.get();
			(event._ : _Event).type = Event.ADDED;
			#else
			var event = new Event(Event.ADDED);
			#end
			(event._ : _Event).bubbles = true;

			(event._ : _Event).target = child;

			(child._ : _DisplayObject).__dispatchWithCapture(event);

			#if !openfl_disable_event_pooling
			_Event.__pool.release(event);
			#end

			if (addedToStage)
			{
				#if openfl_pool_events
				event = _Event.__pool.get(Event.ADDED_TO_STAGE);
				#else
				event = new Event(Event.ADDED_TO_STAGE, false, false);
				#end

				(child._ : _DisplayObject).__dispatchWithCapture(event);
				(child._ : _DisplayObject).__dispatchChildren(event);

				#if openfl_pool_events
				_Event.__pool.release(event);
				#end
			}
		}

		return child;
	}

	public function addChildAt(child:DisplayObject, index:Int):DisplayObject
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
		#if ((haxe_ver >= "3.4.0") || !cpp)
		else if (child.stage == child)
		{
			var error = new ArgumentError("Error #3783: A Stage object cannot be added as the child of another object.");
			error.errorID = 3783;
			throw error;
		}
		#end

		if (index < 0 || index > numChildren)
		{
			throw "Invalid index position " + index;
		}

		if (child.parent == this.displayObjectContainer)
		{
			if (index == 0)
			{
				if (__firstChild != child)
				{
					DisplayObjectLinkedList.__unshiftChild(this.displayObjectContainer, child);
					__setRenderDirty();
				}
			}
			else
			{
				DisplayObjectLinkedList.__swapChildren(this.displayObjectContainer, child, getChildAt(index));
				__setRenderDirty();
			}
		}
		else
		{
			DisplayObjectLinkedList.__reparent(this.displayObjectContainer, child);
			DisplayObjectLinkedList.__insertChildAt(this.displayObjectContainer, child, index);
			__setRenderDirty();

			var addedToStage = (stage != null && child.stage == null);

			if (addedToStage)
			{
				(child._ : _DisplayObject).__setStageReferences(stage);
			}

				(child._ : _DisplayObject).__setTransformDirty(true);
			(child._ : _DisplayObject).__setParentRenderDirty();
			(child._ : _DisplayObject).__setRenderDirty();
			__localBoundsDirty = true;
			__setRenderDirty();

			#if !openfl_disable_event_pooling
			var event = _Event.__pool.get();
			(event._ : _Event).type = Event.ADDED;
			#else
			var event = new Event(Event.ADDED);
			#end
			(event._ : _Event).bubbles = true;

			(event._ : _Event).target = child;

			(child._ : _DisplayObject).__dispatchWithCapture(event);

			#if !openfl_disable_event_pooling
			_Event.__pool.release(event);
			#end

			if (addedToStage)
			{
				#if openfl_pool_events
				event = _Event.__pool.get(Event.ADDED_TO_STAGE);
				#else
				event = new Event(Event.ADDED_TO_STAGE, false, false);
				#end

				(child._ : _DisplayObject).__dispatchWithCapture(event);
				(child._ : _DisplayObject).__dispatchChildren(event);

				#if openfl_pool_events
				_Event.__pool.release(event);
				#end
			}
		}

		return child;
	}

	public function areInaccessibleObjectsUnderPoint(point:Point):Bool
	{
		return false;
	}

	public function contains(child:DisplayObject):Bool
	{
		while (child != this.displayObjectContainer && child != null)
		{
			child = child.parent;
		}

		return child == this.displayObjectContainer;
	}

	public function getChildAt(index:Int):DisplayObject
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
				child = (child._ : _DisplayObject).__nextSibling;
			}
		}

		return child;
	}

	public function getChildByName(name:String):DisplayObject
	{
		var child = __firstChild;
		while (child != null)
		{
			if (child.name == name)
			{
				return child;
			}
			child = (child._ : _DisplayObject).__nextSibling;
		}
		return null;
	}

	public function getChildIndex(child:DisplayObject):Int
	{
		var current = __firstChild;
		if (current != null)
		{
			for (i in 0...numChildren)
			{
				if (current == child) return i;
				current = (current._ : _DisplayObject).__nextSibling;
			}
		}
		return -1;
	}

	public function getObjectsUnderPoint(point:Point):Array<DisplayObject>
	{
		var stack = new Array<DisplayObject>();
		__hitTest(point.x, point.y, false, stack, false, this.displayObjectContainer);
		stack.reverse();
		return stack;
	}

	public function removeChild(child:DisplayObject):DisplayObject
	{
		if (child != null && child.parent == this.displayObjectContainer)
		{
			(child._ : _DisplayObject).__setTransformDirty();
			(child._ : _DisplayObject).__setParentRenderDirty();
			(child._ : _DisplayObject).__setRenderDirty();
			__localBoundsDirty = true;
			__setRenderDirty();

			var event = new Event(Event.REMOVED, true);
			(child._ : _DisplayObject).__dispatchWithCapture(event);

			if (stage != null)
			{
				if (child.stage != null && stage.focus == child)
				{
					stage.focus = null;
				}

				var event = new Event(Event.REMOVED_FROM_STAGE, false, false);
				(child._ : _DisplayObject).__dispatchWithCapture(event);
				(child._ : _DisplayObject).__dispatchChildren(event);
				(child._ : _DisplayObject).__setStageReferences(null);
			}

			DisplayObjectLinkedList.__removeChild(this.displayObjectContainer, child);

			__removedChildren.push(child);
			(child._ : _DisplayObject).__setTransformDirty(true);
			(child._ : _DisplayObject).__setParentRenderDirty();
		}

		return child;
	}

	public function removeChildAt(index:Int):DisplayObject
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
					child = (child._ : _DisplayObject).__nextSibling;
				}
			}
		}

		return null;
	}

	public function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void
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
				child = (child._ : _DisplayObject).__nextSibling;
			}
		}

		var numRemovals = endIndex - beginIndex;
		var next = null;

		while (numRemovals >= 0)
		{
			next = (child._ : _DisplayObject).__nextSibling;
			removeChild(child);
			child = next;
			numRemovals--;
		}
	}

	public function resolve(fieldName:String):DisplayObject
	{
		var child = __firstChild;
		while (child != null)
		{
			if (child.name == fieldName)
			{
				return child;
			}
			child = (child._ : _DisplayObject).__nextSibling;
		}

		return null;
	}

	public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		if (index >= 0 && index <= numChildren && numChildren > 1 && child.parent == this.displayObjectContainer)
		{
			#if openfl_validate_children
			var copy = __children.copy();
			#end
			if (index == 0)
			{
				DisplayObjectLinkedList.__unshiftChild(this.displayObjectContainer, child);
			}
			else if (index >= numChildren - 1)
			{
				DisplayObjectLinkedList.__addChild(this.displayObjectContainer, child);
			}
			else
			{
				DisplayObjectLinkedList.__insertChildAt(this.displayObjectContainer, child, index);
			}
			__setRenderDirty();
			#if openfl_validate_children
			__children = copy;
			__children.remove(child);
			__children.insert(index, child);
			DisplayObjectLinkedList.__validateChildren(this.displayObjectContainer, "setChildIndex");
			#end
		}
	}

	public function stopAllMovieClips():Void
	{
		__stopAllMovieClips();
	}

	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		if (child1.parent == this.displayObjectContainer && child2.parent == this.displayObjectContainer && child1 != child2)
		{
			DisplayObjectLinkedList.__swapChildren(this.displayObjectContainer, child1, child2);
			__setRenderDirty();
		}
	}

	public function swapChildrenAt(index1:Int, index2:Int):Void
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
					current = (current._ : _DisplayObject).__nextSibling;
				}
			}

			DisplayObjectLinkedList.__swapChildren(this.displayObjectContainer, child1, child2);
			__setRenderDirty();
		}
	}

	public inline function __cleanupRemovedChildren():Void
	{
		for (orphan in __removedChildren)
		{
			if (orphan.stage == null)
			{
				(orphan._ : _DisplayObject).__cleanup();
			}
		}

		__removedChildren.length = 0;
	}

	public override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		super.__getBounds(rect, matrix);

		if (numChildren == 0) return;

		var childWorldTransform = _Matrix.__pool.get();

		var child = __firstChild;
		while (child != null)
		{
			if ((child._ : _DisplayObject).__scaleX != 0 && (child._ : _DisplayObject).__scaleY != 0)
			{
				_DisplayObject.__calculateAbsoluteTransform((child._ : _DisplayObject).__transform, matrix, childWorldTransform);
				(child._ : _DisplayObject).__getBounds(rect, childWorldTransform);
			}
			child = (child._ : _DisplayObject).__nextSibling;
		}

		_Matrix.__pool.release(childWorldTransform);
	}

	public override function __getFilterBounds(rect:Rectangle, matrix:Matrix):Void
	{
		super.__getFilterBounds(rect, matrix);
		if (__scrollRect != null) return;

		if (numChildren == 0) return;

		var childWorldTransform = _Matrix.__pool.get();

		var child = __firstChild;
		while (child != null)
		{
			if ((child._ : _DisplayObject).__scaleX != 0
				&& (child._ : _DisplayObject).__scaleY != 0 && !(child._ : _DisplayObject).__isMask)
			{
				_DisplayObject.__calculateAbsoluteTransform((child._ : _DisplayObject).__transform, matrix, childWorldTransform);
				(child._ : _DisplayObject).__getFilterBounds(rect, childWorldTransform);
			}
			child = (child._ : _DisplayObject).__nextSibling;
		}

		_Matrix.__pool.release(childWorldTransform);
	}

	public override function __getRenderBounds(rect:Rectangle, matrix:Matrix):Void
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

		var childWorldTransform = _Matrix.__pool.get();

		var child = __firstChild;
		while (child != null)
		{
			if ((child._ : _DisplayObject).__scaleX != 0
				&& (child._ : _DisplayObject).__scaleY != 0 && !(child._ : _DisplayObject).__isMask)
			{
				_DisplayObject.__calculateAbsoluteTransform((child._ : _DisplayObject).__transform, matrix, childWorldTransform);
				(child._ : _DisplayObject).__getRenderBounds(rect, childWorldTransform);
			}
			child = (child._ : _DisplayObject).__nextSibling;
		}

		_Matrix.__pool.release(childWorldTransform);
	}

	public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled && !mouseChildren)) return false;
		if (mask != null && !(mask._ : _DisplayObject).__hitTestMask(x, y)) return false;

		if (__scrollRect != null)
		{
			var point = _Point.__pool.get();
			point.setTo(x, y);
			__getRenderTransform()._.__transformInversePoint(point);

			if (!__scrollRect.containsPoint(point))
			{
				_Point.__pool.release(point);
				return false;
			}

			_Point.__pool.release(point);
		}

		var child = __lastChild;
		if (interactiveOnly)
		{
			if (stack == null || !mouseChildren)
			{
				while (child != null)
				{
					if ((child._ : _DisplayObject).__hitTest(x, y, shapeFlag, null, true, cast child))
					{
						if (stack != null)
						{
							stack.push(hitObject);
						}

						return true;
					}
					child = (child._ : _DisplayObject).__previousSibling;
				}
			}
			else if (stack != null)
			{
				var length = stack.length;

				var interactive = false;
				var hitTest = false;

				while (child != null)
				{
					interactive = (child._ : _DisplayObject).__getInteractive(null);

					if (interactive || (mouseEnabled && !hitTest))
					{
						if ((child._ : _DisplayObject).__hitTest(x, y, shapeFlag, stack, true, cast child))
						{
							hitTest = true;

							if (interactive && stack.length > length)
							{
								break;
							}
						}
					}
					child = (child._ : _DisplayObject).__previousSibling;
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
				if ((child._ : _DisplayObject).__hitTest(x, y, shapeFlag, stack, false, cast child))
				{
					hitTest = true;
					if (stack == null) break;
				}
				child = (child._ : _DisplayObject).__previousSibling;
			}

			return hitTest;
		}

		return false;
	}

	// public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
	// 		hitObject:DisplayObject):Bool
	// {
	// 	if (!hitObject.visible || __isMask || (interactiveOnly && !mouseEnabled && !mouseChildren)) return false;
	// 	if (mask != null && !(mask._ : _DisplayObject).__hitTestMask(x, y)) return false;
	// 	if (__scrollRect != null)
	// 	{
	// 		var point = _Point.__pool.get();
	// 		point.setTo(x, y);
	// 		__getRenderTransform()._.__transformInversePoint(point);
	// 		if (!__scrollRect.containsPoint(point))
	// 		{
	// 			_Point.__pool.release(point);
	// 			return false;
	// 		}
	// 		_Point.__pool.release(point);
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
	// 				interactive = (child._ : _DisplayObject).__getInteractive(null);
	// 				if (!interactive && !mouseEnabled && hitTest)
	// 				{
	// 					children.skip(child);
	// 					continue;
	// 				}
	// 				stackLength = stack.length;
	// 			}
	// 			inline function super_hitTest(child:DisplayObject, x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
	// 					hitObject:DisplayObject):Bool
	// 			{
	// 				var hitTest = false;
	// 				if ((child._ : _DisplayObject).__graphics != null)
	// 				{
	// 					if (!hitObject._.__visible || (child._ : _DisplayObject).__isMask || (child.mask != null && !child.(mask._ : _DisplayObject).__hitTestMask(x, y)))
	// 					{
	// 						hitTest = false;
	// 					}
	// 					else if ((child._ : _DisplayObject).__graphics._.__hitTest(x, y, shapeFlag, (child._ : _DisplayObject).__getRenderTransform()))
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
	// 			var childHit = switch ((child._ : _DisplayObject).__type)
	// 			{
	// 				case BITMAP:
	// 					var bitmap:Bitmap = cast child;
	// 					inline (bitmap._ : _Bitmap).__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
	// 				case SIMPLE_BUTTON:
	// 					var simpleButton:SimpleButton = cast child;
	// 					inline (simpleButton._ : _SimpleButton).__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
	// 				case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
	// 					// inline super.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
	// 					super_hitTest(child, x, y, shapeFlag, stackRef, interactiveOnly, cast child);
	// 				case TEXTFIELD:
	// 					var textField:TextField = cast child;
	// 					inline (textField._ : _TextField).__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
	// 				case TILEMAP:
	// 					var tilemap:Tilemap = cast child;
	// 					inline tilemap._.__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
	// 				case VIDEO:
	// 					var video:Video = cast child;
	// 					inline (video._ : _Video).__hitTest(x, y, shapeFlag, stackRef, interactiveOnly, cast child);
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

	public override function __hitTestMask(x:Float, y:Float):Bool
	{
		// if (super.__hitTestMask(x, y))
		// {
		// 	return true;
		// }
		if (__graphics != null && (__graphics._ : _Graphics).__hitTest(x, y, true, __getRenderTransform()))
		{
			return true;
		}

		if (numChildren > 0)
		{
			for (child in __childIterator())
			{
				if (switch ((child._ : _DisplayObject).__type)
					{
						case BITMAP:
							var bitmap:Bitmap = cast child;
							#if haxe4 inline #end (bitmap._ : _Bitmap).__hitTestMask(x, y);
						case SIMPLE_BUTTON:
							var simpleButton:SimpleButton = cast child;
							#if haxe4 inline #end (simpleButton._ : _SimpleButton).__hitTestMask(x, y);
						case TEXTFIELD:
							var textField:TextField = cast child;
							#if haxe4 inline #end (textField._ : _TextField).__hitTestMask(x, y);
						case VIDEO:
							var video:Video = cast child;
							#if haxe4 inline #end (video._ : _Video).__hitTestMask(x, y);
						case DISPLAY_OBJECT_CONTAINER,
							MOVIE_CLIP: // inline super.__hitTestMask(x, y) || ((child._ : _DisplayObject).__graphics != null && (child._ : _DisplayObject).__graphics._.__hitTest(x, y, true, (child._ : _DisplayObject).__getRenderTransform()));
							(__graphics != null && (__graphics._ : _Graphics).__hitTest(x, y, true, __getRenderTransform()))
							|| ((child._ : _DisplayObject).__graphics != null
								&& ((child._ : _DisplayObject).__graphics._ : _Graphics).__hitTest(x, y, true,
									(child._ : _DisplayObject).__getRenderTransform()));
						default: super.__hitTestMask(x, y);
					})
				{
					return true;
				}
			}
		}

		return false;
	}

	public override function __readGraphicsData(graphicsData:Vector<IGraphicsData>, recurse:Bool):Void
	{
		// super.__readGraphicsData(graphicsData, recurse);
		if (__graphics != null)
		{
			(__graphics._ : _Graphics).__readGraphicsData(graphicsData);
		}

		if (recurse && numChildren > 0)
		{
			for (child in __childIterator())
			{
				// inline super.__readGraphicsData(graphicsData, recurse);
				if ((child._ : _DisplayObject).__graphics != null)
				{
					((child._ : _DisplayObject).__graphics._ : _Graphics).__readGraphicsData(graphicsData);
				}
			}
		}
	}

	public override function __setTransformDirty(force:Bool = false):Void
	{
		// inline super.__setTransformDirty(force);
		__transformDirty = true;

		if (numChildren > 0 && (!__childTransformDirty || force))
		{
			for (child in __childIterator())
			{
				if ((child._ : _DisplayObject).__type == SIMPLE_BUTTON)
				{
					var simpleButton:SimpleButton = cast child;
					#if haxe4 inline #end (simpleButton._ : _SimpleButton).__setTransformDirty(force);
				}
				else
				{
					// inline super.__setTransformDirty(force);
					(child._ : _DisplayObject).__transformDirty = true;
				}
			}

			__childTransformDirty = true;
		}
	}

	public override function __stopAllMovieClips():Void
	{
		if (numChildren > 0)
		{
			for (child in __childIterator())
			{
				if ((child._ : _DisplayObject).__type == MOVIE_CLIP)
				{
					var movieClip:MovieClip = cast child;
					movieClip.stop();
				}
			}
		}
	}

	public override function __tabTest(stack:Array<InteractiveObject>):Void
	{
		// inline super.__tabTest(stack);
		if (tabEnabled)
		{
			stack.push(this.displayObjectContainer);
		}
		if (!tabChildren) return;

		if (numChildren > 0)
		{
			var children = __childIterator();
			for (child in children)
			{
				switch ((child._ : _DisplayObject).__type)
				{
					case MOVIE_CLIP:
						var movieClip:MovieClip = cast child;
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
					case DISPLAY_OBJECT_CONTAINER:
						var displayObjectContainer:DisplayObjectContainer = cast child;
						if (displayObjectContainer.tabEnabled)
						{
							stack.push(displayObjectContainer);
						}
						if (!displayObjectContainer.tabChildren)
						{
							children.skip(displayObjectContainer);
							continue;
						}
					case SIMPLE_BUTTON, TEXTFIELD:
						var interactiveObject:InteractiveObject = cast child;
						if (interactiveObject.tabEnabled)
						{
							stack.push(interactiveObject);
						}
					default:
				}
			}
		}
	}

	public override function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		__updateSingle(transformOnly, updateChildren);

		if (updateChildren && numChildren > 0)
		{
			for (child in __childIterator())
			{
				var transformDirty = (child._ : _DisplayObject).__transformDirty;

				// TODO: Flatten masks
				(child._ : _DisplayObject).__updateSingle(transformOnly, updateChildren);

				switch ((child._ : _DisplayObject).__type)
				{
					case SIMPLE_BUTTON:
						// TODO: Flatten this into the allChildren() call?
						if (updateChildren)
						{
							var button:SimpleButton = cast child;
							if ((button._ : _SimpleButton).__currentState != null)
							{
								((button._ : _SimpleButton).__currentState._ : _DisplayObject).__update(transformOnly, true);
							}

							if (button.hitTestState != null && button.hitTestState != (button._ : _SimpleButton).__currentState)
							{
								(button.hitTestState._ : _DisplayObject).__update(transformOnly, true);
							}
						}

					case TEXTFIELD:
						if (transformDirty)
						{
							var textField:TextField = cast child;
							(textField._ : _TextField).__renderTransform._.__translateTransformed((textField._ : _TextField).__offsetX,
								(textField._ : _TextField).__offsetY);
						}

					case DISPLAY_OBJECT_CONTAINER, MOVIE_CLIP:
						// Ensure children are marked as dirty again
						// as we no longer know if they all are dirty
						// since at least one has been updated
						(child._ : _DisplayObject).__childTransformDirty = false;

					default:
				}
			}
		}

		__childTransformDirty = false;
	}

	// Get & Set Methods

	private function get_tabChildren():Bool
	{
		return __tabChildren;
	}

	private function set_tabChildren(value:Bool):Bool
	{
		if (__tabChildren != value)
		{
			__tabChildren = value;

			dispatchEvent(new Event(Event.TAB_CHILDREN_CHANGE, true, false));
		}

		return __tabChildren;
	}
}
