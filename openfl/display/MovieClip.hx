package openfl.display;

import lime.utils.Log;
import openfl.errors.ArgumentError;
import openfl._internal.symbols.SWFSymbol;
import openfl._internal.timeline.Frame;
import haxe.CallStack.StackItem;
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

	private var __playing:Bool;

	/**
	 * Do not set this directly.
	 * Use __setCurrentFrameByOneIndex();
	 */
	private var __currentFrameZeroIndexed:Int;

	/**
	 * Do not set this directly.
	 * Use __setCurrentFrameByOneIndex();
	 */
	private var __currentFrameOneIndexed:Int;

	private var __lastFrameScriptEvaluatedOneIndexed:Int;
	private var __lastFrameChildrenArrangedOneIndexed:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>; // zero-indexed, but FrameLabel.frame is one-indexed
	private var __frameScripts:Map<Int, Void->Void>; // zero-indexed
	private var __frameTime:Int;
	private var __swf:SWFLite;
	private var __symbol:SpriteSymbol;
	private var __timeElapsed:Int;
	private var __totalFrames:Int;
	private var __indexFrameObjectEntryById: Map<Int,FrameObjectEntry>;


	public function new () {

		super ();

		__setCurrentFrameByOneIndex(1);
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

	/**
	 * Used to both CREATE new and UPDATE existing DisplayObject children.
	 * Applies the various property changes that may occur between frames.
	 */
	private function __updateDisplayObject(displayObject:DisplayObject, frameObject:FrameObject):Void {
		if (null == displayObject) return;

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

		// TODO: need to check for null. SWFLiteExporter needs to provide a null instead of assuming true.
		//displayObject.visible = frameObject.visible;

		#if (openfl_dynamic || openfl_dynamic_fields_only)
		// convenience feature:
		// attach properties to parent, one per child,
		// so that individual children are easily accessible from the parent
		// by the child instance name at runtime
		Reflect.setField (this, displayObject.name, displayObject);
		#end
	}


	public function addFrameScript (index:Int, method:Void->Void):Void {

		if (method != null) {

			if (__frameScripts == null) {

				__frameScripts = new Map ();

			}

			__frameScripts.set (index, method);

		}
		else if (__frameScripts != null) {

			__frameScripts.remove (index);

		}

	}


	private function __goto (frameOneIndexed: Int) {

		if (null == __symbol) return;

		__setCurrentFrameByOneIndex (__getFrameByOneIndex (frameOneIndexed));

		__enterFrame (0);

	}


	/**
	 * Starts playing the SWF file at the specified frame.
	 */
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {

		play ();

		__goto (__getFrameByOneIndexOrFrameLabel (frame));

	}


	/**
	 * Brings the playhead to the specified frame of the movie clip and stops it there.
	 */
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {

		stop ();

		__goto (__getFrameByOneIndexOrFrameLabel (frame));

	}


	/**
	 * Sends the playhead to the next frame and stops it.
	 */
	public function nextFrame ():Void {

		stop ();

		__goto (__currentFrameOneIndexed + 1); // forward one frame

	}


	/**
	 * Sends the playhead to the previous frame and stops it.
	 */
	public function prevFrame ():Void {

		stop ();

		__goto (__currentFrameOneIndexed - 1); // rewind one frame

	}


	/**
	 * Moves the playhead in the timeline of the movie clip.
	 */
	public function play ():Void {

		if (null == __symbol || __playing || __totalFrames < 2) return;

		__playing = true;

		#if (!swflite_parent_fps && !swf_parent_fps)
		__frameTime = Std.int (1000 / __swf.frameRate);
		__timeElapsed = 0;
		#end

	}


	/**
	 * Stops the playhead in the movie clip.
	 */
	public function stop ():Void {

		if (null == __symbol || !__playing) return;

		__playing = false;

	}


	private function __setCurrentFrameByOneIndex(oneIndex: Int): Void
	{
		__currentFrameZeroIndexed = (__currentFrameOneIndexed = oneIndex) - 1;
	}


	private function __getFrameByOneIndexOrFrameLabel(frame:Dynamic):Int
	{
		if (Std.is (frame, Int)) {

			return __getFrameByOneIndex(cast frame);

		}
		else if (Std.is (frame, String)) {

			return __getFrameByFrameLabel(cast frame);

		}
		else {
			throw "Invalid type for frame "+ Type.getClassName(frame);
		}
	}


	/**
	 * Normalize a one-index frame index integer within frame count bounds.
	 */
	private function __getFrameByOneIndex (index:Int):Int {

		if (index < 1) {

			return 1;

		}

		// TRIVIA: if you call .gotoAndPlay(333) on a 40-frame Flash animation,
		// the play head will go to frame 1, not 40, not (333 % 40 = 13).
		// so this is currently not exactly what Flash would do
		else if (index >= __totalFrames) {

			return Math.floor ((index - 1) % __totalFrames) + 1;

		}
		else {

			return index;

		}

	}


	private function __getFrameByFrameLabel (label:String):Int {

		for (frameLabel in __currentLabels) {

			if (frameLabel.name == label) {

				return frameLabel.frame;

			}

		}

		// TRIVIA: if you pass a frame label that isn't defined
		// Flash will throw an exception.
		throw new ArgumentError("Error #2109: Frame label "+ label +" not found in scene.");

	}


	/**
	 * Called by Stage immediately before Stage.__renderer.render();
	 * Advances currentFrame with playback time.
	 * Executes frameScripts inbetween last and current frame when time has elapsed.
	 * Adds, removes, and updates the list of children belonging to this MovieClip
	 * so only what is supposed to be visible in the current frame
	 * will be drawn by DisplayObject.__render() on a future loop.
	 * Important to call play() operation BEFORE calling this method.
	 *
	 * This function's primary purpose is to arrange the DisplayObject.__children
	 * :Array<DisplayObject> that it inherits. It does not actually call any
	 * draw functions. That happens later. All this function really does is add,
	 * remove, and update its DisplayObject children list.
	 */
	public override function __enterFrame (deltaTime:Int):Void {

		// must be initialized and playing to animate this MovieClip
		// NOTICE: children may still be playing even if this is stopped as their parent
		if (null != __symbol && __playing) {

			// calculate the number of frames we should advance based on
			// how much time has elapsed since last invocation
			#if (swflite_parent_fps || swf_parent_fps)
			var incrementFramesBy:Int = (__lastFrameScriptEvaluatedOneIndexed == __currentFrameOneIndexed) ? 1 : 0;
			#else
			__timeElapsed += deltaTime;
			var incrementFramesBy:Int = Math.floor (__timeElapsed / __frameTime);
			__timeElapsed = (__timeElapsed % __frameTime);
			#end
			// normalize; target frame must be within bounds; loops back to 1
			var targetFrameOneIndexed = __getFrameByOneIndex (__currentFrameOneIndexed + incrementFramesBy);

			if (__lastFrameScriptEvaluatedOneIndexed == targetFrameOneIndexed) {

				// no changes since last invocation
				return;

			}

			// if this movieclip has no frame scripts
			if (null == __frameScripts) {

				// apply target frame as current frame immediately;
				// jumping forward, skipping;
				// no point in working on the middle frames
				__setCurrentFrameByOneIndex(targetFrameOneIndexed);

			}
				// otherwise, some frame scripts exist
			else {

				// one thing that is important to observe here about flash playback:
				// say you have a swf with traces on frames 0, 10, 20, 30, and 40.
				// and say you have a button that will call .gotoAndPlay(25) onclick
				// it doesn't matter which frame you are on when you click it,
				// the next frame script that will evaluate is the trace on frame 30;
				// in other words, frame scripts are not cumulative; there is no need
				// to play frames skipped in a rewind or other goto/jump.
				// so if someone does a gotoAndPlay() we just start playing from that
				// location, not the difference between that location and where they
				// were before they invoked gotoAndPlay(). we only play the difference
				// when time has passed and no gotoAndPlay() was invoked.

				// visit each frame index between current frame and target frame
				// inclusive of current frame
				// we start one frame behind so we can increment
				for (currentFrameOneIndexed in __currentFrameOneIndexed...targetFrameOneIndexed+1) {

					// if the current frame has already had its frame script played before
					if (currentFrameOneIndexed == __lastFrameScriptEvaluatedOneIndexed) {

						// skip evaluation
						continue;

					}
					__lastFrameScriptEvaluatedOneIndexed = currentFrameOneIndexed;

					// move ahead frame-by-frame one-at-a-time
					// evaluating each frame script in sequence,
					// also checking if the frame script stopped the animation.
					__setCurrentFrameByOneIndex (__getFrameByOneIndex (currentFrameOneIndexed));

					// verify we have a frame script to execute on this frame
					if (__frameScripts.exists (__currentFrameZeroIndexed)) {

						// get the frame script function
						var fs = __frameScripts.get (__currentFrameZeroIndexed);

							// try to execute frame script in a safe sandbox
							try {
								
#if !js
								fs();
#else
								untyped fs.call(this);
#end

							}
							// handle any errors
							catch (e: Dynamic)
							{

								// with a very detailed trace including various stack traces
								trace("Error evaluating frame script\n " +
									e + "\n" +
									// sometimes this stack is all you have
									haxe.CallStack.exceptionStack().map(function(a){ return untyped a[2]; }).join("\n") +"\n" + 
									// other times this stack is all you have
									e.stack + "\n" +
									untyped fs.toString());

						}

						// if the frame script called .stop() on this movieclip
						// do not advance
						if (!__playing) {
							
							break;
							
						}
						
					}
					
				}

			}
			
		}

		// permit drawing the first frame even if not playing an animation
		if (null != __symbol && __currentFrameOneIndexed != __lastFrameChildrenArrangedOneIndexed) {

			// cache this movieclip's current frame label
			__currentFrameLabel = __symbol.frames[__currentFrameZeroIndexed].label; // convert one-index to zero-index

			// as3 also offers a currentLabel property, which means
			// the the last frame label occurring before the current frame;
			// cache that too
			// NOTE: this compatibility juice is probably not worth the squeeze
			if (__currentFrameLabel != null) {

				// if the frame we're currently on has a label
				// then it is also the currentLabel
				__currentLabel = __currentFrameLabel;

			}
			else {

				// currentLabel may be null
				__currentLabel = null;

				// to find out,
				// we must iterate through all the labels on this movieclip
				// from frame 0 to the ending frame
				// NOTE: may be more optimal to index these
				for (label in __currentLabels) {

					// as long as the frame label occurs before the current frame
					// NOTE: we don't have to check whether they are equal because
					//       that case would have been matched by currentFrameLabel above
					if (label.frame < __currentFrameOneIndexed) { // both are one-indexed

						// then it could be the last one before the current frame
						__currentLabel = label.name;

					}
					else {

						// once we've passed the current frame
						// there is no point in continuing to iterate
						// throughout the rest of the loop;
						// we've found the last label before currentFrame
						break;

					}
				}
			}

			// Flash Player processes all of the tags in a SWF file until a ShowFrame
			// tag is encountered. At this point, the display list is copied to the
			// screen and Flash Player is idle until it is time to process the next
			// frame.
			//
			// The contents of the first frame are the cumulative effect of performing
			// all of the control tag operations before the first ShowFrame tag. The
			// contents of the second frame are the cumulative effect of performing
			// all of the control tag operations from the beginning of the file to
			// the second ShowFrame tag, and so on.

			// compose display list:
			// every frame is cumulative;
			// sum create/update/destroy events from frame 0 up to and including currentFrame
			// to deduce which DisplayObjects are on-screen cumulatively on currentFrame
			var indexActiveFrameObjectEntryById: Map<Int,FrameObjectEntry> = new Map();

			// deliberately declare outside of for...loop; reuse to save gc cycles
			var displayObjectCache:DisplayObjectCache;
			var frameObject:FrameObject;
			var frameObjectEntry:FrameObjectEntry;
			var displayObjectCacheByDisplayListIndex: Array<DisplayObjectCache>;
			var indexActiveFrameMasks: Array<DisplayObjectCache>;
			var existingChild:DisplayObject;
			var targetDepth:Int;
			var targetChild:DisplayObject;
			var child:DisplayObject;
			var maskApplied:Bool;

			for (frameZeroIndexed in 0...__currentFrameOneIndexed) {

				var frame:Frame = __symbol.frames[frameZeroIndexed];

				if (null == frame.objects) continue;
				
				for (frameObject in frame.objects) {

					if (frameObject.type == FrameObjectType.CREATE) {

						frameObjectEntry = __indexFrameObjectEntryById.get (frameObject.id);

						// TODO: find out why this is necessary for HUDAssets
						if (null != frameObjectEntry) {

							displayObjectCache = frameObjectEntry.displayObjectCache;

							// index which FrameObjects are on-screen cumulatively on this frame
							indexActiveFrameObjectEntryById.set (frameObject.id, frameObjectEntry);

							// apply defined attributes for this character/symbol instance
							// TODO: may need a way to reset attributes when loop happens
							//   if they are not explicitly blanked on first frame by data
							__updateDisplayObject (displayObjectCache.displayObject, frameObject);

						}

					}
					else if (frameObject.type == FrameObjectType.UPDATE) {

						frameObjectEntry = indexActiveFrameObjectEntryById.get (frameObject.id);
						
						if (null != frameObjectEntry)
						{
							displayObjectCache = frameObjectEntry.displayObjectCache;

							// TODO: find out why this is necessary for HUDAssets
							if (null != displayObjectCache && null != displayObjectCache.displayObject) {

								// apply modified attributes for this character/symbol instance
								__updateDisplayObject(displayObjectCache.displayObject, frameObject);

							}
							
						}

					}
					else if (frameObject.type == FrameObjectType.DESTROY) {

						// The character at the specified Depth is removed.

						indexActiveFrameObjectEntryById.remove (frameObject.id);

					}

				}

			}

			// flatten and map the active display list depths
			// into an ordered, indexed, sequential range
			displayObjectCacheByDisplayListIndex = new Array();
			indexActiveFrameMasks = new Array();
			for (frameObjectEntry in indexActiveFrameObjectEntryById) {
				displayObjectCache = frameObjectEntry.displayObjectCache;

				// check whether this frame contains a mask
				if (displayObjectCache.clipDepth > 0) {

					// index it for later processing once displaylist
					// is complete and ordered
					indexActiveFrameMasks.push(displayObjectCache);

					// do not add this frameObject to the display list;
					// masks are not rendered until later
					continue;

				}

				// enqueue displayObjectCache with depth property to display list
				displayObjectCacheByDisplayListIndex.push(displayObjectCache);
			}

			// sort display list by depth value
			displayObjectCacheByDisplayListIndex.sort (__sortDepths);

			//trace("__enterFrame() frame#"
			//	+ __currentFrameOneIndexed
			//	+", DisplayList "
			//	+displayObjectCacheByDisplayListIndex.map(function(displayObjectCache) {
			//		return "(CharacterID: "+ displayObjectCache.characterId +", Depth: "+ displayObjectCache.depth +")"; })
			//		.join(", "));

			// update children, preserving DisplayObject instances between loops
			// only applying the differences
			for (childIndex in 0...displayObjectCacheByDisplayListIndex.length) {

				existingChild = __children[childIndex];
				displayObjectCache = displayObjectCacheByDisplayListIndex[childIndex];
				targetDepth = displayObjectCache.depth;
				targetChild = displayObjectCache.displayObject;

				// if existing child is not the target child we want
				if (existingChild != targetChild) {

					child = targetChild;

					// NOTICE: will move existing child if added twice in new location
					// NOTICE: important to use this method because it does some
					//   child initialization for us, such as setting its .parent
					this.addChildAt(targetChild, childIndex);

				}
				else {

					child = __children[childIndex];

				}

				// Flash supports a special kind of object in the display list called a
				// clipping layer. A character placed as a clipping layer is not
				// displayed; rather it clips (or masks) the characters placed above it.

				// The ClipDepth field in PlaceObject2 specifies the top-most depth that
				// the clipping layer masks. For example, if a shape was placed at
				// depth 1 with a ClipDepth of 4, all depths above 1, up to and
				// including depth 4, are masked by the shape placed at depth 1.
				// Characters placed at depths above 4 are not masked.

				// verify frame contains at least one mask
				maskApplied = false;
				for (maskDisplayObjectCache in indexActiveFrameMasks) {

					// mask applies to maskDisplayObjectCache.depth up to and including clipDepth
					if (targetDepth > maskDisplayObjectCache.depth && targetDepth <= maskDisplayObjectCache.clipDepth) {

						// apply mask
						child.mask = maskDisplayObjectCache.displayObject;

						// only one mask per DisplayObject
						maskApplied = true;
						break;

					}

				}

				if (indexActiveFrameMasks.length > 0 && !maskApplied && null != child.mask) {

					// unset mask leftover from previous frame
					child.mask = null;

				}

			}
			// gc unused children slots
			while (__children.length > displayObjectCacheByDisplayListIndex.length) {

				// NOTICE: important to use this method because it does some cleanup
				//   as well as emits some events for us like Event.REMOVED
				removeChild (__children[__children.length - 1]);

			}

			// mark render dirty so our changes will be rasterized
			// to screen by the outside DisplayObject.__render() loop
			//__renderDirty = true;

			// remember which frame last successfully processed
			// to avoid unnecessary/repeat/duplicate cycles in the future
			__lastFrameChildrenArrangedOneIndexed = __currentFrameOneIndexed;
		}

		// visit children; deliberately last
		super.__enterFrame (deltaTime);

	}


	private function __fromSymbol (swf:SWFLite, symbol:SpriteSymbol):Void {

		if (__indexFrameObjectEntryById != null) return;

		__swf = swf;
		__symbol = symbol;

		__lastFrameScriptEvaluatedOneIndexed = -1;
		__lastFrameChildrenArrangedOneIndexed = -1;
		__setCurrentFrameByOneIndex (1);
		__totalFrames = __symbol.frames.length;
		__indexFrameObjectEntryById = new Map();

		var frame;
		
		#if hscript
		var parser = null;
		#end
		
		for (i in 0...__symbol.frames.length) {
			
			frame = __symbol.frames[i];
			
			if (frame.label != null) {
				
				__currentLabels.push (new FrameLabel (frame.label, i + 1));
				
			}
			
			if (frame.script != null) {
				
				if (__frameScripts == null) {
					
					__frameScripts = new Map ();
					
				}
				
				__frameScripts.set (i, frame.script);
				
			} else if (frame.scriptSource != null) {
				
				if (__frameScripts == null) {
					
					__frameScripts = new Map ();
					
				}
				
				try {
					
					#if hscript
						
					if (parser == null) {
						
						parser = new Parser ();
						parser.allowTypes = true;
						
					}
					
					var program = parser.parseString (frame.scriptSource);
					var interp = new Interp ();
					interp.variables.set ("this", this);
					
					var script = function () {
						
						interp.execute (program);
						
					};
					
					__frameScripts.set (i, script);
					
					#elseif js
					
					var script = untyped __js__('eval({0})', "(function(){" + frame.scriptSource + "})");
					var wrapper = function () {
						
						try {
							
							script.call (this);
							
						} catch (e:Dynamic) {
							
							trace ("Error evaluating frame script\n " + e + "\n" + 
								haxe.CallStack.exceptionStack ().map (function (a) { return untyped a[2]; }).join ("\n") + "\n" + 
								e.stack + "\n" + untyped script.toString ());
							
						}
						
					}
					
					__frameScripts.set (i, wrapper);
					
					#end
					
				} catch (e:Dynamic) {
					
					if (__symbol.className != null) {
						
						Log.warn ("Unable to evaluate frame script source for symbol \"" + __symbol.className + "\" frame " + (i + 1) + "\n" + frame.scriptSource);
						
					} else {
						
						Log.warn ("Unable to evaluate frame script source:\n" + frame.scriptSource);
						
					}
					
				}
				
			}
			
		}

		// while Flash will garbage collect unused DisplayObjects during
		// animation playback, exactly how its done is a mystery, and often
		// an annoyance to developers. doing it well means doing it in a way
		// that both the user and the frame scripts cannot tell their object
		// is being cryogenically frozen while they're not looking; not an easy
		// feat considering the performance impact of constructing large
		// DisplayObjects at render time and how gc really works in various
		// target environments.

		// other engines (like CreateJS, currently officially used by Adobe)
		// don't think the juice is worth the squeeze here. even the swf doc
		// advises that objects should be reused, and its not necessary to
		// recreate them between frames.

		// so strategically we've decided to create all children recursively
		// one time during parent construction. this means while this MovieClip
		// instance exists, a reference to each unique DisplayObject is also
		// held in memory, even when it is not actively being drawn on screen,
		// until the parent MovieClip is gc'ed.

		// TODO: store and operate on frameObject.clipDepth

		// we also perform validation one time here instead of on every loop
		var indexCachedFrameObjectEntryById: Map<Int,FrameObjectEntry> = new Map();
		var frameObjectEntry:FrameObjectEntry;
		var displayObjectCache:DisplayObjectCache;
		var frame:Frame;
		var duplicate:DisplayObjectCache;
		var symbol:SWFSymbol;
		var displayObject:DisplayObject;

		for (frameZeroIndexed in 0...__totalFrames) {

			frame = __symbol.frames[frameZeroIndexed];

			if (null == frame.objects) continue;

			for (frameObject in frame.objects) {

				if (frameObject.type == FrameObjectType.CREATE) {
					// A new character (with ID of CharacterId) is placed on the
					// display list at the specified depth.

					// CAUTION: the same characterId can be placed at different
					//   depths in the same display list to represent multiple
					//   symbol instances of the same symbol class.

					duplicate = null;

					// rule: only instantiate once per characterId and depth
					if (__indexFrameObjectEntryById.exists (frameObject.id)) {

						continue;

					}
					else {

						for (frameObjectEntry in __indexFrameObjectEntryById) {

							displayObjectCache = frameObjectEntry.displayObjectCache;

							if (null != displayObjectCache.displayObject) {

								if (displayObjectCache.characterId == frameObject.symbol
									&& displayObjectCache.depth == frameObject.depth)
								{

									duplicate = displayObjectCache;
									break;

								}
							}

						}

					}

					if (null != duplicate) {

						// trace("Multiple CREATE tags for the same characterId and depth are being merged.\n"
						// 	+ "Asset \""+ untyped this.__swf.library.rootPath +"\", "
						// 	+ "MovieClip \""+ this.__name +"\",\n"
						// 	+ "existing: { "
						// 		+ "frame: "+ displayObjectCache.createFrameOneIndexed
						// 		+ ", frameObjectId: "+ displayObjectCache.createFrameObjectId
						// 		+ ", characterId: "+ displayObjectCache.characterId
						// 		+ ", depth: "+ displayObjectCache.depth
						// 	+" },\n"
						// 	+ "new: { "
						// 		+ "frame: "+ (frameZeroIndexed + 1)
						// 		+ ", frameObjectId: "+ frameObject.id
						// 		+ ", characterId: "+ frameObject.symbol
						// 		+ ", depth: "+ frameObject.depth
						// 	+" }");

						displayObjectCache = duplicate;
						displayObject = displayObjectCache.displayObject;

					}
					else {

						// instantiate child's DisplayObject first and only time
						symbol = __swf.symbols.get (frameObject.symbol); // lookup Symbol class

						if (null == symbol) {

							// trace("Unable to CREATE DisplayObject instance; got NULL symbol\n"
							// 	+ "Asset \""+ untyped this.__swf.library.rootPath +"\", "
							// 	+ "MovieClip \""+ this.__name +"\",\n"
							// 	+ "symbol: "+ frameObject.symbol
							// 	+ ", frame: "+ (frameZeroIndexed + 1)
							// 	+ ", frameObjectId: "+ frameObject.id
							// 	+ ", characterId: "+ frameObject.symbol
							// 	+ ", depth: "+ frameObject.depth);

							displayObject = null;

						}
						else {

							displayObject = symbol.__createObject (__swf); // instantiate Symbol

							// TODO: find out why some displayObject instances are null
							if (null == displayObject) {

								// trace("Unable to CREATE DisplayObject instance; got NULL __createObject()\n"
								// 	+ "Asset \""+ untyped this.__swf.library.rootPath +"\", "
								// 	+ "MovieClip \""+ this.__name +"\",\n"
								// 	+ "frame: "+ (frameZeroIndexed + 1)
								// 	+ ", frameObjectId: "+ frameObject.id
								// 	+ ", characterId: "+ frameObject.symbol
								// 	+ ", depth: "+ frameObject.depth);

							}
							else {

								displayObject.parent = this; // set parent initially until it can be rendered normally
								displayObjectCache = new DisplayObjectCache(frameZeroIndexed+1, frameObject.id, frameObject.symbol, frameObject.depth, displayObject, frameObject.clipDepth);

							}

						}

					}

					if (null != displayObject) {

						// index child DisplayObject instance
						// for later [re]use during animation loop
						// and for the lifetime of this MovieClip
						frameObjectEntry = new FrameObjectEntry(frameObject.id, displayObjectCache);
						__indexFrameObjectEntryById.set (frameObject.id, frameObjectEntry);
						// index which FrameObjects are on-screen cumulatively on this frame
						indexCachedFrameObjectEntryById.set (frameObject.id, frameObjectEntry);

						// apply the other fields that define attributes for this character/symbol instance
						__updateDisplayObject(displayObject, frameObject);

					}

				}
				else if (frameObject.type == FrameObjectType.UPDATE) {
					// The character at the specified depth is modified.
					// Because any given depth can have only one character,
					// no CharacterId is required.

					// rule: depth must already exist
					displayObjectCache = null;
					if (indexCachedFrameObjectEntryById.exists (frameObject.id)) {
						frameObjectEntry = indexCachedFrameObjectEntryById.get (frameObject.id);
						displayObjectCache = frameObjectEntry.displayObjectCache;
					}
					if (null == displayObjectCache || null == displayObjectCache.displayObject) {
						// trace("Tried to UPDATE a DisplayObject child that hasn't been CREATED yet. "
						// 	+ "Frame: "+ (frameZeroIndexed + 1)
						// 	+ ", FrameObjectId: "+ frameObject.id
						// 	+ ", Depth: "+ frameObject.depth
						// 	+ ", CharacterId: "+ frameObject.symbol);
					}
					else {

						// apply modified attributes for this character/symbol instance
						__updateDisplayObject(displayObjectCache.displayObject, frameObject);

					}

				}
				else if (frameObject.type == FrameObjectType.DESTROY) {

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
				}
				else {

					throw "Unrecognized FrameObject.type "+ frameObject.type;

				}

			}

		}

		if (__totalFrames > 1) {

			play ();

		}

		__enterFrame (0);

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


	private function __sortDepths (a:DisplayObjectCache, b:DisplayObjectCache):Int {

		return a.depth - b.depth;

	}


	private override function __stopAllMovieClips ():Void {

		super.__stopAllMovieClips ();
		stop ();

	}




	// Getters & Setters




	private function get_currentFrame ():Int { return __currentFrameOneIndexed; }
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

private class DisplayObjectCache {
	public var createFrameOneIndexed: Int;
	public var createFrameObjectId: Int;
	public var characterId: Int;
	public var depth: Int;
	public var clipDepth: Int;
	public var displayObject: DisplayObject;

	public function new (createFrameOneIndexed:Int, createFrameObjectId:Int, characterId:Int, depth:Int, displayObject:DisplayObject, clipDepth:Int) {

		this.createFrameOneIndexed = createFrameOneIndexed;
		this.createFrameObjectId = createFrameObjectId;
		this.characterId = characterId;
		this.depth = depth;
		this.displayObject = displayObject;
		this.clipDepth = clipDepth;

	}
}

/**
 * FrameObject classes have an .id property that is supposed to be unique for
 * every characterId + depth combination. However, there is a bug in the exporter
 * where sometimes you can get two diferent frameObjectIds pointing to the same
 * characterId + depth (symbol instance).
 *
 * We could safely ignore this identifier altogether, if it weren't for the fact
 * that the DELETE property only gives us a frameObjectId to go by.
 *
 * Therefore we need this map to help resolve which unique symbol instance it is
 * referring to, and resolve duplicates when they occur.
 */
private class FrameObjectEntry {
	public var frameObjectId: Int;
	public var displayObjectCache: DisplayObjectCache;

	public function new (frameObjectId:Int, displayObjectCache:DisplayObjectCache) {

		this.frameObjectId = frameObjectId;
		this.displayObjectCache = displayObjectCache;

	}
}