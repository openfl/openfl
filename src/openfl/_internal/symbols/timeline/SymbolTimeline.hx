package openfl._internal.symbols.timeline;

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
import openfl.display.DisplayObject;
import openfl.display.FrameLabel;
import openfl.display.FrameScript;
import openfl.display.MovieClip;
import openfl.display.Scene;
import openfl.display.Timeline;
import openfl.events.Event;
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

@:access(openfl._internal.symbols)
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)
class SymbolTimeline extends Timeline
{
	#if openfljs
	@:noCompletion private static var __useParentFPS:Bool;
	#else
	@:noCompletion private static inline var __useParentFPS:Bool = #if (swflite_parent_fps || swf_parent_fps) true #else false #end;
	#end

	@:noCompletion private var __activeInstances:Array<FrameSymbolInstance>;
	@:noCompletion private var __activeInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
	@:noCompletion private var __instanceFields:Array<String>;
	@:noCompletion private var __movieClip:MovieClip;
	@:noCompletion private var __previousFrame:Int;
	@:noCompletion private var __swf:SWFLite;
	@:noCompletion private var __symbol:SpriteSymbol;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		__useParentFPS = true;
		untyped __js__("/// #if (typeof ENV === 'undefined' || (!ENV['swflite-parent-fps'] && !ENV['swf-parent-fps'])) && (typeof swf_parent_fps === 'undefined' || !swf_parent_fps) && (typeof swflite_parent_fps === 'undefined' || !swflite-parent-fps) && (typeof defines === 'undefined' || (!defines['swf-parent-fps'] && !defines['swflite-parent-fps']))");
		__useParentFPS = false;
		untyped __js__("/// #endif");
	}
	#end

	public function new(swf:SWFLite, symbol:SpriteSymbol)
	{
		super();

		__swf = swf;
		__symbol = symbol;

		__previousFrame = -1;

		var labels = [];
		scripts = [];

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
				labels.push(new FrameLabel(frameData.label, i + 1));
			}

			if (frameData.script != null)
			{
				scripts.push(new FrameScript(function(scope)
				{
					frameData.script();
				}, frame));
			}
			else if (frameData.scriptSource != null)
			{
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
					interp.variables.set("flash.events_Event", Event);

					var script = function(scope:MovieClip)
					{
						interp.variables.set("this", scope);
						interp.execute(program);
					};

					scripts.push(new FrameScript(script, frame));
					#elseif js
					var script = untyped __js__("eval({0})", "(function(){" + frameData.scriptSource + "})");
					var wrapper = function(scope)
					{
						try
						{
							script.call(scope);
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

					scripts.push(new FrameScript(wrapper, frame));
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

		if (!__useParentFPS) frameRate = swf.frameRate;
		scenes = [new Scene("", labels, __symbol.frames.length)];
	}

	public override function attachMovieClip(movieClip:MovieClip):Void
	{
		if (__activeInstances != null) return;

		__movieClip = movieClip;

		__activeInstances = [];
		__activeInstancesByFrameObjectID = new Map();
		__previousFrame = -1;

		var frame:Int;
		var frameData:Frame;
		var instance:FrameSymbolInstance;
		var duplicate:Bool;
		var symbol:SWFSymbol;
		var displayObject:DisplayObject;

		// TODO: Create later?

		for (i in 0...scenes[0].numFrames)
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
								displayObject.parent = __movieClip;
								displayObject.stage = __movieClip.stage;

								if (__movieClip.stage != null) displayObject.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));

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
			}
		}

		#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
		__instanceFields = Type.getInstanceFields(Type.getClass(this));
		#end

		enterFrame(1);
	}

	public override function enterFrame(targetFrame:Int):Void
	{
		if (__symbol != null && targetFrame != __previousFrame)
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
				existingChild = __movieClip.__children[i];
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
					child = __movieClip.__children[i];
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
			var length = __movieClip.__children.length;

			while (i < length)
			{
				child = __movieClip.__children[i];

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

			__previousFrame = targetFrame;

			#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
			__updateInstanceFields();
			#end
		}
	}

	@:noCompletion private function __sortDepths(a:FrameSymbolInstance, b:FrameSymbolInstance):Int
	{
		return a.depth - b.depth;
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

	@:noCompletion private function __updateInstanceFields():Void
	{
		if (__instanceFields == null) return;

		for (field in __instanceFields)
		{
			for (child in __movieClip.__children)
			{
				if (child.name == field)
				{
					Reflect.setField(this, field, child);
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
