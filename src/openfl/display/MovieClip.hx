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
import openfl._internal.symbols.SWFSymbol;
import openfl._internal.timeline.Frame;
import openfl._internal.timeline.FrameObject;
import openfl._internal.timeline.FrameObjectType;
import openfl.errors.ArgumentError;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.*;
import openfl.geom.ColorTransform;
import openfl.text.TextField;

#if hscript
import hscript.Interp;
import hscript.Parser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.symbols.SWFSymbol)
@:access(openfl.geom.ColorTransform)


class MovieClip extends Sprite #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic<DisplayObject> #end {
	
	
	private static var __initSWF:SWFLite;
	private static var __initSymbol:SpriteSymbol;
	
	#if openfljs
	private static var __useParentFPS:Bool;
	#else
	private static inline var __useParentFPS:Bool = #if (swflite_parent_fps || swf_parent_fps) true #else false #end;
	#end
	
	public var currentFrame (get, never):Int;
	public var currentFrameLabel (get, never):String;
	public var currentLabel (get, never):String;
	public var currentLabels (get, never):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded (get, never):Int;
	public var isPlaying (get, never):Bool;
	public var totalFrames (get, never):Int;
	
	private var __activeInstances:Array<FrameSymbolInstance>;
	private var __activeInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
	private var __currentFrame:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>;
	private var __frameScripts:Map<Int, Void->Void>;
	private var __frameTime:Int;
	private var __hasDown:Bool;
	private var __hasOver:Bool;
	private var __hasUp:Bool;
	private var __lastFrameScriptEval:Int;
	private var __lastFrameUpdate:Int;
	private var __mouseIsDown:Bool;
	private var __playing:Bool;
	private var __swf:SWFLite;
	private var __symbol:SpriteSymbol;
	private var __timeElapsed:Int;
	private var __totalFrames:Int;
	
	
	#if openfljs
	private static function __init__ () {
		
		__useParentFPS = true;
		untyped __js__("/// #if (typeof swf-parent-fps === 'undefined' || !swf-parent-fps) && (typeof swflite-parent-fps === 'undefined' || !swflite-parent-fps)");
		__useParentFPS = false;
		untyped __js__("/// #endif");
		
		untyped Object.defineProperties (MovieClip.prototype, {
			"currentFrame": { get: untyped __js__ ("function () { return this.get_currentFrame (); }") },
			"currentFrameLabel": { get: untyped __js__ ("function () { return this.get_currentFrameLabel (); }") },
			"currentLabel": { get: untyped __js__ ("function () { return this.get_currentLabel (); }") },
			"currentLabels": { get: untyped __js__ ("function () { return this.get_currentLabels (); }") },
			"framesLoaded": { get: untyped __js__ ("function () { return this.get_framesLoaded (); }") },
			"isPlaying": { get: untyped __js__ ("function () { return this.get_isPlaying (); }") },
			"totalFrames": { get: untyped __js__ ("function () { return this.get_totalFrames (); }") },
		});
		
	}
	#end
	
	
	public function new () {
		
		super ();
		
		__currentFrame = 1;
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
		
		if (index < 0) return;
		var frame = index + 1;
		
		if (method != null) {
			
			if (__frameScripts == null) {
				
				__frameScripts = new Map ();
				
			}
			
			__frameScripts.set (frame, method);
			
		} else if (__frameScripts != null) {
			
			__frameScripts.remove (frame);
			
		}
		
	}
	
	
	public function gotoAndPlay (frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void {
		
		play ();
		__goto (__resolveFrameReference (frame));
		
	}
	
	
	public function gotoAndStop (frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void {
		
		stop ();
		__goto (__resolveFrameReference (frame));
		
	}
	
	
	public function nextFrame ():Void {
		
		stop ();
		__goto (__currentFrame + 1);
		
	}
	
	
	public function play ():Void {
		
		if (__symbol == null || __playing || __totalFrames < 2) return;
		
		__playing = true;
		
		if (!__useParentFPS) {
			
			__frameTime = Std.int (1000 / __swf.frameRate);
			__timeElapsed = 0;
			
		}
		
	}
	
	
	public function prevFrame ():Void {
		
		stop ();
		__goto (__currentFrame - 1);
		
	}
	
	
	public function stop ():Void {
		
		__playing = false;
		
	}
	
	
	public override function __enterFrame (deltaTime:Int):Void {
		
		if (__symbol != null && __playing) {
			
			var nextFrame = __getNextFrame (deltaTime);
			
			if (__lastFrameScriptEval == nextFrame) {
				
				return;
				
			}
			
			if (__frameScripts != null) {
				
				if (nextFrame < __currentFrame) {
					
					if (!__evaluateFrameScripts (__totalFrames)) {
						
						return;
						
					}
					
					__currentFrame = 1;
					
				}
				
				if (!__evaluateFrameScripts (nextFrame)) {
					
					return;
					
				}
				
			} else {
				
				__currentFrame = nextFrame;
				
			}
			
		}
		
		if (__symbol != null && __currentFrame != __lastFrameUpdate) {
			
			__updateFrameLabel ();
			
			var currentInstancesByFrameObjectID = new Map<Int, FrameSymbolInstance> ();
			
			var frame:Int;
			var frameData:Frame;
			var instance:FrameSymbolInstance;
			
			// TODO: Handle updates only from previous frame?
			
			for (i in 0...__currentFrame) {
				
				frame = i + 1;
				frameData = __symbol.frames[i];
				
				if (frameData.objects == null) continue;
				
				for (frameObject in frameData.objects) {
					
					switch (frameObject.type) {
						
						case CREATE:
							
							instance = __activeInstancesByFrameObjectID.get (frameObject.id);
							
							if (instance != null) {
								
								currentInstancesByFrameObjectID.set (frameObject.id, instance);
								__updateDisplayObject (instance.displayObject, frameObject, true);
								
							}
						
						case UPDATE:
							
							instance = currentInstancesByFrameObjectID.get (frameObject.id);
							
							if (instance != null && instance.displayObject != null) {
								
								__updateDisplayObject (instance.displayObject, frameObject);
								
							}
						
						case DESTROY:
							
							currentInstancesByFrameObjectID.remove (frameObject.id);
						
					}
					
				}
				
			}
			
			// TODO: Less garbage?
			
			var currentInstances = new Array<FrameSymbolInstance> ();
			var currentMasks = new Array<FrameSymbolInstance> ();
			
			for (instance in currentInstancesByFrameObjectID) {
				
				if (currentInstances.indexOf (instance) == -1) {
					
					currentInstances.push (instance);
					
					if (instance.clipDepth > 0) {
						
						currentMasks.push (instance);
						
					}
					
				}
				
			}
			
			currentInstances.sort (__sortDepths);
			
			var existingChild:DisplayObject;
			var targetDepth:Int;
			var targetChild:DisplayObject;
			var child:DisplayObject;
			var maskApplied:Bool;
			
			for (i in 0...currentInstances.length) {
				
				existingChild = __children[i];
				instance = currentInstances[i];
				
				targetDepth = instance.depth;
				targetChild = instance.displayObject;
				
				if (existingChild != targetChild) {
					
					child = targetChild;
					addChildAt (targetChild, i);
					
				} else {
					
					child = __children[i];
					
				}
				
				maskApplied = false;
				
				for (mask in currentMasks) {
					
					if (targetDepth > mask.depth && targetDepth <= mask.clipDepth) {
						
						child.mask = mask.displayObject;
						maskApplied = true;
						break;
						
					}
					
				}
				
				if (currentMasks.length > 0 && !maskApplied && child.mask != null) {
					
					child.mask = null;
					
				}
				
			}
			
			var child;
			var i = currentInstances.length;
			var length = __children.length;
			
			while (i < length) {
				
				child = __children[i];
				
				// TODO: Faster method of determining if this was automatically added?
				
				for (instance in __activeInstances) {
					
					if (instance.displayObject == child) {
						
						//set MovieClips back to initial state (autoplay)
						if (Std.is(child, MovieClip))
						{
							var movie : MovieClip = cast child;
							movie.gotoAndPlay(1);
						}
						
						removeChild (child);
						i--;
						length--;
						
					}
					
				}
				
				i++;
				
			}
			
			__lastFrameUpdate = __currentFrame;
			
		}
		
		super.__enterFrame (deltaTime);
		
	}
	
	
	private function __evaluateFrameScripts (advanceToFrame:Int):Bool {
		
		for (frame in __currentFrame...advanceToFrame + 1) {
			
			if (frame == __lastFrameScriptEval) continue;
			
			__lastFrameScriptEval = frame;
			__currentFrame = frame;
			
			if (__frameScripts.exists (frame)) {
				
				var script = __frameScripts.get (frame);
				script ();
				
				if (__currentFrame != frame) {
					
					return false;
					
				}
				
			}
			
			if (!__playing) {
				
				break;
				
			}
			
		}
		
		return true;
		
	}
	
	
	private function __fromSymbol (swf:SWFLite, symbol:SpriteSymbol):Void {
		
		if (__activeInstances != null) return;
		
		__swf = swf;
		__symbol = symbol;
		
		__activeInstances = [];
		__activeInstancesByFrameObjectID = new Map ();
		__currentFrame = 1;
		__lastFrameScriptEval = -1;
		__lastFrameUpdate = -1;
		__totalFrames = __symbol.frames.length;
		
		var frame:Int;
		var frameData:Frame;
		
		#if hscript
		var parser = null;
		#end
		
		for (i in 0...__symbol.frames.length) {
			
			frame = i + 1;
			frameData = __symbol.frames[i];
			
			if (frameData.label != null) {
				
				__currentLabels.push (new FrameLabel (frameData.label, i + 1));
				
			}
			
			if (frameData.script != null) {
				
				if (__frameScripts == null) {
					
					__frameScripts = new Map ();
					
				}
				
				__frameScripts.set (frame, frameData.script);
				
			} else if (frameData.scriptSource != null) {
				
				if (__frameScripts == null) {
					
					__frameScripts = new Map ();
					
				}
				
				try {
					
					#if hscript
					
					if (parser == null) {
						
						parser = new Parser ();
						parser.allowTypes = true;
						
					}
					
					var program = parser.parseString (frameData.scriptSource);
					var interp = new Interp ();
					interp.variables.set ("this", this);
					
					var script = function () {
						
						interp.execute (program);
						
					};
					
					__frameScripts.set (frame, script);
					
					#elseif js
					
					var script = untyped __js__('eval({0})', "(function(){" + frameData.scriptSource + "})");
					var wrapper = function () {
						
						try {
							
							script.call (this);
							
						} catch (e:Dynamic) {
							
							trace ("Error evaluating frame script\n " + e + "\n" + 
								haxe.CallStack.exceptionStack ().map (function (a) { return untyped a[2]; }).join ("\n") + "\n" + 
								e.stack + "\n" + untyped script.toString ());
							
						}
						
					}
					
					__frameScripts.set (frame, wrapper);
					
					#end
					
				} catch (e:Dynamic) {
					
					if (__symbol.className != null) {
						
						Log.warn ("Unable to evaluate frame script source for symbol \"" + __symbol.className + "\" frame " + frame + "\n" + frameData.scriptSource);
						
					} else {
						
						Log.warn ("Unable to evaluate frame script source:\n" + frameData.scriptSource);
						
					}
					
				}
				
			}
			
		}
		
		var frame:Int;
		var frameData:Frame;
		var instance:FrameSymbolInstance;
		var duplicate:Bool;
		var symbol:SWFSymbol;
		var displayObject:DisplayObject;
		
		// TODO: Create later?
		
		for (i in 0...__totalFrames) {
			
			frame = i + 1;
			frameData = __symbol.frames[i];
			
			if (frameData.objects == null) continue;
			
			for (frameObject in frameData.objects) {
				
				if (frameObject.type == FrameObjectType.CREATE) {
					
					if (__activeInstancesByFrameObjectID.exists (frameObject.id)) {
						
						continue;
						
					} else {
						
						instance = null;
						duplicate = false;
						
						for (activeInstance in __activeInstances) {
							
							if (activeInstance.displayObject != null && activeInstance.characterID == frameObject.symbol && activeInstance.depth == frameObject.depth) {
								
								// TODO: Fix duplicates in exporter
								instance = activeInstance;
								duplicate = true;
								break;
								
							}
							
						}
						
					}
					
					if (instance == null) {
						
						symbol = __swf.symbols.get (frameObject.symbol);
						
						if (symbol != null) {
							
							displayObject = symbol.__createObject (__swf);
							
							if (displayObject != null) {
								
								displayObject.parent = this;
								displayObject.stage = stage;
								instance = new FrameSymbolInstance (frame, frameObject.id, frameObject.symbol, frameObject.depth, displayObject, frameObject.clipDepth);
								
							}
							
						}
						
					}
					
					if (instance != null) {
						
						__activeInstancesByFrameObjectID.set (frameObject.id, instance);
						
						if (!duplicate) {
							
							__activeInstances.push (instance);
							__updateDisplayObject (instance.displayObject, frameObject);
							
						}
						
					}
					
				}/* else if (frameObject.type == FrameObjectType.UPDATE) {
					
					instance = null;
					
					if (__activeInstancesByFrameObjectID.exists (frameObject.id)) {
						
						instance = __activeInstancesByFrameObjectID.get (frameObject.id);
						
					}
					
					if (instance != null && instance.displayObject != null) {
						
						__updateDisplayObject (instance.displayObject, frameObject);
						
					}
					
				} else if (frameObject.type == FrameObjectType.DESTROY) {
					
					// TODO: the following never evalutates because SWFLiteExporter
					//   always orders DESTROY after CREATE, losing the original order
					//   they were saved as in the .swf, and because SWFLiteExporter
					//   duplicates two frameObjectIds for the same characterId
					//   and depth sometimes.
					//if (!indexCachedFrameObjectEntryById.exists (frameObject.id)) {
					//
					//	throw "Tried to remove a DisplayObject child that hasn't been CREATED yet.";
					//
					//}
					
				} else {
					
					throw "Unrecognized FrameObject.type "+ frameObject.type;
					
				}*/
				
			}
			
		}
		
		if (__totalFrames > 1) {
			
			play ();
			
		}
		
		__enterFrame (0);
		
		#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
		// TODO: Speed this up
		for (field in Type.getInstanceFields (Type.getClass (this))) {
			
			for (child in __children) {
				
				if (child.name == field) {
					
					Reflect.setField (this, field, child);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
	private function __getNextFrame (deltaTime:Int):Int {
		
		var nextFrame:Int = 0;
		
		if (!__useParentFPS) {
			
			__timeElapsed += deltaTime;
			nextFrame = __currentFrame + Math.floor (__timeElapsed / __frameTime);
			if (nextFrame < 1) nextFrame = 1;
			if (nextFrame > __totalFrames) nextFrame = Math.floor ((nextFrame - 1) % __totalFrames) + 1;
			__timeElapsed = (__timeElapsed % __frameTime);
			
		} else {
			
			nextFrame = __currentFrame + 1;
			if (nextFrame > __totalFrames) nextFrame = 1;
			
		}
		
		return nextFrame;
		
	}
	
	
	private function __goto (frame:Int) {
		
		if (__symbol == null) return;
		
		if (frame < 1) frame = 1;
		else if (frame > __totalFrames) frame = __totalFrames;
		
		__currentFrame = frame;
		__enterFrame (0);
		
	}
	
	
	private function __resolveFrameReference (frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end):Int {
		
		if (Std.is (frame, Int)) {
			
			return cast frame;
			
		} else if (Std.is (frame, String)) {
			
			var label:String = cast frame;
			
			for (frameLabel in __currentLabels) {
				
				if (frameLabel.name == label) {
					
					return frameLabel.frame;
					
				}
			}
			
			throw new ArgumentError ("Error #2109: Frame label " + label + " not found in scene.");
			
		} else {
			
			throw "Invalid type for frame " + Type.getClassName (frame);
			
		}
		
	}
	
	
	private function __sortDepths (a:FrameSymbolInstance, b:FrameSymbolInstance):Int {
		
		return a.depth - b.depth;
		
	}
	
	
	private override function __stopAllMovieClips ():Void {
		
		super.__stopAllMovieClips ();
		stop ();
		
	}
	
	
	private function __updateDisplayObject (displayObject:DisplayObject, frameObject:FrameObject, reset : Bool = false):Void {
		
		if (displayObject == null) return;
		
		if (frameObject.name != null) {
			
			displayObject.name = frameObject.name;
			
		}
		
		if (frameObject.matrix != null) {
			
			displayObject.transform.matrix = frameObject.matrix;
			
		}
		
		if (frameObject.colorTransform != null) {
			
			displayObject.transform.colorTransform = frameObject.colorTransform;
			
		}
		else if (reset && !displayObject.transform.colorTransform.__isDefault()) {
			
			displayObject.transform.colorTransform = new ColorTransform();
			
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
			
		} else {

			displayObject.filters = null;

		}
		
		if (frameObject.visible != null) {
			
			displayObject.visible = frameObject.visible;
			
		}
		
		if (frameObject.blendMode != null) {
			
			displayObject.blendMode = frameObject.blendMode;
			
		}
		
		if (frameObject.cacheAsBitmap != null) {
			
			//displayObject.cacheAsBitmap = frameObject.cacheAsBitmap;
			
		}
		
		#if (openfljs || ((openfl_dynamic || openfl_dynamic_fields_only) && haxe_ver <= "4.0.0"))
		Reflect.setField (this, displayObject.name, displayObject);
		#end
		
	}
	
	
	private function __updateFrameLabel ():Void {
		
		__currentFrameLabel = __symbol.frames[__currentFrame - 1].label;
		
		if (__currentFrameLabel != null) {
			
			__currentLabel = __currentFrameLabel;
			
		} else {
			
			__currentLabel = null;
			
			for (label in __currentLabels) {
				
				if (label.frame < __currentFrame) {
					
					__currentLabel = label.name;
					
				} else {
					
					break;
					
				}
				
			}
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function __onMouseDown (event:MouseEvent):Void {
		
		if (__hasDown) {
			
			gotoAndStop ("_down");
			
		}
		
		__mouseIsDown = true;
		stage.addEventListener (MouseEvent.MOUSE_UP, __onMouseUp);
		
	}
	
	
	private function __onMouseUp (event:MouseEvent):Void {
		
		__mouseIsDown = false;
		
		if (stage != null) {
			
			stage.removeEventListener (MouseEvent.MOUSE_UP, __onMouseUp);
			
		}
		
		if (event.currentTarget == this && __hasOver) {
			
			gotoAndStop ("_over");
			
		} else if (__hasUp) {
			
			gotoAndStop ("_up");
			
		}
		
	}
	
	
	private function __onRollOut (event:MouseEvent):Void {
		
		if (__mouseIsDown && __hasOver) {
			
			gotoAndStop ("_over");
			
		} else if (__hasUp) {
			
			gotoAndStop ("_up");
			
		}
		
	}
	
	
	private function __onRollOver (event:MouseEvent):Void {
		
		if (__hasOver) {
			
			gotoAndStop ("_over");
			
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private override function set_buttonMode (value:Bool):Bool {
		
		if (__buttonMode != value) {
			
			if (value) {
				
				__hasDown = false;
				__hasOver = false;
				__hasUp = false;
				
				for (frameLabel in __currentLabels) {
					
					switch (frameLabel.name) {
						
						case "_up": __hasUp = true;
						case "_over": __hasOver = true;
						case "_down": __hasDown = true;
						default:
						
					}
					
				}
				
				if (__hasDown || __hasOver || __hasUp) {
					
					addEventListener (MouseEvent.ROLL_OVER, __onRollOver);
					addEventListener (MouseEvent.ROLL_OUT, __onRollOut);
					addEventListener (MouseEvent.MOUSE_UP, __onMouseUp);
					addEventListener (MouseEvent.MOUSE_DOWN, __onMouseDown);
						
				}
				
			} else {
				
				removeEventListener (MouseEvent.ROLL_OVER, __onRollOver);
				removeEventListener (MouseEvent.ROLL_OUT, __onRollOut);
				removeEventListener (MouseEvent.MOUSE_UP, __onMouseUp);
				removeEventListener (MouseEvent.MOUSE_DOWN, __onMouseDown);
				
			}
			
			__buttonMode = value;
			
		}
		
		return value;
		
	}
	
	
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

private class FrameSymbolInstance {
	
	
	public var characterID:Int;
	public var clipDepth:Int;
	public var depth:Int;
	public var displayObject:DisplayObject;
	public var initFrame:Int;
	public var initFrameObjectID:Int; // TODO: Multiple frame object IDs may refer to the same instance
	
	
	public function new (initFrame:Int, initFrameObjectID:Int, characterID:Int, depth:Int, displayObject:DisplayObject, clipDepth:Int) {

		this.initFrame = initFrame;
		this.initFrameObjectID = initFrameObjectID;
		this.characterID = characterID;
		this.depth = depth;
		this.displayObject = displayObject;
		this.clipDepth = clipDepth;
		
	}
	
	
}
