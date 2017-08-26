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
import openfl.filters.*;
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


class MovieClip extends Sprite #if openfl_dynamic implements Dynamic<DisplayObjectContainer> #end {


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

	private var __cachedChildFrameSymbolInstancesByFrameObjectId:Map<Int, FrameSymbolInstance>;
	private var __cachedChildFrameSymbolInstancesByDisplayObject:Map<DisplayObject, Array<FrameSymbolInstance>>;
	private var __currentFrame:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>;
	private var __frameScripts:Map<Int, Void->Void>;
	private var __lastFrameUpdate:Int;
	private var __playing:Bool;
	private var __swf:SWFLite;
	private var __symbol:SpriteSymbol;
	#if (!swflite_parent_fps && !swf_parent_fps)
	private var __frameTime:Int;
	private var __timeElapsed:Int;
	#end
	private var __totalFrames:Int;


	public function new () {

		super ();

		__currentFrame = 1;
		__lastFrameUpdate = -1;
		__currentLabels = [];
		__totalFrames = 0;
		enabled = true;

		#if (!swflite_parent_fps && !swf_parent_fps)
		__frameTime = Std.int(1000 / 24); // default; overridden later by play()
		__timeElapsed = 0;
		#end

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

	private function __goto (frame:Int) {

		if (__symbol == null) return;

		if (frame < 1) frame = 1;
		else if (frame > __totalFrames) frame = __totalFrames;

		__currentFrame = frame;
		__lastFrameUpdate = -1;
		__enterFrame (0);

	}

	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
//		trace(__name + " gotoAndPlay frame "+ frame);
		play ();
		__goto (__resolveFrameReference (frame));

	}


	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
//		trace(__name + " gotoAndStop frame "+ frame);

		play ();
		__goto (__resolveFrameReference (frame));
		stop ();
	}


	public function nextFrame ():Void {
//		trace(__name + " nextFrame "+ (__currentFrame + 1));

		gotoAndStop (__currentFrame + 1);

	}


	public function play ():Void {
//		trace(__name + " play "+ (__currentFrame));

		if (__symbol == null || __playing || __totalFrames < 2) return;

		__playing = true;

		#if (!swflite_parent_fps && !swf_parent_fps)
		__frameTime = Std.int (1000 / __swf.frameRate);
		__timeElapsed = 0;
		#end

	}


	public function prevFrame ():Void {
//		trace(__name + " nextFrame "+ (__currentFrame - 1));

		gotoAndStop (__currentFrame - 1);

	}


	public function stop ():Void {
//		trace(__name + " stop");

		__playing = false;

	}

	public override function __enterFrame (deltaTime:Int):Void {
		// calculate what the current frame should be
		var __targetFrame: Int = __getNextFrame (deltaTime);

		// __lastFrameUpdate represents the last target frame that completed
		// all the inbetween FrameObject updates don't matter those are just compositions
		// leading up to the final target frame
		// the exception to this is if a frame script stops playback

		// play forward through frame scripts up to and including the current frame,
		// taking looping into account
		var frameIndex:Int = __lastFrameUpdate == -1 ? 0 : __lastFrameUpdate; // will be +1'ed soon
		var frame:Frame;
		var clearChildren:Bool = false;
		if (-1 == __lastFrameUpdate) {
			// clear once before compositing frames 1...__targetFrame
			clearChildren = true;
		}
		while (frameIndex != __targetFrame)
		{
			// nothing here to draw or animate
			if (null == __symbol)
			{
				break;
			}

			if (!__playing && __lastFrameUpdate != -1) {
				// if we're not playing
				// and we've drawn at least one target frame
				// then abort

				// also catches the case where a frame script
				// called stop();
				break;
			}

			frameIndex = frameIndex + 1;
			if (frameIndex > __totalFrames) {
				frameIndex = frameIndex - __totalFrames;

				// clear this frame because we've looped
				clearChildren = true;
			}

			if (clearChildren)
			{
				// remove non-manual children
				// TODO: this is so nasty but first priority is making it work according to spec right now
				var i = __children.length;
				while (--i >= 0)
				{
					var child:DisplayObject = __children[i];
					if (__cachedChildFrameSymbolInstancesByDisplayObject.exists(child)) {
						removeChildAt(i);
					}
				}
			}
			clearChildren = false;


			frame = __symbol.frames[frameIndex-1]; // .frames[] is 0-indexed


			// perform RemoveObject operations on child list since last frame arrangement

			// NOTICE: SWFLiteExporter always [incorrectly] sorts the list of
			// FrameObjects so that DESTROY is at the end. It should list them
			// in the order it finds in the SWF, but as a runtime workaround
			// we can sort them to the front of the list here.

			if (frame.objects != null)
			{
				for (frameObject in frame.objects)
				{
					// get reference to child from cache
					// NOTICE: this means child instances are preserved between being added/removed during animation
					// TODO: move these outside loop
					var instance:FrameSymbolInstance = __cachedChildFrameSymbolInstancesByFrameObjectId.get (frameObject.id);
					// TODO: this only happens if __createObject fails to instantiate the DisplayObject child (e.g., missing baseClassName implementation)
					if (instance == null) continue;
					switch (frameObject.type) {
						case CREATE:
						case UPDATE:
							// do nothing

						case DESTROY:
							// attempt to remove it
							// TODO: if we remove first in a separate loop
							// we might optimize (depends on if frameobject loop
							// is shorter than displayed children. probably)

							removeChild(instance.displayObject);
					}
				}
			}





			// perform PlaceObject operations on child list since last frame arrangement
			var currentMasks = new Array<FrameSymbolInstance> ();
			if (frame.objects != null)
			{
				for (frameObject in frame.objects)
				{

					// update FrameSymbolInstances with reference to current child index
					// detect any children which were manually added since last frame
					// we do this linkedlist thing to try to avoid multiple for...loops later
					var onScreenFrameSymbolInstances:Array<FrameSymbolInstance> = new Array();
					var onScreenframeSymbolInstancesByFrameObjectId: Map<Int, FrameSymbolInstance> = new Map();
					for (i in 0...__children.length)
					{
						// TODO: move above loop for gc optimization?
						var child:DisplayObject = __children[i];
						var frameSymbolInstances:Array<FrameSymbolInstance> = __cachedChildFrameSymbolInstancesByDisplayObject.get(child);
						if (null != frameSymbolInstances) {
							for (ii in 0...frameSymbolInstances.length) {
								var frameSymbolInstance = frameSymbolInstances[ii];
								// link the list (ignoring off-screen links which will become disjointed)
								if (ii > 0) {
									var lastFrameSymbolInstance = frameSymbolInstances[ii-1];
									frameSymbolInstance.prevFrameSymbolInstance = lastFrameSymbolInstance;
									lastFrameSymbolInstance.nextFrameSymbolInstance = frameSymbolInstance;
								}
								frameSymbolInstance.childIndex = i;
								onScreenFrameSymbolInstances.push(frameSymbolInstance);
								onScreenframeSymbolInstancesByFrameObjectId.set(frameSymbolInstance.frameObject.id, frameSymbolInstance);
							}
						}
						else {
							// manually added child
							new FrameSymbolInstance(child, null);
						}
					}



					// get reference to child from cache
					// NOTICE: this means child instances are preserved between being added/removed during animation
					// TODO: move these outside loop
					var instance:FrameSymbolInstance = __cachedChildFrameSymbolInstancesByFrameObjectId.get (frameObject.id);
					// TODO: this only happens if __createObject fails to instantiate the DisplayObject child (e.g., missing baseClassName implementation)
					if (instance == null) continue;
					var isOnScreen:Bool = onScreenframeSymbolInstancesByFrameObjectId.exists (frameObject.id);
					switch (frameObject.type) {

						case CREATE:
							__updateDisplayObject (instance.displayObject, frameObject);

							// if child is in the list
							if (isOnScreen) {
								// leave it; do nothing more
							} else {
								// if its a mask
								if (instance.frameObject.clipDepth > 0) {
									// add it to the mask list and do nothing here
									currentMasks.push (instance);
								}
								else {
									// TODO: if no manual children present, just pop it on the end of __children list

									// calculate new child insertion index (aka. Ferrets in a Mason Jar)
									var targetIndex: Int;

									// TODO:
									// find first non-manual child already on screen which would overlap this child (depth)
									//
									// if one, insert behind it
									//
									// if none,
									//   find first non-manual child already on screen which this child would overlap (depth)
									//
									//   if one, insert after it + any manual children following it
									//   if none,
									//     insert top-most (.push())
									//
									// go to next child
									//

									var nearestMatch: FrameSymbolInstance = null;
									// assumes array is ordered by bg to fg; which it is
									var i = onScreenFrameSymbolInstances.length;
									while (--i >= 0)
									{
										var onScreenFSI:FrameSymbolInstance = onScreenFrameSymbolInstances[i];
										if (onScreenFSI.frameObject.depth > instance.frameObject.depth) {
											//onScreenFSI.childIndex = i; // could do this here instead of for loop above

											// i'm afraid it seems there is no earlier opportunity to join loops here
											// because even if we index by depth, the depths shown have gaps, and the
											// next-nearest depth to this depth can't be predicted in a single loop?
											// at some point its a cross join of what's in the frameObject list
											// and what is on screen (two for...loops)

											nearestMatch = onScreenFSI;
										}
											// if they are ever equal it is a duplicate and should have been
											// filtered out by prior operations before now
											// therefore the only other case is less than
										else {
											// went far enough; can stop
											break;
										}
									}
									// first non-manual child already on screen which would overlap this child (depth)
									if (null != nearestMatch)
									{
										targetIndex = nearestMatch.childIndex; // insert behind
									}
										// no child on screen that would appear on top of me
									else {
										for (i in 0...onScreenFrameSymbolInstances.length)
										{
											var onScreenFSI:FrameSymbolInstance = onScreenFrameSymbolInstances[i];
											if (onScreenFSI.frameObject.depth < instance.frameObject.depth) {
												nearestMatch = onScreenFSI;
											}
											else {
												// went far enough; can stop
												break;
											}
										}
										// first non-manual child already on screen which this child would overlap (depth)
										if (null != nearestMatch)
										{
											// count the number of manual children appearing after this one
											targetIndex = nearestMatch.childIndex;
											while (++targetIndex < __children.length)
											{
												if (__cachedChildFrameSymbolInstancesByDisplayObject.exists(__children[targetIndex])) {
													break;
												}
											}
											// will end up inserting overlapping the last non manual child in a row
										}
										else
										{
											// assumes placeobjects are processed in order
											// of background to foregound, which they are
											targetIndex = __children.length; // insert top-most
										}
									}

									// TODO: need a way to composite the frames without triggering events, etc.
									// my old way of collecting changes into an array is probably necessary here
									// NOTICE: any add or remove to __children requires us to reindex the children
									addChildAt(instance.displayObject, targetIndex);

									// clear old masks
									instance.displayObject.mask = null;
									// apply mask within clipDepth range
									var targetDepth:Int = instance.frameObject.depth;
									var maskApplied:Bool = false;
									if (currentMasks.length > 0) {
										for (mask in currentMasks) {
											if (targetDepth > mask.frameObject.depth && targetDepth <= mask.frameObject.clipDepth) {
												instance.displayObject.mask = mask.displayObject;
												maskApplied = true;
												break;
											}
										}
									}
								}
							}

						case UPDATE:
							// TODO: categorize each type of update to only apply its last value (e.g., last x value)
							__updateDisplayObject (instance.displayObject, frameObject);

							// if child is in the list
							if (isOnScreen) {
								// leave it; update it
							} else {
								// someone manually removed! leave removed
							}

						case DESTROY:
						// do nothing
					}
				}
			}

			// now its time to apply frame scripts

			// we only need to do this if we're processing a range
			// however if we're skipping to a frame (indicated by __lastFrameUpdate == -1)
			// and this is not the targetFrame, then we can skip evaluation of all
			// frame scripts inbetween
			if (-1 == __lastFrameUpdate && frameIndex != __targetFrame) {
				continue;
			}

			// first we need to setup the environment for them
			// so they can query and get current information about
			// what frame they are evaluating on, etc.

			// calculate the current frame label, in case it changed since last frame
			__updateFrameLabel ();

			// set this for the frame scripts' (and recursive callee) sake
			__currentFrame = frameIndex;

			// no frame scripts defined for this movieclip instance
			// or no frame script on this particular frame
			if (__frameScripts != null && __frameScripts.exists (__currentFrame)) {
				// finally, evaluate the frame script for the current frame!
				var script = __frameScripts.get (__currentFrame);
				script ();
			}

			// remember what the last frame we started processing was (to avoid duplication)
			__lastFrameUpdate = frameIndex;
		}



		// the implicit else case of the above while statement:
		// the current frame is not the one we evaluated last time
		// not enough time has passed to advance to the next frame
		// or, we've already drawn the children for this frame once
		// (we need to do this at least once, even if !__playing)
		// so a frozen frame can be rendered with correct children

		// see if the superclass (DisplayObject) wants to do anything
		// currently an empty function;
		// won't do anything meaningful unless someone customizes
		super.__enterFrame (deltaTime);


	}

	@:access(openfl._internal.swf.SWFLiteLibrary.id)
	@:access(openfl._internal.swf.SWFLiteLibrary.rootPath)
	private function __fromSymbol (swf:SWFLite, symbol:SpriteSymbol):Void {

		if (__cachedChildFrameSymbolInstancesByFrameObjectId != null) return;

		__swf = swf;
		__symbol = symbol;

		__cachedChildFrameSymbolInstancesByFrameObjectId = new Map ();
		__cachedChildFrameSymbolInstancesByDisplayObject = new Map ();
		var __activeInstances:Array<FrameSymbolInstance> = [];
		__currentFrame = 1;
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
							var p: DisplayObjectContainer = this;
							var name: Array<String> = new Array();
							do {
								name.push(p.__name);
							} while (null != (p = p.parent));
							name.reverse();
							trace ("Error evaluating frame script\n" +
								"swf library rootPath: "+ this.__swf.library.rootPath +"\n" +
								"swf library id: "+ this.__swf.library.id +"\n" +
								"symbol hierarchy: "+ name.join('.') +"\n" +
								"error: "+	e.toString() + "\n" +
								"frame script:\n"+
								untyped script.toString ());

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

//			var deleteFrameObjects:Array<FrameObject> = new Array();
//			var nonDeleteFrameObjects:Array<FrameObject> = new Array();

			for (frameObject in frameData.objects) {

				switch (frameObject.type) {

					case CREATE:

//						nonDeleteFrameObjects.push(frameObject);

						if (__cachedChildFrameSymbolInstancesByFrameObjectId.exists (frameObject.id)) {

							continue;

						} else {

							instance = null;
							duplicate = false;

							for (activeInstance in __activeInstances) {

								if (activeInstance.displayObject != null &&
								activeInstance.frameObject.symbol == frameObject.symbol && // aka characterID
								activeInstance.frameObject.depth == frameObject.depth) {

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
									instance = new FrameSymbolInstance (displayObject, frameObject);
									var a: Array<FrameSymbolInstance>;
									if (!__cachedChildFrameSymbolInstancesByDisplayObject.exists(displayObject)) {
										a = new Array();
										a.push(instance);
										__cachedChildFrameSymbolInstancesByDisplayObject.set(displayObject, a);
									}
									else {
										a = __cachedChildFrameSymbolInstancesByDisplayObject.get(displayObject);
										a.push(instance);
									}
								}
								else
								{
									trace("failed to __createObject MovieClip child"
									+" symbol className: "+ __symbol.className
									+", symbol baseClassName: "+ __symbol.baseClassName
									+", SWF rootPath :"+ __swf.library.rootPath
									+", SWF id: "+ __swf.library.id
									);

								}


							}
							else {

								// TODO: prevent this from happening. happens on MorphShape tags (ie. HUDAssets.swf)
								trace("failed to __createObject MovieClip child. symbol/characterId id "
								+ frameObject.symbol +" not found among MovieClip __swf.symbols");

							}

						}

						if (instance != null) {

							__cachedChildFrameSymbolInstancesByFrameObjectId.set (frameObject.id, instance);

							if (!duplicate) {

								__activeInstances.push (instance);
								__updateDisplayObject (instance.displayObject, frameObject);

							}

						}

						if (instance == null)
						{
							trace("failed to initialize MovieClip child"
							+" frameObject id: "+ frameObject.id
							+", characterId: "+ frameObject.symbol
							+", depth: "+ frameObject.depth
							+", SWF rootPath :"+ __swf.library.rootPath
							+", SWF id: "+ __swf.library.id
							);
						}


					case UPDATE:

//						nonDeleteFrameObjects.push(frameObject);


					case DESTROY:

//						deleteFrameObjects.push(frameObject);


					case _:

						throw "Unrecognized FrameObject.type "+ frameObject.type;

				}
			}

			// NOTICE: SWFLiteExporter always [incorrectly] sorts the list of
			// FrameObjects so that DESTROY is at the end. It should list them
			// in the order it finds in the SWF, but as a runtime workaround
			// we can sort them to the front of the list here.
//			frameData.objects = deleteFrameObjects.concat(nonDeleteFrameObjects);

		}

		if (__totalFrames > 1) {

			gotoAndPlay (0);

		}
		else {

			gotoAndStop (0);

		}


		#if !openfl_dynamic
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

		#if (!swflite_parent_fps && !swf_parent_fps)
		__timeElapsed += deltaTime;
		var nextFrame = __currentFrame + Math.floor (__timeElapsed / __frameTime);
		if (0 == __totalFrames) return 1;
		if (nextFrame < 1) nextFrame = 1;
		if (nextFrame > __totalFrames) nextFrame = Math.floor ((nextFrame - 1) % __totalFrames) + 1;
		__timeElapsed = (__timeElapsed % __frameTime);

		#else

		if (0 == __frames.length) return 1;
		var nextFrame = __currentFrame + (__lastFrameScriptEval == __currentFrame ? 1 : 0);
		if (nextFrame > __frames.length) nextFrame = 1;

		#end

		return nextFrame;

	}


	private function __resolveFrameReference (frame:Dynamic):Int {

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

		return a.frameObject.depth - b.frameObject.depth;

	}


	private override function __stopAllMovieClips ():Void {

		super.__stopAllMovieClips ();
		stop ();

	}


	private function __updateDisplayObject (displayObject:DisplayObject, frameObject:FrameObject):Void {

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

		if (frameObject.visible != null) {

			displayObject.visible = frameObject.visible;

		}

		if (frameObject.blendMode != null) {

			displayObject.blendMode = frameObject.blendMode;

		}

		if (frameObject.cacheAsBitmap != null) {

			//displayObject.cacheAsBitmap = frameObject.cacheAsBitmap;

		}

		#if (openfl_dynamic || openfl_dynamic_fields_only)
		Reflect.setField (this, displayObject.name, displayObject);
		#end

	}


	private function __updateFrameLabel ():Void {

		__currentFrameLabel = __symbol.frames[__currentFrame - 1].label;

		// either on a frame with a label
		if (__currentFrameLabel != null) {

			__currentLabel = __currentFrameLabel;

			// or occurring after a frame with a label
			// (eg. last label applies to this frame as its a range between last and next label)
			// i don't think that's actually true in flash but its used here for whatever reason
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

private class FrameSymbolInstance {

	public var displayObject:DisplayObject;
	public var frameObject:FrameObject;
	public var nextFrameSymbolInstance: FrameSymbolInstance;
	public var prevFrameSymbolInstance: FrameSymbolInstance;
	public var childIndex: Int;

	public function isManualChild(): Bool {
		return null == frameObject;
	}

	public function new (displayObject:DisplayObject, frameObject:FrameObject) {

		this.displayObject = displayObject;
		this.frameObject = frameObject;

	}

}