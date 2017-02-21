package format.swf.lite;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Shape;
import format.swf.lite.SimpleSprite;
import flash.events.Event;
import flash.filters.*;
import flash.Lib;
import format.swf.lite.symbols.BitmapSymbol;
import format.swf.lite.symbols.ButtonSymbol;
import format.swf.lite.symbols.DynamicTextSymbol;
import format.swf.lite.symbols.ShapeSymbol;
import format.swf.lite.symbols.MorphShapeSymbol;
import format.swf.lite.symbols.SpriteSymbol;
import format.swf.lite.symbols.StaticTextSymbol;
import format.swf.lite.symbols.SimpleSpriteSymbol;
import format.swf.lite.timeline.FrameObject;
import format.swf.lite.timeline.FrameObjectType;
import format.swf.lite.SWFLite;
import openfl.display.BitmapDataChannel;
import openfl.display.FrameLabel;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.ColorTransform;
import openfl._internal.renderer.RenderSession;

#if openfl
import openfl.Assets;
#end

#if (lime && !openfl_legacy)
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
#end

@:access(openfl.display.Graphics)

class MovieClip extends flash.display.MovieClip {


	@:noCompletion private var __frameTime:Int;
	@:noCompletion private var __lastUpdate:Int;
	@:noCompletion private var __objects:Map<Int, DisplayObject>;
	@:noCompletion private var __playing:Bool;
	@:noCompletion private var __swf:SWFLite;
	@:noCompletion private var __symbol:SpriteSymbol;
	@:noCompletion private var __timeElapsed:Int;
	@:noCompletion private var __zeroSymbol:Int;
	@:noCompletion private var __targetFrame:Null<Int>;

	#if flash
	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __previousTime:Int;
	@:noCompletion private var __totalFrames:Int;
	@:noCompletion private var __currentLabels:Array<FrameLabel>;
	#end

	private var __9SliceBitmap:BitmapData;
	private var __scale9Rect:Rectangle;
	private var __updating9SliceBitmap:Bool = false;

	private var __SWFDepthData:Map<DisplayObject, Int>;
	private var __maskData:Map<DisplayObject, Int>;
	private var __maskDataKeys:Array<DisplayObject>;

	private var __childrenCache:Map<FrameObject, DisplayObject>;

	public function new (swf:SWFLite, symbol:SpriteSymbol) {

		super ();

		__swf = swf;
		__symbol = symbol;

		__lastUpdate = 1;
		__objects = new Map ();
		__zeroSymbol = -1;

		__currentFrame = 1;

		if ( __symbol != null ) {
			__totalFrames = __symbol.frames.length;
		} else {
			__totalFrames = 0;
		}

		__SWFDepthData = new Map();
		__maskData = new Map();
		__maskDataKeys = new Array();

		__currentLabels = [];

		if ( __symbol != null ) {
			for (i in 0...__symbol.frames.length) {

				if (__symbol.frames[i].label != null) {

					__currentLabels.push (new FrameLabel (__symbol.frames[i].label, i + 1));

				}

			}

			if (__symbol.scalingGridRect != null ) {
				__useSeparateRenderScaleTransform = false;
			}
		}

		#if (!flash && openfl && !openfl_legacy)
		__setRenderDirty();
		#end

		if (__totalFrames > 1) {

			#if flash
			__previousTime = Lib.getTimer ();
			Lib.current.stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame, false, 0, true);
			play ();
			#elseif (openfl && !openfl_legacy)
			play ();
			#end

		}

		__renderFrame (0);

	}

	public function enableChildrenCache()
	{
		__childrenCache = new Map();
	}


	/*public override function flatten ():Void {

		var bounds = getBounds (this);
		var bitmapData = null;

		if (bounds.width > 0 && bounds.height > 0) {

			bitmapData = new BitmapData (Std.int (bounds.width), Std.int (bounds.height), true, #if neko { a: 0, rgb: 0x000000 } #else 0x00000000 #end);
			var matrix = new Matrix ();
			matrix.translate (-bounds.left, -bounds.top);
			bitmapData.draw (this, matrix);

		}

		for (i in 0...numChildren) {

			var child = getChildAt (0);

			if (Std.is (child, MovieClip)) {

				untyped child.stop ();

			}

			removeChildAt (0);

		}

		if (bounds.width > 0 && bounds.height > 0) {

			var bitmap = new Bitmap (bitmapData);
			bitmap.smoothing = true;
			bitmap.x = bounds.left;
			bitmap.y = bounds.top;
			addChild (bitmap);

		}

	}*/


	public override function gotoAndPlay (frame:#if flash flash.utils.Object #else Dynamic #end, scene:String = null):Void {

		__goto(frame, scene);
		play();
	}


	public override function gotoAndStop (frame:#if flash flash.utils.Object #else Dynamic #end, scene:String = null):Void {

		if(__goto(frame, scene)) {
			stop ();
		}
	}

	public override function nextFrame ():Void {

		var next = __currentFrame + 1;

		if (next > __totalFrames) {

			next = __totalFrames;

		}

		gotoAndStop (next);

	}


	public override function play ():Void {

		if (!__playing && __totalFrames > 1) {

			__playing = true;

			#if !swflite_parent_fps
			__frameTime = Std.int (1000 / __swf.frameRate);
			__timeElapsed = 0;
			#end

		}

	}


	public override function prevFrame ():Void {

		var previous = __currentFrame - 1;

		if (previous < 1) {

			previous = 1;

		}

		gotoAndStop (previous);

	}


	public override function stop ():Void {

		if (__playing) {

			__playing = false;

		}

	}


	#if flash
	@:getter(currentLabels)
	private function get_currentLabels():Array<FrameLabel> {

		return __currentLabels;

	}
	#end

	private override function get_graphics ():Graphics {

		if ( __graphics != null && @:privateAccess __graphics.__owner == null ) {
			throw "Not allowed!";
		}
		return super.get_graphics();

	}

	public function unflatten ():Void {

		__lastUpdate = 0;
		__updateFrame ();

	}


	@:noCompletion private inline function __applyTween (start:Float, end:Float, ratio:Float):Float {

		return start + ((end - start) * ratio);

	}


	@:noCompletion private function __createObject (object:FrameObject):DisplayObject {

		var displayObject:DisplayObject = null;

		if(__childrenCache != null)
		{
			if(__childrenCache.exists(object))
			{
				return __childrenCache.get(object);
			}
		}

		if (__swf.symbols.exists (object.symbol)) {

			var symbol = __swf.symbols.get (object.symbol);

			if( symbol.className != null)
			{
				var _class: Class<Dynamic> = __swf.classes.get(symbol.className);

				if( _class != null )
				{
					displayObject = Type.createInstance( _class, [ __swf, symbol]);
				}
			}

			if(displayObject == null && __swf.classes_id.exists( object.symbol ))
			{
				var _class: Class<Dynamic> = __swf.classes_id.get(object.symbol);

				if( _class != null )
				{
					displayObject = Type.createInstance( _class, [ __swf, symbol]);
				}
			}

			if(displayObject == null)
			{

				if (Std.is (symbol, SpriteSymbol)) {

					displayObject = new MovieClip (__swf, cast symbol);

				} else if (Std.is (symbol, ShapeSymbol)) {

					displayObject = __createShape (cast symbol);

				} else if (Std.is (symbol, MorphShapeSymbol)) {

					displayObject = __createMorphShape (cast symbol);

				} else if (Std.is (symbol, BitmapSymbol)) {

					displayObject = new Bitmap (__getBitmap (cast symbol), PixelSnapping.AUTO, true);

				} else if (Std.is (symbol, DynamicTextSymbol)) {

					displayObject = new DynamicTextField (__swf, cast symbol);

				} else if (Std.is (symbol, StaticTextSymbol)) {

					displayObject = new StaticTextField (__swf, cast symbol);

				} else if (Std.is (symbol, ButtonSymbol)) {

					displayObject = new SimpleButton (__swf, cast symbol);

				} else if (Std.is (symbol, SimpleSpriteSymbol)) {

					displayObject = new SimpleSprite (__swf, cast symbol);
				}
			}

			Reflect.setField( displayObject, "symbolId", symbol.id );

			if (object.name != null) {

				displayObject.name = object.name;

			}

		}

		if(__childrenCache != null)
		{
			__childrenCache[object] = displayObject;
		}

		return displayObject;
	}


	@:noCompletion private function __createShape (symbol:ShapeSymbol):Shape {

		var shape = new Shape ();
		var graphics = shape.graphics;

		if ( symbol.graphics != null && symbol.graphics.readOnly == true ) {
			graphics.copyFrom( symbol.graphics, true );
			return shape;
		}

		graphics.__symbol = symbol;

		for (command in symbol.commands) {

			switch (command) {

				case BeginFill (color, alpha):

					graphics.beginFill (color, alpha);

				case BeginBitmapFill (bitmapID, matrix, repeat, smooth):

					#if openfl

					var bitmap:BitmapSymbol = cast __swf.symbols.get (bitmapID);

					if (bitmap != null && bitmap.path != "") {

						graphics.beginBitmapFill (__getBitmap (bitmap), matrix, repeat, smooth);

					}

					#end

				case BeginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):

					#if (cpp || neko)
					shape.cacheAsBitmap = true;
					#end
					graphics.beginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

				case CurveTo (controlX, controlY, anchorX, anchorY):

					#if (cpp || neko)
					shape.cacheAsBitmap = true;
					#end
					graphics.curveTo (controlX, controlY, anchorX, anchorY);

				case EndFill:

					graphics.endFill ();

				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):

					if (thickness != null) {

						graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

					} else {

						graphics.lineStyle ();

					}

				case LineTo (x, y):

					graphics.lineTo (x, y);

				case MoveTo (x, y):

					graphics.moveTo (x, y);

			}

		}

		graphics.readOnly = true;
		symbol.graphics = shape.graphics;

		return shape;

	}

	@:noCompletion private function __createMorphShape (symbol:MorphShapeSymbol): MorphShape {

		return new MorphShape( __swf, symbol);

	}

	@:noCompletion @:dox(hide) public #if (!flash && openfl && !openfl_legacy) override #end function __enterFrame (deltaTime:Int):Void {

		if (__playing) {

			#if !swflite_parent_fps
			__timeElapsed += deltaTime;
			var advanceFrames = Math.floor (__timeElapsed / __frameTime);
			__timeElapsed = (__timeElapsed % __frameTime);
			#else
			var advanceFrames = (__lastUpdate == __currentFrame) ? 1 : 0;
			#end

			__currentFrame += advanceFrames;

			while (__currentFrame > __totalFrames) {

				__currentFrame -= __totalFrames;

			}

			__updateFrame ();

		}

		#if (!flash && openfl && !openfl_legacy)
		super.__enterFrame (deltaTime);
		#end

	}


	@:noCompletion private static function __getBitmap (symbol:BitmapSymbol):BitmapData {

		#if openfl

		if (Assets.cache.hasBitmapData (symbol.path)) {

			return Assets.cache.getBitmapData (symbol.path);

		} else {

			#if !openfl_legacy

			var source = LimeAssets.getImage (symbol.path, false);

			if (source != null && symbol.alpha != null && symbol.alpha != "") {

				#if flash
				var cache = source;
				var buffer = new ImageBuffer (null, source.width, source.height);
				buffer.src = new BitmapData (source.width, source.height, true, 0);
				source = new Image (buffer);
				source.copyPixels (cache, cache.rect, new Vector2 (), null, null, false);
				#end

				var alpha = LimeAssets.getImage (symbol.alpha, false);
				source.copyChannel (alpha, alpha.rect, new Vector2 (), ImageChannel.RED, ImageChannel.ALPHA);

				//symbol.alpha = null;
				source.buffer.premultiplied = true;

				#if !sys
				source.premultiplied = false;
				#end

			}

			#if !flash
			var bitmapData = BitmapData.fromImage (source);
			#else
			var bitmapData = source.src;
			#end

			Assets.cache.setBitmapData (symbol.path, bitmapData);
			return bitmapData;

			#else

			var bitmapData = Assets.getBitmapData (symbol.path, false);

			if (bitmapData != null && symbol.alpha != null && symbol.alpha != "") {

				var cache = bitmapData;
				bitmapData = new BitmapData (cache.width, cache.height, true, 0);
				bitmapData.copyPixels (cache, cache.rect, new Point (), null, null, false);

				var alpha = Assets.getBitmapData (symbol.alpha, false);
				bitmapData.copyChannel (alpha, alpha.rect, new Point (), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
				//symbol.alpha = null;

				bitmapData.unmultiplyAlpha ();

			}

			Assets.cache.setBitmapData (symbol.path, bitmapData);
			return bitmapData;

			#end

		}

		#else

		return null;

		#end

	}


	@:noCompletion private function __getFrame (frame:Dynamic):Int {

		var index:Int = 0;

		if (Std.is (frame, Int)) {

			index = cast frame;

		} else if (Std.is (frame, String)) {

			var label:String = cast frame;

			if ( __symbol != null ) {
				for (i in 0...__symbol.frames.length) {

					if (__symbol.frames[i].label == label) {

						index = i + 1;
						break;
					}

				}
			}
		}

		if(index < 1){
			index = 1;
		} else if (index > __totalFrames){
			index = __totalFrames;
		}

		return index;
	}

	@:noCompletion private function __goto (frame:#if flash flash.utils.Object #else Dynamic #end, scene:String = null):Bool	{

		if(__targetFrame == null) {

			var targetFrame = __getFrame (frame);
			if ( targetFrame == __currentFrame ) {
				return true;
			}

			__targetFrame = targetFrame;
			play ();

			do {
				__currentFrame = __targetFrame;
				__updateFrame ();

				__playing = true;
			} while (__targetFrame != __currentFrame);

			__targetFrame = null;

			return true;
		}
		else {

			return false;
		}

	}

	@:noCompletion private function __placeObject (displayObject:DisplayObject, frameObject:FrameObject):Void {

		if (frameObject.matrix != null) {

			displayObject.transform.matrix = frameObject.matrix;

			var dynamicTextField:DynamicTextField;

			if (Std.is (displayObject, DynamicTextField)) {

				dynamicTextField = cast displayObject;

				var mat = frameObject.matrix;
				var x = dynamicTextField.symbol.x;
				var y = dynamicTextField.symbol.y;

				// Math.round to prevent blurry fonts
				displayObject.x = Math.round(displayObject.x + mat.a * x + mat.c * y);
				displayObject.y = Math.round(displayObject.y + mat.b * x + mat.d * y #if flash + 4 #end);
			}

		}

		if (Std.is (displayObject, MorphShape) && frameObject.ratio != null) {

			var morphShape : MorphShape = cast displayObject;

			morphShape.ratio = frameObject.ratio;
		}

		if (frameObject.colorTransform != null) {

			displayObject.transform.colorTransform = frameObject.colorTransform;

		}

		if (frameObject.blendMode != null) {
			displayObject.blendMode = frameObject.blendMode;
		}

		displayObject.cacheAsBitmap = frameObject.cacheAsBitmap;

		if (frameObject.filters != null) {

			var filters:Array<BitmapFilter> = [];

			for (filter in frameObject.filters) {

				switch (filter) {

					case BlurFilter (blurX, blurY, quality):

						filters.push (new BlurFilter (blurX, blurY, quality));

					case ColorMatrixFilter (multipliers, offsets):

						filters.push (new ColorMatrixFilter (multipliers.value, offsets.value));

					case DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject):

						filters.push (new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject));

					case GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout):

						filters.push (new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout));

					case GradientGlowFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout):

						filters.push (new GradientGlowFilter (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout));

					case GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout):

						filters.push (new GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout));

					case BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout):

						filters.push (new BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout));

				}

			}

			displayObject.filters = filters;

		}

		if (displayObject.name != null) {
			Reflect.setField (this, displayObject.name, displayObject);
		}

	}

	private function __update9SliceBitmap ():Void {

		// :TODO: use dirty flag if need to update __9SliceBitmap

		if (__symbol != null && __symbol.scalingGridRect != null && __9SliceBitmap == null) {
				__updating9SliceBitmap = true;
				var bounds:Rectangle = Rectangle.pool.get();
				__getBounds (bounds);

				if (bounds.width <= 0 && bounds.height <= 0) {
					Rectangle.pool.put (bounds);
					throw 'Error creating a cached bitmap. The texture size is ${bounds.width}x${bounds.height}';
				}

				if (__scale9Rect == null) {
					__scale9Rect = __symbol.scalingGridRect.clone();
					__scale9Rect.x -= bounds.x;
					__scale9Rect.y -= bounds.y;
				}

				var renderSession = @:privateAccess openfl.Lib.current.stage.__renderer.renderSession;

				var bitmap = @:privateAccess BitmapData.__asRenderTexture ();
				@:privateAccess bitmap.__resize (Math.ceil (bounds.width), Math.ceil (bounds.height));

				var renderTransform = Matrix.pool.get ();
				renderTransform.identity ();
				renderTransform.translate(-bounds.x, -bounds.y);
				@:privateAccess bitmap.__drawGL(renderSession, this, renderTransform);
				Matrix.pool.put (renderTransform);
				Rectangle.pool.put (bounds);

				__9SliceBitmap = bitmap;
				__updating9SliceBitmap = false;
		}
	}

	@:noCompletion private function drawScale9Bitmap (renderSession:RenderSession):Void {

		if (__cacheAsBitmap) {
			__isCachingAsBitmap = true;
			__cacheGL(renderSession);
			__isCachingAsBitmap = false;
			return;
		}

		var bounds:Rectangle = Rectangle.pool.get();
		__getBounds (bounds);

		var bordersReservedWidth = __9SliceBitmap.width - __scale9Rect.width;
		var bordersReservedHeight = __9SliceBitmap.height - __scale9Rect.height;
		var bordersHorizontalScale:Float = 1.0;
		var bordersVerticalScale:Float = 1.0;

		if (width < bordersReservedWidth) {
			bordersHorizontalScale = width / bordersReservedWidth;
		}

		if (height < bordersReservedHeight) {
			bordersVerticalScale = height / bordersReservedHeight;
		}

		var rect = new openfl.geom.Rectangle();
		rect.left = bordersHorizontalScale * __scale9Rect.left;
		rect.right = Math.max (rect.left, width - bordersHorizontalScale * (__9SliceBitmap.width - __scale9Rect.right) );
		rect.top = bordersVerticalScale * __scale9Rect.top;
		rect.bottom = Math.max (rect.top, height - bordersVerticalScale * (__9SliceBitmap.height - __scale9Rect.bottom) );

		var renderToBitmapXScale = __9SliceBitmap.width / width;
		var renderToBitmapYScale = __9SliceBitmap.height / height;
		var cols = [0, rect.left * renderToBitmapXScale, rect.right * renderToBitmapXScale, __9SliceBitmap.width];
		var rows = [0, rect.top * renderToBitmapYScale, rect.bottom * renderToBitmapYScale, __9SliceBitmap.height];
		var us = [0, __scale9Rect.left / __9SliceBitmap.width, __scale9Rect.right / __9SliceBitmap.width, 1];
		var vs = [0, __scale9Rect.top / __9SliceBitmap.height, __scale9Rect.bottom/ __9SliceBitmap.height, 1];
		var uvs:TextureUvs = TextureUvs.pool.get();

		var bitmapDataUvs = @:privateAccess __9SliceBitmap.__uvData;
		var u_scale = bitmapDataUvs.x1 - bitmapDataUvs.x0;
		var v_scale = bitmapDataUvs.y2 - bitmapDataUvs.y0;

		var matrix = new Matrix();

		for(row in 0...3) {

			for(col in 0...3) {

				var sourceX = cols[col];
				var sourceY = rows[row];
				var w = cols[col+1] - cols[col];
				var h = rows[row+1] - rows[row];

				matrix.identity ();
				matrix.translate (sourceX + bounds.x, sourceY + bounds.y);
				matrix.concat (__renderTransform);

				uvs.x0 = uvs.x3 = us[col] * u_scale;
				uvs.x1 = uvs.x2 = us[col+1] * u_scale;
				uvs.y0 = uvs.y1 = vs[row] * v_scale;
				uvs.y2 = uvs.y3 = vs[row+1] * v_scale;

				renderSession.spriteBatch.renderBitmapDataEx (__9SliceBitmap, w, h, uvs, true, matrix, __worldColorTransform, 1.0, __blendMode, __shader, null);

			}
		}

		TextureUvs.pool.put (uvs);
		Rectangle.pool.put (bounds);
	}

	public override function __renderGL (renderSession:RenderSession):Void {

		if (!__updating9SliceBitmap) {
			__update9SliceBitmap ();
		}

		if (__symbol != null && __symbol.scalingGridRect != null && __9SliceBitmap != null) {
			#if dev
				if (!__renderable || __worldAlpha <= 0) throw "Callee should check these conditions!";
			#end

			drawScale9Bitmap(renderSession);
		}
		else {
			super.__renderGL (renderSession);
		}
	}

	private function frame0ChildrenUpdate():Void {

		if ( __symbol == null ) {
			return;
		}

		var frame = __symbol.frames[0];

		for( object_id in __objects.keys() ){

			var remove:Bool = true;
			var resetColorTransform:Bool = true;

			for (frameObject in frame.objects){

					if( frameObject.id == object_id ){

							remove = frameObject.symbol != Reflect.field( __objects.get( object_id ), "symbolId" );

							resetColorTransform = !remove && (frameObject.colorTransform == null);

							break;
					}
			}

			if(remove){

					var displayObject = __objects.get (object_id);

					if(displayObject != null){

							removeChild(displayObject);
							__maskDataKeys.remove(displayObject);
							__maskData.remove(displayObject);
							__SWFDepthData.remove(displayObject);
					}

				__objects.remove (object_id);
			} else {
				if(resetColorTransform) {
					__objects.get (object_id).transform.resetColorTransform();
				}
			}
		}
	}

	@:noCompletion private function __renderFrame (index:Int):Bool {

		if (__symbol == null || __symbol.frames.length == 0) {
			return false;
		}

		if (index == 0) {
			frame0ChildrenUpdate();
		}

		var frame, displayObject, depth;

		frame = __symbol.frames[index];

		__currentFrame = index + 1;
		__lastUpdate = index + 1;

		for (frameObject in frame.objects) {

			if (frameObject.type != FrameObjectType.DESTROY) {

				if (!__objects.exists (frameObject.id)) {

					displayObject = __createObject (frameObject);

					if (displayObject != null) {

						__addChildAtSwfDepth (displayObject, frameObject.depth);
						__objects.set (frameObject.id, displayObject);

					}

				} else {

					displayObject = __objects.get (frameObject.id);

					if( frameObject.type == FrameObjectType.UPDATE_CHARACTER ){

						var oldObject : DisplayObject = displayObject;

						var clipDepth = __maskData.get(displayObject);
						__maskDataKeys.remove(displayObject);
						__maskData.remove(displayObject);
						__SWFDepthData.remove(displayObject);
						removeChild(displayObject);

						displayObject = __createObject (frameObject);

						displayObject.name = oldObject.name;
						displayObject.transform.matrix = oldObject.transform.getMatrixNoClone();
						displayObject.transform.colorTransform = oldObject.transform.colorTransform;
						if ( oldObject.__filters != null ) {
							displayObject.filters = oldObject.__filters.map(function(bitmapFilter){ return bitmapFilter.clone(); });
						}

						if( clipDepth != null ) {
							__maskDataKeys.push(displayObject);
							__maskData.set( displayObject, clipDepth );
						}

						__addChildAtSwfDepth (displayObject, frameObject.depth);
						__objects.set (frameObject.id, displayObject);
					}

				}

				if (displayObject != null) {

					__placeObject (displayObject, frameObject);

					if (frameObject.clipDepth != 0 #if neko && frameObject.clipDepth != null #end) {

						displayObject.visible = false;

						__maskData.set( displayObject, frameObject.clipDepth );
						__maskDataKeys.push(displayObject);

					}

				}

			} else {

				if (__objects.exists (frameObject.id)) {

					displayObject = __objects.get (frameObject.id);

					if (displayObject != null && displayObject.parent == this) {

						removeChild (displayObject);
						__SWFDepthData.remove(displayObject);
						__maskData.remove(displayObject);
						__maskDataKeys.remove(displayObject);

					}

					__objects.remove (frameObject.id);

				}

			}

		}

		__updateSwfMaskData();

		#if (!flash && openfl && !openfl_legacy)
		inline function labelLogic() {
			var label = __symbol.frames[index].label;
			__currentFrameLabel = label;
			if ( label != null ) {
				__currentLabel = label;
			}
		}
		if (__frameScripts != null) {

			if (__frameScripts.exists (index)) {
				labelLogic();

				__frameScripts.get (index) ();

				if(index  + 1 != __currentFrame){
					return true;
				}
			}

		}
		if (__staticFrameScripts != null) {

			if (__staticFrameScripts.exists (index)) {
				labelLogic();

				__staticFrameScripts.get (index) (this);

				if(index  + 1 != __currentFrame){
					return true;
				}
			}

		}
		#end

		return false;

	}


	@:noCompletion private function __updateFrame ():Void {

		if (__currentFrame != __lastUpdate) {

			var scriptHasChangedFlow : Bool;

			if( __currentFrame < __lastUpdate ){
				var cacheCurrentFrame = __currentFrame;
				for( frameIndex in ( __lastUpdate ... __totalFrames ) ){
					scriptHasChangedFlow = __renderFrame (frameIndex);
					if (!__playing || scriptHasChangedFlow)
					{
						break;
					}
				}
				if (__playing){
					for( frameIndex in ( 0 ... cacheCurrentFrame ) ){
						scriptHasChangedFlow = __renderFrame (frameIndex);
						if (!__playing || scriptHasChangedFlow)
						{
							break;
						}
					}
				}
			} else {

				for( frameIndex in ( __lastUpdate ... __currentFrame ) ){
					scriptHasChangedFlow = __renderFrame (frameIndex);
					if (!__playing || scriptHasChangedFlow)
					{
						break;
					}
				}
			}

			#if (!flash && openfl && !openfl_legacy)
			__setRenderDirty();
			#end

		}

	}

	private function __updateSwfMaskData(){

		var children_length = __children.length;

		for( child in __children ){
			child.__clippedAt = null;
		}

		for( mask in __maskDataKeys ){
			var maskIndex = getChildIndex( mask );

			var depthValue = __maskData.get(mask);

			var result = children_length;

			for( i in maskIndex ... children_length ){
				var sibling = getChildAt(i);
				if ( sibling != null ) {
					if( __SWFDepthData.get(sibling) > depthValue){
						result = i;
						break;
					} else {
						sibling.__clippedAt = maskIndex;
					}
				}
			}

			mask.__clipDepth = result - maskIndex - 1;
		}
	}

#if as2_depth_accessors

	public function getNextHighestDepthExternal() : Int {
		if (numChildren > 0) {
			return __SWFDepthData.get(getChildAt(numChildren-1)) - 0x3FFE;
		}
		return 0;
	}

	public function getDepth() : Int {
		return cast(parent, MovieClip).__SWFDepthData.get(this);
	}

	public function getDepthExternal() : Int {
		return getDepth()  - 0x3FFE;
	}

	public function addChildAtSwfDepthExternal(displayObject:DisplayObject, targetDepth:Int):Void {
		__addChildAtSwfDepth(displayObject, targetDepth + 0x3FFF);
		__updateSwfMaskData();
	}

	public function swapDepths(target: Dynamic) {
		var object_to_swap : DisplayObject = null;
		var target_depth : Int;
		if ( Std.is(target, Int) || Std.is(target, Float) ) {
			target_depth = Std.int(target) + 0x3FFF;
			for( i in 0 ... numChildren ){
				if( __SWFDepthData.get(getChildAt(i)) == target_depth){
					object_to_swap = getChildAt(i);

					break;
				}
			}
		} else if ( Std.is(target, DisplayObject) ) {
			object_to_swap = target;
			target_depth = __SWFDepthData.get(target);
		} else {
			throw("Trying to swap depths with unknown type.. " + Type.getClassName(target));
		}


		var swf_parent = cast(parent, MovieClip);
		var my_depth = getDepth();
		if ( object_to_swap != null ) {
			swf_parent.removeChild(object_to_swap);
			swf_parent.__addChildAtSwfDepth(object_to_swap, my_depth);
		}
        swf_parent.removeChild(this);
        swf_parent.__addChildAtSwfDepth(this, target_depth);
        swf_parent.addChildAtSwfDepthExternal(this, target_depth);
		__updateSwfMaskData();
    }
#end

	@:noCompletion private function __addChildAtSwfDepth(displayObject: DisplayObject, targetDepth:Int):Void{

		__SWFDepthData.set(displayObject, targetDepth);

		for( i in 0 ... numChildren ){
			var child = getChildAt(i);
			if( __SWFDepthData.get(child) > targetDepth){
				addChildAt (displayObject, i);

				return;
			}
		}

		addChild (displayObject);
	}

	public override function removeChild (child:DisplayObject):DisplayObject {
		var object = super.removeChild(child);
		__SWFDepthData.remove(object);
		__maskDataKeys.remove(object);
		__maskData.remove(object);
		__updateSwfMaskData();
		return object;
	}

	@:noCompletion override private function __releaseResources(){

		super.__releaseResources();

		if( __9SliceBitmap != null ){
			__9SliceBitmap.dispose();
			__9SliceBitmap = null;
		}
	}

	@:noCompletion private function __debugPrintChildren( parentSymbolID: Int = -1 ):Void {

		if ( __symbol == null ) {
			return;
		}

		var print :Bool = false;
		if(parentSymbolID < 0 || parentSymbolID == __symbol.id){
			print = true;
		}

		if(print){

			for( objectID in __objects.keys() ){

				var object = __objects.get(objectID);

				var maxNameLength = 20;
				var objectName = object.name;
				var isMask = __maskData.exists(object);

				if(objectName.length < maxNameLength){

					var spaceNumber = maxNameLength - objectName.length;

					for (i in 0...spaceNumber){
						objectName += " ";
					}
				}

				switch (isMask) {

					case true:
						trace("parent (" + __symbol.id + ")\t\t\t | " + "mask   \t " + objectName + "\t\t\t | depth = " + __SWFDepthData.get(object) + "\t | mask = " + __maskData.get(object));
					case false:
						trace("parent (" + __symbol.id + ")\t\t\t | " + "object \t " + objectName + "\t\t\t | depth = " + __SWFDepthData.get(object) + "\t |");
				}
			}

			trace("-");
		}
	}

	private override function mustResetRenderColorTransform():Bool {

		return super.mustResetRenderColorTransform() || (__symbol != null && __symbol.scalingGridRect != null);

	}

	// Get & Set Methods




	#if flash
	@:noCompletion @:getter public function get_currentFrame():Int {

		return __currentFrame;

	}


	@:noCompletion @:getter public function get___totalFrames():Int {

		return __totalFrames;

	}
	#end




	// Event Handlers




	#if flash
	@:noCompletion private function stage_onEnterFrame (event:Event):Void {

		var currentTime = Lib.getTimer ();
		var deltaTime = currentTime - __previousTime;

		__enterFrame (deltaTime);

		__previousTime = currentTime;

	}
	#end
}
