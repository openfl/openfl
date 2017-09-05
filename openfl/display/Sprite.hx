package openfl.display; #if !openfl_legacy


import lime.ui.MouseCursor;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.UnshrinkableArray;

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)


class Sprite extends DisplayObjectContainer {


	public var buttonMode:Bool;
	public var graphics (get, null):Graphics;
	public var hitArea:Sprite;
	public var useHandCursor:Bool;


	public function new () {

		super ();

		buttonMode = false;
		useHandCursor = true;
	}


	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void {

		if (stage != null) {

			stage.__startDrag (this, lockCenter, bounds);

		}

	}


	public function stopDrag ():Void {

		if (stage != null) {

			stage.__stopDrag (this);

		}

	}


	private override function __getCursor ():MouseCursor {

		return (buttonMode && useHandCursor) ? POINTER : null;

	}


	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {

		shapeFlag = shapeFlag && ( getSymbol() != null ? getSymbol().pixelPerfectHitTest : true );
		if (hitArea != null) {

			if (!hitArea.mouseEnabled)
			{
				var itHasMouseListener = __hasMouseListener ();

				__pushHitTestLevel (itHasMouseListener);

				hitArea.mouseEnabled = true;
				var hitTest = hitArea.__hitTest (x, y, shapeFlag, null, true, hitObject);
				hitArea.mouseEnabled = false;

				__popHitTestLevel (itHasMouseListener);

				if( hitTest ){
					stack.push(hitObject);
				}

				return hitTest;
			}

		} else {

			if (!hitObject.visible || __isMask || (interactiveOnly && !mouseChildren && !mouseEnabled)) return false;
			if (mask != null && !mask.__hitTestMask (x, y)) return false;

			if (super.__hitTest (x, y, shapeFlag, stack, interactiveOnly, hitObject)) {

				return true;

			} else if ((!interactiveOnly || mouseEnabled) && __graphics != null && __graphics.__hitTest (x, y, shapeFlag, __getWorldTransform ())) {

				if (stack != null) {

					stack.push (hitObject);

				}

				return true;

			}

		}

		return false;

	}


	private override function __hitTestMask (x:Float, y:Float):Bool {

		if (super.__hitTestMask (x, y)) {

			return true;

		} else if (__graphics != null && __graphics.__hitTest (x, y, true, __getWorldTransform ())) {

			return true;

		}

		return false;

	}




	// Get & Set Methods




	private function get_graphics ():Graphics {

		if (__graphics == null) {

			__graphics = new Graphics ();
			@:privateAccess __graphics.__owner = this;

		}

		return __graphics;

	}


	private override function get_tabEnabled ():Bool {

		return (__tabEnabled || buttonMode);

	}


}


#else
typedef Sprite = openfl._legacy.display.Sprite;
#end
