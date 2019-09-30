package openfl._internal.formats.animate;

// TODO: Force keeping of symbols a different way?
import openfl._internal.formats.animate.AnimateBitmapSymbol;
import openfl._internal.formats.animate.AnimateButtonSymbol;
import openfl._internal.formats.animate.AnimateDynamicTextSymbol;
import openfl._internal.formats.animate.AnimateFontSymbol;
import openfl._internal.formats.animate.AnimateFrame;
import openfl._internal.formats.animate.AnimateFrameObject;
import openfl._internal.formats.animate.AnimateFrameObjectType;
import openfl._internal.formats.animate.AnimateLibrary;
import openfl._internal.formats.animate.AnimateShapeSymbol;
import openfl._internal.formats.animate.AnimateSpriteSymbol;
import openfl._internal.formats.animate.AnimateStaticTextSymbol;
import openfl._internal.formats.animate.AnimateSymbol;
import openfl._internal.utils.ITimeline;
import openfl._internal.utils.Log;
import openfl.display.DisplayObject;
import openfl.display.FrameLabel;
import openfl.display.MovieClip;
import openfl.errors.ArgumentError;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.ConvolutionFilter;
import openfl.filters.DisplacementMapFilter;
import openfl.filters.DropShadowFilter;
import openfl.filters.GlowFilter;
import openfl.geom.ColorTransform;
#if hscript
import hscript.Interp;
import hscript.Parser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.formats.animate.AnimateLibrary)
@:access(openfl._internal.formats.animate.AnimateSymbol)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.MovieClip)
@:access(openfl.geom.ColorTransform)
class AnimateTimeline implements ITimeline
{
	#if openfljs
	@:noCompletion private static var __useParentFPS:Bool;
	#else
	@:noCompletion private static inline var __useParentFPS:Bool = #if (swflite_parent_fps || swf_parent_fps) true #else false #end;
	#end
	#if 0
	// Suppress checkstyle warning
	private static var __unusedImport:Array<Class<Dynamic>> = [
		AnimateBitmapSymbol, AnimateButtonSymbol, AnimateDynamicTextSymbol, AnimateFontSymbol, AnimateShapeSymbol, AnimateSpriteSymbol,
		AnimateStaticTextSymbol, AnimateSymbol, BlurFilter, ColorMatrixFilter, ConvolutionFilter, DisplacementMapFilter, DropShadowFilter, GlowFilter
	];
	#end

	// @:noCompletion @:dox(hide) public var trackAsMenu:Bool;
	@:noCompletion private var __activeInstances:Array<FrameSymbolInstance>;
	@:noCompletion private var __activeInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
	@:noCompletion private var __currentInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __currentFrameLabel:String;
	@:noCompletion private var __currentLabel:String;
	@:noCompletion private var __currentLabels:Array<FrameLabel>;
	@:noCompletion private var __enabled:Bool;
	@:noCompletion private var __frameScripts:Map<Int, Void->Void>;
	@:noCompletion private var __frameTime:Int;
	@:noCompletion private var __hasDown:Bool;
	@:noCompletion private var __hasOver:Bool;
	@:noCompletion private var __hasUp:Bool;
	@:noCompletion private var __instanceFields:Array<String>;
	@:noCompletion private var __lastFrameScriptEval:Int;
	@:noCompletion private var __lastFrameUpdate:Int;
	@:noCompletion private var __library:AnimateLibrary;
	@:noCompletion private var __mouseIsDown:Bool;
	@:noCompletion private var __movieClip:MovieClip;
	@:noCompletion private var __playing:Bool;
	@:noCompletion private var __symbol:AnimateSpriteSymbol;
	@:noCompletion private var __timeElapsed:Int;
	@:noCompletion private var __totalFrames:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		__useParentFPS = true;
		untyped __js__("/// #if (typeof ENV === 'undefined' || (!ENV['swflite-parent-fps'] && !ENV['swf-parent-fps'])) && (typeof swf_parent_fps === 'undefined' || !swf_parent_fps) && (typeof swflite_parent_fps === 'undefined' || !swflite-parent-fps) && (typeof defines === 'undefined' || (!defines['swf-parent-fps'] && !defines['swflite-parent-fps']))");
		__useParentFPS = false;
		untyped __js__("/// #endif");
	}
	#end

	public function new(movieClip:MovieClip, library:AnimateLibrary, symbol:AnimateSpriteSymbol)
	{
		__movieClip = movieClip;
		__library = library;
		__symbol = symbol;

		__currentFrame = 1;
		__currentLabels = [];
		__instanceFields = [];
		__totalFrames = 0;
		__enabled = true;

		init();
	}

	public function addFrameScript(index:Int, method:Void->Void):Void
	{
		if (index < 0) return;
		var frame = index + 1;

		if (method != null)
		{
			if (__frameScripts == null)
			{
				__frameScripts = new Map();
			}

			__frameScripts.set(frame, method);
		}
		else if (__frameScripts != null)
		{
			__frameScripts.remove(frame);
		}
	}

	public function getCurrentFrame():Int
	{
		return __currentFrame;
	}

	public function getCurrentFrameLabel():String
	{
		return __currentFrameLabel;
	}

	public function getCurrentLabel():String
	{
		return __currentLabel;
	}

	public function getCurrentLabels():Array<FrameLabel>
	{
		return __currentLabels;
	}

	public function getFramesLoaded():Int
	{
		return __totalFrames;
	}

	public function getTotalFrames():Int
	{
		return __totalFrames;
	}

	/**
		Starts playing the SWF file at the specified frame. This happens after all
		remaining actions in the frame have finished executing. To specify a scene
		as well as a frame, specify a value for the `scene` parameter.

		@param frame A number representing the frame number, or a string
					 representing the label of the frame, to which the playhead is
					 sent. If you specify a number, it is relative to the scene
					 you specify. If you do not specify a scene, the current scene
					 determines the global frame number to play. If you do specify
					 a scene, the playhead jumps to the frame number in the
					 specified scene.
		@param scene The name of the scene to play. This parameter is optional.
	**/
	public function gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		play();
		__goto(__resolveFrameReference(frame));
	}

	/**
		Brings the playhead to the specified frame of the movie clip and stops it
		there. This happens after all remaining actions in the frame have finished
		executing. If you want to specify a scene in addition to a frame, specify
		a `scene` parameter.

		@param frame A number representing the frame number, or a string
					 representing the label of the frame, to which the playhead is
					 sent. If you specify a number, it is relative to the scene
					 you specify. If you do not specify a scene, the current scene
					 determines the global frame number at which to go to and
					 stop. If you do specify a scene, the playhead goes to the
					 frame number in the specified scene and stops.
		@param scene The name of the scene. This parameter is optional.
		@throws ArgumentError If the `scene` or `frame`
							  specified are not found in this movie clip.
	**/
	public function gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		stop();
		__goto(__resolveFrameReference(frame));
	}

	private function init():Void
	{
		if (__activeInstances != null) return;

		__activeInstances = [];
		__activeInstancesByFrameObjectID = new Map();
		__currentInstancesByFrameObjectID = new Map();
		__currentFrame = 1;
		__lastFrameScriptEval = -1;
		__lastFrameUpdate = -1;
		__totalFrames = __symbol.frames.length;

		var frame:Int;
		var frameData:AnimateFrame;

		#if hscript
		var parser = null;
		#end

		for (i in 0...__symbol.frames.length)
		{
			frame = i + 1;
			frameData = __symbol.frames[i];

			if (frameData.label != null)
			{
				__currentLabels.push(new FrameLabel(frameData.label, i + 1));
			}

			if (frameData.script != null)
			{
				if (__frameScripts == null)
				{
					__frameScripts = new Map();
				}

				__frameScripts.set(frame, frameData.script);
			}
			else if (frameData.scriptSource != null)
			{
				if (__frameScripts == null)
				{
					__frameScripts = new Map();
				}

				try
				{
					#if hscript
					if (parser == null)
					{
						parser = new Parser();
						parser.allowTypes = true;
					}

					var program = parser.parseString(frameData.scriptSource);
					var interp = new Interp();
					interp.variables.set("this", this);

					var script = function()
					{
						interp.execute(program);
					};

					__frameScripts.set(frame, script);
					#elseif js
					var script = untyped __js__("eval({0})", "(function(){" + frameData.scriptSource + "})");
					var wrapper = function()
					{
						try
						{
							script.call(this);
						}
						catch (e:Dynamic)
						{
							Log.info("Error evaluating frame script\n "
								+ e
								+ "\n"
								+ haxe.CallStack.exceptionStack().map(function(a)
								{
									return untyped a[2];
								}).join("\n")
								+ "\n"
								+ e.stack
								+ "\n"
								+ untyped script.toString());
						}
					}

					__frameScripts.set(frame, wrapper);
					#end
				}
				catch (e:Dynamic)
				{
					if (__symbol.className != null)
					{
						Log.warn("Unable to evaluate frame script source for symbol \"" + __symbol.className + "\" frame " + frame + "\n"
							+ frameData.scriptSource);
					}
					else
					{
						Log.warn("Unable to evaluate frame script source:\n" + frameData.scriptSource);
					}
				}
			}
		}

		var frame:Int;
		var frameData:AnimateFrame;
		var instance:FrameSymbolInstance;
		var duplicate:Bool;
		var symbol:AnimateSymbol;
		var displayObject:DisplayObject;

		// TODO: Create later?

		for (i in 0...__totalFrames)
		{
			frame = i + 1;
			frameData = __symbol.frames[i];

			if (frameData.objects == null) continue;

			for (frameObject in frameData.objects)
			{
				if (frameObject.type == AnimateFrameObjectType.CREATE)
				{
					if (__activeInstancesByFrameObjectID.exists(frameObject.id))
					{
						continue;
					}
					else
					{
						instance = null;
						duplicate = false;

						for (activeInstance in __activeInstances)
						{
							if (activeInstance.displayObject != null
								&& activeInstance.characterID == frameObject.symbol
								&& activeInstance.depth == frameObject.depth)
							{
								// TODO: Fix duplicates in exporter
								instance = activeInstance;
								duplicate = true;
								break;
							}
						}
					}

					if (instance == null)
					{
						symbol = __library.symbols.get(frameObject.symbol);

						if (symbol != null)
						{
							displayObject = symbol.__createObject(__library);

							if (displayObject != null)
							{
								#if !flash
								displayObject.parent = __movieClip;
								displayObject.stage = __movieClip.stage;

								if (__movieClip.stage != null) displayObject.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));
								#end

								instance = new FrameSymbolInstance(frame, frameObject.id, frameObject.symbol, frameObject.depth, displayObject,
									frameObject.clipDepth);
							}
						}
					}

					if (instance != null)
					{
						__activeInstancesByFrameObjectID.set(frameObject.id, instance);

						if (!duplicate)
						{
							__activeInstances.push(instance);
							__updateDisplayObject(instance.displayObject, frameObject);
						}
					}
				}
				/*
					else if (frameObject.type == FrameObjectType.UPDATE)
					{
						instance = null;

						if (__activeInstancesByFrameObjectID.exists (frameObject.id))
						{
							instance = __activeInstancesByFrameObjectID.get (frameObject.id);
						}

						if (instance != null && instance.displayObject != null)
						{
							__updateDisplayObject (instance.displayObject, frameObject);
						}

					}
					else if (frameObject.type == FrameObjectType.DESTROY)
					{
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
					else
					{
						throw "Unrecognized FrameObject.type "+ frameObject.type;
					}
				**/
			}
		}

		// if (__totalFrames > 1)
		// {
		// 	play();
		// }

		enterFrame(0);

		#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
		__instanceFields = Type.getInstanceFields(Type.getClass(__movieClip));
		__updateInstanceFields();
		#end
	}

	public function isPlaying():Bool
	{
		return __playing;
	}

	/**
		Sends the playhead to the next frame and stops it. This happens after all
		remaining actions in the frame have finished executing.

	**/
	public function nextFrame():Void
	{
		stop();
		__goto(__currentFrame + 1);
	}

	// @:noCompletion @:dox(hide) public function nextScene ():Void;

	/**
		Moves the playhead in the timeline of the movie clip.

	**/
	public function play():Void
	{
		if (__symbol == null || __playing || __totalFrames < 2) return;

		__playing = true;

		if (!__useParentFPS)
		{
			__frameTime = Std.int(1000 / __library.frameRate);
			__timeElapsed = 0;
		}
	}

	/**
		Sends the playhead to the previous frame and stops it. This happens after
		all remaining actions in the frame have finished executing.

	**/
	public function prevFrame():Void
	{
		stop();
		__goto(__currentFrame - 1);
	}

	// @:noCompletion @:dox(hide) public function prevScene ():Void;

	/**
		Stops the playhead in the movie clip.

	**/
	public function stop():Void
	{
		__playing = false;
	}

	public function enterFrame(deltaTime:Int):Void
	{
		__updateFrameScript(deltaTime);
		__updateSymbol(__currentFrame);

		// super.__enterFrame(deltaTime);
	}

	@:noCompletion private function __updateFrameScript(deltaTime:Int):Void
	{
		if (__symbol != null && __playing)
		{
			var nextFrame = __getNextFrame(deltaTime);

			if (__lastFrameScriptEval == nextFrame)
			{
				// super.__enterFrame(deltaTime);
				return;
			}

			if (__frameScripts != null)
			{
				if (nextFrame < __currentFrame)
				{
					if (!__evaluateFrameScripts(__totalFrames))
					{
						// super.__enterFrame(deltaTime);
						return;
					}

					__currentFrame = 1;
				}

				if (!__evaluateFrameScripts(nextFrame))
				{
					// super.__enterFrame(deltaTime);
					return;
				}
			}
			else
			{
				__currentFrame = nextFrame;
			}
		}
	}

	@:noCompletion private function __updateSymbol(targetFrame:Int):Void
	{
		if (__symbol != null && __currentFrame != __lastFrameUpdate)
		{
			__updateFrameLabel();

			var frame:Int;
			var frameData:AnimateFrame;
			var instance:FrameSymbolInstance;

			var updateFrameStart = __lastFrameUpdate < targetFrame ? (__lastFrameUpdate == -1 ? 0 : __lastFrameUpdate)  : 0;

			// Reset frame objects if starting over.
			if (updateFrameStart < 0) {
				__currentInstancesByFrameObjectID = new Map();
			}

			for (i in updateFrameStart...targetFrame)
			{
				frame = i + 1;
				frameData = __symbol.frames[i];

				if (frameData.objects == null) continue;

				for (frameObject in frameData.objects)
				{
					switch (frameObject.type)
					{
						case CREATE:
							instance = __activeInstancesByFrameObjectID.get(frameObject.id);

							if (instance != null)
							{
								__currentInstancesByFrameObjectID.set(frameObject.id, instance);
								__updateDisplayObject(instance.displayObject, frameObject, true);
							}

						case UPDATE:
							instance = __currentInstancesByFrameObjectID.get(frameObject.id);

							if (instance != null && instance.displayObject != null)
							{
								__updateDisplayObject(instance.displayObject, frameObject);
							}

						case DESTROY:
							__currentInstancesByFrameObjectID.remove(frameObject.id);
					}
				}
			}

			// TODO: Less garbage?

			var currentInstances = new Array<FrameSymbolInstance>();
			var currentMasks = new Array<FrameSymbolInstance>();

			for (instance in __currentInstancesByFrameObjectID)
			{
				if (currentInstances.indexOf(instance) == -1)
				{
					currentInstances.push(instance);

					if (instance.clipDepth > 0)
					{
						currentMasks.push(instance);
					}
				}
			}

			currentInstances.sort(__sortDepths);

			var existingChild:DisplayObject;
			var targetDepth:Int;
			var targetChild:DisplayObject;
			var child:DisplayObject;
			var maskApplied:Bool;

			for (i in 0...currentInstances.length)
			{
				existingChild = #if flash (i < __movieClip.numChildren) ? __movieClip.getChildAt(i) : null #else __movieClip.__children[i] #end;
				instance = currentInstances[i];

				targetDepth = instance.depth;
				targetChild = instance.displayObject;

				if (existingChild != targetChild)
				{
					child = targetChild;
					__movieClip.addChildAt(targetChild, i);
				}
				else
				{
					child = #if flash __movieClip.getChildAt(i) #else __movieClip.__children[i] #end;
				}

				maskApplied = false;

				for (mask in currentMasks)
				{
					if (targetDepth > mask.depth && targetDepth <= mask.clipDepth)
					{
						child.mask = mask.displayObject;
						maskApplied = true;
						break;
					}
				}

				if (currentMasks.length > 0 && !maskApplied && child.mask != null)
				{
					child.mask = null;
				}
			}

			var child;
			var i = currentInstances.length;
			var length = #if flash __movieClip.numChildren #else __movieClip.__children.length #end;

			while (i < length)
			{
				child = #if flash __movieClip.getChildAt(i) #else __movieClip.__children[i] #end;

				// TODO: Faster method of determining if this was automatically added?

				for (instance in __activeInstances)
				{
					if (instance.displayObject == child)
					{
						// set MovieClips back to initial state (autoplay)
						if (Std.is(child, MovieClip))
						{
							var movie:MovieClip = cast child;
							movie.gotoAndPlay(1);
						}

						__movieClip.removeChild(child);
						i--;
						length--;
					}
				}

				i++;
			}

			__lastFrameUpdate = __currentFrame;

			#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
			__updateInstanceFields();
			#end
		}
	}

	@:noCompletion private function __evaluateFrameScripts(advanceToFrame:Int):Bool
	{
		for (frame in __currentFrame...advanceToFrame + 1)
		{
			if (frame == __lastFrameScriptEval) continue;

			__lastFrameScriptEval = frame;
			__currentFrame = frame;

			if (__frameScripts.exists(frame))
			{
				__updateSymbol(frame);
				var script = __frameScripts.get(frame);
				script();

				if (__currentFrame != frame)
				{
					return false;
				}
			}

			if (!__playing)
			{
				return false;
			}
		}

		return true;
	}

	@:noCompletion private function __fromSymbol(library:AnimateLibrary, symbol:AnimateSpriteSymbol):Void {}

	@:noCompletion private function __getNextFrame(deltaTime:Int):Int
	{
		var nextFrame:Int = 0;

		if (!__useParentFPS)
		{
			__timeElapsed += deltaTime;
			nextFrame = __currentFrame + Math.floor(__timeElapsed / __frameTime);
			if (nextFrame < 1) nextFrame = 1;
			if (nextFrame > __totalFrames) nextFrame = Math.floor((nextFrame - 1) % __totalFrames) + 1;
			__timeElapsed = (__timeElapsed % __frameTime);
		}
		else
		{
			nextFrame = __currentFrame + 1;
			if (nextFrame > __totalFrames) nextFrame = 1;
		}

		return nextFrame;
	}

	@:noCompletion private function __goto(frame:Int):Void
	{
		if (__symbol == null) return;

		if (frame < 1) frame = 1;
		else if (frame > __totalFrames) frame = __totalFrames;

		__currentFrame = frame;
		enterFrame(0);
	}

	@:noCompletion private function __resolveFrameReference(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end):Int
	{
		if (Std.is(frame, Int))
		{
			return cast frame;
		}
		else if (Std.is(frame, String))
		{
			var label:String = cast frame;

			for (frameLabel in __currentLabels)
			{
				if (frameLabel.name == label)
				{
					return frameLabel.frame;
				}
			}

			throw new ArgumentError("Error #2109: Frame label " + label + " not found in scene.");
		}
		else
		{
			throw "Invalid type for frame " + Type.getClassName(frame);
		}
	}

	@:noCompletion private function __sortDepths(a:FrameSymbolInstance, b:FrameSymbolInstance):Int
	{
		return a.depth - b.depth;
	}

	@:noCompletion private function __updateDisplayObject(displayObject:DisplayObject, frameObject:AnimateFrameObject, reset:Bool = false):Void
	{
		if (displayObject == null) return;

		if (frameObject.name != null)
		{
			displayObject.name = frameObject.name;
		}

		if (frameObject.matrix != null)
		{
			displayObject.transform.matrix = frameObject.matrix;
		}

		if (frameObject.colorTransform != null)
		{
			displayObject.transform.colorTransform = frameObject.colorTransform;
		}
		else if (reset #if !flash && !displayObject.transform.colorTransform.__isDefault(true) #end)
		{
			displayObject.transform.colorTransform = new ColorTransform();
		}

		displayObject.transform = displayObject.transform;

		if (frameObject.filters != null)
		{
			var filters:Array<BitmapFilter> = [];

			for (filter in frameObject.filters)
			{
				switch (filter)
				{
					case BlurFilter(blurX, blurY, quality):
						filters.push(new BlurFilter(blurX, blurY, quality));

					case ColorMatrixFilter(matrix):
						filters.push(new ColorMatrixFilter(matrix));

					case DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject):
						filters.push(new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject));

					case GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout):
						filters.push(new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout));
				}
			}

			displayObject.filters = filters;
		}
		else
		{
			displayObject.filters = null;
		}

		if (frameObject.visible != null)
		{
			displayObject.visible = frameObject.visible;
		}

		if (frameObject.blendMode != null)
		{
			displayObject.blendMode = frameObject.blendMode;
		}

		if (frameObject.cacheAsBitmap != null)
		{
			displayObject.cacheAsBitmap = frameObject.cacheAsBitmap;
		}

		#if (openfljs || ((openfl_dynamic || openfl_dynamic_fields_only) && haxe_ver <= "4.0.0"))
		Reflect.setField(this, displayObject.name, displayObject);
		#end
	}

	@:noCompletion private function __updateFrameLabel():Void
	{
		__currentFrameLabel = __symbol.frames[__currentFrame - 1].label;

		if (__currentFrameLabel != null)
		{
			__currentLabel = __currentFrameLabel;
		}
		else
		{
			__currentLabel = null;

			for (label in __currentLabels)
			{
				if (label.frame < __currentFrame)
				{
					__currentLabel = label.name;
				}
				else
				{
					break;
				}
			}
		}
	}

	@:noCompletion private function __updateInstanceFields():Void
	{
		for (field in __instanceFields)
		{
			var length = #if flash __movieClip.numChildren #else __movieClip.__children.length #end;
			for (i in 0...length)
			{
				var child = #if flash __movieClip.getChildAt(i) #else __movieClip.__children[i] #end;
				if (child.name == field)
				{
					Reflect.setField(__movieClip, field, child);
					break;
				}
			}
		}
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class FrameSymbolInstance
{
	public var characterID:Int;
	public var clipDepth:Int;
	public var depth:Int;
	public var displayObject:DisplayObject;
	public var initFrame:Int;
	public var initFrameObjectID:Int; // TODO: Multiple frame object IDs may refer to the same instance

	public function new(initFrame:Int, initFrameObjectID:Int, characterID:Int, depth:Int, displayObject:DisplayObject, clipDepth:Int)
	{
		this.initFrame = initFrame;
		this.initFrameObjectID = initFrameObjectID;
		this.characterID = characterID;
		this.depth = depth;
		this.displayObject = displayObject;
		this.clipDepth = clipDepth;
	}
}
