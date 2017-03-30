package openfl.display;


import lime.utils.Log;
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.symbols.SWFSymbol)


class MovieClip extends Sprite #if openfl_dynamic implements Dynamic<DisplayObject> #end {
	
	
	private static var __initSWF:SWFLite;
	private static var __initSymbol:SpriteSymbol;
	
	public var currentFrame (get, never):Int;
	public var currentFrameLabel (get, never):String;
	public var currentLabel (get, never):String;
	public var currentLabels (get, never):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded (get, never):Int;
	public var isPlaying (get, never):Bool;
	public var totalFrames (get, never):Int;
	
	private var __currentFrame:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>;
	private var __frameScripts:Map<Int, Void->Void>;
	private var __frameTime:Int;
	private var __lastUpdate:Int;
	private var __maskCount:Int;
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
		
		if (__initSymbol != null) {
			
			__swf = __initSWF;
			__symbol = __initSymbol;
			
			__initSWF = null;
			__initSymbol = null;
			
			__fromSymbol (__swf, __symbol);
			
		}
		
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
				
				#if (!swflite_parent_fps && !swf_parent_fps)
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
	
	
	public override function __enterFrame (deltaTime:Int):Void {
		
		if (__symbol != null) {
			
			if (__playing) {
				
				#if (!swflite_parent_fps && !swf_parent_fps)
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
	
	
	private function __fromSymbol (swf:SWFLite, symbol:SpriteSymbol):Void {
		
		if (__objects != null) return;
		
		__swf = swf;
		__symbol = symbol;
		
		__lastUpdate = -1;
		__maskCount = 0;
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
		
		#if !openfl_dynamic
		for (field in Type.getInstanceFields (Type.getClass (this))) {
			
			for (child in __children) {
				
				if (child.name == field) {
					
					Reflect.setField (this, field, child);
					
				}
				
			}
			
		}
		#end
		
		if (__totalFrames > 1) {
			
			play ();
			
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
			
			for (frameLabel in __currentLabels) {
				
				if (frameLabel.name == label) {
					
					return frameLabel.frame;
					
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
		
		displayObject.visible = frameObject.visible;
		
		#if openfl_dynamic
		Reflect.setField (this, displayObject.name, displayObject);
		#end
		
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
					
					if (timelineObject.clipDepth > 0) __maskCount--;
					if (__maskCount < 0) __maskCount = 0;
					
					__objectDepths.splice (i, 1);
					
				} else {
					
					i++;
					
				}
				
			}
			
			previousIndex = 0;
			
		}
		
		var frame, timelineObject, displayObject, depth, symbol;
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
						timelineObject = null;
						__zeroSymbol = frameObject.symbol;
						
					}
					
					displayObject = null;
					
					if (!__objects.exists (frameObject.id)) {
						
						if (__swf.symbols.exists (frameObject.symbol)) {
							
							symbol = __swf.symbols.get (frameObject.symbol);
							displayObject = symbol.__createObject (__swf);
							
						}
						
						if (displayObject != null) {
							
							timelineObject = new TimelineObject (frameObject.id, frameObject.depth, frameObject.clipDepth, displayObject);
							
							if (frameObject.clipDepth > 0) __maskCount++;
							__objectDepths.push (timelineObject);
							__objects.set (frameObject.id, timelineObject);
							
							depthChange = true;
							
						}
						
					} else {
						
						timelineObject = __objects.get (frameObject.id);
						displayObject = timelineObject.displayObject;
						
						if (timelineObject.displayObject.parent == null) {
							
							if (frameObject.clipDepth > 0) __maskCount++;
							__objectDepths.push (timelineObject);
							
							depthChange = true;
							
						}
						
					}
					
					if (displayObject != null) {
						
						__placeObject (displayObject, frameObject);
						
					}
					
				} else {
					
					if (__objects.exists (frameObject.id)) {
						
						timelineObject = __objects.get (frameObject.id);
						
						if (timelineObject != null) {
							
							if (timelineObject.displayObject.parent == this) {
								
								removeChild (timelineObject.displayObject);
								
							}
							
							if (timelineObject.clipDepth > 0) {
								
								__maskCount--;
								
								for (object in __objectDepths) {
									
									if (object.displayObject.mask == timelineObject.displayObject) {
										
										object.displayObject.mask = null;
										
									}
									
								}
								
							}
							
							__objectDepths.remove (timelineObject);
							
						}
						
						depthChange = true;
						
					}
					
				}
				
			}
			
		}
		
		if (depthChange) {
			
			__objectDepths.sort (__sortTimelineDepth);
			
			var i = __objectDepths.length - 1;
			
			while (i >= 0) {
				
				timelineObject = __objectDepths[i];
				addChildAt (timelineObject.displayObject, 0);
				i--;
				
			}
			
		}
		
		if (__maskCount > 0) {
			
			var object, mask;
			
			for (timelineObject in __objectDepths) {
				
				if (timelineObject.clipDepth > 0) {
					
					mask = timelineObject.displayObject;
					
					for (object in __objectDepths) {
						
						if (object.depth <= timelineObject.clipDepth) {
							
							if (object.depth >= timelineObject.depth) {
								
								object.displayObject.mask = mask;
								
							}
							
						} else {
							
							break;
							
						}
						
					}
					
				}
				
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
	private function get_isPlaying ():Bool { return __playing; }
	private function get_totalFrames ():Int { return __totalFrames; }
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


private class TimelineObject {
	
	
	public var clipDepth:Int;
	public var depth:Int;
	public var displayObject:DisplayObject;
	public var id:Int;
	
	
	public function new (id:Int, depth:Int, clipDepth:Int, displayObject:DisplayObject) {
		
		this.id = id;
		this.depth = depth;
		this.clipDepth = clipDepth;
		this.displayObject = displayObject;
		
	}
	
	
}