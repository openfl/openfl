package openfl.display;


import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
import openfl._internal.swf.SWFLite;
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.symbols.ButtonSymbol;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.FontSymbol;
import openfl._internal.symbols.ShapeSymbol;
import openfl._internal.symbols.SpriteSymbol;
import openfl._internal.symbols.StaticTextSymbol;
import openfl._internal.timeline.FrameObject;
import openfl._internal.timeline.FrameObjectType;
import openfl.events.Event;
import openfl.filters.*;
import openfl.text.TextField;
import openfl.Assets;

@:access(openfl.display.SimpleButton)
@:access(openfl.text.TextField)


class MovieClip extends Sprite implements Dynamic<DisplayObject> {
	
	
	public var currentFrame (get, never):Int;
	public var currentFrameLabel (get, never):String;
	public var currentLabel (get, never):String;
	public var currentLabels (get, never):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded (get, never):Int;
	public var totalFrames (get, never):Int;
	
	private var __currentFrame:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>;
	private var __frameScripts:Map<Int, Void->Void>;
	private var __frameTime:Int;
	private var __lastUpdate:Int;
	private var __objectDepths:Array<TimelineObject>;
	private var __objects:Map<Int, TimelineObject>;
	private var __playing:Bool;
	private var __swf:SWFLite;
	private var __symbol:SpriteSymbol;
	private var __timeElapsed:Int;
	private var __totalFrames:Int;
	private var __zeroSymbol:Int;
	
	
	public function new () {
		
		super ();
		
		__currentFrame = 0;
		__currentLabels = [];
		__totalFrames = 0;
		enabled = true;
		
	}
	
	
	public function addFrameScript (index:Int, method:Void->Void):Void {
		
		if (method != null) {
			
			if (__frameScripts == null) {
				
				__frameScripts = new Map ();
				
			}
			
			__frameScripts.set (index, method);
			
		} else if (__frameScripts != null) {
			
			__frameScripts.remove (index);
			
		}
		
	}
	
	
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		if (__symbol != null) {
			
			__currentFrame = __getFrame (frame);
			__updateFrame ();
			play ();
			
		}
		
	}
	
	
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		if (__symbol != null) {
			
			__currentFrame = __getFrame (frame);
			__updateFrame ();
			stop ();
			
		}
		
	}
	
	
	public function nextFrame ():Void {
		
		if (__symbol != null) {
			
			var next = __currentFrame + 1;
			
			if (next > __totalFrames) {
				
				next = __totalFrames;
				
			}
			
			gotoAndStop (next);
			
		}
		
	}
	
	
	public function play ():Void {
		
		if (__symbol != null) {
			
			if (!__playing && __totalFrames > 1) {
				
				__playing = true;
				
				#if !swflite_parent_fps
				__frameTime = Std.int (1000 / __swf.frameRate);
				__timeElapsed = 0;
				#end
				
			}
			
		}
		
	}
	
	
	public function prevFrame ():Void {
		
		if (__symbol != null) {
			
			var previous = __currentFrame - 1;
			
			if (previous < 1) {
				
				previous = 1;
				
			}
			
			gotoAndStop (previous);
			
		}
		
	}
	
	
	public function stop ():Void {
		
		if (__symbol != null) {
			
			if (__playing) {
				
				__playing = false;
				
			}
			
		}
		
	}
	
	
	private inline function __applyTween (start:Float, end:Float, ratio:Float):Float {
		
		return start + ((end - start) * ratio);
		
	}
	
	
	private function __createObject (object:FrameObject):DisplayObject {
		
		if (__swf.symbols.exists (object.symbol)) {
			
			var symbol = __swf.symbols.get (object.symbol);
			
			if (Std.is (symbol, SpriteSymbol)) {
				
				var movieClip = new MovieClip ();
				movieClip.__fromSymbol (__swf, cast symbol);
				return movieClip;
				
			} else if (Std.is (symbol, ShapeSymbol)) {
				
				return __createShape (cast symbol);
				
			} else if (Std.is (symbol, BitmapSymbol)) {
				
				return new Bitmap (__getBitmap (cast symbol), PixelSnapping.AUTO, true);
				
			} else if (Std.is (symbol, DynamicTextSymbol)) {
				
				var textField = new TextField ();
				textField.__fromSymbol (__swf, cast symbol);
				return textField;
				
			} else if (Std.is (symbol, StaticTextSymbol)) {
				
				return __createStaticTextField (cast symbol);
				
			} else if (Std.is (symbol, ButtonSymbol)) {
				
				var simpleButton = new SimpleButton ();
				simpleButton.__fromSymbol (__swf, cast symbol);
				return simpleButton;
				
			}
			
		}
		
		return null;
		
	}
	
	
	private function __createShape (symbol:ShapeSymbol):Shape {
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		
		if (symbol.rendered != null) {
			
			graphics.copyFrom (symbol.rendered.graphics);
			return shape;
			
		}
		
		for (command in symbol.commands) {
			
			switch (command) {
				
				case BeginFill (color, alpha):
					
					graphics.beginFill (color, alpha);
				
				case BeginBitmapFill (bitmapID, matrix, repeat, smooth):
					
					var bitmap:BitmapSymbol = cast __swf.symbols.get (bitmapID);
					
					if (bitmap != null && bitmap.path != "") {
						
						graphics.beginBitmapFill (__getBitmap (bitmap), matrix, repeat, smooth);
						
					}
				
				case BeginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):
					
					graphics.beginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
				
				case CurveTo (controlX, controlY, anchorX, anchorY):
					
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
		
		symbol.commands = null;
		symbol.rendered = new Shape ();
		symbol.rendered.graphics.copyFrom (shape.graphics);
		
		return shape;
		
	}
	
	
	private function __createStaticTextField (symbol:StaticTextSymbol):Shape {
		
		var shape = new Shape ();
		var graphics = shape.graphics;
		
		if (symbol.rendered != null) {
			
			graphics.copyFrom (symbol.rendered.graphics);
			return shape;
			
		}
		
		if (symbol.records != null) {
			
			var font:FontSymbol = null;
			var color = 0xFFFFFF;
			var offsetX = symbol.matrix.tx;
			var offsetY = symbol.matrix.ty;
			
			for (record in symbol.records) {
				
				if (record.fontID != null) font = cast __swf.symbols.get (record.fontID);
				if (record.offsetX != null) offsetX = symbol.matrix.tx + record.offsetX * 0.05;
				if (record.offsetY != null) offsetY = symbol.matrix.ty + record.offsetY * 0.05;
				if (record.color != null) color = record.color;
				
				if (font != null) {
					
					var scale = (record.fontHeight / 1024) * 0.05;
					
					var index;
					var code;
					
					for (i in 0...record.glyphs.length) {
						
						index = record.glyphs[i];
						
						for (command in font.glyphs[index]) {
							
							switch (command) {
								
								case BeginFill (_, alpha):
									
									graphics.beginFill (color & 0xFFFFFF, ((color >> 24) & 0xFF) / 0xFF);
								
								case CurveTo (controlX, controlY, anchorX, anchorY):
									
									#if (cpp || neko)
									cacheAsBitmap = true;
									#end
									graphics.curveTo (controlX * scale + offsetX, controlY * scale + offsetY, anchorX * scale + offsetX, anchorY * scale + offsetY);
								
								case EndFill:
									
									graphics.endFill ();
								
								case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
									
									if (thickness != null) {
										
										graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
										
									} else {
										
										graphics.lineStyle ();
										
									}
								
								case LineTo (x, y):
									
									graphics.lineTo (x * scale + offsetX, y * scale + offsetY);
								
								case MoveTo (x, y):
									
									graphics.moveTo (x * scale + offsetX, y * scale + offsetY);
								
								default:
								
							}
							
						}
						
						offsetX += record.advances[i] * 0.05;
						
					}
					
				}
				
			}
			
		}
		
		symbol.records = null;
		symbol.rendered = new Shape ();
		symbol.rendered.graphics.copyFrom (shape.graphics);
		
		return shape;
		
	}
	
	
	public override function __enterFrame (deltaTime:Int):Void {
		
		if (__symbol != null) {
			
			if (__playing) {
				
				#if !swflite_parent_fps
				__timeElapsed += deltaTime;
				var advanceFrames = Math.floor (__timeElapsed / __frameTime);
				__timeElapsed = (__timeElapsed % __frameTime);
				#else
				var advanceFrames = (__lastUpdate == __currentFrame) ? 1 : 0;
				#end
				
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
					
				} else {
					
					__currentFrame += advanceFrames;
					
					while (__currentFrame > __totalFrames) {
						
						__currentFrame -= __totalFrames;
						
					}
					
				}
				
				__updateFrame ();
				
			}
			
		}
		
		super.__enterFrame (deltaTime);
		
	}
	
	
	public function __fromSymbol (swf:SWFLite, symbol:SpriteSymbol):Void {
		
		__swf = swf;
		__symbol = symbol;
		
		__lastUpdate = -1;
		__objectDepths = [];
		__objects = new Map ();
		__zeroSymbol = -1;
		
		__currentFrame = 1;
		__totalFrames = __symbol.frames.length;
		
		for (i in 0...__symbol.frames.length) {
			
			if (__symbol.frames[i].label != null) {
				
				__currentLabels.push (new FrameLabel (__symbol.frames[i].label, i + 1));
				
			}
			
		}
		
		__updateFrame ();
		
		if (__totalFrames > 1) {
			
			play ();
			
		}
		
	}
	
	
	private function __getBitmap (symbol:BitmapSymbol):BitmapData {
		
		if (Assets.cache.hasBitmapData (symbol.path)) {
			
			return Assets.cache.getBitmapData (symbol.path);
			
		} else {
			
			var source = LimeAssets.getImage (symbol.path, false);
			
			if (source != null && symbol.alpha != null && symbol.alpha != "") {
				
				var alpha = LimeAssets.getImage (symbol.alpha, false);
				source.copyChannel (alpha, alpha.rect, new Vector2 (), ImageChannel.RED, ImageChannel.ALPHA);
				
				//symbol.alpha = null;
				source.buffer.premultiplied = true;
				
				#if !sys
				source.premultiplied = false;
				#end
				
			}
			
			var bitmapData = BitmapData.fromImage (source);
			
			Assets.cache.setBitmapData (symbol.path, bitmapData);
			return bitmapData;
			
		}
		
	}
	
	
	private function __getFrame (frame:Dynamic):Int {
		
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
	
	
	private function __placeObject (displayObject:DisplayObject, frameObject:FrameObject):Void {
		
		if (frameObject.name != null) {
			
			displayObject.name = frameObject.name;
			
		}
		
		if (frameObject.matrix != null) {
			
			displayObject.transform.matrix = frameObject.matrix;
			
			var dynamicTextField:TextField;
			
			if (Std.is (displayObject, TextField)) {
				
				dynamicTextField = cast displayObject;
				
				displayObject.x += dynamicTextField.__symbol.x;
				displayObject.y += dynamicTextField.__symbol.y #if flash + 4 #end;
				
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
	
	
	private function __renderFrame (index:Int):Void {
		
		var previousIndex = __lastUpdate - 1;
		
		if (previousIndex > index) {
			
			var timelineObject, exists;
			var i = 0;
			
			while (i < __objectDepths.length) {
				
				timelineObject = __objectDepths[i];
				exists = false;
				
				for (frameObject in __symbol.frames[0].objects) {
					
					if (frameObject.id == timelineObject.id) {
						
						exists = true;
						break;
						
					}
					
				}
				
				if (!exists) {
					
					if (timelineObject.displayObject.parent == this) {
						
						removeChild (timelineObject.displayObject);
						
					}
					
					__objectDepths.splice (i, 1);
					__objects.remove (timelineObject.id);
					
				} else {
					
					i++;
					
				}
				
			}
			
			previousIndex = 0;
			
		}
		
		var frame, timelineObject, displayObject, depth;
		var mask = null, maskObject = null;
		var depthChange = false;
		
		for (i in previousIndex...(index + 1)) {
			
			if (i < 0) continue;
			
			frame = __symbol.frames[i];
			
			for (frameObject in frame.objects) {
				
				if (frameObject.type != FrameObjectType.DESTROY) {
					
					if (frameObject.id == 0 && frameObject.symbol != __zeroSymbol) {
						
						timelineObject = __objects.get (0);
						
						if (timelineObject != null && timelineObject.displayObject.parent == this) {
							
							removeChild (timelineObject.displayObject);
							
						}
						
						__objectDepths.remove (__objects.get (0));
						__objects.remove (0);
						timelineObject = null;
						displayObject = null;
						__zeroSymbol = frameObject.symbol;
						
					}
					
					if (!__objects.exists (frameObject.id)) {
						
						displayObject = __createObject (frameObject);
						
						if (displayObject != null) {
							
							timelineObject = new TimelineObject (frameObject.id, frameObject.depth, displayObject);
							
							__objectDepths.push (timelineObject);
							__objectDepths.sort (__sortTimelineDepth);
							
							depthChange = true;
							
							__objects.set (frameObject.id, timelineObject);
							
						}
						
					} else {
						
						timelineObject = __objects.get (frameObject.id);
						displayObject = timelineObject.displayObject;
						
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
						
						timelineObject = __objects.get (frameObject.id);
						
						if (timelineObject != null && timelineObject.displayObject.parent == this) {
							
							removeChild (timelineObject.displayObject);
							
						}
						
						__objectDepths.remove (timelineObject);
						__objects.remove (timelineObject.id);
						
						depthChange = true;
						
					}
					
				}
				
			}
			
		}
		
		if (depthChange) {
			
			var i = __objectDepths.length - 1;
			
			while (i >= 0) {
				
				timelineObject = __objectDepths[i];
				addChildAt (timelineObject.displayObject, 0);
				i--;
				
			}
			
		}
		
	}
	
	
	private function __sortTimelineDepth (a:TimelineObject, b:TimelineObject):Int {
		
		return a.depth - b.depth;
		
	}
	
	
	private override function __stopAllMovieClips ():Void {
		
		super.__stopAllMovieClips ();
		stop ();
		
	}
	
	
	private function __updateFrame ():Void {
		
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
			
			__renderDirty = true;
			DisplayObject.__worldRenderDirty++;
			
		}
		
		__lastUpdate = __currentFrame;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_currentFrame ():Int { return __currentFrame; }
	private function get_currentFrameLabel ():String { return __currentFrameLabel; }
	private function get_currentLabel ():String { return __currentLabel; }
	private function get_currentLabels ():Array<FrameLabel> { return __currentLabels; }
	private function get_framesLoaded ():Int { return __totalFrames; }
	private function get_totalFrames ():Int { return __totalFrames; }
	
	
}


private class TimelineObject {
	
	
	public var depth:Int;
	public var displayObject:DisplayObject;
	public var id:Int;
	
	
	public function new (id:Int, depth:Int, displayObject:DisplayObject) {
		
		this.id = id;
		this.depth = depth;
		this.displayObject = displayObject;
		
	}
	
	
}