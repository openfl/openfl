package openfl.display;

#if !flash
// TODO: Force keeping of SWF symbols a different way?
import openfl._internal.formats.swf.SWFLite;
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.symbols.ButtonSymbol;
import openfl._internal.symbols.DynamicTextSymbol;
import openfl._internal.symbols.FontSymbol;
import openfl._internal.symbols.ShapeSymbol;
import openfl._internal.symbols.SpriteSymbol;
import openfl._internal.symbols.StaticTextSymbol;
import openfl._internal.symbols.SWFSymbol;
import openfl._internal.symbols.timeline.Frame;
import openfl._internal.symbols.timeline.FrameObject;
import openfl._internal.symbols.timeline.FrameObjectType;
import openfl._internal.utils.Log;
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

/**
	The MovieClip class inherits from the following classes: Sprite,
	DisplayObjectContainer, InteractiveObject, DisplayObject, and
	EventDispatcher.

	Unlike the Sprite object, a MovieClip object has a timeline.

	In Flash Professional, the methods for the MovieClip class provide the
	same functionality as actions that target movie clips. Some additional
	methods do not have equivalent actions in the Actions toolbox in the
	Actions panel in the Flash authoring tool.

	Children instances placed on the Stage in Flash Professional cannot be
	accessed by code from within the constructor of a parent instance since
	they have not been created at that point in code execution. Before
	accessing the child, the parent must instead either create the child
	instance by code or delay access to a callback function that listens for
	the child to dispatch its `Event.ADDED_TO_STAGE` event.

	If you modify any of the following properties of a MovieClip object that
	contains a motion tween, the playhead is stopped in that MovieClip object:
	`alpha`, `blendMode`, `filters`,
	`height`, `opaqueBackground`, `rotation`,
	`scaleX`, `scaleY`, `scale9Grid`,
	`scrollRect`, `transform`, `visible`,
	`width`, `x`, or `y`. However, it does not
	stop the playhead in any child MovieClip objects of that MovieClip
	object.

	**Note:**Flash Lite 4 supports the MovieClip.opaqueBackground
	property only if FEATURE_BITMAPCACHE is defined. The default configuration
	of Flash Lite 4 does not define FEATURE_BITMAPCACHE. To enable the
	MovieClip.opaqueBackground property for a suitable device, define
	FEATURE_BITMAPCACHE in your project.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.symbols.SWFSymbol)
@:access(openfl.geom.ColorTransform)
class MovieClip extends Sprite #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic<DisplayObject> #end
{
	@:noCompletion private static var __initSWF:SWFLite;
	@:noCompletion private static var __initSymbol:SpriteSymbol;
	#if openfljs
	@:noCompletion private static var __useParentFPS:Bool;
	#else
	@:noCompletion private static inline var __useParentFPS:Bool = #if (swflite_parent_fps || swf_parent_fps) true #else false #end;
	#end
	#if 0
	// Suppress checkstyle warning
	private static var __unusedImport:Array<Class<Dynamic>> = [
		BitmapSymbol, ButtonSymbol, DynamicTextSymbol, FontSymbol, ShapeSymbol, SpriteSymbol, StaticTextSymbol, SWFSymbol, BlurFilter, ColorMatrixFilter,
		ConvolutionFilter, DisplacementMapFilter, DropShadowFilter, GlowFilter
	];
	#end

	/**
		Specifies the number of the frame in which the playhead is located in the
		timeline of the MovieClip instance. If the movie clip has multiple scenes,
		this value is the frame number in the current scene.
	**/
	public var currentFrame(get, never):Int;

	/**
		The label at the current frame in the timeline of the MovieClip instance.
		If the current frame has no label, `currentLabel` is
		`null`.
	**/
	public var currentFrameLabel(get, never):String;

	/**
		The current label in which the playhead is located in the timeline of the
		MovieClip instance. If the current frame has no label,
		`currentLabel` is set to the name of the previous frame that
		includes a label. If the current frame and previous frames do not include
		a label, `currentLabel` returns `null`.
	**/
	public var currentLabel(get, never):String;

	/**
		Returns an array of FrameLabel objects from the current scene. If the
		MovieClip instance does not use scenes, the array includes all frame
		labels from the entire MovieClip instance.
	**/
	public var currentLabels(get, never):Array<FrameLabel>;

	/**
		A Boolean value that indicates whether a movie clip is enabled. The
		default value of `enabled` is `true`. If
		`enabled` is set to `false`, the movie clip's Over,
		Down, and Up frames are disabled. The movie clip continues to receive
		events(for example, `mouseDown`, `mouseUp`,
		`keyDown`, and `keyUp`).

		The `enabled` property governs only the button-like
		properties of a movie clip. You can change the `enabled`
		property at any time; the modified movie clip is immediately enabled or
		disabled. If `enabled` is set to `false`, the object
		is not included in automatic tab ordering.
	**/
	public var enabled(get, set):Bool;

	/**
		The number of frames that are loaded from a streaming SWF file. You can
		use the `framesLoaded` property to determine whether the
		contents of a specific frame and all the frames before it loaded and are
		available locally in the browser. You can also use it to monitor the
		downloading of large SWF files. For example, you might want to display a
		message to users indicating that the SWF file is loading until a specified
		frame in the SWF file finishes loading.

		If the movie clip contains multiple scenes, the
		`framesLoaded` property returns the number of frames loaded for
		_all_ scenes in the movie clip.
	**/
	public var framesLoaded(get, never):Int;

	public var isPlaying(get, never):Bool;

	// @:noCompletion @:dox(hide) public var scenes (default, never):Array<openfl.display.Scene>;

	/**
		The total number of frames in the MovieClip instance.

		If the movie clip contains multiple frames, the
		`totalFrames` property returns the total number of frames in
		_all_ scenes in the movie clip.
	**/
	public var totalFrames(get, never):Int;

	// @:noCompletion @:dox(hide) public var trackAsMenu:Bool;
	@:noCompletion private var __activeInstances:Array<FrameSymbolInstance>;
	@:noCompletion private var __activeInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
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
	@:noCompletion private var __mouseIsDown:Bool;
	@:noCompletion private var __playing:Bool;
	@:noCompletion private var __swf:SWFLite;
	@:noCompletion private var __symbol:SpriteSymbol;
	@:noCompletion private var __timeElapsed:Int;
	@:noCompletion private var __totalFrames:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		__useParentFPS = true;
		untyped __js__("/// #if (typeof ENV === 'undefined' || (!ENV['swflite-parent-fps'] && !ENV['swf-parent-fps'])) && (typeof swf_parent_fps === 'undefined' || !swf_parent_fps) && (typeof swflite_parent_fps === 'undefined' || !swflite-parent-fps) && (typeof defines === 'undefined' || (!defines['swf-parent-fps'] && !defines['swflite-parent-fps']))");
		__useParentFPS = false;
		untyped __js__("/// #endif");

		untyped Object.defineProperties(MovieClip.prototype, {
			"currentFrame": {get: untyped __js__("function () { return this.get_currentFrame (); }")},
			"currentFrameLabel": {get: untyped __js__("function () { return this.get_currentFrameLabel (); }")},
			"currentLabel": {get: untyped __js__("function () { return this.get_currentLabel (); }")},
			"currentLabels": {get: untyped __js__("function () { return this.get_currentLabels (); }")},
			"enabled": {get: untyped __js__("function () { return this.get_enabled (); }"),
				set: untyped __js__("function (v) { return this.set_enabled (v); }")},
			"framesLoaded": {get: untyped __js__("function () { return this.get_framesLoaded (); }")},
			"isPlaying": {get: untyped __js__("function () { return this.get_isPlaying (); }")},
			"totalFrames": {get: untyped __js__("function () { return this.get_totalFrames (); }")},
		});
	}
	#end

	/**
		Creates a new MovieClip instance. After creating the MovieClip, call the
		`addChild()` or `addChildAt()` method of a display
		object container that is onstage.
	**/
	public function new()
	{
		super();

		__currentFrame = 1;
		__currentLabels = [];
		__instanceFields = [];
		__totalFrames = 0;
		__enabled = true;

		if (__initSymbol != null)
		{
			__swf = __initSWF;
			__symbol = __initSymbol;

			__initSWF = null;
			__initSymbol = null;

			__fromSymbol(__swf, __symbol);
		}
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
			__frameTime = Std.int(1000 / __swf.frameRate);
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

	public override function __enterFrame(deltaTime:Int):Void
	{
		__updateFrameScript(deltaTime);
		__updateSymbol(__currentFrame);

		super.__enterFrame(deltaTime);
	}

	@:noCompletion private function __updateFrameScript(deltaTime:Int):Void
	{
		if (__symbol != null && __playing)
		{
			var nextFrame = __getNextFrame(deltaTime);

			if (__lastFrameScriptEval == nextFrame)
			{
				super.__enterFrame(deltaTime);
				return;
			}

			if (__frameScripts != null)
			{
				if (nextFrame < __currentFrame)
				{
					if (!__evaluateFrameScripts(__totalFrames))
					{
						super.__enterFrame(deltaTime);
						return;
					}

					__currentFrame = 1;
				}

				if (!__evaluateFrameScripts(nextFrame))
				{
					super.__enterFrame(deltaTime);
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

			var currentInstancesByFrameObjectID = new Map<Int, FrameSymbolInstance>();

			var frame:Int;
			var frameData:Frame;
			var instance:FrameSymbolInstance;

			// TODO: Handle updates only from previous frame?

			for (i in 0...targetFrame)
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
								currentInstancesByFrameObjectID.set(frameObject.id, instance);
								__updateDisplayObject(instance.displayObject, frameObject, true);
							}

						case UPDATE:
							instance = currentInstancesByFrameObjectID.get(frameObject.id);

							if (instance != null && instance.displayObject != null)
							{
								__updateDisplayObject(instance.displayObject, frameObject);
							}

						case DESTROY:
							currentInstancesByFrameObjectID.remove(frameObject.id);
					}
				}
			}

			// TODO: Less garbage?

			var currentInstances = new Array<FrameSymbolInstance>();
			var currentMasks = new Array<FrameSymbolInstance>();

			for (instance in currentInstancesByFrameObjectID)
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
				existingChild = __children[i];
				instance = currentInstances[i];

				targetDepth = instance.depth;
				targetChild = instance.displayObject;

				if (existingChild != targetChild)
				{
					child = targetChild;
					addChildAt(targetChild, i);
				}
				else
				{
					child = __children[i];
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
			var length = __children.length;

			while (i < length)
			{
				child = __children[i];

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

						removeChild(child);
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

	@:noCompletion private function __fromSymbol(swf:SWFLite, symbol:SpriteSymbol):Void
	{
		if (__activeInstances != null) return;

		__swf = swf;
		__symbol = symbol;

		__activeInstances = [];
		__activeInstancesByFrameObjectID = new Map();
		__currentFrame = 1;
		__lastFrameScriptEval = -1;
		__lastFrameUpdate = -1;
		__totalFrames = __symbol.frames.length;

		var frame:Int;
		var frameData:Frame;

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
					interp.variables.set("flash.events_Event", Event);

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
		var frameData:Frame;
		var instance:FrameSymbolInstance;
		var duplicate:Bool;
		var symbol:SWFSymbol;
		var displayObject:DisplayObject;

		// TODO: Create later?

		for (i in 0...__totalFrames)
		{
			frame = i + 1;
			frameData = __symbol.frames[i];

			if (frameData.objects == null) continue;

			for (frameObject in frameData.objects)
			{
				if (frameObject.type == FrameObjectType.CREATE)
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
						symbol = __swf.symbols.get(frameObject.symbol);

						if (symbol != null)
						{
							displayObject = symbol.__createObject(__swf);

							if (displayObject != null)
							{
								displayObject.parent = this;
								displayObject.stage = stage;

								if (stage != null) displayObject.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));

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

		if (__totalFrames > 1)
		{
			play();
		}

		__enterFrame(0);

		#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
		__instanceFields = Type.getInstanceFields(Type.getClass(this));
		__updateInstanceFields();
		#end
	}

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
		__enterFrame(0);
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

	@:noCompletion private override function __stopAllMovieClips():Void
	{
		super.__stopAllMovieClips();
		stop();
	}

	@:noCompletion private override function __tabTest(stack:Array<InteractiveObject>):Void
	{
		if (!__enabled) return;
		super.__tabTest(stack);
	}

	@:noCompletion private function __updateDisplayObject(displayObject:DisplayObject, frameObject:FrameObject, reset:Bool = false):Void
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
		else if (reset && !displayObject.transform.colorTransform.__isDefault(true))
		{
			displayObject.transform.colorTransform = new ColorTransform();
		}

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
			for (child in __children)
			{
				if (child.name == field)
				{
					Reflect.setField(this, field, child);
					break;
				}
			}
		}
	}

	// Event Handlers
	@:noCompletion private function __onMouseDown(event:MouseEvent):Void
	{
		if (__enabled && __hasDown)
		{
			gotoAndStop("_down");
		}

		__mouseIsDown = true;
		stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp, true);
	}

	@:noCompletion private function __onMouseUp(event:MouseEvent):Void
	{
		__mouseIsDown = false;

		if (stage != null)
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}

		if (!__buttonMode)
		{
			return;
		}

		if (event.target == this && __enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (__enabled && __hasUp)
		{
			gotoAndStop("_up");
		}
	}

	@:noCompletion private function __onRollOut(event:MouseEvent):Void
	{
		if (!__enabled) return;

		if (__mouseIsDown && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (__hasUp)
		{
			gotoAndStop("_up");
		}
	}

	@:noCompletion private function __onRollOver(event:MouseEvent):Void
	{
		if (__enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
	}

	// Getters & Setters
	@:noCompletion private override function set_buttonMode(value:Bool):Bool
	{
		if (__buttonMode != value)
		{
			if (value)
			{
				__hasDown = false;
				__hasOver = false;
				__hasUp = false;

				for (frameLabel in __currentLabels)
				{
					switch (frameLabel.name)
					{
						case "_up":
							__hasUp = true;
						case "_over":
							__hasOver = true;
						case "_down":
							__hasDown = true;
						default:
					}
				}

				if (__hasDown || __hasOver || __hasUp)
				{
					addEventListener(MouseEvent.ROLL_OVER, __onRollOver);
					addEventListener(MouseEvent.ROLL_OUT, __onRollOut);
					addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
				}
			}
			else
			{
				removeEventListener(MouseEvent.ROLL_OVER, __onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, __onRollOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			}

			__buttonMode = value;
		}

		return value;
	}

	@:noCompletion private function get_currentFrame():Int
	{
		return __currentFrame;
	}

	@:noCompletion private function get_currentFrameLabel():String
	{
		return __currentFrameLabel;
	}

	@:noCompletion private function get_currentLabel():String
	{
		return __currentLabel;
	}

	@:noCompletion private function get_currentLabels():Array<FrameLabel>
	{
		return __currentLabels;
	}

	@:noCompletion private function get_enabled():Bool
	{
		return __enabled;
	}

	@:noCompletion private function set_enabled(value:Bool):Bool
	{
		return __enabled = value;
	}

	@:noCompletion private function get_framesLoaded():Int
	{
		return __totalFrames;
	}

	@:noCompletion private function get_isPlaying():Bool
	{
		return __playing;
	}

	@:noCompletion private function get_totalFrames():Int
	{
		return __totalFrames;
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
#else
typedef MovieClip = flash.display.MovieClip;
#end
