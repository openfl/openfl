package openfl._internal.formats.animate;

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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.formats.animate.AnimateLibrary)
@:access(openfl._internal.formats.animate.AnimateSymbol)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.MovieClip)
@:access(openfl.geom.ColorTransform)
class AnimateTimeline extends Timeline
{
	#if 0
	// Suppress checkstyle warning
	private static var __unusedImport:Array<Class<Dynamic>> = [
		AnimateBitmapSymbol, AnimateButtonSymbol, AnimateDynamicTextSymbol, AnimateFontSymbol, AnimateShapeSymbol, AnimateSpriteSymbol,
		AnimateStaticTextSymbol, AnimateSymbol, BlurFilter, ColorMatrixFilter, ConvolutionFilter, DisplacementMapFilter, DropShadowFilter, GlowFilter
	];
	#end

	@:noCompletion private var __activeInstances:Array<FrameSymbolInstance>;
	@:noCompletion private var __activeInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
	@:noCompletion private var __currentInstancesByFrameObjectID:Map<Int, FrameSymbolInstance>;
	@:noCompletion private var __instanceFields:Array<String>;
	@:noCompletion private var __library:AnimateLibrary;
	@:noCompletion private var __movieClip:MovieClip;
	@:noCompletion private var __previousFrame:Int;
	@:noCompletion private var __symbol:AnimateSpriteSymbol;

	public function new(library:AnimateLibrary, symbol:AnimateSpriteSymbol)
	{
		super();

		__library = library;
		__symbol = symbol;

		frameRate = library.frameRate;
		var labels = [];
		scripts = [];

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
				labels.push(new FrameLabel(frameData.label, frame));
			}

			if (frameData.script != null)
			{
				scripts.push(new FrameScript(frameData.script, frame));
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

					var script = function(scope:MovieClip)
					{
						interp.variables.set("this", scope);
						interp.execute(program);
					};

					scripts.push(new FrameScript(script, frame));
					#elseif js
					var script = untyped __js__("eval({0})", "(function(){" + frameData.scriptSource + "})");
					var wrapper = function(scope:MovieClip)
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

		scenes = [new Scene("", labels, __symbol.frames.length)];
	}

	public override function attachMovieClip(movieClip:MovieClip):Void
	{
		__movieClip = movieClip;

		if (__activeInstances != null) return;

		__instanceFields = [];
		__previousFrame = -1;

		__activeInstances = [];
		__activeInstancesByFrameObjectID = new Map();
		__currentInstancesByFrameObjectID = new Map();

		var frame:Int;
		var frameData:AnimateFrame;
		var instance:FrameSymbolInstance;
		var duplicate:Bool;
		var symbol:AnimateSymbol;
		var displayObject:DisplayObject;

		// TODO: Create later?

		for (i in 0...scenes[0].numFrames)
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
			}
		}

		#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
		__instanceFields = Type.getInstanceFields(Type.getClass(__movieClip));
		#end

		enterFrame(1);
	}

	public override function enterFrame(currentFrame:Int):Void
	{
		if (__symbol != null && currentFrame != __previousFrame)
		{
			var frame:Int;
			var frameData:AnimateFrame;
			var instance:FrameSymbolInstance;

			var updateFrameStart = __previousFrame < currentFrame ? (__previousFrame == -1 ? 0 : __previousFrame) : 0;

			// Reset frame objects if starting over.
			if (updateFrameStart <= 0)
			{
				__currentInstancesByFrameObjectID = new Map();
			}

			for (i in updateFrameStart...currentFrame)
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

			#if (!openfljs && (!openfl_dynamic || haxe_ver >= "4.0.0"))
			__updateInstanceFields();
			#end

			__previousFrame = currentFrame;
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
		else if (reset #if !flash && !displayObject.transform.colorTransform.__isDefault(false) #end)
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
