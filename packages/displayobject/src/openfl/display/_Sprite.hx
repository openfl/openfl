package openfl.display;

import openfl.geom.Point;
import openfl.geom._Point;
import openfl.geom.Rectangle;
import openfl.ui.MouseCursor;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:noCompletion
class _Sprite extends _DisplayObjectContainer
{
	public var buttonMode(get, set):Bool;
	public var dropTarget:DisplayObject;
	public var graphics(get, never):Graphics;
	public var hitArea:Sprite;
	public var useHandCursor:Bool;

	public var __buttonMode:Bool;

	public function new(sprite:Sprite)
	{
		super(sprite);

		__buttonMode = false;
		useHandCursor = true;
	}

	public function startDrag(lockCenter:Bool = false, bounds:Rectangle = null):Void
	{
		if (stage != null)
		{
			stage._.__startDrag(this, lockCenter, bounds);
		}
	}

	public function stopDrag():Void
	{
		if (stage != null)
		{
			stage._.__stopDrag(this);
		}
	}

	public override function __getCursor():MouseCursor
	{
		return (__buttonMode && useHandCursor) ? BUTTON : null;
	}

	public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (interactiveOnly && !mouseEnabled && !mouseChildren) return false;
		if (!hitObject.visible || __isMask) return __hitTestHitArea(x, y, shapeFlag, stack, interactiveOnly, hitObject);
		if (mask != null && !mask._.__hitTestMask(x, y)) return __hitTestHitArea(x, y, shapeFlag, stack, interactiveOnly, hitObject);

		if (__scrollRect != null)
		{
			var point = _Point.__pool.get();
			point.setTo(x, y);
			__getRenderTransform()._.__transformInversePoint(point);

			if (!__scrollRect.containsPoint(point))
			{
				_Point.__pool.release(point);
				return __hitTestHitArea(x, y, shapeFlag, stack, true, hitObject);
			}

			_Point.__pool.release(point);
		}

		if (super._.__hitTest(x, y, shapeFlag, stack, interactiveOnly, hitObject))
		{
			return (stack == null || interactiveOnly);
		}
		else if (hitArea == null && __graphics != null && __graphics._.__hitTest(x, y, shapeFlag, __getRenderTransform()))
		{
			if (stack != null && (!interactiveOnly || mouseEnabled))
			{
				stack.push(hitObject);
			}

			return true;
		}

		return __hitTestHitArea(x, y, shapeFlag, stack, interactiveOnly, hitObject);
	}

	public function __hitTestHitArea(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (hitArea != null)
		{
			if (!hitArea.mouseEnabled)
			{
				hitArea.mouseEnabled = true;
				var hitTest = hitArea._.__hitTest(x, y, shapeFlag, null, true, hitObject);
				hitArea.mouseEnabled = false;

				if (stack != null && hitTest)
				{
					stack[stack.length] = hitObject;
				}

				return hitTest;
			}
		}

		return false;
	}

	public override function __hitTestMask(x:Float, y:Float):Bool
	{
		if (super._.__hitTestMask(x, y))
		{
			return true;
		}
		else if (__graphics != null && __graphics._.__hitTest(x, y, true, __getRenderTransform()))
		{
			return true;
		}

		return false;
	}

	// Get & Set Methods

	private function get_buttonMode():Bool
	{
		return __buttonMode;
	}

	private function set_buttonMode(value:Bool):Bool
	{
		return __buttonMode = value;
	}

	private function get_graphics():Graphics
	{
		if (__graphics == null)
		{
			__graphics = new Graphics(this_displayObject);
		}

		return __graphics;
	}

	public override function get_tabEnabled():Bool
	{
		return (__tabEnabled == null ? __buttonMode : __tabEnabled);
	}
}
