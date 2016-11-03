package openfl._internal.swf;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl.display.FrameLabel;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.PixelSnapping;
import openfl.display.Shape;
import openfl.display.SpreadMethod;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.filters.*;
import openfl.Lib;
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.symbols.ButtonSymbol;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.ShapeSymbol;
import openfl._internal.symbols.SpriteSymbol;
import openfl._internal.symbols.StaticTextSymbol;
import openfl._internal.timeline.FrameObject;
import openfl._internal.timeline.FrameObjectType;
import openfl._internal.swf.SWFLite;

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


class MovieClip extends openfl.display.MovieClip {
	
	
	@:noCompletion private var __frameTime:Int;
	@:noCompletion private var __lastUpdate:Int;
	@:noCompletion private var __objects:Map<Int, DisplayObject>;
	@:noCompletion private var __playing:Bool;
	@:noCompletion private var __swf:SWFLite;
	@:noCompletion private var __symbol:SpriteSymbol;
	@:noCompletion private var __timeElapsed:Int;
	@:noCompletion private var __zeroSymbol:Int;
	
	#if flash
	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __currentFrameLabel:String;
	@:noCompletion private var __currentLabel:String;
	@:noCompletion private var __currentLabels:Array<FrameLabel>;
	@:noCompletion private var __previousTime:Int;
	@:noCompletion private var __totalFrames:Int;
	#end
	
	
	public function new (swf:SWFLite, symbol:SpriteSymbol) {
		
		super ();
		
		__swf = swf;
		__symbol = symbol;
		
		__lastUpdate = -1;
		__objects = new Map ();
		__zeroSymbol = -1;
		
		__currentFrame = 1;
		__totalFrames = __symbol.frames.length;
		
		__currentLabels = [];
		
		for (i in 0...__symbol.frames.length) {
			
			if (__symbol.frames[i].label != null) {
				
				__currentLabels.push (new FrameLabel (__symbol.frames[i].label, i + 1));
				
			}
			
		}
		
		__updateFrame ();
		
		if (__totalFrames > 1) {
			
			#if flash
			__previousTime = Lib.getTimer ();
			Lib.current.stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame, false, 0, true);
			play ();
			#elseif (openfl && !openfl_legacy)
			play ();
			#end
			
		}
		
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
	
	
	public override function gotoAndPlay (frame:#if flash openfl.utils.Object #else Dynamic #end, scene:String = null):Void {
		
		__currentFrame = __getFrame (frame);
		__updateFrame ();
		play ();
		
	}
	
	
	public override function gotoAndStop (frame:#if flash openfl.utils.Object #else Dynamic #end, scene:String = null):Void {
		
		__currentFrame = __getFrame (frame);
		__updateFrame ();
		stop ();
		
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
	
	
	public function unflatten ():Void {
		
		__lastUpdate = -1;
		__updateFrame ();
		
	}
	
	
	@:noCompletion private inline function __applyTween (start:Float, end:Float, ratio:Float):Float {
		
		return start + ((end - start) * ratio);
		
	}
	
	
	@:noCompletion private function __createObject (object:FrameObject):DisplayObject {
		
		var displayObject:DisplayObject = null;
		
		if (__swf.symbols.exists (object.symbol)) {
			
			var symbol = __swf.symbols.get (object.symbol);
			
			if (Std.is (symbol, SpriteSymbol)) {
				
				displayObject = new MovieClip (__swf, cast symbol);
				
			} else if (Std.is (symbol, ShapeSymbol)) {
				
				displayObject = __createShape (cast symbol);
				
			} else if (Std.is (symbol, BitmapSymbol)) {
				
				displayObject = new Bitmap (__getBitmap (cast symbol), PixelSnapping.AUTO, true);
				
			} else if (Std.is (symbol, DynamicTextSymbol)) {
				
				displayObject = new DynamicTextField (__swf, cast symbol);
				
			} else if (Std.is (symbol, StaticTextSymbol)) {
				
				displayObject = new StaticTextField (__swf, cast symbol);
				
			} else if (Std.is (symbol, ButtonSymbol)) {
				
				displayObject = new SimpleButton (__swf, cast symbol);
				
			}
			
		}
		
		return displayObject;
		
	}
	
	
	@:noCompletion private function __createShape (symbol:ShapeSymbol):Shape {
		
		var shape = new Shape ();
		var graphics = shape.graphics;

		if (symbol.rendered != null) {
			graphics.copyFrom(symbol.rendered.graphics);
			return shape;
		}

		
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
					
					#if flash
					var fillType = switch (fillType) {
						case "0": GradientType.LINEAR;
						case "1": GradientType.RADIAL;
						default: fillType;
					}
					var spreadMethod = switch (fillType) {
						case "0": SpreadMethod.PAD;
						case "1": SpreadMethod.REFLECT;
						case "2": SpreadMethod.REPEAT;
						default: spreadMethod;
					}
					var interpolationMethod = switch (interpolationMethod) {
						case "0": InterpolationMethod.LINEAR_RGB;
						case "1": InterpolationMethod.RGB;
						default: interpolationMethod;
					}
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
					
					#if flash
					var scaleMode = switch (scaleMode) {
						case "0": LineScaleMode.HORIZONTAL;
						case "1": LineScaleMode.NONE;
						case "2": LineScaleMode.NORMAL;
						case "3": LineScaleMode.VERTICAL;
						default: scaleMode;
					}
					var caps = switch (caps) {
						case "0": CapsStyle.NONE;
						case "1": CapsStyle.ROUND;
						case "2": CapsStyle.SQUARE;
						default: caps;
					}
					var joints = switch (joints) {
						case "0": JointStyle.BEVEL;
						case "1": JointStyle.MITER;
						case "2": JointStyle.ROUND;
						default: joints;
					}
					#end
					
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

		// Graphics is drawn.
		// We no longer need the commands, allow GC to collect...
		symbol.commands = null;
		symbol.rendered = new Shape();
		symbol.rendered.graphics.copyFrom(shape.graphics);
		
		return shape;
		
	}
	
	
	@:noCompletion @:dox(hide) public #if !flash override #end function __enterFrame (deltaTime:Int):Void {
		
		if (__playing) {
			
			#if !swflite_parent_fps
			__timeElapsed += deltaTime;
			var advanceFrames = Math.floor (__timeElapsed / __frameTime);
			__timeElapsed = (__timeElapsed % __frameTime);
			#else
			var advanceFrames = (__lastUpdate == __currentFrame) ? 1 : 0;
			#end
			
			#if (!flash && openfl && !openfl_legacy)
			if (__frameScripts != null) {
				
				for (i in 0...advanceFrames) {
					
					__currentFrame++;
					
					if (__currentFrame > __totalFrames) {
						
						__currentFrame = 1;
						
					}
					
					if (__frameScripts.exists (__currentFrame - 1)) {
						
						__frameScripts.get (__currentFrame - 1) ();
						if (!__playing) break;
						
					}
					
				}
				
			} else 
			#end
			{
				
				__currentFrame += advanceFrames;
				
				while (__currentFrame > __totalFrames) {
					
					__currentFrame -= __totalFrames;
					
				}
				
			}
			
			__updateFrame ();
			
		}
		
		#if (!flash && openfl && !openfl_legacy)
		super.__enterFrame (deltaTime);
		#end
		
	}
	
	
	@:noCompletion private function __getBitmap (symbol:BitmapSymbol):BitmapData {
		
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
		
		if (Std.is (frame, Int)) {
			
			var index:Int = cast frame;
			
			if (index < 1) return 1;
			if (index > __totalFrames) return __totalFrames;
			
			return index;
			
		} else if (Std.is (frame, String)) {
			
			var label:String = cast frame;
			
			for (i in 0...__symbol.frames.length) {
				
				if (__symbol.frames[i].label == label) {
					
					return i + 1;
					
				}
				
			}
			
		}
		
		return 1;
		
	}
	
	
	@:noCompletion private function __placeObject (displayObject:DisplayObject, frameObject:FrameObject):Void {
		
		if (frameObject.name != null) {
			
			displayObject.name = frameObject.name;
			
		}
		
		if (frameObject.matrix != null) {
			
			displayObject.transform.matrix = frameObject.matrix;
			
			var dynamicTextField:DynamicTextField;
			
			if (Std.is (displayObject, DynamicTextField)) {
				
				dynamicTextField = cast displayObject;
				
				displayObject.x += dynamicTextField.symbol.x;
				displayObject.y += dynamicTextField.symbol.y #if flash + 4 #end;
				
			}
			
		}
		
		if (frameObject.colorTransform != null) {
			
			displayObject.transform.colorTransform = frameObject.colorTransform;
			
		}
		
		if (frameObject.filters != null) {
			
			var filters:Array<BitmapFilter> = [];
			
			for (filter in frameObject.filters) {
				
				switch (filter) {
					
					case BlurFilter (blurX, blurY, quality):
						
						filters.push (new BlurFilter (blurX, blurY, quality));
					
					case ColorMatrixFilter (matrix):
						
						filters.push (new ColorMatrixFilter (matrix));
					
					case DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject):
						
						filters.push (new DropShadowFilter (distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject));
					
					case GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout):
						
						filters.push (new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout));
					
				}
				
			}
			
			displayObject.filters = filters;
			
		}
		
		Reflect.setField (this, displayObject.name, displayObject);
		
	}
	
	
	@:noCompletion private function __renderFrame (index:Int):Void {
		
		var previousIndex = __lastUpdate - 1;
		
		if (previousIndex > index) {
			
			// TODO: Better way to handle this?
			
			var displayObject, exists;
			
			for (id in __objects.keys ()) {
				
				exists = false;
				
				for (frameObject in __symbol.frames[0].objects) {
					
					if (frameObject.id == id) {
						
						exists = true;
						break;
						
					}
					
				}
				
				if (!exists) {
					
					displayObject = __objects.get (id);
					
					if (displayObject.parent == this) {
						
						removeChild (displayObject);
						
					}
					
					__objects.remove (id);
					
				}
				
			}
			
			previousIndex = 0;
			
		}
		
		var frame, displayObject, depth;
		var mask = null, maskObject = null;
		
		for (i in previousIndex...(index + 1)) {
			
			if (i < 0) continue;
			
			frame = __symbol.frames[i];
			
			for (frameObject in frame.objects) {
				
				if (frameObject.type != FrameObjectType.DESTROY) {
					
					if (frameObject.id == 0 && frameObject.symbol != __zeroSymbol) {
						
						displayObject = __objects.get (0);
						
						if (displayObject != null && displayObject.parent == this) {
							
							removeChild (displayObject);
							
						}
						
						__objects.remove (0);
						displayObject = null;
						__zeroSymbol = frameObject.symbol;
						
					}
					
					if (!__objects.exists (frameObject.id)) {
						
						displayObject = __createObject (frameObject);
						
						if (displayObject != null) {
							
							if (frameObject.depth >= numChildren) {
								
								addChild (displayObject);
								
							} else {
								
								addChildAt (displayObject, frameObject.depth);
								
							}
							
							__objects.set (frameObject.id, displayObject);
							
						}
						
					} else {
						
						displayObject = __objects.get (frameObject.id);
						
					}
					
					if (displayObject != null) {
						
						__placeObject (displayObject, frameObject);
						
						if (mask != null) {
							
							if (mask.clipDepth < frameObject.depth) {
								
								mask = null;
								
							} else {
								
								displayObject.mask = maskObject;
								
							}
							
						} else {
							
							displayObject.mask = null;
							
						}
						
						if (frameObject.clipDepth != 0 #if neko && frameObject.clipDepth != null #end) {
							
							mask = frameObject;
							displayObject.visible = false;
							maskObject = displayObject;
							
						}
						
					}
					
				} else {
					
					if (__objects.exists (frameObject.id)) {
						
						displayObject = __objects.get (frameObject.id);
						
						if (displayObject != null && displayObject.parent == this) {
							
							removeChild (displayObject);
							
						}
						
						__objects.remove (frameObject.id);
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __updateFrame ():Void {
		
		if (__currentFrame != __lastUpdate) {
			
			var frameIndex = __currentFrame - 1;
			
			if (frameIndex > -1) {
				
				if (__symbol.frames.length > frameIndex && __symbol.frames[frameIndex] != null) {
					
					__currentFrameLabel = __symbol.frames[frameIndex].label;
					
				} else {
					
					__currentFrameLabel = null;
					
				}
				
				if (__currentFrameLabel != null) {
					
					__currentLabel = __currentFrameLabel;
					
				} else {
					
					if (__currentFrame != __lastUpdate + 1) {
						
						__currentLabel = null;
						
						for (label in __currentLabels) {
							
							if (label.frame <= __currentFrame) {
								
								__currentLabel = label.name;
								
							} else {
								
								break;
								
							}
							
						}
						
					}
					
				}
				
				__renderFrame (frameIndex);
				
			}
			
			#if (!flash && openfl && !openfl_legacy)
			__renderDirty = true;
			DisplayObject.__worldRenderDirty++;
			#end
			
		}
		
		__lastUpdate = __currentFrame;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	#if flash
	
	@:noCompletion @:getter(currentFrame) public function get_currentFrame ():Int {
		
		return __currentFrame;
		
	}
	
	
	@:noCompletion @:getter(currentFrameLabel) public function get_currentFrameLabel ():String {
		
		return __currentFrameLabel;
		
	}
	
	
	@:noCompletion @:getter(currentLabel) public function get_currentLabel ():String {
		
		return __currentLabel;
		
	}
	
	
	@:noCompletion @:getter(currentLabels) private function get_currentLabels ():Array<FrameLabel> {
		
		return __currentLabels;
		
	}
	
	
	@:noCompletion @:getter(framesLoaded) public function get_framesLoaded ():Int {
		
		return __totalFrames;
		
	}
	
	
	@:noCompletion @:getter(totalFrames) public function get_totalFrames ():Int {
		
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
