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
import openfl._internal.utils.FastIteratingIntMap;
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
@:access(openfl._internal.timeline.FrameObjectType)

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

	private var __cachedChildrenFrameSymbolInstacesDisplayObjects:Array<DisplayObject>;
	private var __cachedManuallyAddedDisplayObjects:Array<DisplayObject>;
	private var __activeInstances:Array<FrameSymbolInstance>;
	private var __activeInstancesByFrameObjectID:FastIteratingIntMap<FrameSymbolInstance>;
	private var __lastInstancesByDepth:FastIteratingIntMap<FrameSymbolInstance>;
	private var __currentFrame:Int;
	private var __currentFrameLabel:String;
	private var __currentLabel:String;
	private var __currentLabels:Array<FrameLabel>;
	private var __frameScripts:FastIteratingIntMap<Void->Void>;
	private var __frameTime:Int;
	private var __lastFrameScriptEval:Int;
	private var __lastFrameUpdate:Int;
	private var __playing:Bool;
	private var __swf:SWFLite;
	private var __symbol:SpriteSymbol;
	private var __timeElapsed:Int;
	private var __totalFrames:Int;
	private var __isInstanceFieldsSetup:Bool;
	
	
	#if openfljs
	private static function __init__ () {
		
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

		__cachedManuallyAddedDisplayObjects = new Array();
		__cachedChildrenFrameSymbolInstacesDisplayObjects = new Array();
		
		__currentFrame = 1;
		__currentLabels = [];
		__totalFrames = 0;
		__isInstanceFieldsSetup = false;
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
				
				__frameScripts = new FastIteratingIntMap ();
				
			}
			
			__frameScripts.set (frame, method);
			
		} else if (__frameScripts != null) {
			
			__frameScripts.remove (frame);
			
		}
		
	}


	private override function __initializeSelf() : Void {
		if (__lastFrameUpdate == -2){
			__enterFrame(0);
		}
	}


	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		play ();
		__goto (__resolveFrameReference (frame));
		
	}
	
	
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		stop ();
		__goto (__resolveFrameReference (frame));
		
	}
	
	
	public function nextFrame ():Void {

		__goto (__currentFrame + 1);
		stop ();
		
	}
	
	
	public function play ():Void {
		
		if (__symbol == null || __playing || __totalFrames < 2) return;
		
		__playing = true;
		
		#if (!swflite_parent_fps && !swf_parent_fps)
		__frameTime = Std.int (1000 / __swf.frameRate);
		__timeElapsed = 0;
		#end
		
	}
	
	
	public function prevFrame ():Void {
		
		stop ();
		__goto (__currentFrame - 1);
		
	}
	
	
	public function stop ():Void {
		
		__playing = false;
		
	}



	private override function __addChildAtInternal(child:DisplayObject, index:Int):DisplayObject{
		var addedChild : DisplayObject = super.__addChildAtInternal(child, index);

		__cacheChild(addedChild);

		return addedChild;
	}


	public function __cacheChild(child:DisplayObject){
		if(child != null) {
			var cached : Bool = false;
			if(__cachedChildrenFrameSymbolInstacesDisplayObjects.indexOf(child) >= 0 || __cachedManuallyAddedDisplayObjects.indexOf(child) >= 0) {
				cached = true;
			}
			else if(__activeInstances != null) {
				for (instance in __activeInstances) {
					if (instance.displayObject == child) {
						cached = true;
						__cachedChildrenFrameSymbolInstacesDisplayObjects.push(child);
						break;
					}
				}
			}
			if(!cached){
				__cachedManuallyAddedDisplayObjects.push(child);
				//rebuild current children and apply masks now with new dynamically added object.
				if(__symbol != null) {
					__lastFrameUpdate = __currentFrame-1;
					__updateFrameObjectsAndChildren();
				}
			}
		}
	}


	public override function removeChild (child:DisplayObject):DisplayObject {
		if (child != null && child.parent == this) {
			__cachedManuallyAddedDisplayObjects.remove(child);
		}
		return super.removeChild(child);
	}

	public override function __enterFrame (deltaTime:Int):Void {

		if (__symbol == null) {
			super.__enterFrame (deltaTime);
			return;
		}
		var nextFrame : Int = -1;
		var shouldRunTotalFramesScripts : Bool = false;
		var startFrame : Int = __currentFrame;
		if(__playing){

			nextFrame = __getNextFrame (deltaTime);
		}
		else
		{
			// stopped, just build frameobjects (and run script if any) at the current frame
			nextFrame = __currentFrame;
		}

		var updateToFrame : Int = startFrame;

		var runInitScript : Bool = false;
		if (__lastFrameUpdate == -2){
			runInitScript = true;
		}
		while(updateToFrame != nextFrame || __lastFrameUpdate < 0) {
			var shouldRunScriptAtFrame = false;
			if(__playing){
				if (__frameScripts != null){
					// if we looped around
					if (nextFrame < updateToFrame) {
						// scan for any framescripts on keyframes to run after our current starting point (stored in updateToFrame) before we restart at the beginning
						for(key in __frameScripts.keys()) {
							if (key > updateToFrame){
								// found one, let's run this framescript
								shouldRunScriptAtFrame = true;
								updateToFrame = key;
								break;
							}
						}
						if (!shouldRunScriptAtFrame) {
							// there were none, so restart at the beginning (at 0 just in case nextFrame is 1)
							updateToFrame = 0;
						}
					}
					if (!shouldRunScriptAtFrame) {
						// we did not loop or we restarted at the beginning, so find the next keyframe
						for(key in __frameScripts.keys()) {
							if (key > updateToFrame && key <= nextFrame){
								// found one, let's run this framescript
								shouldRunScriptAtFrame = true;
								updateToFrame = key;
								break;
							}
						}
					}
				}
			} else if (runInitScript)
			{
				shouldRunScriptAtFrame = true;
				updateToFrame = 1;
			}

			if (!shouldRunScriptAtFrame) {
				// no keyframes to run, so we're done, jump to the end
				updateToFrame = nextFrame;
			}

			__currentFrame = updateToFrame;

			__updateFrameObjectsAndChildren();

			var runScriptOverride = false;
			if(runInitScript){
				runInitScript = false;
				__setupInstanceFields();
				if(__frameScripts != null && updateToFrame == 1 && __frameScripts.exists(1))	{
					runScriptOverride = true;
				}
			}

			if ((shouldRunScriptAtFrame && __playing) || runScriptOverride) {

				var currentFrameBeforeScript = __currentFrame;
				var script = __frameScripts.get (updateToFrame);
				script ();
				if (__currentFrame != currentFrameBeforeScript || !__playing) {

					super.__enterFrame (deltaTime);
					return;

				}
			}
		}
		if(runInitScript){
			runInitScript = false;
			__setupInstanceFields();
		}
		super.__enterFrame (deltaTime);
	}

	private function __updateFrameObjectsAndChildren(isGoTo : Bool = false)	{

		if (__currentFrame == __lastFrameUpdate)
			return;

		__updateFrameLabel ();

		var loopedSinceLastFrameUpdate:Bool = ( __lastFrameUpdate > __currentFrame );

		var currentInstancesbyDepth : FastIteratingIntMap<FrameSymbolInstance> = null;//<depth, FrameSymbolInstance>  frameObject.id should be the same as FrameSymbolInstance.initFrameObjectID

		// start from scratch if we have looped around or starting from beginning.
		// Otherwise we need to keep the objects on the timeline active (when we are doing a goto either backward or forward, or just playing sequentially)
		if(__lastInstancesByDepth == null || (!isGoTo && (loopedSinceLastFrameUpdate || __lastFrameUpdate < 0))) {
			currentInstancesbyDepth = new FastIteratingIntMap<FrameSymbolInstance>();
		}
		else {
			currentInstancesbyDepth = __lastInstancesByDepth;
		}

		var frame:Int;
		var frameData:Frame;
		var instance:FrameSymbolInstance;

		//main loop to get updated frame object information and apply it to display objects.
		var updateFrameStart:Int = (loopedSinceLastFrameUpdate || __lastFrameUpdate < 0)? 0 : __lastFrameUpdate;
		for (i in updateFrameStart...__currentFrame) {


			frame = i + 1;
			frameData = __symbol.frames[i];

			if (frameData.objects == null) continue;

			var lastFrameObjectDepths : Array<Int> = new Array();

			//Collect all depths present on the last frame
			if( currentInstancesbyDepth.iterator().hasNext() ) {
				for(frameObjectDepth in currentInstancesbyDepth.keys()) {
					lastFrameObjectDepths.push(frameObjectDepth);
				}
			}
			//anything that is on this frame we don't need to delete, so remove from the list
			if( lastFrameObjectDepths.iterator().hasNext() ) {
				for (frameObject in frameData.objects) {
					lastFrameObjectDepths.remove(frameObject.depth);
				}
			}
			//delete anything that is left (means that depth was only present on the last frame)
			for (depth in lastFrameObjectDepths) {
				currentInstancesbyDepth.remove(depth);
			}

			for (frameObject in frameData.objects) {

				// if is a new character sequentially in the timeline and has move information we check the old object
				// at that depth after creating the new one and any information not applied by the frameObject is applied by the old object at that depth
				//--
				// if both hasChracter and hasMove are false then we just need to create a new character and
				// add it at the depth and remove the previous object at that depth if it is not the same object already being use (frameObjectID)
				// this should only happen when doing a goto
				if(frameObject.hasCharacter == frameObject.hasMove) {

					var oldInstance : FrameSymbolInstance = null;
					if(currentInstancesbyDepth.exists(frameObject.depth)) {

						oldInstance = currentInstancesbyDepth.get(frameObject.depth);
						currentInstancesbyDepth.remove(frameObject.depth);
					}

					instance = __activeInstancesByFrameObjectID.get (frameObject.id);

					if (instance != null) {

						currentInstancesbyDepth.set(frameObject.depth, instance);
						if(!frameObject.hasCharacter && !frameObject.hasMove && oldInstance != null && instance.initFrameObjectID == oldInstance.initFrameObjectID) {
							continue;//this object is already on the timeline and being used, no need to update
						}
						__updateDisplayObject (instance.displayObject, frameObject);

						if(oldInstance != null && frameObject.hasMove) {
							if(frameObject.name == null) {
								instance.displayObject.name = oldInstance.displayObject.name;
							}
							if(frameObject.matrix == null) {
								instance.displayObject.transform.matrix = oldInstance.displayObject.transform.matrix;
							}
							if(frameObject.colorTransform == null) {
								instance.displayObject.transform.colorTransform = oldInstance.displayObject.transform.colorTransform;
							}
							if(frameObject.filters == null) {
								instance.displayObject.filters = oldInstance.displayObject.filters;
							}
							if (frameObject.visible == null) {
								instance.displayObject.visible = oldInstance.displayObject.visible;
							}
							if (frameObject.blendMode == null) {
								instance.displayObject.blendMode = oldInstance.displayObject.blendMode;
							}
							if (frameObject.cacheAsBitmap == null) {
								//instance.displayObject.cacheAsBitmap = oldInstance.displayObject.cacheAsBitmap;
							}
						}

					}
				} else {

					//if hasMove we should be modifying the current object, unless we are doing a goto and the object doesn't exist
					instance = null;
					if(frameObject.hasMove) {
						instance = currentInstancesbyDepth.get(frameObject.depth);
						if(instance != null && instance.initFrameObjectID != frameObject.id) {//throw away changes made by scripts if it isn't the same id
							instance = null;
						}
					}
					//if frameObject.hasCharacter or we are doing a goto and the character doesn't exist yet, we need to make it
					if (instance == null) {
						instance = __activeInstancesByFrameObjectID.get (frameObject.id);
						if (instance != null) {
							currentInstancesbyDepth.set(frameObject.depth, instance);
						}
					}
					if (instance != null) {
						__updateDisplayObject (instance.displayObject, frameObject);
					}

				}

			}

		}

		// TODO: Less garbage?

		var currentInstances = new Array<FrameSymbolInstance> ();
		var currentMasks = new Array<FrameSymbolInstance> ();

		//separate out masks and make array of everything that should be displayed
		for (instance in currentInstancesbyDepth) {

			if (currentInstances.indexOf (instance) == -1) {

				if (instance.clipDepth > 0) {

					currentMasks.push (instance);
					currentInstances.push (instance);

				} else {

					currentInstances.push (instance);

				}

			}

		}

		__lastInstancesByDepth = currentInstancesbyDepth;

		currentInstances.sort (__sortDepths);

		var existingChild:DisplayObject;
		var targetDepth:Int;
		var targetChild:DisplayObject;
		var child:DisplayObject;
		var maskApplied:Bool;

		var length:Int = currentInstances.length;
		var currentInstancesIndex = 0;
		var childrenIndex = 0;

		// first remove anything that doesn't exist now
		while (childrenIndex < __children.length) {
			child = __children[childrenIndex];

			if(child != null){
				if(__cachedManuallyAddedDisplayObjects.indexOf(child) >= 0){
					//keep manually added child where it is at
				}
				else {
					var shouldRemove = true;
					for(instance in currentInstances){
						if(child == instance.displayObject){
							shouldRemove = false;
							break;
						}
					}
					if(shouldRemove && child != null){
						removeChild(child);
						if( !loopedSinceLastFrameUpdate ) {
							__children.insert(childrenIndex, null);//insert placeholder null
						}
					}
				}
			}
			childrenIndex++;
		}

		currentInstancesIndex = 0;
		childrenIndex = 0;

		var lastDepth = 0;
		// then leave the manually added dynamic objects where they are, while adding anything new from the frame
		while (currentInstancesIndex < length) {

			existingChild = childrenIndex >= __children.length ? null : __children[childrenIndex];
			instance = currentInstances[currentInstancesIndex];

			targetDepth = lastDepth = instance.depth;
			targetChild = instance.displayObject;

			if (existingChild != targetChild) {
				if(existingChild != null && __cachedManuallyAddedDisplayObjects.indexOf(existingChild) >= 0){ //keep manually added child where it is at
					currentInstancesIndex--;
					child = existingChild;
				}
				else{
					child = targetChild;
					if(existingChild == null && childrenIndex < __children.length)
					{
						__children.splice(childrenIndex, 1);//remove placeholder null
					}
					__addChildAtInternal (targetChild, childrenIndex); //add child at will remove another instance of the same object, so we know it is in the right spot and not duplicated
				}

			} else {

				child = existingChild;

			}

			if(child != targetChild || (child == targetChild && instance.clipDepth <= 0)) { //dont apply masks to masks
				__applyMask(currentMasks, targetDepth, child);
			}

			childrenIndex++;
			currentInstancesIndex++;
		}
		//if any dynamic objects at the end of the __children array check to see if they need masks applied
		while(childrenIndex < __children.length) {
			lastDepth++;
			child = __children[childrenIndex++];
			if(child != null) {
				__applyMask(currentMasks, lastDepth, child);
			}
		}
		//remove any left over null children
		childrenIndex = 0;
		while(childrenIndex < __children.length){  // rely on haxe to javascript not caching length variable in while loop
			if(__children[childrenIndex] == null) {
				__children.splice(childrenIndex,1);
			}
			else {
				childrenIndex++;
			}
		}

		__lastFrameUpdate = __currentFrame;
	}

	private function __applyMask(currentMasks : Array<FrameSymbolInstance>, targetDepth : Int, child : DisplayObject):Void {
		var maskApplied:Bool = false;
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


	@:access(openfl._internal.swf.SWFLiteLibrary.rootPath)
	private function __fromSymbol (swf:SWFLite, symbol:SpriteSymbol):Void {

		if (__activeInstancesByFrameObjectID != null) return;

		__swf = swf;
		__symbol = symbol;

		__activeInstances = [];
		__activeInstancesByFrameObjectID = new FastIteratingIntMap<FrameSymbolInstance> ();
		__currentFrame = 1;
		__lastFrameUpdate = -2;
		__totalFrames = __symbol.frames.length;

		var frame:Int;
		var frameData:Frame;

		#if hscript
		var parser = null;
		#end

		for (i in 0...__symbol.frames.length) {

			frame = i + 1;
			frameData = __symbol.frames[i];

			var labelSingle : String = frameData.label;
			var addLabel : Bool = (labelSingle != null);
			if (frameData.labels != null) {

				for (label in frameData.labels) {

					addLabel = addLabel && label != labelSingle;
					__currentLabels.push (new FrameLabel (label, i + 1));

				}

			}

			if (addLabel) {

				__currentLabels.push (new FrameLabel (labelSingle, i + 1));

			}

			if (frameData.script != null) {

				if (__frameScripts == null) {

					__frameScripts = new FastIteratingIntMap<Void->Void> ();

				}

				__frameScripts.set (frame, frameData.script);

			} else if (frameData.scriptSource != null) {

				if (__frameScripts == null) {

					__frameScripts = new FastIteratingIntMap<Void->Void> ();

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
								"swf: "+ this.__swf.library.rootPath +"\n" +
								"symbol path: "+ name.join('.') +"\n" +
								e + "\n" +
								haxe.CallStack.exceptionStack ().map (function (a) { return untyped a[2]; }).join ("\n") + "\n" +
								e.stack + "\n" + untyped script.toString ());

						}

					}

					__frameScripts.set (frame, wrapper);

					#end

				} catch (e:Dynamic) {

					var p: DisplayObjectContainer = this;
					var name: Array<String> = new Array();
					do {
						name.push(p.__name);
					} while (null != (p = p.parent));
					name.reverse();
					Log.warn ("Unable to evaluate frame script source\n" +
						"swf: "+ this.__swf.library.rootPath +"\n" +
						"symbol path: "+ name.join('.') +"\n" +
						"symbol: "+ (__symbol.className == null ? "null " : "\"" + __symbol.className + "\"") + "\n" +
						"frame: " + frame + "\n" +
						frameData.scriptSource);

				}

			}

		}

		var frame:Int;
		var frameData:Frame;
		var instance:FrameSymbolInstance;
		var duplicate:Bool;
		var symbol:SWFSymbol;
		var displayObject:DisplayObject;
		var lastObjectToHavePlacementData:FrameObject = null;

		// TODO: Create later?

		for (i in 0...__totalFrames) {

			frame = i + 1;
			frameData = __symbol.frames[i];

			if (frameData.objects == null) continue;

			for (frameObject in frameData.objects) {

				if (__activeInstancesByFrameObjectID.exists (frameObject.id)) {

					continue;

				} else {

					instance = null;
					duplicate = false;

					if(frameData.objects.length <= 2)	//for create and destroy
					{
						if(frameObject.name != null || frameObject.matrix != null || frameObject.colorTransform != null || frameObject.filters != null) {
							lastObjectToHavePlacementData = frameObject.lastFrameObjectWithPlacementData = frameObject;
						}
						else if(lastObjectToHavePlacementData != null)
							frameObject.lastFrameObjectWithPlacementData = lastObjectToHavePlacementData;
					}

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
							if(frameObject.clipDepth > 0) {
								displayObject.isTimelineMask = true;
							}
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
			}

		}

		if (__totalFrames > 1) {

			play ();

		}

		__updateFrameObjectsAndChildren();//frame scripts are not called here because they get attached after the constructor is completed.
		//but this call is still needed to initialize the frame objects/children so that dynamic fields refer to the right object in the event there are multiple of the same name.

		__currentFrame = 1;
		__lastFrameUpdate = -2;
	}

	private function __setupInstanceFields() {
		#if !openfl_dynamic
		if(!__isInstanceFieldsSetup){
			__isInstanceFieldsSetup = true;
			for (field in Type.getInstanceFields (Type.getClass (this))) {

				for (child in __children) {

					if (child.name == field) {

						Reflect.setField (this, field, child);

					}

				}
			}
		}
		#end
	}
	
	
	private function __getNextFrame (deltaTime:Int):Int {
		
		#if (!swflite_parent_fps && !swf_parent_fps)
		
		__timeElapsed += deltaTime;
		var nextFrame = __currentFrame < 0 ? 0 : __currentFrame + Math.floor (__timeElapsed / __frameTime);
		if (nextFrame < 1) nextFrame = 1;
		if (nextFrame > __totalFrames) nextFrame = Math.floor ((nextFrame - 1) % __totalFrames) + 1;
		__timeElapsed = (__timeElapsed % __frameTime);
		
		#else
		
		var nextFrame = __currentFrame + 1;
		if (nextFrame > __totalFrames) nextFrame = 1;
		
		#end
		
		return nextFrame;
		
	}
	
	
	private function __goto (frame:Int) {
		
		if (__symbol == null) return;
		
		if (frame < 1) frame = 1;
		else if (frame > __totalFrames) frame = __totalFrames;

		//if not initialized yet run enterFrame
		if(__lastFrameUpdate == -2)
		{
			__enterFrame(0);
		}

		if(__currentFrame != frame)
		{
			__currentFrame = frame;
			__lastFrameUpdate = frame-1;
			//updating objects only on target frame (__lastFrameUpdate should be one before just to get into the loop)
			__updateFrameObjectsAndChildren(true);

			//check if there is a framescript and run it for this frame
			if(__frameScripts != null && __frameScripts.exists(frame)) {
				var script = __frameScripts.get (frame);
				script ();
			}
		}
		//make sure new children are updated appropriately
		super.__enterFrame (0);
	}

	@:access(openfl._internal.swf.SWFLiteLibrary.rootPath)
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

			// alternate error handling that may be useful for some projects with many strange swfs
//			var p: DisplayObjectContainer = this;
//			var name: Array<String> = new Array();
//			do {
//				name.push(p.__name);
//			} while (null != (p = p.parent));
//			name.reverse();
//			Log.warn ("Error #2109: Frame label " + label + " not found in scene.\n" +
//				"swf: "+ this.__swf.library.rootPath +"\n" +
//				"symbol path: "+ name.join('.') +"\n" +
//				"symbol: "+ (__symbol.className == null ? "null " : "\"" + __symbol.className + "\"") + "\n" +
//				"frame: " + frame);
//			return 1;
			
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
	
	
	private function __updateDisplayObject (displayObject:DisplayObject, frameObject:FrameObject):Void {
		
		if (displayObject == null) return;

		// check for lastFrameObjectWithPlacementData single timelime object behavior
		var currFrameObject : FrameObject = frameObject.lastFrameObjectWithPlacementData != null ? frameObject.lastFrameObjectWithPlacementData : frameObject;

		if (currFrameObject.name != null) {

			displayObject.name = currFrameObject.name;

		}

		if (currFrameObject.matrix != null) {

			displayObject.transform.matrix = currFrameObject.matrix;

		}

		if (currFrameObject.colorTransform != null) {

			displayObject.transform.colorTransform = currFrameObject.colorTransform;

		}

		if (currFrameObject.filters != null) {

			var filters:Array<BitmapFilter> = [];

			for (filter in currFrameObject.filters) {
				
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

		if (currFrameObject.visible != null) {

			displayObject.visible = currFrameObject.visible;

		}

		if (currFrameObject.blendMode != null) {

			displayObject.blendMode = currFrameObject.blendMode;

		}

		if (currFrameObject.cacheAsBitmap != null) {

			//displayObject.cacheAsBitmap = currFrameObject.cacheAsBitmap;
			
		}
		
		#if (openfl_dynamic || openfl_dynamic_fields_only)
		Reflect.setField (this, displayObject.name, displayObject);
		#end
		
	}
	
	
	private function __updateFrameLabel ():Void {

		// NOTE: in flash, the first label on the timeline is the current one
		var labels : Array<String> = __symbol.frames[__currentFrame - 1].labels;
		__currentFrameLabel = labels != null && labels.length > 0 ? labels[0] : __symbol.frames[__currentFrame - 1].label;
		
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


	public override function cleanGraphics ():Void {
		super.cleanGraphics();

		for (child in __cachedChildrenFrameSymbolInstacesDisplayObjects) {
			child.cleanGraphics();
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

	private override function get_width():Float
	{
		if(__swf != null && __swf.frameSizeMaxPixel != null && this.__symbol == __swf.root)
		{
			var thisWidth = super.width;
			var frameSizeWidth = __swf.frameSizeMaxPixel.x - __swf.frameSizeMinPixel.x;
			if(frameSizeWidth > thisWidth)
				return frameSizeWidth;
			else
				return thisWidth;
		}
		else
			return super.width;
	}

	private override function get_height():Float
	{
		if(__swf != null && __swf.frameSizeMaxPixel != null && this.__symbol == __swf.root)
		{
			var thisHeight = super.height;
			var frameSizeHeight = __swf.frameSizeMaxPixel.y - __swf.frameSizeMinPixel.y;
			if(frameSizeHeight > thisHeight)
				return frameSizeHeight;
			else
				return thisHeight;
		}
		else
			return super.height;
	}
	
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
