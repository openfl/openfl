package openfl.display; #if !openfl_legacy


import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import openfl.utils.UnshrinkableArray;

@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Rectangle)


class DisplayObjectContainer extends InteractiveObject {


	public var mouseChildren:Bool;
	public var numChildren (get, null):Int;
	public var tabChildren:Bool;

	private function new () {

		super ();

		mouseChildren = true;

		__children = new UnshrinkableArray<DisplayObject> (8);

	}


	inline public function addChild (child:DisplayObject):DisplayObject {
		return addChildAt(child, numChildren);
	}


	public function addChildAt (child:DisplayObject, index:Int):DisplayObject {

		if (index < 0 || index > __children.length) {
			throw "Invalid index position " + index;
		}

		if (!__useSeparateRenderScaleTransform) {
			child.__useSeparateRenderScaleTransform = false;
		}

		var childIndexToRemove:Int = -1;

		if (child.parent == this) {
			childIndexToRemove = __children.indexOf (child);
			__children[childIndexToRemove] = null;
			__children.insert(index,child);
		} else {
			if (child.parent != null) {
				child.parent.removeChild (child);
			}

			__children.insert(index,child);
			initParent(child);
		}

		if(childIndexToRemove > -1) {
			removeChildAt(childIndexToRemove < index ? childIndexToRemove : childIndexToRemove + 1);
		}

		return child;

	}

	public function initParent (child:DisplayObject) {

			child.parent = this;

			if (this.__cachedParent != null) {

				child.setCachedParent (this.__cachedParent);

			}	else if (this.__cacheAsBitmap) {

				child.setCachedParent (this);

			}

			if (stage != null) {
				// TODO: Dispatch ADDED_TO_STAGE after ADDED (but parent and stage must be set)
				child.__setStageReference (stage);

			}

			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();

			child.dispatchEvent (Event.__create (Event.ADDED, true));
	}

	public function areInaccessibleObjectsUnderPoint (point:Point):Bool {

		return false;

	}


	public function contains (child:DisplayObject):Bool {

		while (child != this && child != null) {

			child = child.parent;

		}

		return child == this;

	}


	public function getChildAt (index:Int):DisplayObject {

		if (index >= 0 && index < __children.length) {

			return __children[index];

		}

		return null;

	}


	public function getChildByName (name:String):DisplayObject {

		for (child in __children) {
			if (child == null) continue;
			if (child.name == name) return child;

		}

		return null;

	}


	public function getChildIndex (child:DisplayObject):Int {

		return __children.indexOf(child);

	}


	public function getObjectsUnderPoint (point:Point):UnshrinkableArray<DisplayObject> {

		var stack = new UnshrinkableArray<DisplayObject>(32);
		__hitTest (point.x, point.y, false, stack, false, this);
		stack.reverse ();
		return stack;

	}


	public function removeChild (child:DisplayObject):DisplayObject {

		if (child != null && child.parent == this) {

			child.dispatchEvent (Event.__create (Event.REMOVED, true));

			if (stage != null) {

				child.__setStageReference (null);

			}

			child.parent = null;
			if(child.__cachedParent != null){
				child.setCachedParent(null);
			}
			__children.remove (child);
			child.__setTransformDirty ();
			child.__setRenderDirty ();
			__setRenderDirty();

		}

		return child;

	}


	public function removeChildAt (index:Int):DisplayObject {

		if (index >= 0 && index < __children.length) {

			var child: DisplayObject = __children[index];

			if(child !=null){
				return removeChild (child);
			} else {
				__children.splice(index, 1);
			}

		}

		return null;

	}


	public function removeChildren (beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void {

		if (endIndex == 0x7FFFFFFF) {

			endIndex = __children.length - 1;

			if (endIndex < 0) {

				return;

			}

		}

		if (beginIndex > __children.length - 1) {

			return;

		} else if (endIndex < beginIndex || beginIndex < 0 || endIndex > __children.length) {

			throw new RangeError ("The supplied index is out of bounds.");

		}

		var numRemovals = endIndex - beginIndex;
		while (numRemovals >= 0) {

			removeChildAt (beginIndex);
			numRemovals--;

		}

	}


	public override function resolve (fieldName:String):DisplayObject {

		var result = Reflect.field(this, fieldName);
		if( result != null ) {
			return result;
		}
		return getChildByName(fieldName);

	}


	public function setChildIndex (child:DisplayObject, index:Int):Void {

		if (index >= 0 && index <= __children.length && child.parent == this) {

			if(__children[index]==null){
				var old_index: Int = __children.indexOf (child);
				__children[old_index] = null;
				__children[index] = child;
			} else {

				__children.remove(child);
				__children.insert(index, child);
			}

		}

	}


	public function swapChildren (child1:DisplayObject, child2:DisplayObject):Void {

		if (child1.parent == this && child2.parent == this) {

			#if (haxe_ver > 3.100)

			var index1 = __children.indexOf (child1);
			var index2 = __children.indexOf (child2);

			#else

			var index1 = -1;
			var index2 = -1;

			for (i in 0...__children.length) {

				if (__children[i] == child1) {

					index1 = i;

				} else if (__children[i] == child2) {

					index2 = i;

				}

			}

			#end

			__children[index1] = child2;
			__children[index2] = child1;

		}

	}


	public function swapChildrenAt (index1:Int, index2:Int):Void {

		var swap:DisplayObject = __children[index1];
		__children[index1] = __children[index2];
		__children[index2] = swap;
		swap = null;

	}

	private override function setCachedParent (newParent:DisplayObjectContainer, overwrite:Bool = true){

		super.setCachedParent(newParent, overwrite);

		if (newParent != null) {
			for (child in __children) {
				child.setCachedParent (newParent, overwrite);
			}
		} else {

			if( __cacheAsBitmap ) {
				for (child in __children) {
					child.setCachedParent (this, overwrite);
				}
			} else {
				for (child in __children) {
					child.setCachedParent (null, overwrite);
				}
			}
		}
	}

	private override function __broadcast (event:Event, notifyChilden:Bool):Bool {

		if (event.target == null) {

			event.target = this;

		}

		var result = super.__broadcast (event, notifyChilden);

		if (!event.__isCanceled && notifyChilden) {

			for (child in __children) {

				if(child == null) continue;

				child.__broadcast (event, true);

				if (event.__isCanceled) {

					return true;

				}

			}

		}

		return result;

	}

	private override function __getBounds (rect:Rectangle):Void {

		super.__getBounds (rect);

		if (__children.length == 0) return;

		var childRect = Rectangle.pool.get ();

		for (child in __children) {

			if (child == null ) continue;
			if (child.scaleX == 0 || child.scaleY == 0 || child.__isMask) continue;
			child.__getTransformedBounds (childRect, child.__transform);
			rect.__expand (childRect.x, childRect.y, childRect.width, childRect.height);

		}

		Rectangle.pool.put(childRect);

	}


	private override function __getRenderBounds (rect:Rectangle):Void {

		super.__getRenderBounds (rect);

		if (__scrollRect != null || __children.length == 0) {

			return;

		}

		var childRect = Rectangle.pool.get();

		for (child in __children) {

			if (child == null ) continue;
			if (child.scaleX == 0 || child.scaleY == 0 || child.__isMask) continue;
			child.__getRenderBounds (childRect);

			var temp_transform = null;
			if(child.__useSeparateRenderScaleTransform) {
				temp_transform = @:privateAccess Matrix.__temp;
				temp_transform.copyFrom(child.__transform);
				var scaleX = child.scaleX;
				var scaleY = child.scaleY;
				temp_transform.a /= scaleX;
				temp_transform.b /= scaleX;
				temp_transform.c /= scaleY;
				temp_transform.d /= scaleY;
			} else {
				temp_transform = child.__transform;
			}

			childRect.__transform (childRect, temp_transform);
			rect.__expand (childRect.x, childRect.y, childRect.width, childRect.height);

		}
		Rectangle.pool.put(childRect);
	}


	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {

		if (!hitObject.visible || __isMask || (interactiveOnly && !mouseChildren && !mouseEnabled)) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		var point = Point.pool.get();
		point.setTo (x, y);
		if (__scrollRect != null && !__scrollRect.containsPoint (globalToLocal (point))) {
			Point.pool.put(point);
			return false;
		} else {
			Point.pool.put(point);
		}

		var i = __children.length;
		if (interactiveOnly) {

			if (stack == null || !mouseChildren) {


				while (--i >= 0) {

					var child = __children[i];
					var clippedAt = child.__clippedAt;

					if (clippedAt != null) {
						// :TODO: Do not recheck the mask several times.
						if ( __children[clippedAt] != null && !__children[clippedAt].__hitTestMask(x,y) ) {
							i = clippedAt;
							continue;
						}
					}

					if (child != null && child.__hitTest (x, y, shapeFlag, null, mouseChildren, cast child)) {

						if (stack != null) {

							stack.push (hitObject);

						}

						return true;

					}

				}

			} else if (stack != null) {

				var length = stack.length;

				var interactive = false;
				var hitTest = false;

				while (--i >= 0) {

					var child = __children[i];
					var clippedAt = child.__clippedAt;

					if (clippedAt != null) {
						// :TODO: Do not recheck the mask several times.
						if ( __children[clippedAt] != null && !__children[clippedAt].__hitTestMask(x,y) ) {
							i = clippedAt;
							continue;
						}
					}

					interactive = child.__getInteractive (null);

					if (interactive || (mouseEnabled && !hitTest)) {

						if (child.__hitTest (x, y, shapeFlag, stack, true, cast child)) {

							if(mouseEnabled) {
								hitTest = true;
							}

							if (interactive) {

								if ( !hitTest ) {
									return true;
								}
								break;

							}

						}

					}

				}

				if (hitTest) {

					stack.insert (length, hitObject);
					return true;

				}

			}

		} else {

			while (--i >= 0) {

				if ( __children[i].__hitTest (x, y, shapeFlag, stack, false, cast __children[i]) ) {
					if (stack != null) {

						stack.push (hitObject);

					}

					return true;
				};

			}

		}

		return false;

	}


	private override function __hitTestMask (x:Float, y:Float):Bool {

		var i = __children.length;

		while (--i >= 0) {

			if (__children[i] == null ) continue;

			if (__children[i].__hitTestMask (x, y)) {

				return true;

			}

		}

		return false;

	}


	public override function __renderCairo (renderSession:RenderSession):Void {

		if (!__renderable || __worldAlpha <= 0) return;

		super.__renderCairo (renderSession);

		if (__scrollRect != null) {

			renderSession.maskManager.pushRect (__scrollRect, __worldTransform);

		}

		if (__mask != null) {

			renderSession.maskManager.pushMask (__mask);

		}

		for (child in __children) {

			if (child == null ) continue;
			child.__renderCairo (renderSession);

		}

		if (__mask != null) {

			renderSession.maskManager.popMask ();

		}

		if (__scrollRect != null) {

			renderSession.maskManager.popRect ();

		}

	}


	public override function __renderCairoMask (renderSession:RenderSession):Void {

		if (__graphics != null) {

			CairoGraphics.renderMask (__graphics, renderSession);

		}

		//var bounds = new Rectangle ();
		//__getLocalBounds (bounds);
		//
		//renderSession.cairo.rectangle (0, 0, bounds.width, bounds.height);

		for (child in __children) {
			if (child == null ) continue;
			child.__renderCairoMask (renderSession);

		}

	}


	public override function __renderCanvas (renderSession:RenderSession):Void {

		if (!__renderable || __worldAlpha <= 0) return;

		#if !neko

		super.__renderCanvas (renderSession);

		if (__scrollRect != null) {

			renderSession.maskManager.pushRect (__scrollRect, __worldTransform);

		}

		if (__mask != null) {

			renderSession.maskManager.pushMask (__mask);

		}

		for (child in __children) {
			if (child == null ) continue;
			child.__renderCanvas (renderSession);

		}

		if (__mask != null) {

			renderSession.maskManager.popMask ();

		}

		if (__scrollRect != null) {

			renderSession.maskManager.popRect ();

		}

		#end

	}


	public override function __renderCanvasMask (renderSession:RenderSession):Void {
		throw ":TODO: Remove";
	}


	public override function __renderGL (renderSession:RenderSession):Void {

		if (!__renderable || __worldAlpha <= 0) return;

		if (__cacheAsBitmap) {
			__isCachingAsBitmap = true;
			__cacheGL(renderSession);
			__isCachingAsBitmap = false;
			return;
		}

		__preRenderGL (renderSession);
		__drawGraphicsGL (renderSession);

		var maskEndDepth = -1;

		for (child in __children) {

			--maskEndDepth;

			if( maskEndDepth == -1 ){
				renderSession.maskManager.popMask();
			}

			if (child == null ) {
				continue;
			}

			if( child.__clipDepth != 0 ){

				if( !child.__maskCached ){
					if( child.__cachedBitmap != null ){
						child.__cachedBitmap.dispose();
						child.__cachedBitmap = null;
					}

					child.__isMask = true;
					child.__update (true, true);

					child.__maskCached = true;
				}

				renderSession.maskManager.pushMask (child);
				maskEndDepth =  child.__clipDepth;
			}
			else {
				child.__renderGL (renderSession);
			}
		}

		if( maskEndDepth >= 0 ){
			renderSession.maskManager.popMask();
		}

		__postRenderGL (renderSession);

	}


	private override function __setStageReference (stage:Stage):Void {

		if (this.stage != stage) {

			#if compliant_stage_events
				var stack = __getDisplayStack( this );
			#end

			if (this.stage != null) {

				#if compliant_stage_events
					Stage.fireEvent( Event.__create (Event.REMOVED_FROM_STAGE, false, false), stack);
				#else
					__dispatchEvent ( Event.__create (Event.REMOVED_FROM_STAGE, false, false));
				#end
				__releaseResources();

			}

			this.stage = stage;

			__setUpdateDirty();

			if (stage != null) {

				#if compliant_stage_events
					Stage.fireEvent( Event.__create (Event.ADDED_TO_STAGE, false, false), stack);
				#else
					__dispatchEvent ( Event.__create (Event.ADDED_TO_STAGE, false, false));
				#end
			}

			if (__children != null) {

				for (child in __children) {

					if(child == null) continue;
					child.__setStageReference (stage);

				}

			}

		}

	}


	public override function __update (transformOnly:Bool, updateChildren:Bool):Void {

		super.__update (transformOnly, updateChildren);

		// nested objects into a mask are non renderables but are part of the mask
		if (!__renderable && !__isMask) {

			return;

		}

		//if (!__renderable) return;

		if (updateChildren) {

			for (child in __children) {

				if (child == null ) continue;
				child.__update (transformOnly, true);

			}

		}

	}


	public override function __updateChildren (transformOnly:Bool):Void {

		super.__updateChildren (transformOnly);

		for (child in __children) {

			if (child == null ) continue;
			child.__update (transformOnly, true);

		}

	}




	// Get & Set Methods




	inline private function get_numChildren ():Int {

		return __children.length;

	}

	private override function set_cacheAsBitmap (cacheAsBitmap:Bool):Bool {

		if (__cachedParent == null){
			if(cacheAsBitmap) {
				for(child in __children){
					child.setCachedParent (this, false);
				}
			} else {
				for(child in __children){
					child.setCachedParent (null, false);
				}
			}
		}

		return super.set_cacheAsBitmap(cacheAsBitmap);

	}


}


#else
typedef DisplayObjectContainer = openfl._legacy.display.DisplayObjectContainer;
#end
