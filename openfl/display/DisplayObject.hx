package openfl.display; #if !openfl_legacy


import lime.ui.MouseCursor;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasShape;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.EventDispatcher;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.Lib;
import openfl.utils.UnshrinkableArray;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.Element;
#end


@:access(openfl.events.Event)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)

@:keepSub
class DisplayObject extends EventDispatcher implements IBitmapDrawable implements Dynamic<DisplayObject> {

	private static var __worldRenderDirty = 0;
	private static var __worldTransformDirty = 0;

	public var alpha (get, set):Float;
	public var blendMode (default, set):BlendMode;
	public var cacheAsBitmap (get, set):Bool;
	public var cacheAsBitmapMatrix (get, set):Matrix;
	public var cacheAsBitmapSmooth (get, set):Bool;
	public var filters (get, set):Array<BitmapFilter>;
	public var height (get, set):Float;
	public var loaderInfo (get, null):LoaderInfo;
	public var mask (get, set):DisplayObject;
	public var mouseX (get, null):Float;
	public var mouseY (get, null):Float;
	public var name (get, set):String;
	public var opaqueBackground:Null <Int>;
	public var parent (default, null):DisplayObjectContainer;
	public var root (get, null):DisplayObject;
	public var rotation (get, set):Float;
	public var scale9Grid:Rectangle;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	public var renderScaleX (default, null):Float = 1.0;
	public var renderScaleY (default, null):Float = 1.0;
	public var scrollRect (get, set):Rectangle;
	public var shader (default, set):Shader;
	public var stage (default, null):Stage;
	public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	public var width (get, set):Float;
	public var x (get, set):Float;
	public var y (get, set):Float;

	public var __renderAlpha:Float;
	public var __renderColorTransform:ColorTransform;
	public var __renderTransform:Matrix;
	public var __worldColorTransform:ColorTransform;
	public var __worldOffset:Point;
	public var __worldTransform:Matrix;

	private var __alpha:Float;
	private var __blendMode:BlendMode;
	private var __children:UnshrinkableArray<DisplayObject>;
	private var __cachedParent:DisplayObjectContainer;
	private var __filters:Array<BitmapFilter>;
	private var __graphics:Graphics;
	private var __interactive:Bool;
	private var __isMask:Bool;
	private var __mask:DisplayObject;
	private var __maskCached:Bool = false;
	private var __name:String = "";
	private var __objectTransform:Transform;
	private var __offset:Point;
	private var __renderable:Bool;
	private var __renderDirty:Bool;
	private var __rotation:Float;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scrollRect:Rectangle;
	private var __shader:Shader;
	private var __transform:Matrix;
	private var __transformDirty:Bool;
	private var __updateDirty:Bool;
	private var __visible:Bool;
	private var __worldAlpha:Float;
	private var __worldAlphaChanged:Bool;
	private var __worldClip:Rectangle;
	private var __worldClipChanged:Bool;
	private var __worldTransformCache:Matrix;
	private var __worldTransformChanged:Bool;
	private var __worldVisible:Bool;
	private var __worldVisibleChanged:Bool;
	private var __worldZ:Int;
	private var __cacheAsBitmap:Bool = false;
	private var __isCachingAsBitmap:Bool = false;
	private var __cacheAsBitmapMatrix:Matrix;
	private var __cacheAsBitmapSmooth:Bool = true;
	private var __forceCacheAsBitmap:Bool;
	private var __updateCachedBitmap:Bool;
	private var __cachedBitmap:BitmapData;
	private var __cachedBitmapBounds:Rectangle;
	private var __cacheGLMatrix:Matrix;
	private var __updateFilters:Bool;
	private var __clipDepth : Int;
	private var __clippedAt : Null<Int>;
	private var __useSeparateRenderScaleTransform = true;
	private var __forbidCachedBitmapUpdate = false;

	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end

	private function new () {

		super ();

		__alpha = 1;
		__transform = new Matrix ();
		__visible = true;

		__rotation = 0;
		__rotationSine = 0;
		__rotationCosine = 1;

		__renderTransform = new Matrix ();

		__cacheGLMatrix = new Matrix();

		__offset = new Point ();
		__worldOffset = new Point ();

		__worldAlpha = 1;
		__renderAlpha = 1;
		__worldTransform = new Matrix ();
		__worldColorTransform = new ColorTransform ();
		__renderColorTransform = new ColorTransform ();

		__clipDepth = 0;

		__cachedParent = null;
	}

	public function resolve (fieldName:String):DisplayObject {

		return null;

	}


	public function getSymbol():format.swf.lite.symbols.SWFSymbol{
		return null;
	}

	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {

		var matrix = Matrix.pool.get();

		if (targetCoordinateSpace != null) {

			matrix.copyFrom(__getWorldTransform ());
			var inversed_target_matrix = Matrix.pool.get();
			inversed_target_matrix.copyFrom( targetCoordinateSpace.__getWorldTransform() );
			inversed_target_matrix.invert();
			matrix.concat (inversed_target_matrix);
			Matrix.pool.put(inversed_target_matrix);

		} else {

			matrix.identity();

		}

		var bounds = new Rectangle ();
		__getTransformedBounds (bounds, matrix);

		Matrix.pool.put(matrix);

		return bounds;

	}


	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {

		// should not account for stroke widths, but is that possible?
		return getBounds (targetCoordinateSpace);

	}


	public function globalToLocal (point:Point):Point {

		if ( this.stage != null ) {
			point = this.stage.__getWorldTransform ().transformPoint (point);
		} else {
			point = point.clone();
		}
		__getWorldTransform ().__transformInversePoint (point);
		return point;

	}


	public function localToGlobal (point:Point):Point {

		point = __getWorldTransform ().transformPoint (point);
		if ( this.stage != null ) {
			this.stage.__getWorldTransform ().__transformInversePoint (point);
		} else {
			throw ":TODO:";
		}
		return point;

	}

	public inline function convertToLocal (point:Point) {
		if ( this.stage != null ) {
			this.stage.__getWorldTransform ().__transformPoint (point);
		}
		__getWorldTransform ().__transformInversePoint (point);
	}


	public function hitTestObject (obj:DisplayObject):Bool {

		if (obj != null && obj.parent != null && parent != null) {

			var currentBounds = getBounds (this);
			var targetBounds = obj.getBounds (this);

			return currentBounds.intersects (targetBounds);

		}

		return false;

	}


	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool {

			var bounds = openfl.geom.Rectangle.pool.get ();
			__getTransformedBounds (bounds, __getWorldTransform ());

			var hit_point = Point.pool.get();
			hit_point.setTo (x, y);
			var result = bounds.containsPoint (hit_point);
			Point.pool.put(hit_point);
			openfl.geom.Rectangle.pool.put (bounds);
			return result;

		}



	private function updateCachedParent (currentCachedParent:DisplayObjectContainer = null){



		if ( currentCachedParent == null ) {
			var object:DisplayObjectContainer = this.parent;
			while(object != null && !object.cacheAsBitmap) {
				object = object.parent;
			}
			__cachedParent = object;
		} else {
			__cachedParent = currentCachedParent;
		}

		if ( cacheAsBitmap ) {
			currentCachedParent = cast this;
		} else {
			currentCachedParent = __cachedParent;
		}

		return currentCachedParent;

	}

	private function __broadcast (event:Event, notifyChilden:Bool):Bool {

		if (__eventMap != null && hasEventListener (event.type)) {

			var result = super.__dispatchEvent (event);

			if (event.__isCanceled) {

				return true;

			}

			return result;

		}

		return false;

	}

	private override function __dispatchEvent (event:Event):Bool {

		event.acquire();
		var result = super.__dispatchEvent (event);

		if (event.__isCanceled) {
			event.release();
			return true;

		}

		if (event.bubbles && parent != null && parent != this) {

			event.eventPhase = EventPhase.BUBBLING_PHASE;

			if (event.target == null) {

				event.target = this;

			}

			parent.__dispatchEvent (event);

		}

		event.release();

		return result;

	}


	private function __enterFrame (deltaTime:Int):Void {



	}


	private function __getBounds (rect:Rectangle):Void {

		if (__graphics != null) {

			__graphics.__getBounds (rect);

		} else {

			rect.setEmpty ();

		}

	}

	private function __getTransformedBounds (rect:Rectangle, matrix:Matrix):Void {

		__getBounds (rect);
		rect.__transform (rect, matrix);

	}

	private function __getCursor ():MouseCursor {

		return null;

	}


	private function __getInteractive (stack:UnshrinkableArray<DisplayObject>):Bool {

		return false;

	}


	#if as2_depth_accessors
		public function getAssetPrefix() : String {
			if ( !Reflect.hasField(this, "assetPrefix") ) {
				if ( parent != null ) {
					return parent.getAssetPrefix();
				}
				return "";
			} else {
				return Reflect.field(this, "assetPrefix");
			}
		}
	#end

	private inline function __getLocalBounds (rect:Rectangle):Void {

		__getTransformedBounds (rect, __transform);

	}


	private function __getRenderBounds (rect:Rectangle):Void {

		if (__scrollRect == null) {

			__getBounds (rect);

		} else {

			rect.copyFrom (__scrollRect);

		}

	}


	private static var __parentList = new haxe.ds.Vector(32);
	private function __getWorldTransform ():Matrix {

		if (__transformDirty || __worldTransformDirty > 0) {

			var list = __parentList;
			var listIndex = 0;
			var current = this;
			var transformDirty = __transformDirty;

			if (parent == null) {

				if (transformDirty) __update (true, false);

			} else {

				while (current.parent != null) {

					#if !js
					if(listIndex + 1 >= list.length)
					{
						throw "DisplayObject.__parentList is too small.";
					}
					#end

					list[listIndex++] = current;
					current = current.parent;

					if (current.__transformDirty) {

						transformDirty = true;

					}

				}

			}

			if (transformDirty) {

				var i = listIndex;
				while (--i >= 0) {

					list[i].__update (true, false);

				}

			}

		}

		return __worldTransform;

	}


	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {

		if (__graphics != null) {

			if (!hitObject.visible || __isMask) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;

			if (__graphics.__hitTest (x, y, shapeFlag, __getWorldTransform ())) {

				if (stack != null && !interactiveOnly) {

					stack.push (hitObject);

				}

				return true;

			}

		}

		return false;

	}


	private function __hitTestMask (x:Float, y:Float):Bool {

		if (__graphics == null) return false;

		if (__graphics.__hitTest (x, y, true, __getWorldTransform ())) {

			return true;

		}

		return false;

	}


	public function __renderCanvas (renderSession:RenderSession):Void {

		throw ":TODO: remove me";

	}


	public function __renderCanvasMask (renderSession:RenderSession):Void {

		throw ":TODO: remove me";

	}


	public function __renderGL (renderSession:RenderSession):Void {

		if (!__renderable || __worldAlpha <= 0) return;

		if (__cacheAsBitmap) {
			__isCachingAsBitmap = true;
			__cacheGL(renderSession);
			__isCachingAsBitmap = false;
			return;
		}

		__preRenderGL (renderSession);
		__drawGraphicsGL (renderSession);
		__postRenderGL (renderSession);

	}

	public inline function __drawGraphicsGL (renderSession:RenderSession):Void {

		if (__graphics != null) {

			#if (js && html5)
			CanvasGraphics.render (__graphics, renderSession, renderScaleX, renderScaleY, __isMask);
			#end

			GLRenderer.renderBitmap (this, renderSession);

		}

	}

	public inline function __preRenderGL (renderSession:RenderSession):Void {

		if (__scrollRect != null) {

			renderSession.maskManager.pushRect (__scrollRect, __renderTransform);

		}

		if (__mask != null) {

			if( !__mask.__maskCached ){

				if( __mask.__cachedBitmap != null ){
					__mask.__cachedBitmap.dispose();
					__mask.__cachedBitmap = null;
				}

				__mask.__isMask = true;
				__mask.__update (true, true);

				__mask.__maskCached = true;
			}

			renderSession.maskManager.pushMask (__mask);
		}

	}


	public inline function __postRenderGL (renderSession:RenderSession):Void {

		if (__mask != null) {

			renderSession.maskManager.popMask ();

		}

		if (__scrollRect != null) {

			renderSession.maskManager.popRect ();

		}

	}

	#if profile
		private static var __applyFiltersCountMap:Map<Int, Int> = new Map<Int, Int>();

		public static function __init__ () {

			#if js
				untyped $global.Profile = $global.Profile || {};
				untyped $global.Profile.Filters = {};
				untyped $global.Profile.Filters.resetStatistics = resetStatistics;
				untyped $global.Profile.Filters.logStatistics= logStatistics;
			#end

		}

		public static function resetStatistics () {

			__applyFiltersCountMap = new Map<Int, Int> ();

		}

		public static function logStatistics (?threshold = 0) {
			for(id in __applyFiltersCountMap.keys()) {
				var value = __applyFiltersCountMap[id];
				if(value < threshold) {
					continue;
				}
				trace ('Symbol id:$id; applyFilters count: ${value}');
			}
		}
	#end

	public function __updateCachedBitmapFn (renderSession:RenderSession, maskBitmap: BitmapData = null, maskMatrix:Matrix = null):Void {

		var filterTransform = Matrix.pool.get ();
		filterTransform.identity ();
		filterTransform.a = __renderTransform.a / renderScaleX;
		filterTransform.b = __renderTransform.b / renderScaleX;
		filterTransform.c = __renderTransform.c / renderScaleY;
		filterTransform.d = __renderTransform.d / renderScaleY;
		filterTransform.invert ();

		__updateCachedBitmapBounds (filterTransform);

		if (__cachedBitmapBounds.width <= 0 && __cachedBitmapBounds.height <= 0) {
			return;
		}

		var symbol = getSymbol();

		if(symbol != null && symbol.useUniqueSharedBitmapCache && symbol.uniqueSharedCachedBitmap != null) {
			__cachedBitmap = symbol.uniqueSharedCachedBitmap;
			__forbidCachedBitmapUpdate = true;
			return;
		}

		if (__cachedBitmap == null) {
			__cachedBitmap = @:privateAccess BitmapData.__asRenderTexture ();
		}

		// :TRICKY: scale factor on BitmapData must be set AFTER the filters have been rendered
		@:privateAccess __cachedBitmap.__resize (Math.ceil (__cachedBitmapBounds.width), Math.ceil (__cachedBitmapBounds.height));

		var m = Matrix.pool.get();
		m.identity ();
		m.a = renderScaleX;
		m.d = renderScaleY;
		m.translate (-__cachedBitmapBounds.x, -__cachedBitmapBounds.y);

		var m2:Matrix = null;

		if (maskMatrix != null) {
			m2 = Matrix.pool.get ();
			m2.copyFrom (m);
			m2.invert ();
			m2.concat (__renderTransform);
			m2.concat (maskMatrix);
		}

		// we disable the container shader, it will be applied to the final texture
		var shader = __shader;
		this.__shader = null;
		@:privateAccess __cachedBitmap.__drawGL (renderSession, this, m, true, false, true, maskBitmap, m2);

		if (maskMatrix != null) {
			Matrix.pool.put(m2);
		}

		Matrix.pool.put(m);
		this.__shader = shader;

		__updateCachedBitmap = false;

		if (__updateFilters) {
			@:privateAccess BitmapFilter.__applyFilters (__filters, renderSession, __cachedBitmap, filterTransform);
			__updateFilters = false;

			#if(profile && js)
				if(untyped __js__("this.symbolId"))
				{
					var symbolId:Int = untyped __js__("this.symbolId");
					__applyFiltersCountMap.set(symbolId, (__applyFiltersCountMap.exists(symbolId) ? __applyFiltersCountMap.get(symbolId) + 1 : 1));
				}
			#end
		}

		Matrix.pool.put (filterTransform);

		@:privateAccess __cachedBitmap.__scaleX = renderScaleX;
		@:privateAccess __cachedBitmap.__scaleY = renderScaleY;

		if(symbol != null && symbol.useUniqueSharedBitmapCache) {
			symbol.uniqueSharedCachedBitmap = __cachedBitmap;
		}
	}

	public inline function __cacheGL (renderSession:RenderSession):Void {

		if ( ( __updateCachedBitmap || __updateFilters ) && ( !__forbidCachedBitmapUpdate || __cachedBitmap == null ) ) {

 			__updateCachedBitmapFn (renderSession);

		}

		__cacheGLMatrix.identity ();
		__cacheGLMatrix.translate (__cachedBitmapBounds.x / renderScaleX, __cachedBitmapBounds.y / renderScaleY);
		__cacheGLMatrix.concat (__renderTransform);
		__cacheGLMatrix.translate (__offset.x, __offset.y);

		renderSession.spriteBatch.renderBitmapData(__cachedBitmap, __cacheAsBitmapSmooth, __cacheGLMatrix, __worldColorTransform, __worldAlpha, blendMode, __shader, NEVER);

	}

	#if compliant_stage_events
		private function __getDisplayStack(object:DisplayObject):UnshrinkableArray<DisplayObject> {
			var stack = new UnshrinkableArray<DisplayObject>(16);
			var element : DisplayObject = object;
			while(element != null) {
				stack.push(element);
				element = element.parent;
			}
			stack.reverse();
			return stack;
		}
	#end

	private function setStage (stage:Stage):Stage {
		if (this.stage != stage) {
			var stack = null;
			#if compliant_stage_events
				stack = __getDisplayStack( this );
			#end

			if (this.stage != null) {
				__fireRemovedFromStageEvent(stack);

				if (this.stage.focus == this) {
					this.stage.focus = null;
				}
			}

			__releaseResources();

			this.__updateStageInternal(stage);

			if (stage != null) {
				__fireAddedToStageEvent(stack);
			}
		}
		return stage;
	}

	private function __fireRemovedFromStageEvent(stack=null) {
		#if compliant_stage_events
			Stage.fireEvent( Event.__create (Event.REMOVED_FROM_STAGE, false, false), stack);
		#else
			__dispatchEvent ( Event.__create (Event.REMOVED_FROM_STAGE, false, false));
		#end
	}

	private function __fireAddedToStageEvent(stack=null) {
		#if compliant_stage_events
			Stage.fireEvent( Event.__create (Event.ADDED_TO_STAGE, false, false), stack);
		#else
			__dispatchEvent ( Event.__create (Event.ADDED_TO_STAGE, false, false));
		#end
	}

	private function __releaseResources ():Void {

		var dirty:Bool = false;

		if (__graphics != null) {
			__graphics.dispose();
			dirty = true;
		}

		if (__cachedBitmap != null) {
			var symbol = getSymbol();
			if(symbol == null || !symbol.useUniqueSharedBitmapCache) {
				__cachedBitmap.dispose();
			}
			__cachedBitmap = null;
			dirty = true;
		}

		if (__filters != null ){
			for ( filter in __filters ){
				filter.dispose();
			}
			dirty = true;
		}

		if (dirty) {
			__setRenderDirty();
		}

		if ( __objectTransform != null) {
			Transform.pool.put(__objectTransform);
			__objectTransform = null;
		}
	}


	private inline function __setRenderDirty ():Void {

		__updateCachedBitmap = true;
		__updateFilters = __filters != null && __filters.length > 0;

		__setRenderDirtyNoCachedBitmap();

	}

	private inline function __setRenderDirtyNoCachedBitmap ():Void {

		if( __isMask ){
			__maskCached = false;
		}

		if (!__renderDirty) {

			__renderDirty = true;
			__worldRenderDirty++;

			if (__cachedParent != null) {
				__cachedParent.__setRenderDirty();
			}

		}

		__setUpdateDirty();

	}


	private inline function __setTransformDirty ():Void {

		if (!__transformDirty) {

			__transformDirty = true;
			__setRenderDirtyNoCachedBitmap();
			__worldTransformDirty++;

		}

	}

	private inline function __setUpdateDirty() :Void {
		if ( !__updateDirty && stage != null && this != this.stage ) {
			__updateDirty = true;
			stage.__updateStack.push(this);
		}

	}
	private function __updateCachedBitmapBounds (filterTransform:Matrix):Void {

		if (__cachedBitmapBounds == null) {
			__cachedBitmapBounds = new Rectangle ();
		}

		__cachedBitmapBounds.setEmpty();
		__getRenderBounds (__cachedBitmapBounds);

		__cachedBitmapBounds.x *= renderScaleX;
		__cachedBitmapBounds.y *= renderScaleY;
		__cachedBitmapBounds.width *= renderScaleX;
		__cachedBitmapBounds.height *= renderScaleY;

		if (__filters != null) {

			@:privateAccess BitmapFilter.__expandBounds (__filters, __cachedBitmapBounds, filterTransform);

		}

		__cachedBitmapBounds.x = Math.floor (__cachedBitmapBounds.x);
		__cachedBitmapBounds.y = Math.floor (__cachedBitmapBounds.y);

	}

	public function __updateColor()
	{
		if (parent != null) {

			__worldColorTransform.setFromCombination (transform.colorTransform, parent.__worldColorTransform);

			if (mustResetRenderColorTransform()) {
				__renderAlpha = 1.0;
				__worldAlpha = alpha * parent.__renderAlpha;
				__renderColorTransform.reset ();
			} else {
				__renderAlpha = alpha * parent.__renderAlpha;
				__worldAlpha = alpha * parent.__worldAlpha;
				__renderColorTransform.setFromCombination (transform.colorTransform, parent.__renderColorTransform);
			}

		} else {


			__worldColorTransform.copyFrom(transform.colorTransform);
			__worldAlpha = alpha;

			if (mustResetRenderColorTransform()) {
				__renderAlpha = 1.0;
				__renderColorTransform.reset ();
			} else {
				__renderAlpha = alpha;
				__renderColorTransform.copyFrom(transform.colorTransform);
			}
		}

	}

	public function __update (transformOnly:Bool, updateChildren:Bool):Void {
		__inlineUpdate(transformOnly, updateChildren);
	}

	public inline function __inlineUpdate(transformOnly:Bool, updateChildren:Bool):Void {

		__renderable = (visible && !hasZeroScale() && !__isMask);

		__updateTransforms ();

		if (updateChildren && __transformDirty) {

			__transformDirty = false;
			__worldTransformDirty--;

		}

		if (!transformOnly) {

			#if profile
				lime._backend.html5.HTML5Application.__updateCalls++;
				var key :String = null;
				if ( Reflect.field(this, "__symbol")) {
					key = Std.string(Reflect.field(this, "__symbol").id);
				} else if ( name != "" ) {
					key = name;
				}
				if ( key != null ) {
					var val = lime._backend.html5.HTML5Application.__updateMap.get(key);
					val = val != null ? val : 0;
					lime._backend.html5.HTML5Application.__updateMap.set(key, val + 1);
				}
			#end

			__updateColor();

			if(parent != null)
			{
				if ((blendMode == null || blendMode == NORMAL)) {

					__blendMode = parent.__blendMode;

				}

				if (shader == null) {
					__shader = parent.__shader;
				}
			}

			__renderDirty = __renderDirty && !updateChildren;
			__updateDirty = false;
		}
	}

	#if profile
	public function getAllChildrenCount():Int
	{
		var total = 0;

		if(__children != null)
		{
			total += __children.length;

			for (child in __children)
			{
				total += child.getAllChildrenCount();
			}
		}

		return total;
	}
	#end


	public function __updateChildren (transformOnly:Bool):Void {

		__renderable = (visible && !hasZeroScale() && !__isMask);
		if (!__renderable && !__isMask) return;
		__worldAlpha = alpha;

		if (__transformDirty) {

			__transformDirty = false;
			__worldTransformDirty--;

		}

	}


	public function __updateTransforms ():Void {

		var local =__transform;

		if (__worldTransform == null) {

			__worldTransform = new Matrix ();

		}

		var wt = __worldTransform;
		var old_world_transform_a = wt.a;
		var old_world_transform_b = wt.b;
		var old_world_transform_c = wt.c;
		var old_world_transform_d = wt.d;

		if (parent != null) {

			var parentTransform = parent.__worldTransform;

			var a = parentTransform.a;
			var b = parentTransform.b;
			var c = parentTransform.c;
			var d = parentTransform.d;

			var la = local.a;
			var lb = local.b;
			var lc = local.c;
			var ld = local.d;

			wt.a = la * a + lb * c;
			wt.b = la * b + lb * d;
			wt.c = lc * a+ ld * c;
			wt.d = lc * b + ld * d;
			wt.tx = local.tx * a+ local.ty * c + parentTransform.tx;
			wt.ty = local.tx * b + local.ty * d + parentTransform.ty;

			__worldOffset.copyFrom (parent.__worldOffset);

		} else {
			wt.copyFrom (local);
			__worldOffset.setTo (0, 0);
		}

		if (__scrollRect != null) {

			__offset = wt.deltaTransformPoint (__scrollRect.topLeft);
			__worldOffset.offset (__offset.x, __offset.y);

		} else {

			__offset.setTo (0, 0);

		}

		if (!__isCachingAsBitmap &&
			(old_world_transform_a != wt.a ||
			old_world_transform_d != wt.d ||
			old_world_transform_b != wt.b ||
			old_world_transform_c != wt.c)) {
			_onWorldTransformScaleRotationChanged ();
		}


		if (__cacheAsBitmapMatrix != null) {

			trace(":TODO: fill renderScaleX, renderScaleY and use __cacheAsBitmapMatrix where appropriate");

		} else if (__useSeparateRenderScaleTransform) {

			renderScaleX = Math.sqrt (wt.a * wt.a + wt.b * wt.b);
			renderScaleY = Math.sqrt (wt.c * wt.c + wt.d * wt.d);

		}

		__renderTransform.copyFrom (wt);
		__renderTransform.translate ( -__worldOffset.x, -__worldOffset.y);
	}

	public function _onWorldTransformScaleRotationChanged ():Void {
		__updateCachedBitmap = true;
		__updateFilters = __filters != null && __filters.length > 0;

		if (__graphics != null) {
			__graphics.__dirty = true;
		}
	}


	// Get & Set Methods




	private function get_alpha ():Float {

		return __alpha;

	}


	private function set_alpha (value:Float):Float {

		if (value > 1.0) value = 1.0;
		if (value != __alpha) {
			__setRenderDirtyNoCachedBitmap();
		}
		return __alpha = value;

	}


	private function set_blendMode (value:BlendMode):BlendMode {

		if ( __blendMode != value ) {
			__setUpdateDirty();
			__blendMode = value;
		}
		return blendMode = value;

	}

	private function set_shader (value:Shader):Shader {

		if ( __shader != value ) {
			__setUpdateDirty();
			__shader = value;
		}
		return shader = value;

	}

	private function __updateStageInternal(value:Stage) {
		stage = value;
		__setUpdateDirty();
	}


	private function get_cacheAsBitmap ():Bool {

		return __cacheAsBitmap;

	}


	private function set_cacheAsBitmap (cacheAsBitmap:Bool):Bool {

		if(cacheAsBitmap != __cacheAsBitmap) __setRenderDirty ();

		return __cacheAsBitmap = __forceCacheAsBitmap ? true : cacheAsBitmap;

	}

	private function get_cacheAsBitmapMatrix ():Matrix {

		return __cacheAsBitmapMatrix;

	}


	private function set_cacheAsBitmapMatrix (value:Matrix):Matrix {

		__setRenderDirty ();
		if ( __cacheAsBitmapMatrix != null ) {
			__cacheAsBitmapMatrix.copyFrom(value);
		} else {
			__cacheAsBitmapMatrix = value.clone();
		}
		return __cacheAsBitmapMatrix;

	}


	private function get_cacheAsBitmapSmooth ():Bool {

		return __cacheAsBitmapSmooth;

	}


	private function set_cacheAsBitmapSmooth (value:Bool):Bool {

		return __cacheAsBitmapSmooth = value;

	}


	private function get_filters ():Array<BitmapFilter> {

		if (__filters == null) {

			return new Array ();

		} else {

			return __filters.copy ();

		}

	}


	private function set_filters (value:Array<BitmapFilter>):Array<BitmapFilter> {

		if (__filters != null){
			for( filter in __filters ){
				filter.dispose();
			}
		}

		if(value != null && value.length > 0) {
			__forceCacheAsBitmap = true;
			cacheAsBitmap = true;
			__updateFilters = true;
			__filters = value;
		} else {
			__forceCacheAsBitmap = false;
			cacheAsBitmap = false;
			__updateFilters = false;
			__filters = null;
		}

		__setRenderDirty ();

		return value;

	}


	private function get_height ():Float {

		var bounds = openfl.geom.Rectangle.pool.get ();
		__getLocalBounds (bounds);

		var result = bounds.height;
		openfl.geom.Rectangle.pool.put (bounds);
		return result;

	}


	private function set_height (value:Float):Float {

		var bounds = openfl.geom.Rectangle.pool.get ();
		__getBounds (bounds);

		if (value != bounds.height) {

			scaleY = value / bounds.height;

		} else {

			scaleY = 1;

		}

		openfl.geom.Rectangle.pool.put(bounds);

		return value;

	}


	private function get_loaderInfo():LoaderInfo{
		if( loaderInfo == null ){
			loaderInfo = LoaderInfo.create (null);
		}

		return loaderInfo;
	}

	private function get_mask ():DisplayObject {

		return __mask;

	}


	private function set_mask (value:DisplayObject):DisplayObject {

		if (value == __mask) {
			return value;
		}

		__setTransformDirty ();
		__setRenderDirty ();

		if (__mask != null) {
			__mask.__isMask = false;
			__mask.__maskCached = false;
			__mask.__setTransformDirty();
			__mask.__setRenderDirty();
		}

		if (value != null) {
			value.__isMask = true;
			value.__maskCached = false;
			value.__setTransformDirty();
			value.__setRenderDirty();
		}

		return __mask = value;

	}


	private function get_mouseX ():Float {

		var mouseX = Lib.current.stage.__mouseX;
		var mouseY = Lib.current.stage.__mouseY;

		return __getWorldTransform ().__transformInverseX (mouseX, mouseY);

	}


	private function get_mouseY ():Float {

		var mouseX = Lib.current.stage.__mouseX;
		var mouseY = Lib.current.stage.__mouseY;

		return __getWorldTransform ().__transformInverseY (mouseX, mouseY);

	}


	private function get_name ():String {

		return __name;

	}


	private function set_name (value:String):String {

		return __name = value;

	}


	private function get_root ():DisplayObject {

		if (stage != null) {

			return Lib.current;

		}

		return null;

	}


	private function get_rotation ():Float {

		return __rotation;

	}


	private function set_rotation (value:Float):Float {

		if (value != __rotation) {

			__rotation = value;
			var radians = __rotation * (Math.PI / 180);
			__rotationSine = Math.sin (radians);
			__rotationCosine = Math.cos (radians);

			var __scaleX = this.scaleX;
			var __scaleY = this.scaleY;

			__transform.a = __rotationCosine * __scaleX;
			__transform.b = __rotationSine * __scaleX;
			__transform.c = -__rotationSine * __scaleY;
			__transform.d = __rotationCosine * __scaleY;

			__setTransformDirty ();

		}

		return value;

	}

	public inline function hasZeroScale ():Bool {
		return (__transform.a == 0
				&& __transform.b == 0 )
			|| (__transform.c == 0
			&& __transform.d == 0 );
	}

	private function get_scaleX ():Float {

		if (__transform.b == 0) {

			return __transform.a;

		} else {

			return Math.sqrt (__transform.a * __transform.a + __transform.b * __transform.b);

		}

	}


	private function set_scaleX (value:Float):Float {

			var a = __rotationCosine * value;
			var b = __rotationSine * value;

			if (__transform.a != a || __transform.b != b) {

				__setTransformDirty ();

			}

			__transform.a = a;
			__transform.b = b;


		return value;

	}

	private function get_scaleY ():Float {

		if (__transform.c == 0) {

			return __transform.d;

		} else {

			return Math.sqrt (__transform.c * __transform.c + __transform.d * __transform.d);

		}

	}


	private function set_scaleY (value:Float):Float {

			var c = -__rotationSine * value;
			var d = __rotationCosine * value;

			if (__transform.d != d || __transform.c != c) {

				__setTransformDirty ();

			}

			__transform.c = c;
			__transform.d = d;

		return value;

	}

	private function get_scrollRect ():Rectangle {

		if ( __scrollRect == null ) return null;

		return __scrollRect.clone();

	}


	private function set_scrollRect (value:Rectangle):Rectangle {

		if (value != __scrollRect) {

			__setTransformDirty ();

		}

		return __scrollRect = value;

	}


	private function get_transform ():Transform {

		if (__objectTransform == null) {

			__objectTransform = Transform.pool.get();
			__objectTransform.reset(this);

		}

		return __objectTransform;

	}


	private function set_transform (value:Transform):Transform {

		if (value == null) {

			throw new TypeError ("Parameter transform must be non-null.");

		}

		if (__objectTransform == null) {

			__objectTransform = Transform.pool.get();
			__objectTransform.reset(this);

		}

		__setTransformDirty ();
		__objectTransform.matrix = value.matrix;
		__objectTransform.colorTransform = value.colorTransform.__clone();

		return __objectTransform;

	}


	private function get_visible ():Bool {

		return __visible;

	}


	private function set_visible (value:Bool):Bool {

		if (value != __visible) __setRenderDirty ();
		return __visible = value;

	}


	private function get_width ():Float {

		var bounds = openfl.geom.Rectangle.pool.get ();
		__getLocalBounds (bounds);

		var result = bounds.width;
		openfl.geom.Rectangle.pool.put(bounds);
		return result;

	}


	private function set_width (value:Float):Float {

		var bounds = openfl.geom.Rectangle.pool.get ();
		__getBounds (bounds);

		if (value != bounds.width) {

			scaleX = value / bounds.width;

		} else {

			scaleX = 1;

		}

		openfl.geom.Rectangle.pool.put(bounds);

		return value;

	}


	private function get_x ():Float {

		return __transform.tx;

	}


	private function set_x (value:Float):Float {

		if (value != __transform.tx) __setTransformDirty ();
		return __transform.tx = value;

	}


	private function get_y ():Float {

		return __transform.ty;

	}


	private function set_y (value:Float):Float {

		if (value != __transform.ty) __setTransformDirty ();
		return __transform.ty = value;

	}

	private function mustResetRenderColorTransform():Bool {

		return __cacheAsBitmap || __isMask;

	}
}


#else
typedef DisplayObject = openfl._legacy.display.DisplayObject;
#end
