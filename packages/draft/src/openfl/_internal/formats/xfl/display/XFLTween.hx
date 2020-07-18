package openfl.display;

import openfl.events.Event;
import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import openfl.filters.DropShadowFilter;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

class XFLTween
{
	private static var tweens:Array<Dynamic> = new Array<Dynamic>();

	private static function copy(value:Dynamic):Dynamic
	{
		if (Reflect.isObject(value) == false)
		{
			return value;
		}
		else if ((value is String))
		{
			return value;
		}
		else if ((value is Array))
		{
			var result:Array<Dynamic> = cast(value, Array<Dynamic>).copy();
			for (i in 0...result.length)
			{
				result[i] = copy(result[i]);
			}
			return result;
		}
		else if (Type.getClass(value) == null)
		{
			var result:Dynamic = {};
			for (field in Reflect.fields(value))
			{
				Reflect.setField(result, field, copy(Reflect.field(value, field)));
			}
			return result;
		}
		return null;
	}

	public static function allTo(objects:Array<Dynamic>, duration:Float, tween:Dynamic, stagger:Float = 0.0, onCompleteAll:Void->Void = null,
			onCompleteAllParams:Array<Dynamic> = null):Array<Dynamic>
	{
		var allTweens:Array<Dynamic> = [];
		if (onCompleteAll != null)
		{
			tween.onComplete = function()
			{
				var tweensFinished:Bool = true;
				for (tween in allTweens)
				{
					if (tweens.indexOf(tween) != -1)
					{
						tweensFinished = false;
						break;
					}
				}
				if (tweensFinished == true)
				{
					Reflect.callMethod(null, onCompleteAll, onCompleteAllParams != null ? onCompleteAllParams : []);
				}
			};
		}
		for (object in objects)
		{
			var tweenCloned:Dynamic = copy(tween);
			allTweens.push(to(object, duration, tweenCloned));
		}
		return tweens;
	}

	public static function to(object:Dynamic, duration:Float, tween:Dynamic, appendTo:Dynamic = null):Dynamic
	{
		tween.object = object;
		tween.delay = Reflect.hasField(tween, "delay") ? tween.delay : 0.0;
		tween.duration = duration;
		if ((object is DisplayObject) == true)
		{
			tween.initFunc = toInitDisplayObject;
			tween.disposeFunc = toDisposeDisplayObject;
			tween.handleFunc = tweenToImplDisplayObject;
		}
		else if ((object is SoundChannel) == true)
		{
			tween.initFunc = toInitSoundChannel;
			tween.disposeFunc = toDisposeSoundChannel;
			tween.handleFunc = tweenToImplSoundChannel;
		}
		tween.completed = false;
		tween.easeFunc = Reflect.hasField(tween, "ease") == true ? tween.ease : linearEaseIn;
		tween.repeat = Reflect.hasField(tween, "repeat") == true ? tween.repeat : 1;
		tween.yoyo = Reflect.hasField(tween, "yoyo") == true ? tween.yoyo : false;
		if (tween.yoyo == true)
		{
			if (tween.repeat != -1) tween.repeat *= 2;
			// tween.duration/= 2.0;
		}
		tween.runs = 0;
		tween.onCompleteCalled = false;
		tween.nextTween = null;
		if (appendTo != null)
		{
			appendTo.nextTween = tween;
		}
		else
		{
			if (tween.initFunc != null) tween.initFunc(tween);
			killTweensOf(object);
			addTween(tween);
		}
		return tween;
	}

	public static function delayedCall(duration:Float, onComplete:Dynamic, onCompleteParams:Array<Dynamic> = null):Void
	{
		var tween:Dynamic = {};
		tween.object = null;
		tween.delay = Reflect.hasField(tween, "delay") ? tween.delay : 0.0;
		tween.duration = duration;
		tween.timeInit = haxe.Timer.stamp() + tween.delay;
		tween.timeCurrent = tween.timeInit;
		tween.timeFinal = tween.timeInit + tween.duration;
		tween.duration = duration;
		tween.repeat = 1;
		tween.yoyo = false;
		tween.runs = 0;
		tween.completed = false;
		tween.onCompleteCalled = false;
		tween.nextTween = null;
		tween.onComplete = onComplete;
		tween.onCompleteParams = onCompleteParams;
		tween.initFunc = null;
		tween.disposeFunc = null;
		tween.handleFunc = null;
		addTween(tween);
	}

	private static function toInitDisplayObject(tween:Dynamic):Void
	{
		var object:DisplayObject = cast(tween.object, DisplayObject);
		tween.timeInit = haxe.Timer.stamp() + tween.delay;
		tween.timeCurrent = tween.timeInit;
		tween.timeFinal = tween.timeInit + tween.duration;
		tween.initialRotation = object.rotation;
		tween.initialAlpha = object.alpha;
		tween.initialX = object.x;
		tween.initialY = object.y;
		tween.initialWidth = object.width;
		tween.initialHeight = object.height;
		tween.initialScaleX = object.scaleX;
		tween.initialScaleY = object.scaleY;
		if (Reflect.hasField(tween, "rotation") == true)
		{
			tween.targetRotation = tween.rotation;
		}
		if (Reflect.hasField(tween, "alpha") == true)
		{
			tween.targetAlpha = tween.alpha;
		}
		if (Reflect.hasField(tween, "x") == true)
		{
			tween.targetX = tween.x;
		}
		if (Reflect.hasField(tween, "y") == true)
		{
			tween.targetY = tween.y;
		}
		if (Reflect.hasField(tween, "width") == true)
		{
			tween.targetWidth = tween.width;
		}
		if (Reflect.hasField(tween, "height") == true)
		{
			tween.targetHeight = tween.height;
		}
		if (Reflect.hasField(tween, "scaleX") == true)
		{
			tween.targetScaleX = tween.scaleX;
		}
		if (Reflect.hasField(tween, "scaleY") == true)
		{
			tween.targetScaleY = tween.scaleY;
		}
		if (Reflect.hasField(tween, "glowFilter") == true)
		{
			tween.glowFilter.firstInvocation = true;
			tween.glowFilter.targetStrength = tween.glowFilter.strength;
			tween.glowFilter.initialStrength = tween.glowFilter.strength;
			tween.glowFilterInstance = new GlowFilter(tween.glowFilter.color, tween.glowFilter.alpha, tween.glowFilter.blurX, tween.glowFilter.blurY,
				tween.glowFilter.strength);
			var objectFilters:Array<BitmapFilter> = object.filters;
			objectFilters.push(tween.glowFilterInstance);
			object.filters = objectFilters;
		}
		if (Reflect.hasField(tween, "dropShadowFilter") == true)
		{
			tween.dropShadowFilter.targetDistance = tween.dropShadowFilter.distance;
			tween.dropShadowFilter.initialDistance = 0.0;
			tween.dropShadowFilterInstance = new DropShadowFilter(tween.dropShadowFilter.distance, 45.0, tween.dropShadowFilter.color,
				tween.dropShadowFilter.alpha, tween.dropShadowFilter.blurX, tween.dropShadowFilter.blurY);
			var objectFilters:Array<BitmapFilter> = object.filters;
			objectFilters.push(tween.dropShadowFilterInstance);
			object.filters = objectFilters;
		}
	}

	public static function toDisposeDisplayObject(tween:Dynamic):Void
	{
		var object:DisplayObject = cast(tween.object, DisplayObject);
		if (Reflect.hasField(tween, "glowFilterInstance") == true)
		{
			var glowFilter:GlowFilter = cast(tween.glowFilterInstance, GlowFilter);
			object.filters.remove(glowFilter);
			object.filters = object.filters;
		}
		if (Reflect.hasField(tween, "dropShadowFilterInstance") == true)
		{
			var dropShadowFilter:DropShadowFilter = cast(tween.dropShadowFilterInstance, DropShadowFilter);
			object.filters.remove(dropShadowFilter);
			object.filters = object.filters;
		}
	}

	private static function tweenToImplDisplayObject(tween:Dynamic):Void
	{
		var applyYoyo:Bool = tween.yoyo == true && tween.completed == true && (tween.repeat == -1 || tween.runs < tween.repeat);
		var object:DisplayObject = cast(tween.object, DisplayObject);
		if (Reflect.hasField(tween, "rotation") == true)
		{
			object.rotation = tween.initialRotation
				+ ((tween.rotation - tween.initialRotation) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.rotation = Math.abs(object.rotation - tween.initialRotation) < 0.1 ? tween.targetRotation : tween.initialRotation;
				tween.initialRotation = object.rotation;
			}
		}
		if (Reflect.hasField(tween, "alpha") == true)
		{
			object.alpha = tween.initialAlpha + ((tween.alpha - tween.initialAlpha) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.alpha = Math.abs(object.alpha - tween.initialAlpha) < 0.1 ? tween.targetAlpha : tween.initialAlpha;
				tween.initialAlpha = object.alpha;
			}
		}
		if (Reflect.hasField(tween, "x") == true)
		{
			object.x = tween.initialX + ((tween.x - tween.initialX) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.x = Math.abs(object.x - tween.initialX) < 0.1 ? tween.x : tween.initialX;
				tween.initialX = object.x;
			}
		}
		if (Reflect.hasField(tween, "y") == true)
		{
			object.y = tween.initialY + ((tween.y - tween.initialY) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.y = Math.abs(object.y - tween.initialY) < 0.1 ? tween.y : tween.initialY;
				tween.initialY = object.y;
			}
		}
		if (Reflect.hasField(tween, "width") == true)
		{
			object.width = tween.initialWidth + ((tween.width - tween.initialWidth) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.width = Math.abs(object.width - tween.initialWidth) < 0.1 ? tween.width : tween.initialWidth;
				tween.initialWidth = object.width;
			}
		}
		if (Reflect.hasField(tween, "height") == true)
		{
			object.height = tween.initialHeight
				+ ((tween.height - tween.initialHeight) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.height = Math.abs(object.height - tween.initialHeight) < 0.1 ? tween.height : tween.initialHeight;
				tween.initialHeight = object.height;
			}
		}
		if (Reflect.hasField(tween, "scaleX") == true)
		{
			object.scaleX = tween.initialScaleX
				+ ((tween.scaleX - tween.initialScaleX) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.scaleX = Math.abs(object.scaleX - tween.initialScaleX) < 0.1 ? tween.targetScaleX : tween.initialScaleX;
				tween.initialScaleX = object.scaleX;
			}
		}
		if (Reflect.hasField(tween, "scaleY") == true)
		{
			object.scaleY = tween.initialScaleY
				+ ((tween.scaleY - tween.initialScaleY) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (applyYoyo == true)
			{
				tween.scaleY = Math.abs(object.scaleY - tween.initialScaleY) < 0.1 ? tween.targetScaleY : tween.initialScaleY;
				tween.initialScaleY = object.scaleY;
			}
		}
		if (Reflect.hasField(tween, "glowFilter") == true)
		{
			var glowFilter:GlowFilter = cast(tween.glowFilterInstance, GlowFilter);
			var strength:Float = tween.glowFilter.initialStrength
				+ ((tween.glowFilter.strength - tween.glowFilter.initialStrength) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			if (tween.glowFilter.firstInvocation == true)
			{
				glowFilter.strength = tween.glowFilter.targetStrength;
				tween.glowFilter.firstInvocation = false;
			}
			else
			{
				glowFilter.strength = strength;
			}
			var objectFilters:Array<BitmapFilter> = object.filters;
			if (objectFilters.indexOf(glowFilter) == -1) objectFilters.push(glowFilter);
			object.filters = objectFilters;
			if (applyYoyo == true)
			{
				tween.glowFilter.strength = strength < 0.1 ? tween.glowFilter.targetStrength : 0.0;
				tween.glowFilter.initialStrength = strength;
			}
		}
		if (Reflect.hasField(tween, "dropShadowFilter") == true)
		{
			var dropShadowFilter:DropShadowFilter = cast(tween.dropShadowFilterInstance, DropShadowFilter);
			dropShadowFilter.distance = tween.dropShadowFilter.initialDistance
				+
				((tween.dropShadowFilter.distance - tween.dropShadowFilter.initialDistance) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
			var objectFilters:Array<BitmapFilter> = object.filters;
			if (objectFilters.indexOf(dropShadowFilter) == -1) objectFilters.push(dropShadowFilter);
			object.filters = objectFilters;
			if (applyYoyo == true)
			{
				tween.dropShadowFilter.initialDistance = dropShadowFilter.distance;
				tween.dropShadowFilter.distance = dropShadowFilter.distance < 0.1 ? tween.dropShadowFilter.targetDistance : 0.0;
			}
		}
	}

	private static function toInitSoundChannel(tween:Dynamic):Void
	{
		var object:SoundChannel = cast(tween.object, SoundChannel);
		tween.timeInit = haxe.Timer.stamp() + tween.delay;
		tween.timeCurrent = tween.timeInit;
		tween.timeFinal = tween.timeInit + tween.duration;
		tween.initialVolume = object.soundTransform.volume;
		if (Reflect.hasField(tween, "volume") == true)
		{
			tween.targetVolume = tween.volume;
		}
		if (object.soundTransform == null)
		{
			object.soundTransform = new SoundTransform();
		}
	}

	public static function toDisposeSoundChannel(tween:Dynamic):Void
	{
		var object:SoundChannel = cast(tween.object, SoundChannel);
	}

	private static function tweenToImplSoundChannel(tween:Dynamic):Void
	{
		var object:SoundChannel = cast(tween.object, SoundChannel);
		if (Reflect.hasField(tween, "volume") == true)
		{
			object.soundTransform.volume = tween.initialVolume
				+ ((tween.volume - tween.initialVolume) * tween.easeFunc((tween.timeCurrent - tween.timeInit) / tween.duration));
		}
	}

	public static function killTweensOf(object:Dynamic):Void
	{
		for (tween in tweens)
		{
			if (tween.object == object)
			{
				completeTween(tween);
			}
		}
		if (tweens.length > 0) return;
		openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, handleTweens);
	}

	public static function killChildTweensOf(object:Dynamic):Void
	{
		if ((object is DisplayObjectContainer))
		{
			var displayObjectContainer:DisplayObjectContainer = cast(object, DisplayObjectContainer);
			for (i in 0...displayObjectContainer.numChildren)
			{
				killChildTweensOf(displayObjectContainer.getChildAt(i));
			}
		}
		killTweensOf(object);
	}

	public static function killDelayedCallsTo(onComplete:Dynamic):Void
	{
		for (tween in tweens)
		{
			if (tween.object == null && Reflect.hasField(tween, "onComplete") == true && tween.onComplete == onComplete)
			{
				tweens.remove(tween);
			}
		}
		if (tweens.length > 0) return;
		openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, handleTweens);
	}

	private static function addTween(tween:Dynamic):Void
	{
		if (tweens.length == 0)
		{
			openfl.Lib.current.stage.addEventListener(Event.ENTER_FRAME, handleTweens);
		}
		tweens.push(tween);
	}

	private static function removeTweens():Void
	{
		for (tween in tweens)
		{
			completeTween(tween);
		}
		if (tweens.length > 0) return;
		openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, handleTweens);
	}

	private static function completeTween(tween:Dynamic):Void
	{
		tweens.remove(tween);
		if (tween.onCompleteCalled == true) return;
		tween.onCompleteCalled = true;
		if (Reflect.hasField(tween, "onComplete") == true)
		{
			Reflect.callMethod(null, tween.onComplete, Reflect.hasField(tween, "onCompleteParams") ? tween.onCompleteParams : []);
		}
	}

	private static function handleTweens(event:Event):Void
	{
		// TODO: a.drewke, maybe remove tweens that have no parent or stage attached
		var now:Float = haxe.Timer.stamp();
		for (tween in tweens)
		{
			if (now < tween.timeInit) continue;
			tween.timeCurrent = now;
			if (tween.timeCurrent >= tween.timeFinal)
			{
				tween.completed = true;
				tween.timeCurrent = tween.timeFinal;
			}
			if (tween.handleFunc != null) tween.handleFunc(tween);
			if (Reflect.hasField(tween, "onUpdate") == true)
			{
				Reflect.callMethod(null, tween.onUpdate, []);
			}
			if (tween.completed == true)
			{
				tween.runs++;
				if (tween.repeat == -1 || tween.runs < tween.repeat)
				{
					tween.completed = false;
					tween.timeInit = now;
					tween.timeFinal = tween.timeInit + tween.duration;
				}
				else
				{
					if (tween.disposeFunc != null) tween.disposeFunc(tween);
					if (tween.nextTween != null)
					{
						if (tween.nextTween.initFunc != null) tween.nextTween.initFunc(tween.nextTween);
						addTween(tween.nextTween);
					}
					completeTween(tween);
				}
			}
		}
		if (tweens.length > 0) return;
		openfl.Lib.current.stage.removeEventListener(Event.ENTER_FRAME, handleTweens);
	}

	public static function linearEaseIn(x:Float):Float
	{
		return x;
	}

	public static function linearEaseInOut(x:Float):Float
	{
		return x;
	}

	public static function expoEaseInOut(x:Float):Float
	{
		return x;
	}

	public static function quartEaseOut(x:Float):Float
	{
		return x;
	}

	public static function elasticEaseInOut(x:Float):Float
	{
		return x;
	}

	public static function elasticEaseOut(x:Float):Float
	{
		return x;
	}
}
